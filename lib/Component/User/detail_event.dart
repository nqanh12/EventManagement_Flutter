import 'dart:async';
import 'package:doan/Component/User/qrcode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventId;
  final String name;
  final String dateStart;
  final String dateEnd;
  final String location;
  final String description;
  final String managerId;
  final String role;
  final String token;
  final bool isRegistered;
  final VoidCallback onUpdate;

  const EventDetailsScreen({
    super.key,
    required this.eventId,
    required this.name,
    required this.dateStart,
    required this.dateEnd,
    required this.location,
    required this.description,
    required this.managerId,
    required this.role,
    required this.token,
    required this.isRegistered,
    required this.onUpdate,
  });

  @override
  EventDetailsScreenState createState() => EventDetailsScreenState();
}

class EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _isRegistered = false;
  bool _checkInStatus = false;
  bool _checkOutStatus = false;
  int _totalParticipants = 0;
  int _capacity = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _isRegistered = widget.isRegistered;
    _fetchEventCapacity();
    _fetchEventDetails();
    _fetchParticipants();
    _startAutoReload();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoReload() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchEventCapacity();
      _fetchEventDetails();
      _fetchParticipants();
    });
  }

  Future<void> _fetchEventCapacity() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/events/getCapacity/${widget.eventId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _capacity = data['result']['capacity'];
      });
    } else {
      throw Exception('Failed to load event capacity');
    }
  }

  Future<void> _fetchEventDetails() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/users/getRegisteredEvents'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final eventsRegistered = data['result']['eventsRegistered'];
      final event = eventsRegistered.firstWhere(
            (event) => event['eventId'] == widget.eventId,
        orElse: () => null,
      );

      if (event != null) {
        setState(() {
          _isRegistered = true;
          _checkInStatus = event['checkInStatus'];
          _checkOutStatus = event['checkOutStatus'];
        });
      }
    } else {
      throw Exception('Failed to load event details');
    }
  }

  Future<void> _cancelRegistration() async {
    final userResponse = await http.delete(
      Uri.parse('http://10.0.2.2:8080/api/users/deleteRegisteredEvent/${widget.eventId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    final eventResponse = await http.delete(
      Uri.parse('http://10.0.2.2:8080/api/events/deleteParticipant/${widget.eventId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (userResponse.statusCode == 200 && eventResponse.statusCode == 200) {
      setState(() {
        _isRegistered = false;
        _checkInStatus = false;
        _checkOutStatus = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hủy đăng ký thành công')),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hủy đăng ký thất bại')),
      );
    }
  }

  Future<void> _fetchParticipants() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/events/participants/${widget.eventId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final participants = data['result']['participants'] as List;
      setState(() {
        _totalParticipants = participants.length;
      });
    } else {
      throw Exception('Failed to load participants');
    }
  }

  Future<void> _registerEvent() async {
    final userResponse = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/users/registerEvent/${widget.eventId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    final eventResponse = await http.post(
      Uri.parse('http://10.0.2.2:8080/api/events/addParticipant/${widget.eventId}'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (userResponse.statusCode == 200 && eventResponse.statusCode == 200) {
      setState(() {
        _isRegistered = true;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thành công')),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng ký thất bại')),
      );
    }
  }

  Future<void> _refreshData() async {
    await _fetchEventCapacity();
    await _fetchEventDetails();
    await _fetchParticipants();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFull = _totalParticipants >= _capacity;
    final DateTime now = DateTime.now();
    final DateTime eventStart = DateTime.parse(widget.dateStart);
    final bool isEventStarted = now.isAfter(eventStart);

    return Scaffold(
      appBar:AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.00, // Điều chỉnh padding theo tỷ lệ màn hình
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.00, // Điều chỉnh padding tiêu đề theo chiều cao màn hình
          ),
          child: Text(
            "Chi tiết",
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.07, // Điều chỉnh kích thước font theo tỷ lệ màn hình
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 25, 117, 215),
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.06, // Điều chỉnh chiều cao AppBar theo màn hình
      ),
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 197, 216, 236),
                Color.fromARGB(255, 25, 117, 215),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                // Event Info Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Name
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Ngày bắt đầu: ${_formatDateTime(widget.dateStart)}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Ngày kết thúc: ${_formatDateTime(widget.dateEnd)}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Số lượng: $_capacity',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Tổng số người đăng ký: $_totalParticipants',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Location
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Địa điểm: ${widget.location}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Description Section
                const Text(
                  "Mô tả",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Manager and Status Section
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Manager ID
                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Chủ trì: ${widget.managerId}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Status Check-in/Check-out
                        Row(
                          children: [
                            Icon(
                              _checkInStatus ? Icons.check_circle_outline : Icons.cancel_outlined,
                              color: _checkInStatus ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _checkInStatus ? "Đã check-in" : "Chưa check-in",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(
                              _checkOutStatus ? Icons.check_circle_outline : Icons.cancel_outlined,
                              color: _checkOutStatus ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _checkOutStatus ? "Đã check-out" : "Chưa check-out",
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!isFull && !isEventStarted)
                      ElevatedButton(
                        onPressed: _isRegistered ? null : () {
                          _showRegisterDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRegistered ? Colors.grey : Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Đăng ký",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    if (!isEventStarted)
                      ElevatedButton(
                        onPressed: _isRegistered ? () {
                          _showCancelDialog(context);
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isRegistered ? Colors.red : Colors.grey,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Huỷ đăng ký",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: _isRegistered ? () {
                        // Open QR code screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => QRCodePage(eventId: widget.eventId, token: widget.token, role: widget.role),
                          ),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isRegistered ? Colors.blue : Colors.grey,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Lấy mã QR",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận đăng ký"),
          content: const Text("Bạn có muốn đăng ký sự kiện này không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _registerEvent();
              },
              child: const Text("Đồng ý"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác nhận hủy đăng ký"),
          content: const Text("Bạn có muốn hủy đăng ký sự kiện này không?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _cancelRegistration();
              },
              child: const Text("Đồng ý"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
          ],
        );
      },
    );
  }
}

String _formatDateTime(String dateTime) {
  final DateTime parsedDate = DateTime.parse(dateTime);
  final DateFormat formatter = DateFormat('dd/MM/yyyy - HH:mm a');
  return formatter.format(parsedDate);
}
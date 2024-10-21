import 'dart:async';
import 'package:doan/Component/User/detail_event.dart';
import 'package:doan/Component/User/list_event_check.dart';
import 'package:flutter/material.dart';
import 'package:doan/Component/User/list_event.dart';
import 'package:doan/Component/User/notification.dart';
import 'package:doan/Component/User/setting.dart';
import 'package:doan/Component/User/status_check_in_out.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package

class Home extends StatefulWidget {
  final String role;
  final String token;
  const Home({super.key, required this.role, required this.token});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? userInfo;
  List<dynamic> _upcomingEvents = [];
  Timer? _timer;
  Timer? _timer2;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
    _fetchUpcomingEvents();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _fetchUserInfo();
      _fetchUpcomingEvents();
    });
    _timer2 = Timer.periodic(const Duration(minutes: 30), (timer) {
      _autoCalculateTrainingPoint();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer2?.cancel();
    super.dispose();
  }

  Future<void> _fetchUserInfo() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/users/myInfo'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        userInfo = data['result'];
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load user info')),
      );
    }
  }

  Future<void> _fetchUpcomingEvents() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/api/events/listEvent'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final List<dynamic> allEvents = data['result'];

      // Filter events to include only upcoming events
      final DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm');
      final DateTime now = DateTime.now().toLocal();
      final List<dynamic> upcomingEvents = allEvents.where((event) {
        final DateTime eventStartDate = DateTime.parse(event['dateStart']).toLocal();
        return now.isBefore(eventStartDate);
      }).map((event) {
        event['formattedDateStart'] = dateFormat.format(DateTime.parse(event['dateStart']).toLocal());
        event['formattedDateEnd'] = dateFormat.format(DateTime.parse(event['dateEnd']).toLocal());
        return event;
      }).toList();

      setState(() {
        _upcomingEvents = upcomingEvents;
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: ${response.statusCode}')),
      );
    }
  }

  Future<void> _autoCalculateTrainingPoint() async {
    final response = await http.put(
      Uri.parse('http://10.0.2.2:8080/api/users/autoCalculateTrainingPoint'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      // ignore: avoid_print
      print('Training point calculated: ${data['result']['training_point']}');
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to calculate training point: ${response.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userInfo?['full_Name'] ?? 'Loading...',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 25, 25, 25),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const CircleAvatar(
                            backgroundImage: AssetImage('assets/avatar.png'),
                            radius: 25,
                            backgroundColor: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Sự kiện sắp tới",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _upcomingEvents.length,
                                    itemBuilder: (context, index) {
                                      final event = _upcomingEvents[index];
                                      return _buildEventCard(
                                        event,
                                        event['name'] ?? 'Chưa cập nhật',
                                        event['dateStart'] ?? 'Chưa cập nhật',
                                        event['dateEnd'] ?? 'Chưa cập nhật',
                                        event['locationId'] ?? 'Chưa cập nhật',
                                        event['description'] ?? 'Chưa cập nhật',
                                        event['checkInStatus'] ?? false,
                                        event['checkOutStatus'] ?? false,
                                        event['managerId'] ?? 'Chưa cập nhật',
                                        event['isRegistered'] ?? false,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _buildQuickAccessButton(" Sự kiện", Icons.event, ListEvent(role: widget.role, token: widget.token)),
                                    const SizedBox(height: 16),
                                    if (widget.role == '[MANAGER]') ...[
                                      _buildQuickAccessButton("Điểm danh", Icons.person, ListEventCheck(role: widget.role, token: widget.token)),
                                      const SizedBox(height: 16),
                                    ],
                                    _buildQuickAccessButton("Trạng thái", Icons.history, CheckInOutStatusScreen(token: widget.token, role: widget.role)),
                                    const SizedBox(height: 16),
                                    _buildQuickAccessButton("Thông báo", Icons.notifications, NotificationsPage(token: widget.token)),
                                    const SizedBox(height: 16),
                                    _buildQuickAccessButton(" Cài đặt", Icons.settings, SettingsScreen(token: widget.token, role: widget.role)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(dynamic event, String title, String dateStart, String dateEnd, String location, String description, bool checkInStatus, bool checkOutStatus, String managerId, bool isRegistered) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy HH:mm'); // Define the date format

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 5),
              Text("Ngày bắt đầu: \n${dateFormat.format(DateTime.parse(dateStart))}", style: const TextStyle(color: Colors.black54)),
              Text("Ngày kết thúc:\n${dateFormat.format(DateTime.parse(dateEnd))}", style: const TextStyle(color: Colors.black54)),
              Text("Địa điểm: $location", style: const TextStyle(color: Colors.black54)),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailsScreen(
                          isRegistered: isRegistered,
                          name: event['name'],
                          eventId: event['eventId'],
                          dateStart: dateStart,
                          dateEnd: dateEnd,
                          location: location,
                          description: description,
                          managerId: event['managerName'],
                          role: widget.role,
                          token: widget.token,
                          onUpdate: () => _fetchUpcomingEvents(),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text("Xem chi tiết"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(String label, IconData icon, Widget destination) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      icon: Icon(icon, color: Colors.black),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        elevation: 5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }
}
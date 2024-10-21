import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class Student {
  final String eventId; // user_id
  final String userName;
  final bool checkInStatus; // Trạng thái check-in
  final DateTime? checkInTime; // Thời gian check-in
  final bool checkOutStatus; // Trạng thái check-out
  final DateTime? checkOutTime; // Thời gian check-out
  final String? userCheckIn; // Người check-in
  final String? userCheckOut; // Người check-out
  String fullName;
  String className;

  Student({
    required this.eventId,
    required this.userName,
    required this.checkInStatus,
    required this.checkInTime,
    required this.checkOutStatus,
    required this.checkOutTime,
    this.userCheckIn,
    this.userCheckOut,
    this.fullName = '',
    this.className = '',
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      eventId: json['eventId'] ?? '',
      userName: json['userName'] ?? '',
      checkInStatus: json['checkInStatus'] ?? false,
      checkInTime: json['checkInTime'] != null ? DateTime.parse(json['checkInTime']) : null,
      checkOutStatus: json['checkOutStatus'] ?? false,
      checkOutTime: json['checkOutTime'] != null ? DateTime.parse(json['checkOutTime']) : null,
      userCheckIn: json['userCheckIn'],
      userCheckOut: json['userCheckOut'],
      className: json['class_id'] ?? 'Chưa cập nhật',
      fullName: json['full_Name'] ?? 'Chưa cập nhật',
    );
  }
}

class ParticipantListScreen extends StatefulWidget {
  final String eventId;
  final String token;
  final String role;

  const ParticipantListScreen({super.key, required this.eventId, required this.token, required this.role});

  @override
  ParticipantListScreenState createState() => ParticipantListScreenState();
}

class ParticipantListScreenState extends State<ParticipantListScreen> {
  List<Student> participants = [];
  String filter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _fetchParticipants();
  }

  Future<void> _fetchFullName(String userName) async {
    final String url = 'http://10.0.2.2:8080/api/users/getFullName/$userName';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final String fullName = data['result']['full_Name'];
      final String className = data['result']['class_id'];
      setState(() {
        for (var participant in participants) {
          if (participant.userName == userName) {
            participant.fullName = fullName; // Update fullName field
            participant.className = className; // Update className field
            break;
          }
        }
      });
    } else {
      // Handle error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load full name for $userName: ${response.statusCode}')),
      );
    }
  }

  // Fetch participants of the event
  Future<void> _fetchParticipants() async {
    final String url = 'http://10.0.2.2:8080/api/events/participants/${widget.eventId}';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final List<Student> loadedParticipants = (data['result']['participants'] as List)
          .map((participantJson) => Student.fromJson(participantJson))
          .toList();

      setState(() {
        participants = loadedParticipants;
      });

      for (var participant in participants) {
        _fetchFullName(participant.userName);
      }
    } else {
      // Handle error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load participants: ${response.statusCode}')),
      );
    }
  }

  String _getRegistrationStatus(Student student) {
    if (student.checkInStatus && student.checkOutStatus) {
      return "Đã hoàn thành";
    } else if (student.checkInStatus || student.checkOutStatus) {
      return "Đang xử lý";
    } else {
      return "Cảnh báo";
    }
  }

  Color _getStatusColor(Student student) {
    if (student.checkInStatus && student.checkOutStatus) {
      return Colors.green; // Màu xanh lá khi hoàn thành
    } else if (student.checkInStatus || student.checkOutStatus) {
      return Colors.orange; // Màu cam khi đang xử lý
    } else {
      return Colors.red; // Màu đỏ khi cảnh báo
    }
  }

  void _removeParticipant(int index) {
    setState(() {
      participants.removeAt(index);
      _fetchParticipants(); // Reload data after removing a participant
    });
  }

  Map<String, int> _countParticipants() {
    int completed = 0;
    int notCompleted = 0;

    for (var student in participants) {
      if (student.checkInStatus && student.checkOutStatus) {
        completed++;
      } else {
        notCompleted++;
      }
    }

    return {
      'completed': completed,
      'notCompleted': notCompleted,
    };
  }

  List<Student> _filterParticipants() {
    if (filter == 'Tất cả') {
      return participants;
    } else if (filter == 'Hoàn thành') {
      return participants.where((student) => student.checkInStatus && student.checkOutStatus).toList();
    } else if (filter == 'Đang check') {
      return participants.where((student) => student.checkInStatus || student.checkOutStatus).toList();
    } else {
      return participants.where((student) => !student.checkInStatus && !student.checkOutStatus).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final counts = _countParticipants();
    final dateFormat = DateFormat('dd-MM-yyyy HH:mm');
    final filteredParticipants = _filterParticipants();

    return Scaffold(
      appBar: AppBar(
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
            "Danh sách sinh viên",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.safety_check),
            onPressed: () {
              // Handle the icon press
            },
          ),
        ],
      ),
      body: Container(
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Set the background color to white
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0), // Optional: Add padding inside the container
                child: Row(
                  children: [
                    const Icon(Icons.assessment, color: Colors.blue, size: 40), // Add an icon
                    const SizedBox(width: 16), // Add some space between the icon and text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hoàn thành: ${counts['completed']}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8), // Add some space between the texts
                        Text(
                          'Chưa hoàn thành: ${counts['notCompleted']}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Spacer(),
                    DropdownButton<String>(
                      value: filter,
                      onChanged: (String? newValue) {
                        setState(() {
                          filter = newValue!;
                        });
                      },
                      items: <String>['Tất cả', 'Hoàn thành', 'Đang check', 'Chưa hoàn thành']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchParticipants, // Pull-to-refresh functionality
                child: filteredParticipants.isEmpty
                    ? const Center(
                  child: Text(
                    'Chưa có sinh viên đăng ký',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredParticipants.length,
                  itemBuilder: (context, index) {
                    var student = filteredParticipants[index];
                    return Dismissible(
                      key: Key(student.userName),
                      background: Container(
                        color: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) {
                        // Remove the participant from the list
                        _removeParticipant(index);

                        // Optionally, show a snackbar to notify about the deletion
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${student.fullName} đã bị xoá khỏi danh sách')),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: ListTile(
                          title: Text(student.fullName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text('Check-in:   '),
                                  student.checkInStatus
                                      ? const Icon(Icons.check_circle, color: Colors.green)
                                      : const Icon(Icons.cancel_presentation, color: Colors.red),
                                ],
                              ),
                              Text('Giờ vào: ${student.checkInTime != null ? dateFormat.format(student.checkInTime!) : 'Chưa điểm danh'}'),
                              Text('Người check in: ${student.userCheckIn ?? 'Chưa điểm danh'}'),
                              Row(
                                children: [
                                  const Text('Check-out: '),
                                  student.checkOutStatus
                                      ? const Icon(Icons.check_circle, color: Colors.green)
                                      : const Icon(Icons.cancel_presentation, color: Colors.red),
                                ],
                              ),
                              Text('Giờ ra: ${student.checkOutTime != null ? dateFormat.format(student.checkOutTime!) : 'Chưa điểm danh'}'),
                              Text('Người check out: ${student.userCheckOut ?? 'Chưa điểm danh'}'),
                              Text('MSSV: ${student.userName}'),
                              Text('Lớp: ${student.className}'),
                            ],
                          ),
                          trailing: Text(
                            _getRegistrationStatus(student),
                            style: TextStyle(
                              color: _getStatusColor(student),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            // Optional: Handle tap to view student details
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
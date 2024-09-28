import 'package:flutter/material.dart';

class Participant {
  String id;
  String name;
  bool checkInStatus;
  bool checkOutStatus;

  Participant({
    required this.id,
    required this.name,
    required this.checkInStatus,
    required this.checkOutStatus,
  });
}

class EventParticipantsScreen extends StatelessWidget {
  final List<Participant> participants = [
    Participant(id: '1', name: 'Nguyen Van A', checkInStatus: true, checkOutStatus: false),
    Participant(id: '2', name: 'Tran Thi B', checkInStatus: true, checkOutStatus: true),
    Participant(id: '3', name: 'Tran Van C', checkInStatus: false, checkOutStatus: true),
    Participant(id: '4', name: 'Nguyen Van D', checkInStatus: false, checkOutStatus: true),
    Participant(id: '5', name: 'Nguyen Van E', checkInStatus: false, checkOutStatus: true),
    Participant(id: '6', name: 'Le Van F', checkInStatus: false, checkOutStatus: false),
    Participant(id: '7', name: 'Nguyen Van G', checkInStatus: false, checkOutStatus: false),
    Participant(id: '8', name: 'Nguyen Van H', checkInStatus: false, checkOutStatus: false),
    Participant(id: '9', name: 'Le Van J', checkInStatus: true, checkOutStatus: true),
  ];

  EventParticipantsScreen({super.key});

  // Hàm đếm số lượng sinh viên đã check cả 2 in và out
  int countCheckInAndOut() {
    return participants.where((participant) => participant.checkInStatus && participant.checkOutStatus).length;
  }

  // Hàm đếm tổng số lượng sinh viên đã đăng ký sự kiện
  int countTotalParticipants() {
    return participants.length;
  }

  IconData getStatusIcon(Participant participant) {
    if (participant.checkInStatus && participant.checkOutStatus) {
      return Icons.check_circle; // Hoàn thành
    } else if (participant.checkInStatus || participant.checkOutStatus) {
      return Icons.warning; // Cảnh báo
    } else {
      return Icons.cancel; // Cancel
    }
  }

  Color getStatusColor(Participant participant) {
    if (participant.checkInStatus && participant.checkOutStatus) {
      return Colors.green; // Hoàn thành
    } else if (participant.checkInStatus || participant.checkOutStatus) {
      return Colors.orange; // Cảnh báo
    } else {
      return Colors.red; // Cancel
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh sách sinh viên tham gia',
          style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 25, 117, 215),
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 90), // Tạo khoảng cách để tránh đè lên AppBar
              // Hiển thị số lượng sinh viên
              Container(
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Tổng số sinh viên đã hoàn thành: ${countCheckInAndOut()}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Tổng số sinh viên tham gia sự kiện: ${countTotalParticipants()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    final participant = participants[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 6,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 240, 245, 252),
                              Color.fromARGB(255, 197, 216, 236),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color.fromARGB(255, 25, 117, 215),
                            child: Text(
                              participant.name[0],
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            participant.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    'Check-in: ',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                                  ),
                                  Text(
                                    participant.checkInStatus ? "Đã Check-in" : "Chưa Check-in",
                                    style: TextStyle(
                                      color: participant.checkInStatus ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    'Check-out: ',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
                                  ),
                                  Text(
                                    participant.checkOutStatus ? "Đã Check-out" : "Chưa Check-out",
                                    style: TextStyle(
                                      color: participant.checkOutStatus ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Icon(
                            getStatusIcon(participant),
                            color: getStatusColor(participant),
                            size: 32,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

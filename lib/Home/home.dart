import 'package:doan/User/list_event_check.dart';
import 'package:flutter/material.dart';
import 'package:doan/User/list_event.dart';
import 'package:doan/User/notification.dart';
import 'package:doan/User/profile.dart';
import 'package:doan/User/scannerqr.dart';
import 'package:doan/User/status_check_in_out.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isManager = true; // Set this value based on the user's role

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
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
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with profile
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nguyễn Quốc Anh",
                          style: TextStyle(
                            color: Color.fromARGB(255, 25, 25, 25),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/person.png'), // Profile picture
                          radius: 25,
                          backgroundColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Body content
                  Expanded(
                    child: Row(
                      children: [
                        // Event List
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
                                  child: ListView(
                                    children: [
                                      _buildEventCard(
                                        "Hội thảo tổ chức sự kiện",
                                        "28 - 5 - 2024",
                                        "10:00 AM",
                                        "Hội trường C",
                                      ),
                                      _buildEventCard(
                                        "Hội thảo tổ chức sự kiện",
                                        "28 - 5 - 2024",
                                        "10:00 AM",
                                        "Hội trường C",
                                      ),
                                      // Add more event cards here
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Quick Access Grid
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    _buildQuickAccessButton(" Sự kiện", Icons.event, const ListEvent()),
                                      if (isManager)
                                       const SizedBox(height: 16),
                                      // Check if the user is a manager before showing the button
                                      if (isManager)
                                      _buildQuickAccessButton("Điểm danh", Icons.qr_code_scanner, const ListEventCheck()),
                                    const SizedBox(height: 16),
                                    _buildQuickAccessButton(" Lịch sử", Icons.history, CheckInOutStatusScreen(events: [
                                            Event(
                                              name: 'Orientation Day',
                                              dateStart: '2024-08-01',
                                              dateEnd: '2024-08-01',
                                              checkInStatus: true,
                                              checkOutStatus: false,
                                              time: '08:30 AM',
                                            ),
                                            Event(
                                              name: 'Workshop on Flutter',
                                              dateStart: '2024-08-10',
                                              dateEnd: '2024-08-10',
                                              checkInStatus: true,
                                              checkOutStatus: true,
                                              time: '12:00 PM',
                                            ),
                                            Event(
                                              name: 'React Native Seminar',
                                              dateStart: '2024-08-15',
                                              dateEnd: '2024-08-15',
                                              checkInStatus: false,
                                              checkOutStatus: false,
                                              time: '',
                                            ),
                                            Event(
                                              name: 'Hackathon',
                                              dateStart: '2024-08-20',
                                              dateEnd: '2024-08-20',
                                              checkInStatus: false,
                                              checkOutStatus: false,
                                              time: '',
                                            ),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 16),
                                    _buildQuickAccessButton("Thông báo", Icons.notifications, const NotificationsScreen()),
                                    const SizedBox(height: 16),
                                    _buildQuickAccessButton(" Cài đặt", Icons.settings, const SettingsScreen()),
                                  ],
                                ),
                              ),
                              // Status Overview
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Trạng thái",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Điểm danh vào: 9:00 AM, August 27, 2024",
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      "Thống kê",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Đã tham gia sự kiện: 10",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    Text(
                                      "Sự kiện sắp tới: 2",
                                      style: TextStyle(color: Colors.black54),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(String title, String date, String time, String location) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: 10),
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
            Text("Ngày: $date", style: const TextStyle(color: Colors.black54)),
            Text("Giờ: $time", style: const TextStyle(color: Colors.black54)),
            Text("Địa điểm: $location", style: const TextStyle(color: Colors.black54)),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // Xử lý sự kiện khi nhấn nút
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

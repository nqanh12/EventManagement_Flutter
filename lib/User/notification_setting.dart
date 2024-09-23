import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt thông báo", style: TextStyle(color: Colors.black, fontSize: 24,fontWeight: FontWeight.bold)),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text("Nhận thông báo", style: TextStyle(fontSize: 20,color: Colors.black)),
                value: true,
                onChanged: (value) {
                  // Xử lý logic bật/tắt nhận thông báo ở đây
                },
              ),
              SwitchListTile(
                title: const Text("Thông báo email", style: TextStyle(fontSize: 20,color: Colors.black)),
                value: false,
                onChanged: (value) {
                  // Xử lý logic bật/tắt thông báo email ở đây
                },
              ),
              // Thêm các tùy chọn thông báo khác nếu cần
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:doan/Component/User/edit_personal_info.dart';
import 'package:flutter/material.dart';

class UpdatePersonalScreen extends StatelessWidget {

  final String token;
  const UpdatePersonalScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          "Thông tin cá nhân",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body:Container(
    decoration: const BoxDecoration(
    gradient: LinearGradient(
    colors: [
    Color(0xFFC5D8EC),
    Color(0xFF1975D7),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    ),
    ),child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', // replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 80.0),
            child: Column(
              children: [
                // Profile avatar and name
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/avatar.jpg'), // Replace with your avatar image
                ),
                const SizedBox(height: 10),
                const Text(
                  'Nguyễn QuốcAnh',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Thông tin cá nhân',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),

                // Information details box
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Giới tính", "Nam"),
                        _buildInfoRow("Ngày sinh", "12/05/2003"),
                        _buildInfoRow("Điện thoại", "+84 98 728 46 71"),
                        _buildInfoRow("Lớp", "12DHTH06"),
                        _buildInfoRow("Email", "chaybon@gmail.com"),
                        _buildInfoRow("Địa chỉ", "566/197/25 Nguyễn Thái Sơn"),
                        const SizedBox(height: 20),
                        // Edit Button
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EditPersonalInfoScreen(role: "user"),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            label: const Text(
                              'Chỉnh sửa',
                              style: TextStyle(color: Colors.blue),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ));
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

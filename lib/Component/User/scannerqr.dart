import 'package:permission_handler/permission_handler.dart';
import 'package:doan/Component/User/student_list_event.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScanScreen extends StatefulWidget {
  const QRCodeScanScreen({super.key});

  @override
  QRCodeScanScreenState createState() => QRCodeScanScreenState();
}

class QRCodeScanScreenState extends State<QRCodeScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? studentInfo;
  String? checkStatus;
  bool isCheckIn = true; // State to manage Check-In/Check-Out mode

  @override
  void initState() {
    super.initState();
    requestCameraPermission(); // Yêu cầu quyền camera
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quét QR Điểm danh',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 25, 117, 215),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
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
          Column(
            children: <Widget>[
              // QR Scanner section
              Expanded(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(top: 80, right: 0,left: 0,bottom: 30),
                  padding: const EdgeInsets.only(top:0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  // Make the QR Scanner square-shaped
                  child: AspectRatio(
                    aspectRatio: 1, // Ensures a square scanner
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ),
              ),
              // Student info and status section
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (studentInfo != null)
                        Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Thông tin sinh viên đã quét',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  studentInfo ?? 'Chưa có thông tin',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (checkStatus != null)
                        Text(
                          'Trạng thái: $checkStatus',
                          style: TextStyle(
                            fontSize: 18,
                            color: checkStatus == 'Checked In'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Refined Check-In / Check-Out switch at the top-right corner
          Positioned(
            bottom: 100,
            right: 20,

            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              child: Switch(
                value: isCheckIn,
                onChanged: (value) {
                  setState(() {
                    isCheckIn = value;
                  });
                },
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventParticipantsScreen()),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('Xem danh sách'),
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                foregroundColor: const Color.fromARGB(255, 0, 92, 250),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                // Add functionality to load data
              },
              icon: const Icon(Icons.sync),
              label: const Text('Đồng bộ'),
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                foregroundColor: const Color.fromARGB(255, 0, 92, 250),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        // Dữ liệu giả định từ mã QR sau khi quét
        studentInfo = 'MSSV: 123456, Tên: Nguyễn Văn A';
        checkStatus = isCheckIn ? 'Checked In' : 'Checked Out'; // Update based on switch value
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

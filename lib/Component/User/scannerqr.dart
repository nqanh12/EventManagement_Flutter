import 'package:permission_handler/permission_handler.dart';
import 'package:doan/Component/User/student_list_event.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QRCodeScanScreen extends StatefulWidget {
  final String role;
  final String token;
  final String eventId;
  final String dateStart;
  final String dateEnd;
  const QRCodeScanScreen({super.key, required this.role, required this.token, required this.eventId, required this.dateStart, required this.dateEnd});

  @override
  QRCodeScanScreenState createState() => QRCodeScanScreenState();
}

class QRCodeScanScreenState extends State<QRCodeScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? studentInfo;
  String? checkStatus;
  bool isCheckIn = true; // State to manage Check-In/Check-Out mode
  bool isCheckInDisabled = false; // State to manage switch disable
  List<dynamic> participants = [];

  @override
  void initState() {
    super.initState();
    requestCameraPermission(); // Request camera permission
    _checkIfCheckInDisabled(); // Check if check-in should be disabled
    _fetchParticipants(); // Fetch participants list
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  void _checkIfCheckInDisabled() {
    final dateStart = DateTime.parse(widget.dateStart);
    final oneHourAfterStart = dateStart.add(const Duration(hours: 1));
    final now = DateTime.now();

    if (now.isAfter(oneHourAfterStart)) {
      setState(() {
        isCheckInDisabled = true;
        isCheckIn = false; // Ensure the switch is off
      });
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
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        participants = data['result']['participants'];
      });
    } else {
      // Handle error
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load participants: ${response.statusCode}')),
      );
    }
  }

  Future<void> _checkInOut(String userName) async {
    final String checkInOut = isCheckIn ? 'checkIn' : 'checkOut';
    final String userUrl = 'http://10.0.2.2:8080/api/users/$checkInOut/${widget.eventId}/$userName';
    final String eventUrl = 'http://10.0.2.2:8080/api/events/$checkInOut/${widget.eventId}/$userName';

    final userResponse = await http.put(
      Uri.parse(userUrl),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    final eventResponse = await http.put(
      Uri.parse(eventUrl),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (userResponse.statusCode == 200 && eventResponse.statusCode == 200) {
      json.decode(userResponse.body);
      // ignore: unused_local_variable
      final eventData = json.decode(eventResponse.body);

      setState(() {
        checkStatus = isCheckIn ? 'Check In thành công' : 'Check Out thành công';
        studentInfo = 'MSSV: $userName\nTrạng thái: $checkStatus';
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thao tác thành công: $checkStatus')),
      );
    } else {
      // ignore: avoid_print
      print('Failed to check in/out: ${userResponse.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.00, // Adjust padding based on screen ratio
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.00, // Adjust title padding based on screen height
          ),
          child: Text(
            "Quét QR điểm Danh",
            style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width * 0.07, // Adjust font size based on screen ratio
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 25, 117, 215),
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.06, // Adjust AppBar height based on screen
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
                  margin: const EdgeInsets.only(top: 80, right: 0, left: 0, bottom: 30),
                  padding: const EdgeInsets.only(top: 0),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Refined Check-In / Check-Out switch at the top-right corner
          Positioned(
            bottom: 20,
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
              child: Row(
                children: [
                  Switch(
                    value: isCheckIn,
                    onChanged: isCheckInDisabled ? null : (value) {
                      setState(() {
                        isCheckIn = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                  Text(
                    isCheckIn ? 'Check In' : 'Check Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCheckIn ? Colors.green : Colors.red,
                    ),
                  ),
                ],
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
                      builder: (context) => EventParticipantsScreen(token : widget.token, eventId: widget.eventId)),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('Xem danh sách'),
              style: ElevatedButton.styleFrom(
                elevation: 10,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        final String scannedCode = scanData.code!;
        final String eventCode = widget.eventId; // Assuming eventId is the event QR code

        if (scannedCode.substring(0, 9) == eventCode) {
          final studentId = scannedCode.substring(9); // Remaining characters
          final participant = participants.firstWhere(
                (participant) => participant['userName'] == studentId,
            orElse: () => null,
          );

          if (participant != null) {
            if (participant['checkOutStatus'] == true) {
              setState(() {
                studentInfo = 'MSSV: $studentId\nTrạng thái: Đã check out';
                checkStatus = 'Checked Out';
              });
            } else {
              await _checkInOut(studentId);
            }
          } else {
            setState(() {
              studentInfo = 'Sinh viên chưa đăng kí';
              checkStatus = null;
            });
          }
        } else {
          setState(() {
            studentInfo = 'Không tìm thấy sinh viên';
            checkStatus = null;
          });
        }
      } else {
        setState(() {
          studentInfo = 'No QR code data';
          checkStatus = null;
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
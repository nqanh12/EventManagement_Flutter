// import 'package:doan/User/scannerqr.dart';
// import 'package:doan/Home/login.dart';
// import 'package:doan/Admin/event_management.dart';
import 'package:doan/Home/home.dart';
// import 'package:doan/User/qrcode.dart';
// import 'package:doan/Admin/account_management.dart';
// import 'package:doan/Admin/dash_board_admin.dart';
// import 'package:doan/Home/signup.dart';
// import 'package:doan/Event/list_event.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      title: 'Trang chủ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:const Home(),
    );
  }
}



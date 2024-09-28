// import 'package:doan/User/scannerqr.dart';
// import 'package:doan/Home/login.dart';
// import 'package:doan/Admin/event_list_management.dart';
// import 'package:doan/Home/home.dart';
// import 'package:doan/User/qrcode.dart';
// import 'package:doan/Admin/account_management.dart';
// import 'package:doan/Component/Admin/dash_board_admin.dart';
import 'package:doan/Component/Home/login.dart';
// import 'package:doan/Event/list_event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doan/Handle/user_handle.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MyApp(),
    ),
  );
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
      home:const Login(),
    );
  }
}



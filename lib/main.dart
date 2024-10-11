import 'package:doan/Component/Home/login.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(
    const MyApp(),
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



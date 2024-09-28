import 'package:doan/Component/Admin/dash_board_admin.dart';
import 'package:doan/Component/Home/home.dart';
import 'package:doan/Component/Home/signup.dart';
import 'package:flutter/material.dart';
import 'package:doan/Handle/user_handle.dart';
import 'package:provider/provider.dart';

  class Login extends StatefulWidget {
    const Login({super.key});

    @override
    LoginState createState() => LoginState();
  }

  class LoginState extends State<Login> {
    final LoginService _loginService = LoginService();
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

     void _handleLogin() async {
      String username = _usernameController.text.toString();
      String password = _passwordController.text.toString();
      Map<String, dynamic> result = await _loginService.login(username, password);
      if (result['success']) {
        String role = result['role'];
        Provider.of<UserProvider>(context, listen: false).setUser(username, role);
        if (role == 'admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đăng nhập với tài khoản $username thành công')),
          );
        } else if (role == 'user') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Home()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đăng nhập với tài khoản $username thành công')),
          );
        } else if (role == 'manager') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Đăng nhập với tài khoản $username thành công')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thất bại')),
        );
      }
    }

    //Interface login
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            // Bắt đầu màn hiện
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 197, 216, 236),
                    Color.fromARGB(255, 25, 117, 215)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // textfield
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: Column(
                  children: [
                    const Text(
                      'Hệ thống đăng nhập',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.asset(
                      'assets/logo.png',
                      height: 350,
                      width: 350,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                        prefixIcon: const Icon(Icons.person, color: Color.fromARGB(255, 0, 0, 0)),
                        labelText: 'Tài khoản',
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                        prefixIcon: const Icon(Icons.lock, color: Color.fromARGB(255, 0, 0, 0)),
                        labelText: 'Mật khẩu',
                        labelStyle: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        elevation: 10,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: const Color.fromARGB(255, 0, 92, 250),
                        foregroundColor: const Color.fromARGB(255, 8, 8, 8), // Thiết lập màu chữ ở đây
                      ),
                      child: const Text('Đăng nhập'),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Chưa có tài khoản?',
                          style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Register(),
                              ),
                            );
                          },
                          child: const Text(
                            'Đăng ký ngay',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 13, 254),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // Kết thúc màn hiện
          ],
        ),
      );
    }
  }

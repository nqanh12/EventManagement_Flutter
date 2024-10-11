import 'package:flutter/material.dart';

class User {
  String userName;
  String password;
  String fullName;
  String classId;
  String email;
  String phone;
  String address;
  Set<String> roles;

  User({
    required this.userName,
    required this.password,
    required this.fullName,
    required this.classId,

    required this.email,
    required this.phone,
    required this.address,
    required this.roles,
  });
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});
  UserManagementScreenState createState() => UserManagementScreenState();
}

class UserManagementScreenState extends State<UserManagementScreen> {
  List<User> users = [
    User(
      userName: 'nguyenvana',
      password: 'password123',
      fullName: 'Nguyen Van A',
      classId: 'Class1',
      email: 'nguyenvana@example.com',
      phone: '123456789',
      address: '123 Main St',
      roles: {'Admin'},
    ),
    // Add more users here
  ];

  List<User> filteredUsers = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredUsers = users; // Initialize filtered list with all users
  }

  // Function to filter users by name or role
  void _filterUsers(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredUsers = users;
      } else {
        filteredUsers = users.where((user) {
          final lowerCaseQuery = query.toLowerCase();
          return user.fullName.toLowerCase().contains(lowerCaseQuery) ||
              user.roles.any((role) => role.toLowerCase().contains(lowerCaseQuery));
        }).toList();
      }
    });
  }

  // Function to handle adding or editing users
  void _showUserForm({User? user}) {
    final isEditing = user != null;
    final userNameController = TextEditingController(text: isEditing ? user.userName : '');
    final passwordController = TextEditingController(text: isEditing ? user.password : '');
    String selectedRole = isEditing && user.roles.isNotEmpty ? user.roles.first : 'USER';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? "Sửa người dùng" : "Thêm người dùng"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(userNameController, "Tên đăng nhập"),
                const SizedBox(height: 10),
                _buildTextField(passwordController, "Mật khẩu"),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: "Quyền",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.9),
                  ),
                  items: ['USER', 'MANAGER'].map((role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRole = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isEditing) {
                    user.userName = userNameController.text;
                    user.password = passwordController.text;
                    user.roles = {selectedRole};
                  } else {
                    users.add(User(
                      userName: userNameController.text,
                      password: passwordController.text,
                      fullName: '',
                      classId: '',
                      email: '',
                      phone: '',
                      address: '',
                      roles: {selectedRole},
                    ));
                  }
                  filteredUsers = users; // Reset filtered list after adding or editing
                });
                Navigator.pop(context);
              },
              child: Text(isEditing ? "Sửa" : "Thêm"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 197, 216, 236), Color.fromARGB(255, 25, 117, 215)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Tìm kiếm theo tên hoặc quyền",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(1),
                ),
                onChanged: (value) {
                  _filterUsers(value); // Filter users when search query changes
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = filteredUsers[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 10,
                      margin: const EdgeInsets.only(bottom: 20), // Thêm margin-bottom
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color.fromARGB(255, 25, 117, 215),
                          child: Text(
                            user.fullName[0],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _showUserForm(user: user),
                            ),
                          ],
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
      floatingActionButton: Material(
        elevation: 10,
        shadowColor: Colors.blueAccent, // Set the shadow color here
        shape: const CircleBorder(),
        child: FloatingActionButton(
          onPressed: () => _showUserForm(),
          backgroundColor: Colors.white,
          child: const Icon(Icons.add, color: Colors.black),
        ),
      ),
    );
  }
}

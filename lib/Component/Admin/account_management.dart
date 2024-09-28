import 'package:flutter/material.dart';

class User {
  String name;
  String email;
  String role;

  User({required this.name, required this.email, required this.role});
}

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  _UserManagementScreenState createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  List<User> users = [
    User(name: 'Nguyen Van A', email: 'nguyenvana@example.com', role: 'Admin'),
    User(name: 'Tran Thi B', email: 'tranthib@example.com', role: 'User'),
    User(name: 'Le Van C', email: 'levanc@example.com', role: 'Manager'),
    User(name: 'Nguyen Van D', email: 'nguyenvand@example.com', role: 'User'),
    User(name: 'Pham Thi E', email: 'phamthie@example.com', role: 'Manager'),
    User(name: 'Hoang Van F', email: 'hoangvanf@example.com', role: 'Admin'),
    User(name: 'Tran Van G', email: 'tranvang@example.com', role: 'User'),
    User(name: 'Le Thi H', email: 'lethih@example.com', role: 'Admin'),
    User(name: 'Vu Van I', email: 'vuvani@example.com', role: 'Manager'),
    User(name: 'Pham Van J', email: 'phamvanj@example.com', role: 'User'),
    User(name: 'Nguyen Thi K', email: 'nguyenthik@example.com', role: 'Admin'),
    User(name: 'Tran Van L', email: 'tranvanl@example.com', role: 'Manager'),
    User(name: 'Le Van M', email: 'levanm@example.com', role: 'User'),
    User(name: 'Nguyen Thi N', email: 'nguyenthin@example.com', role: 'User'),
    User(name: 'Pham Van O', email: 'phamvano@example.com', role: 'Admin'),
    User(name: 'Hoang Thi P', email: 'hoangthip@example.com', role: 'Manager'),
    User(name: 'Tran Van Q', email: 'tranvanq@example.com', role: 'User'),
    User(name: 'Le Thi R', email: 'lethir@example.com', role: 'User'),
    User(name: 'Vu Van S', email: 'vuvans@example.com', role: 'Manager'),
    User(name: 'Pham Thi T', email: 'phamthit@example.com', role: 'Admin'),
    User(name: 'Nguyen Van U', email: 'nguyenvanu@example.com', role: 'User'),
    User(name: 'Tran Thi V', email: 'tranthiv@example.com', role: 'Manager'),
    User(name: 'Le Van W', email: 'levanw@example.com', role: 'Admin'),
    User(name: 'Nguyen Thi X', email: 'nguyenthix@example.com', role: 'User'),
    User(name: 'Pham Van Y', email: 'phamvany@example.com', role: 'Manager'),
    User(name: 'Hoang Thi Z', email: 'hoangthiz@example.com', role: 'Admin'),
    User(name: 'Tran Van AA', email: 'tranvanaa@example.com', role: 'User'),
    User(name: 'Le Thi BB', email: 'lethibb@example.com', role: 'Admin'),
    User(name: 'Vu Van CC', email: 'vuvancc@example.com', role: 'Manager'),
    User(name: 'Pham Thi DD', email: 'phamthidd@example.com', role: 'User'),
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
          return user.name.toLowerCase().contains(lowerCaseQuery) ||
              user.role.toLowerCase().contains(lowerCaseQuery);
        }).toList();
      }
    });
  }

  // Function to handle adding or editing users
  void _showUserForm({User? user}) {
    final isEditing = user != null;
    final roleController = TextEditingController(text: isEditing ? user.role : '');
    final nameController = TextEditingController(text: isEditing ? user.name : '');
    final emailController = TextEditingController(text: isEditing ? user.email : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? "Sửa người dùng" : "Thêm người dùng"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, "Họ và tên"),
              const SizedBox(height: 10),
              _buildTextField(emailController, "Email"),
              const SizedBox(height: 10),
              _buildTextField(roleController, "Quyền"),
            ],
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
                    user.name = nameController.text;
                    user.email = emailController.text;
                    user.role = roleController.text;
                  } else {
                    users.add(User(
                      name: nameController.text,
                      email: emailController.text,
                      role: roleController.text,
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

  void _deleteUser(User user) {
    setState(() {
      users.remove(user);
      filteredUsers = users; // Reset filtered list after deletion
    });
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
                            user.name[0],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(user.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _showUserForm(user: user),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteUser(user),
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

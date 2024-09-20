import 'package:flutter/material.dart';

class Event {
  String name;
  DateTime dateTime;
  String location;

  Event({required this.name, required this.dateTime, required this.location});
}

class EventManagementScreen extends StatefulWidget {
  const EventManagementScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EventManagementScreenState createState() => _EventManagementScreenState();
}

class _EventManagementScreenState extends State<EventManagementScreen> {
  List<Event> events = [
    Event(name: 'Conference', dateTime: DateTime(2024, 9, 12, 10, 0), location: 'HCMC Hall'),
    Event(name: 'Workshop', dateTime: DateTime(2024, 9, 15, 14, 0), location: 'Tech Lab'),
    Event(name: 'Seminar', dateTime: DateTime(2024, 9, 20, 9, 0), location: 'Auditorium'),
  ];

  void _showEventForm({Event? event}) {
    final isEditing = event != null;
    final nameController = TextEditingController(text: isEditing ? event.name : '');
    final locationController = TextEditingController(text: isEditing ? event.location : '');
    DateTime selectedDateTime = isEditing ? event.dateTime : DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? "Sửa sự kiện" : "Thêm sự kiện"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(nameController, "Tên sự kiện"),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDateTime,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2025),
                  );
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      // ignore: use_build_context_synchronously
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: Text(
                    "Chọn ngày & giờ: ${selectedDateTime.toLocal().toString().split(' ')[0]} ${TimeOfDay.fromDateTime(selectedDateTime).format(context)}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildTextField(locationController, "Địa điểm"),
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
                    event.name = nameController.text;
                    event.dateTime = selectedDateTime;
                    event.location = locationController.text;
                  } else {
                    events.add(Event(
                      name: nameController.text,
                      dateTime: selectedDateTime,
                      location: locationController.text,
                    ));
                  }
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

  void _deleteEvent(Event event) {
    setState(() {
      events.remove(event);
    });
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
      appBar: AppBar(
        title: const Text(
          'Quản Lý Sự Kiện',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
              const SizedBox(height: 100),
              Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ListTile(
                        title: Text(event.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          "${event.dateTime.toLocal()} - ${event.location}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _showEventForm(event: event),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteEvent(event),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventForm(),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

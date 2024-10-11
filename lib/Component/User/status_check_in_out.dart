import 'package:flutter/material.dart';

class CheckInOutStatusScreen extends StatefulWidget {
  final List<Event> events;

  const CheckInOutStatusScreen({super.key, required this.events});

  @override
  _CheckInOutStatusScreenState createState() => _CheckInOutStatusScreenState();
}

class _CheckInOutStatusScreenState extends State<CheckInOutStatusScreen> {
  String? selectedYear;
  List<String> years = [];

  @override
  void initState() {
    super.initState();
    _initializeYears();
  }

  void _initializeYears() {
    final currentYear = DateTime.now().year;
    for (int i = 0; i < 10; i++) {
      years.add((currentYear - i).toString());
    }
  }

  List<Event> _filterEventsByYear() {
    if (selectedYear == null) {
      return widget.events;
    }
    return widget.events.where((event) {
      return DateTime.parse(event.dateStart).year.toString() == selectedYear;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _filterEventsByYear();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch sử',
          style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 25, 117, 215),
      ),
      body: Container(
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButton<String>(
                hint: const Text(
                  "Chọn năm",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: selectedYear,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedYear = newValue;
                  });
                },
                items: years.map<DropdownMenuItem<String>>((String year) {
                  return DropdownMenuItem<String>(
                    value: year,
                    child: Text(
                      year,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  );
                }).toList(),
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                underline: Container(
                  height: 2,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = filteredEvents[index];
                  return _buildEventCard(event);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(Event event) {
    // Determine the check-in/check-out status
    String status;
    Color statusColor;
    IconData statusIcon;

    if (event.checkInStatus && event.checkOutStatus) {
      status = 'Đã hoàn thành';
      statusColor = Colors.green;
      statusIcon = Icons.check_circle_outline;
    } else if (event.checkInStatus) {
      status = 'Chưa hoàn thành';
      statusColor = Colors.orange;
      statusIcon = Icons.warning_amber;
    } else if (event.checkOutStatus) {
      status = 'Chưa hoàn thành';
      statusColor = Colors.orange;
      statusIcon = Icons.logout;
    } else if (DateTime.now().isAfter(DateTime.parse(event.dateEnd))) {
      status = 'Đã Bỏ lỡ';
      statusColor = Colors.red;
      statusIcon = Icons.cancel;
    } else {
      status = 'Pending';
      statusColor = Colors.yellow;
      statusIcon = Icons.pending;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        leading: Icon(
          statusIcon,
          color: statusColor,
          size: 30,
        ),
        title: Text(
          event.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          'BĐ: ${event.dateStart}\nKT: ${event.dateEnd}',
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status,
              style: TextStyle(
                fontSize: 16,
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              event.time.isNotEmpty ? event.time : '',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class Event {
  final String name;
  final String dateStart;
  final String dateEnd;
  final bool checkInStatus;
  final bool checkOutStatus;
  final String time;

  Event({
    required this.name,
    required this.dateStart,
    required this.dateEnd,
    required this.checkInStatus,
    required this.checkOutStatus,
    required this.time,
  });
}
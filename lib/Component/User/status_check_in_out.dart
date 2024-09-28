import 'package:flutter/material.dart';

class CheckInOutStatusScreen extends StatelessWidget {
  final List<Event> events;

  const CheckInOutStatusScreen({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lịch sử',
          style: TextStyle(color: Colors.black,fontSize: 30,fontWeight: FontWeight.bold),
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
        child: ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return _buildEventCard(event);
          },
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

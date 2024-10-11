import 'package:doan/Component/Home/home.dart';
import 'package:doan/Component/User/scannerqr.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class ListEventCheck extends StatefulWidget {
  final String role;
  final String token;
  const ListEventCheck({super.key, required this.role, required this.token});

  @override
  EventListScreenState createState() => EventListScreenState();
}

class EventListScreenState extends State<ListEventCheck> {
  List<dynamic> _events = [];
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';

  Future<void> _fetchEvents() async {
    const String url = 'http://10.0.2.2:8080/api/events/listEvent';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _events = json.decode(response.body)['result'];
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load events: ${response.statusCode}')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchEvents();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreEvents();
    }
  }

  void _loadMoreEvents() {
    // setState(() {
    //   _events.addAll(List.generate(10, (index) => "Event ${_events.length + index}"));
    // });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // Định dạng ngày tháng năm với A.M./P.M.
  String _formatDateTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('dd/MM/yyyy -- HH:mm a');
    return formatter.format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // Adjust the height as needed
        child: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            padding: const EdgeInsets.only(top: 20), // Add vertical padding
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(role: widget.role, token: widget.token),
                ),
              );
            },
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 20), // Add vertical padding
            child: Text(
              "Điểm Danh",
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 25, 117, 215),
          elevation: 0,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFC5D8EC),
              Color(0xFF1975D7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 80),
              _buildSearchBar(),
              const SizedBox(height: 20), // Added extra space below the filter options
              Expanded(
                child: _buildEventList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 30.0),
      child: TextField(
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: "Tìm kiếm sự kiện...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildEventList() {
    final filteredEvents = _events
        .where((event) =>
        event['name'].toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return ListView.builder(
      controller: _scrollController,
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        return _buildEventCard(filteredEvents[index], index);
      },
    );
  }

  Widget _buildEventCard(dynamic event, int index) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12), // Added more margin for spacing between cards
      color: Colors.white.withOpacity(0.9),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Added padding inside the card for more space between text and card edges
        child: ListTile(
          contentPadding: const EdgeInsets.all(5), // Reduced content padding for tighter layout
          title: Text(
            event['name'],
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20), // Increased font size for title
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5), // Added spacing between title and subtitle
              Text(
                "Ngày bắt đầu: ${_formatDateTime(event['dateStart'])} ",
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),
          trailing: const Icon(Icons.qr_code_scanner_rounded, color: Colors.black, size: 50),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QRCodeScanScreen(),
              ),
            );
          },
        ),
      ),
    );
  }
}
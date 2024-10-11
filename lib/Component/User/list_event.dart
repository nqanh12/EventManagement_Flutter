import 'package:doan/Component/Home/home.dart';
import 'package:doan/Component/User/detail_event.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ListEvent extends StatefulWidget {
  final String role;
  final String token;
  const ListEvent({super.key, required this.role, required this.token});

  @override
  EventListScreenState createState() => EventListScreenState();
}

class EventListScreenState extends State<ListEvent> {
  List<dynamic> _events = [];
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _filter = 'Tất cả';

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

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreEvents();
    }
  }

  void _loadMoreEvents() {
    // Implement pagination if needed
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  //Định dạng ngày tháng năm
  String _formatDateTime(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    final DateFormat formatter = DateFormat('dd/MM/yyyy -- HH:mm a');
    return formatter.format(parsedDate);
  }
  void _onFilterChanged(String? value) {
    setState(() {
      _filter = value ?? 'Tất cả';
    });
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
              "Sự kiện",
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
              const SizedBox(height: 20), // Added extra space below the search bar
              _buildFilterOptions(),
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
      margin: const EdgeInsets.only(top: 10.0),
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
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Increased vertical padding for more space
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
      child: DropdownButton<String>(
        borderRadius: BorderRadius.circular(20),
        value: _filter,
        onChanged: _onFilterChanged,
        items: <String>['Tất cả', 'Sắp tới', 'Đã qua', 'Hôm nay']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        isExpanded: true,
        underline: Container(),
        icon: const Icon(Icons.filter_list, color: Colors.black),
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildEventList() {
    final filteredEvents = _events
        .where((event) =>
    event['name'].toLowerCase().contains(_searchQuery.toLowerCase()) &&
        (_filter == 'Tất cả' || _applyFilter(event)))
        .toList();

    return ListView.builder(
      controller: _scrollController,
      itemCount: filteredEvents.length,
      itemBuilder: (context, index) {
        return _buildEventCard(filteredEvents[index], index);
      },
    );
  }

  bool _applyFilter(dynamic event) {
    if (_filter == 'Sắp tới') {
      return event['dateStart'].contains('Sắp tới');
    } else if (_filter == 'Đã qua') {
      return event['dateStart'].contains('Đã qua');
    } else if (_filter == 'Hôm nay') {
      return event['dateStart'].contains('Hôm nay');
    }
    return true;
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
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsScreen(
                  isRegistered: true,
                  role: widget.role,
                  token: widget.token,
                  eventID: event['eventID'],
                  name: event['name'],
                  dateStart: "Ngày bắt đầu: ${_formatDateTime(event['dateStart'])}",
                  dateEnd: "Ngày kết thúc: ${_formatDateTime(event['dateEnd'])}",
                  location:"Địa điểm: ${event['locationId']}",
                  description: event['description'],
                  checkInStatus: false, // Giả định mặc định là false
                  checkOutStatus: false, // Giả định mặc định là false
                  managerId: event['managerName'], // Giả định ID người quản lý
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
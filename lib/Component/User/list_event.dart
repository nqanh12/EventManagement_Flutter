import 'package:doan/Component/User/detail_event.dart';
import 'package:doan/Component/Home/home.dart';
import 'package:flutter/material.dart';

class ListEvent extends StatefulWidget {
  const ListEvent({super.key});

  @override
  EventListScreenState createState() => EventListScreenState();
}

class EventListScreenState extends State<ListEvent> {
  final List<String> _events = List.generate(10, (index) => "Event $index");
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _filter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    setState(() {
      _events.addAll(List.generate(10, (index) => "Event ${_events.length + index}"));
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onFilterChanged(String? value) {
    setState(() {
      _filter = value ?? 'All';
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
                  builder: (context) => const Home(),
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
            event.toLowerCase().contains(_searchQuery.toLowerCase()) &&
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

  bool _applyFilter(String event) {
    if (_filter == 'Sắp tới') {
      return event.contains('Sắp tới');
    } else if (_filter == 'Đã qua') {
      return event.contains('Đã qua');
    } else if (_filter == 'Hôm nay') {
      return event.contains('Hôm nay');
    }
    return true;
  }

  Widget _buildEventCard(String event, int index) {
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
            event,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20), // Increased font size for title
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5), // Added spacing between title and subtitle
              Text(
                "Ngày bắt đầu: ${_getFormattedDate(index)}",
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
                  name: event,
                  dateStart: "Ngày bắt đầu: ${_getFormattedDate(index)}",
                  dateEnd:
                      "Ngày kết thúc: ${_getFormattedDate(index + 1)}", // giả định sự kiện kéo dài 1 ngày
                  location: "Vị trí $index",
                  description: "Mô tả cho sự kiện $index.",
                  checkInStatus: false, // Giả định mặc định là false
                  checkOutStatus: false, // Giả định mặc định là false
                  managerId: "Manager $index", // Giả định ID người quản lý
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _getFormattedDate(int index) {
    DateTime now = DateTime.now().add(Duration(days: index));
    return "${now.day}-${now.month}-${now.year}";
  }
}

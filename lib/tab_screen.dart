import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Setingan BottomNavigationBar
class TabScreen extends StatefulWidget {
  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    DashboardTab(),
    StudentsTab(),
    ProfileTab(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMK Negeri 4 - Mobile App'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        backgroundColor: Color.fromARGB(255, 3, 95, 255),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Layout untuk Tab Dashboard
class DashboardTab extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.school_outlined, 'label': 'Academics'},
    {'icon': Icons.class_, 'label': 'Classes'},
    {'icon': Icons.event_note_outlined, 'label': 'Events'},
    {'icon': Icons.notifications_outlined, 'label': 'Alerts'},
    {'icon': Icons.assignment_outlined, 'label': 'Tasks'},
    {'icon': Icons.chat_bubble_outline, 'label': 'Chat'},
    {'icon': Icons.settings_outlined, 'label': 'Preferences'},
    {'icon': Icons.help_outline, 'label': 'Support'},
    {'icon': Icons.map_outlined, 'label': 'Map'},
    {'icon': Icons.calendar_today_outlined, 'label': 'Calendar'},
    {'icon': Icons.phone_outlined, 'label': 'Contact'},
    {'icon': Icons.info_outline, 'label': 'Info'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of items per row
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () {
              // Handle tap on the menu icon
              print('${item['label']} tapped');
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4,
              shadowColor: Colors.blueAccent.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], size: 40.0, color: Colors.blueAccent),
                    SizedBox(height: 10.0),
                    Text(
                      item['label'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Layout untuk Tab Students
class StudentsTab extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  child: ListTile(
                    leading: Icon(Icons.person_outline, color: Colors.blueAccent),
                    title: Text(user.firstName),
                    subtitle: Text(user.email),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

// Layout untuk Tab Profile
class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile_picture.jpg'),
            ),
          ),
          SizedBox(height: 25),
          Center(
            child: Text(
              'Asahi',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Email: as4hi@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          SizedBox(height: 35),
          Text(
            'Profile Information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person_outline, color: Colors.blueAccent),
            title: Text('Full Name'),
            subtitle: Text('Asahi Hamada'),
          ),
          ListTile(
            leading: Icon(Icons.cake_outlined, color: Colors.blueAccent),
            title: Text('Date of Birth'),
            subtitle: Text('August 20, 2001'),
          ),
        ],
      ),
    );
  }
}

class User {
  final String firstName;
  final String email;

  User({required this.firstName, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      email: json['email'],
    );
  }
}

void main() => runApp(MaterialApp(home: TabScreen()));

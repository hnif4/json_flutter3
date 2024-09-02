import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Setingan TabMenu
class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('SMK Negeri 4 - Mobile Apps'),
        ),
        body: TabBarView(
          children: [
            BerandaTab(),
            UsersTab(),
            ProfilTab(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.home), text: 'Beranda'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.person), text: 'Profil'),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
        ),
      ),
    );
  }
}

// Layout untuk Tab Beranda
class BerandaTab extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.school, 'label': 'Sekolah', 'color': Color.fromARGB(255, 24, 95, 104)},
    {'icon': Icons.library_books, 'label': 'Kurikulum', 'color': Colors.purple},
    {'icon': Icons.event_available, 'label': 'Agenda', 'color': Color.fromARGB(255, 88, 61, 20)},
    {'icon': Icons.notification_important, 'label': 'Pemberitahuan', 'color': Colors.red},
    {'icon': Icons.assignment, 'label': 'Tugas', 'color': Colors.blue},
    {'icon': Icons.message, 'label': 'Pesan', 'color': Colors.teal},
    {'icon': Icons.settings, 'label': 'Pengaturan', 'color': Colors.brown},
    {'icon': Icons.help_outline, 'label': 'Bantuan', 'color': Colors.indigo},
    {'icon': Icons.map, 'label': 'Peta', 'color': Color.fromARGB(255, 62, 133, 45)},
    {'icon': Icons.calendar_today, 'label': 'Kalender', 'color': Colors.deepOrange},
    {'icon': Icons.contact_mail, 'label': 'Kontak', 'color': Colors.pink},
    {'icon': Icons.info_outline, 'label': 'Tentang', 'color': Color.fromARGB(255, 149, 151, 131)},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of items per row
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 19.0,
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () {
              // Handle tap on the menu icon
              print('${item['label']} tapped');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: item['color'],
                border: Border.all(color: Colors.blueAccent),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], size: 30.0, color: Color.fromARGB(255, 253, 253, 253)),
                  SizedBox(height: 8.0),
                  Text(
                    item['label'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Color.fromARGB(255, 251, 248, 248), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Layout untuk Tab User
class UsersTab extends StatelessWidget {
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
      appBar: AppBar(
        title: Text('Daftar Pengguna'),
      ),
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
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://reqres.in/img/faces/${index + 1}-image.jpg'), // Example profile picture
                    ),
                    title: Text(
                      user.firstName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Handle tap on user
                      print('${user.firstName} tapped');
                    },
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
// Layout untuk Tab Profil
class ProfilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,  // Reduced the size of the profile picture
              backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuSzCK4jpO7wAhaXwVA9ehZ_XrtmNDfxiA2omwQu1fGQyMw0sIgT6qM0YzaJ9r3lgUYAI&usqp=CAU'),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Siti Nur Hanifah',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Email: nhanifah@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
          SizedBox(height: 30),
          Text(
            'Biodata',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Nama Lengkap'),
            subtitle: Text('Siti Nur Hanifah'),
          ),
          ListTile(
            leading: Icon(Icons.cake),
            title: Text('Tanggal Lahir'),
            subtitle: Text('29 Mei 2007'),
          ),
          // Add more fields as necessary
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

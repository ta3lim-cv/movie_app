import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      appBar: AppBar(
        title: const Text('My Account', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundColor: Color.fromARGB(255, 255, 193, 7),
                child: Icon(Icons.person, size: 60.0, color: Color.fromARGB(255, 4, 4, 4)),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Our First APP 😊',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'The_Great_Team@student.nu.edu.sa',
              style: TextStyle(
                fontSize: 14.0,
                color: Color.fromARGB(255, 170, 170, 170),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              color: const Color.fromARGB(255, 34, 34, 34),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.settings, color: Color.fromARGB(255, 150, 150, 150)),
                title: const Text('App Settings', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {},
              ),
            ),
            Card(
              color: const Color.fromARGB(255, 34, 34, 34),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.favorite, color: Color.fromARGB(255, 215, 31, 18)),
                title: const Text('Favorite Movies', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {},
              ),
            ),
            Card(
              color: const Color.fromARGB(255, 34, 34, 34),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.info, color: Color.fromARGB(255, 21, 140, 238)),
                title: const Text('About App', style: TextStyle(color: Colors.white)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {},
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 195, 5, 5),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
              },
              icon: const Icon(Icons.logout, color: Color.fromARGB(255, 252, 251, 251)),
              label: const Text('Log Out',
                  style: TextStyle(color: Color.fromARGB(255, 253, 253, 253), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
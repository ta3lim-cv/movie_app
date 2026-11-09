import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/genres_screen.dart'; 
import 'screens/account_screen.dart';

void main() async {
  // 1. Ensure Flutter framework binding is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Initialize Firebase core app
  await Firebase.initializeApp();

  runApp(const MovieApp());
}

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      // Set main navigation screen as app root
      home: const MainNavigationScreen(),
    );
  }
}

// Main Navigation Screen embedded inside main.dart
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // Current active tab index
  int _currentIndex = 0;

  // List of all app screens (genres_screen must be imported above)
  final List<Widget> _screens = [
    const HomeScreen(),
    const SearchScreen(),
     GenresScreen(), 
    const AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display active screen based on index
      body: _screens[_currentIndex],
      
      // Bottom navigation bar for switching views
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Trigger UI rebuild on tab change
          });
        },
        backgroundColor: const Color(0xFF121212), // Dark streaming app theme
        selectedItemColor: Colors.amber, // Active tab icon color
        unselectedItemColor: Colors.grey, // Inactive tab icon color
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded),
            label: 'Genres',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
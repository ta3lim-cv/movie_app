import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/home_screen.dart'; // استدعاء الشاشة الرئيسية الجديدة

void main() async {
  // 1. ضمان تهيئة بيئة الفلاتر
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. تهيئة الفايربيس الأساسية
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
      home: const HomeScreen(), // نقطة البداية للمستخدم
    );
  }
}
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/movie_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('شاشة الأفلام الرئيسية'),
        backgroundColor: Colors.deepPurple,
      ),
      // استخدام StreamBuilder لجلب وتحديث الأفلام تلقائياً من Firestore
      body: StreamBuilder<List<Movie>>(
        stream: firebaseService.getMoviesStream(),
        builder: (context, snapshot) {
          // 1. حالة التحميل
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. حالة وجود خطأ
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ: ${snapshot.error}'));
          }
          // 3. حالة عدم وجود بيانات
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('لا توجد أفلام مضافة حالياً في قاعدة البيانات'));
          }

          final movies = snapshot.data!;

          // 4. عرض الأفلام في قائمة احترافية
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
             return Card(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: ListTile(
    // إضافة عرض الصورة هنا باستخدام leading
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        movie.imageUrl,
        width: 50,
        height: 70,
        fit: BoxFit.cover,
        // معالجة في حال كان الرابط خطأ أو غير صالح لتفادي توقف التطبيق
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 50,
            height: 70,
            color: Colors.grey[300],
            child: const Icon(Icons.movie, color: Colors.grey),
          );
        },
      ),
    ),
    title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text('التصنيف: ${movie.genre} | التقييم: ${movie.rating} ⭐'),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
  ),
);         
            },
          );
        },
      ),
    );
  }
}
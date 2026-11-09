import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Stream to fetch movies for the UI
Stream<List<Movie>> getMoviesStream() {
    return _firestore.collection('movies').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Movie.fromMap(doc.data());
      }).toList();
    });
  }
}
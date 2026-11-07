import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/movie.dart';

class FirebaseService {
  FirebaseService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Stream<List<Movie>> getMoviesStream() {
    return _firestore.collection('movies').snapshots().map((snapshot) {
      return snapshot.docs
          .map((document) => Movie.fromMap(document.data(), id: document.id))
          .toList(growable: false);
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/movie.dart';

/// CRUD de filmes no Firestore. Estrutura: users/{uid}/movies/{movieId}
class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _db.collection('users').doc(uid).collection('movies');

  // READ (em tempo real)
  Stream<List<Movie>> watchMovies(String uid) {
    return _col(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(Movie.fromDoc).toList());
  }

  // CREATE
  Future<void> addMovie(String uid, Movie movie) {
    return _col(uid).add({
      ...movie.toMap(),
      'createdAt': Timestamp.fromDate(movie.createdAt),
    });
  }

  // UPDATE
  Future<void> updateMovie(String uid, Movie movie) {
    return _col(uid).doc(movie.id).update(movie.toMap());
  }

  // DELETE
  Future<void> deleteMovie(String uid, String movieId) {
    return _col(uid).doc(movieId).delete();
  }
}

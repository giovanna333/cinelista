import 'package:cloud_firestore/cloud_firestore.dart';

enum MovieStatus { watchlist, watched }

class Movie {
  static const genres = [
    'Ação', 'Animação', 'Aventura', 'Comédia', 'Drama',
    'Ficção científica', 'Terror', 'Romance', 'Suspense', 'Documentário', 'Outro',
  ];

  final String? id;
  final String title;
  final String genre;
  final int year;
  final int rating; // 0 = sem nota, 1 a 5 = estrelas
  final MovieStatus status;
  final String comment;
  final DateTime createdAt;

  Movie({
    this.id,
    required this.title,
    required this.genre,
    required this.year,
    this.rating = 0,
    this.status = MovieStatus.watchlist,
    this.comment = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Movie.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Movie(
      id: doc.id,
      title: d['title'] ?? '',
      genre: d['genre'] ?? 'Outro',
      year: d['year'] ?? DateTime.now().year,
      rating: d['rating'] ?? 0,
      status: d['status'] == 'watched' ? MovieStatus.watched : MovieStatus.watchlist,
      comment: d['comment'] ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'genre': genre,
        'year': year,
        'rating': rating,
        'status': status.name,
        'comment': comment,
      };
}

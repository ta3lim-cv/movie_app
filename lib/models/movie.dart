class Movie {
  final String id;
  final String title;
  final String genre;
  final String year;
  final double rating;
  final String description;
  final String imageUrl;
  final String videoUrl;

  const Movie({
    this.id = '',
    required this.title,
    required this.genre,
    this.year = '',
    this.rating = 0,
    this.description = '',
    this.imageUrl = '',
    this.videoUrl = '',
  });

  factory Movie.fromMap(Map<String, dynamic> map, {String id = ''}) {
    return Movie(
      id: id,
      title: map['title'] as String? ?? '',
      genre: map['genre'] as String? ?? '',
      year: map['year']?.toString() ?? '',
      rating: _toDouble(map['rating']),
      description:
          map['description'] as String? ?? map['overview'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      videoUrl: map['videoUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'genre': genre,
      'year': year,
      'rating': rating,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}

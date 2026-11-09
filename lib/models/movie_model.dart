class Movie {
  final String title;
  final String genre;
  final double rating;
  final String imageUrl;
  final String overview;

// Movie model properties
  Movie({
    required this.title,
    required this.genre,
    required this.rating,
    required this.imageUrl,
    required this.overview,
  });

// Factory to convert Firebase Map data to a Movie object
factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'] ?? '',
      genre: map['genre'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      overview: map['overview'] ?? '',
    );
  }
}
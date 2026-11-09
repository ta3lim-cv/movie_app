import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/firebase_service.dart';

class GenresScreen extends StatelessWidget {
  GenresScreen({super.key});

  final FirebaseService _firebaseService = FirebaseService();

  // Helper method to get icon based on genre name
  IconData _getGenreIcon(String genreName) {
    switch (genreName.toLowerCase()) {
      case 'action':
        return Icons.bolt;
      case 'comedy':
        return Icons.sentiment_very_satisfied;
      case 'drama':
        return Icons.theater_comedy;
      case 'horror':
        return Icons.nightlight_round;
      case 'sci-fi':
        return Icons.rocket_launch;
      case 'animation':
        return Icons.auto_awesome;
      default:
        return Icons.movie;
    }
  }

  // Show movies dialog for selected genre
  void _showMovies(BuildContext context, String genreName, List<Movie> movies) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        icon: Icon(_getGenreIcon(genreName), color: const Color.fromARGB(255, 255, 193, 7)),
        title: Text(genreName, style: const TextStyle(color: Colors.white)),
        scrollable: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Movies', style: TextStyle(color: Color.fromARGB(255, 170, 170, 170))),
            const SizedBox(height: 8),
            for (final movie in movies)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.movie_outlined, color: Color.fromARGB(255, 255, 193, 7)),
                title: Text(movie.title, style: const TextStyle(color: Colors.white)),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close', style: TextStyle(color: Color.fromARGB(255, 255, 193, 7))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      appBar: AppBar(
        title: const Text('Movie Genres', style: TextStyle(color: Colors.white)),
        leading: const Icon(Icons.local_movies_outlined, color: Color.fromARGB(255, 255, 193, 7)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            // StreamBuilder to fetch movies from Firebase
            child: StreamBuilder<List<Movie>>(
              stream: _firebaseService.getMoviesStream(),
              builder: (context, snapshot) {
                // Show loading indicator
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 255, 193, 7)));
                }

                // Show error message if any
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)),
                  );
                }

                // Check if data is empty
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No genres available', style: TextStyle(color: Color.fromARGB(255, 170, 170, 170))),
                  );
                }

                final allMovies = snapshot.data!;
                // Extract unique genres from movies
                final genresList = allMovies.map((m) => m.genre).toSet().toList();

                return ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      'Find your next movie',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap a genre to see the movies.',
                      style: TextStyle(color: Color.fromARGB(255, 170, 170, 170)),
                    ),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const gap = 12.0;
                        final columns = ((constraints.maxWidth + gap) ~/ 160)
                            .clamp(1, 3)
                            .toInt();
                        final cardWidth =
                            (constraints.maxWidth - gap * (columns - 1)) / columns;

                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final genreName in genresList)
                              SizedBox(
                                width: cardWidth,
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  color: const Color.fromARGB(255, 34, 34, 34),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {
                                      // Filter movies belonging to the tapped genre
                                      final genreMovies = allMovies
                                          .where((m) => m.genre == genreName)
                                          .toList();
                                      _showMovies(context, genreName, genreMovies);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(_getGenreIcon(genreName),
                                              color: const Color.fromARGB(255, 255, 193, 7)),
                                          const SizedBox(height: 12),
                                          Text(
                                            genreName,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
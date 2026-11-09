import 'package:flutter/material.dart';

class Genre {
  const Genre(this.name, this.icon, this.color, this.movies);

  final String name;
  final IconData icon;
  final Color color;
  final List<String> movies;
}

const genres = [
  Genre('Action', Icons.bolt, Color.fromARGB(255, 255, 193, 7), [
    'Die Hard',
    'John Wick',
    'Mad Max: Fury Road',
  ]),
  Genre('Comedy', Icons.sentiment_very_satisfied, Color.fromARGB(255, 255, 193, 7), [
    'The Hangover',
    'Superbad',
    'Mrs. Doubtfire',
  ]),
  Genre('Drama', Icons.theater_comedy, Color.fromARGB(255, 255, 193, 7), [
    'The Shawshank Redemption',
    'Little Women',
    'The Godfather',
  ]),
  Genre('Horror', Icons.nightlight_round, Color.fromARGB(255, 255, 193, 7), [
    'A Quiet Place',
    'Get Out',
    'The Conjuring',
  ]),
  Genre('Sci-Fi', Icons.rocket_launch, Color.fromARGB(255, 255, 193, 7), [
    'Interstellar',
    'Arrival',
    'The Matrix',
  ]),
  Genre('Animation', Icons.auto_awesome, Color.fromARGB(255, 255, 193, 7), [
    'Spirited Away',
    'Toy Story',
    'Finding Nemo',
  ]),
];

class GenresScreen extends StatelessWidget {
  const GenresScreen({super.key});

  void _showMovies(BuildContext context, Genre genre) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 34, 34, 34),
        icon: Icon(genre.icon, color: const Color.fromARGB(255, 255, 193, 7)),
        title: Text(genre.name, style: const TextStyle(color: Colors.white)),
        scrollable: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Top 3 Movies', style: TextStyle(color: Color.fromARGB(255, 170, 170, 170))),
            const SizedBox(height: 8),
            for (final movie in genre.movies)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.movie_outlined, color: Color.fromARGB(255, 255, 193, 7)),
                title: Text(movie, style: const TextStyle(color: Colors.white)),
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
            child: ListView(
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
                  'Tap a genre to see the top 3 movies.',
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
                        for (final genre in genres)
                          SizedBox(
                            width: cardWidth,
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: const Color.fromARGB(255, 34, 34, 34),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => _showMovies(context, genre),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(genre.icon, color: const Color.fromARGB(255, 255, 193, 7)),
                                      const SizedBox(height: 12),
                                      Text(
                                        genre.name,
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
            ),
          ),
        ),
      ),
    );
  }
}
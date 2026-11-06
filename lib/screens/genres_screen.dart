import 'package:flutter/material.dart';

void main() => runApp(const MovieGenresApp());

class MovieGenresApp extends StatelessWidget {
  const MovieGenresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Genres',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xffffb7d9),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MovieGenresPage(),
    );
  }
}

class Genre {
  const Genre(this.name, this.icon, this.color, this.movies);

  final String name;
  final IconData icon;
  final Color color;
  final List<String> movies;
}

const genres = [
  Genre('Action', Icons.bolt, Color(0xffff9398), [
    'Die Hard',
    'John Wick',
    'Mad Max: Fury Road',
  ]),
  Genre('Comedy', Icons.sentiment_very_satisfied, Color(0xffedc87d), [
    'The Hangover',
    'Superbad',
    'Mrs. Doubtfire',
  ]),
  Genre('Drama', Icons.theater_comedy, Color(0xff9970b0), [
    'The Shawshank Redemption',
    'Little Women',
    'The Godfather',
  ]),
  Genre('Horror', Icons.nightlight_round, Color(0xff798bd7), [
    'A Quiet Place',
    'Get Out',
    'The Conjuring',
  ]),
  Genre('Sci-Fi', Icons.rocket_launch, Color(0xffafffb6), [
    'Interstellar',
    'Arrival',
    'The Matrix',
  ]),
  Genre('Animation', Icons.auto_awesome, Color(0xff9cdbe6), [
    'Spirited Away',
    'Toy Story',
    'Finding Nemo',
  ]),
];

class MovieGenresPage extends StatelessWidget {
  const MovieGenresPage({super.key});

  void _showMovies(BuildContext context, Genre genre) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(genre.icon, color: genre.color),
        title: Text(genre.name),
        scrollable: true,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Top 3 Movies'),
            const SizedBox(height: 8),
            for (final movie in genre.movies)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.movie_outlined),
                title: Text(movie),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Genres'),
        leading: const Icon(Icons.local_movies_outlined),
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
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text('Tap a genre to see the top 3 movies.'),
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
                              color: genre.color,
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => _showMovies(context, genre),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(genre.icon, color: Colors.black87),
                                      const SizedBox(height: 12),
                                      Text(
                                        genre.name,
                                        style: const TextStyle(
                                          color: Colors.black87,
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

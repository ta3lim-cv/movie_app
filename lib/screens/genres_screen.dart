import 'package:flutter/material.dart';

import '../data/movie_catalog.dart';
import '../models/movie.dart';
import '../widgets/movie_list_tile.dart';

class GenresScreen extends StatelessWidget {
  const GenresScreen({super.key});

  static const _icons = <String, IconData>{
    'Action': Icons.bolt_rounded,
    'Adventure': Icons.explore_rounded,
    'Drama': Icons.theater_comedy_rounded,
    'Mystery': Icons.travel_explore_rounded,
    'Romance': Icons.favorite_rounded,
    'Sci-Fi': Icons.rocket_launch_rounded,
    'Thriller': Icons.nights_stay_rounded,
  };

  Map<String, List<Movie>> get _moviesByGenre {
    final result = <String, List<Movie>>{};
    for (final movie in allMovies) {
      for (final genre in movie.genre.split('•')) {
        final name = genre.trim();
        result.putIfAbsent(name, () => <Movie>[]).add(movie);
      }
    }
    return result;
  }

  void _showMovies(BuildContext context, String genre, List<Movie> movies) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Text(
                  genre,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MovieListTile(movie: movies[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedMovies = _moviesByGenre;
    final genres = groupedMovies.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Movie genres')),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 220,
            mainAxisExtent: 145,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
          ),
          itemCount: genres.length,
          itemBuilder: (context, index) {
            final genre = genres[index];
            final movies = groupedMovies[genre]!;
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _showMovies(context, genre, movies),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _icons[genre] ?? Icons.movie_filter_rounded,
                        size: 30,
                      ),
                      const Spacer(),
                      Text(
                        genre,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text('${movies.length} movies'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

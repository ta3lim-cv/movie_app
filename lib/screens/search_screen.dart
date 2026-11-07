import 'package:flutter/material.dart';

import '../data/movie_catalog.dart';
import '../models/movie.dart';
import '../widgets/movie_list_tile.dart';
import 'video_player_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query = '';

  List<Movie> get _results {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) return allMovies;

    return allMovies
        .where((movie) {
          return movie.title.toLowerCase().contains(query) ||
              movie.genre.toLowerCase().contains(query) ||
              movie.year.contains(query);
        })
        .toList(growable: false);
  }

  void _openMovie(Movie movie) {
    if (movie.videoUrl.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            VideoPlayerPage(title: movie.title, videoUrl: movie.videoUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      appBar: AppBar(title: const Text('Search movies')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SearchBar(
                hintText: 'Title, genre, or year',
                leading: const Icon(Icons.search_rounded),
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? const _EmptySearch()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        final movie = results[index];
                        return MovieListTile(
                          movie: movie,
                          onTap: () => _openMovie(movie),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 54),
          SizedBox(height: 12),
          Text('No movies match your search'),
        ],
      ),
    );
  }
}

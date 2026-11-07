import 'package:flutter/material.dart';

import '../data/movie_catalog.dart';
import '../models/movie.dart';
import '../services/firebase_service.dart';
import '../widgets/movie_card.dart';
import 'video_player_page.dart';

const Color _background = Color(0xFFF6F4FA);
const Color _primary = Color(0xFF7456A6);
const Color _accent = Color(0xFFE978A0);
const Color _textColor = Color(0xFF29243D);
const Color _mutedColor = Color(0xFF827B92);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();

  void _playTrailer(Movie movie) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            VideoPlayerPage(title: movie.title, videoUrl: movie.videoUrl),
      ),
    );
  }

  void _openMovie(Movie movie) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      showDragHandle: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return FractionallySizedBox(
          widthFactor: 1,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: double.infinity,
                      height: 220,
                      child: _movieImage(movie),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: _textColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _infoChip(Icons.category_outlined, movie.genre),
                      _infoChip(Icons.calendar_today_outlined, movie.year),
                      _infoChip(
                        Icons.star_rounded,
                        movie.rating.toStringAsFixed(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Storyline',
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.description,
                    style: const TextStyle(
                      color: _mutedColor,
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 26),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: movie.videoUrl.isEmpty
                          ? null
                          : () {
                              Navigator.pop(sheetContext);
                              _playTrailer(movie);
                            },
                      icon: const Icon(Icons.play_arrow_rounded, size: 22),
                      label: Text(
                        movie.videoUrl.isEmpty
                            ? 'Trailer unavailable'
                            : 'Watch Trailer',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFF9),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _primary, size: 15),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: _textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _movieImage(Movie movie) {
    return Image.network(
      movie.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }

        return Container(
          color: const Color(0xFFEDE7F6),
          child: const Center(
            child: CircularProgressIndicator(color: _primary, strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7456A6), Color(0xFF29243D)],
            ),
          ),
          child: const Center(
            child: Icon(Icons.movie_rounded, color: Colors.white, size: 75),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _header()),
            SliverToBoxAdapter(child: _welcomeBanner()),
            SliverToBoxAdapter(
              child: _sectionHeading(
                'Featured Movie',
                'Our special pick for you',
              ),
            ),
            SliverToBoxAdapter(child: _hero()),
            SliverToBoxAdapter(
              child: _movieSection(
                'Trending Now',
                'Popular movies to discover',
                trendingMovies,
              ),
            ),
            SliverToBoxAdapter(
              child: _movieSection(
                'New Releases',
                'Fresh stories to explore',
                newReleases,
              ),
            ),
            SliverToBoxAdapter(child: _remoteMovies()),
            const SliverToBoxAdapter(child: SizedBox(height: 35)),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEDE7F6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.movie_filter_rounded,
              color: _primary,
              size: 25,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MOVIE APP',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 19,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Discover your next favorite',
                  style: TextStyle(color: _mutedColor, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            width: 43,
            height: 43,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFECE7F3)),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: _accent,
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  Widget _welcomeBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(22, 0, 22, 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFECE4F8), Color(0xFFFCEAF1)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What will you watch today?',
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 7),
                Text(
                  'Explore exciting stories and find a movie you will love.',
                  style: TextStyle(
                    color: _mutedColor,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Icon(Icons.local_movies_rounded, size: 47, color: _primary),
        ],
      ),
    );
  }

  Widget _sectionHeading(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _textColor,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(color: _mutedColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _hero() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 22),
      height: 310,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7F6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _movieImage(featuredMovie),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x3329243D),
                  Color(0xE629243D),
                ],
                stops: [0, 0.40, 1],
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: _accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'FEATURED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  featuredMovie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${featuredMovie.genre} • ${featuredMovie.year}',
                  style: const TextStyle(
                    color: Color(0xFFF2ECFA),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFFFC46B),
                      size: 18,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      featuredMovie.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                FilledButton.icon(
                  onPressed: () {
                    _openMovie(featuredMovie);
                  },
                  icon: const Icon(Icons.info_outline_rounded, size: 18),
                  label: const Text('Explore Movie'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _movieSection(String title, String subtitle, List<Movie> movies) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeading(title, subtitle),
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
              itemCount: movies.length,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 14);
              },
              itemBuilder: (context, index) {
                final movie = movies[index];

                return MovieCard(
                  movie: movie,
                  onTap: () {
                    _openMovie(movie);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _remoteMovies() {
    return StreamBuilder<List<Movie>>(
      stream: _firebaseService.getMoviesStream(),
      builder: (context, snapshot) {
        final movies = snapshot.data;
        if (movies == null || movies.isEmpty) {
          return const SizedBox.shrink();
        }

        return _movieSection(
          'Movie Library',
          'Movies added from your collection',
          movies,
        );
      },
    );
  }
}

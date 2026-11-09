import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/firebase_service.dart';

const _bg = Color(0xFF141414), _primary = Color(0xFFFFC107), _text = Colors.white, _muted = Color(0xFFB3B3B3);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firebaseService = FirebaseService();

  // Show movie details bottom sheet
  void _openMovie(Movie m) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: const Color(0xFF1F1F1F),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(width: double.infinity, height: 240, child: _movieImage(m)),
            ),
            const SizedBox(height: 22),
            Text(m.title, style: const TextStyle(color: _text, fontSize: 25, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              _Chip(icon: Icons.category_outlined, label: m.genre),
              _Chip(icon: Icons.star_rounded, label: m.rating.toStringAsFixed(1)),
            ]),
            const SizedBox(height: 24),
            const Text('Overview', style: TextStyle(color: _text, fontSize: 17, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            Text(m.overview.isEmpty ? 'No overview available.' : m.overview,
                style: const TextStyle(color: _muted, fontSize: 14, height: 1.7)),
          ],
        ),
      ),
    );
  }

  Widget _movieImage(Movie m) {
    if (m.imageUrl.isEmpty) return const _Placeholder(70);
    return Image.network(
      m.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (_, child, prog) => prog == null ? child : const ColoredBox(color: Color(0xFF2C2C2C), child: Center(child: CircularProgressIndicator(color: _primary, strokeWidth: 2))),
      errorBuilder: (_, __, ___) => const _Placeholder(70),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: StreamBuilder<List<Movie>>(
          stream: _firebaseService.getMoviesStream(),
          builder: (context, snapshot) {
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: _Header()),
                if (snapshot.connectionState == ConnectionState.waiting)
                  const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(color: _primary)))
                else if (snapshot.hasError)
                  const SliverFillRemaining(hasScrollBody: false, child: _Message(icon: Icons.cloud_off_rounded, title: 'Unable to load movies', message: 'Please check your connection.'))
                else if (snapshot.data == null || snapshot.data!.isEmpty)
                  const SliverFillRemaining(hasScrollBody: false, child: _Message(icon: Icons.movie_creation_outlined, title: 'No movies yet', message: 'Added movies will appear here.'))
                else ..._buildSlivers(snapshot.data!),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildSlivers(List<Movie> movies) {
    final featured = movies.first;
    return [
      const SliverToBoxAdapter(child: _Section(title: 'Featured Movie', subtitle: 'Our special pick for you')),
      SliverToBoxAdapter(child: _Featured(movie: featured, image: _movieImage(featured), onTap: () => _openMovie(featured))),
      const SliverToBoxAdapter(child: Padding(padding: EdgeInsets.only(top: 30), child: _Section(title: 'Explore Movies', subtitle: 'Discover stories from your collection'))),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 12),
            itemCount: movies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, i) => MovieCard(movie: movies[i], onTap: () => _openMovie(movies[i])),
          ),
        ),
      ),
      const SliverToBoxAdapter(child: SizedBox(height: 32)),
    ];
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({super.key, required this.movie, required this.onTap});
  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 166,
      child: Material(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF222222), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF333333))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        movie.imageUrl.isEmpty ? const _Placeholder(54) : Image.network(movie.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const _Placeholder(54)),
                        Positioned(
                          top: 9, right: 9,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0xCC141414), borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded, color: _primary, size: 15),
                                const SizedBox(width: 3),
                                Text(movie.rating.toStringAsFixed(1), style: const TextStyle(color: _text, fontSize: 11, fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 11),
                Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _text, fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(height: 5),
                Text(movie.genre, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: _muted, fontSize: 11)),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      child: Row(
        children: [
          Container(
            width: 46, height: 46,
            decoration: BoxDecoration(color: const Color(0xFF222222), borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.movie_filter_rounded, color: _primary, size: 25),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MOVIE APP', style: TextStyle(color: _text, fontSize: 19, letterSpacing: 1.2, fontWeight: FontWeight.w900)),
                SizedBox(height: 3),
                Text('Discover your next favorite', style: TextStyle(color: _muted, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.subtitle});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 0, 22, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: _text, fontSize: 21, fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text(subtitle, style: const TextStyle(color: _muted, fontSize: 12)),
        ],
      ),
    );
  }
}

class _Featured extends StatelessWidget {
  const _Featured({required this.movie, required this.image, required this.onTap});
  final Movie movie;
  final Widget image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      margin: const EdgeInsets.symmetric(horizontal: 22),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(color: const Color(0xFF222222), borderRadius: BorderRadius.circular(24)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          image,
          const DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0x66141414), Color(0xE6141414)], stops: [0, 0.4, 1]))),
          Positioned(
            top: 18, left: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(color: _primary, borderRadius: BorderRadius.circular(10)),
              child: const Text('FEATURED', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
            ),
          ),
          Positioned(
            left: 20, right: 20, bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(child: Text(movie.genre, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFFE5E5E5), fontSize: 12))),
                    const SizedBox(width: 10),
                    const Icon(Icons.star_rounded, color: _primary, size: 18),
                    const SizedBox(width: 4),
                    Text(movie.rating.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 15),
                FilledButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.info_outline_rounded, size: 18),
                  label: const Text('Explore Movie'),
                  style: FilledButton.styleFrom(backgroundColor: _primary, foregroundColor: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(11)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: _primary, size: 15),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: _text, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder(this.size);
  final double size;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF2C2C2C), Color(0xFF141414)])),
      child: Center(child: Icon(Icons.movie_rounded, size: size, color: Colors.white)),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.title, required this.message});
  final IconData icon;
  final String title, message;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: _primary),
            const SizedBox(height: 14),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(color: _text, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 7),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: _muted, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
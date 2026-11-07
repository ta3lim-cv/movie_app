import 'package:flutter/material.dart';

import '../models/movie.dart';

class MovieListTile extends StatelessWidget {
  const MovieListTile({super.key, required this.movie, this.onTap});

  final Movie movie;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 52,
            height: 72,
            child: Image.network(
              movie.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const ColoredBox(
                  color: Color(0xFFF0EBF7),
                  child: Icon(Icons.movie_rounded),
                );
              },
            ),
          ),
        ),
        title: Text(
          movie.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text('${movie.genre}  •  ${movie.year}'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, color: Color(0xFFFFB84D), size: 18),
            const SizedBox(width: 3),
            Text(movie.rating.toStringAsFixed(1)),
          ],
        ),
      ),
    );
  }
}

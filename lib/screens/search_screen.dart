import 'package:flutter/material.dart';
import '../models/movie_model.dart';
import '../services/firebase_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 20, 20),
      appBar: AppBar(
        title: const Text('Search Movies', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search by title...',
                labelStyle: const TextStyle(color: Color.fromARGB(255, 170, 170, 170)),
                prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 255, 193, 7)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 60, 60, 60)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Color.fromARGB(255, 255, 193, 7)),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Movie>>(
                stream: _firebaseService.getMoviesStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 255, 193, 7)));
                  }

                  final movies = snapshot.data!
                      .where((movie) =>
                          movie.title.toLowerCase().contains(_searchQuery))
                      .toList();

                  if (movies.isEmpty) {
                    return const Center(child: Text('No results found', style: TextStyle(color: Color.fromARGB(255, 170, 170, 170))));
                  }

                  return ListView.builder(
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Card(
                        color: const Color.fromARGB(255, 34, 34, 34),
                        child: ListTile(
                          leading: Image.network(
                            movie.imageUrl,
                            width: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.movie, color: Color.fromARGB(255, 255, 193, 7)),
                          ),
                          title: Text(movie.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          subtitle: Text('Genre: ${movie.genre}', style: const TextStyle(color: Color.fromARGB(255, 170, 170, 170))),
                          trailing: Text('${movie.rating} ⭐', style: const TextStyle(color: Color.fromARGB(255, 255, 193, 7))),
                        ),
                      );
                    },
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
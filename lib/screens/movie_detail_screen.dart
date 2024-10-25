import 'package:flutter/material.dart';
import 'package:project/models/movie.dart';
import 'package:project/widgets/starbuilder.dart';

/// A screen representing the movie details screen. This screen shows a movie
/// with every detail the movie has.
class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  final Movie movie;

  /// Converting genre to a readable format
  String get genreText {
    return movie.genre.name[0].toUpperCase() + movie.genre.name.substring(1);
  }

  /// Adds a movie to the watch list
  void _addToWatchList() {
    //TODO: Add logic to add a movie to watchlist
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    movie.posterUrl,
                    height: 300,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                movie.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Rating: ${movie.rating}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 10),
                      StarBuilder(rating: movie.rating),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _addToWatchList();
                    },
                    child: const Text('Add to Watchlist'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Genre: $genreText',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Text(
                movie.description,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

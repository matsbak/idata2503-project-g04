import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/models/movie.dart';
import 'package:project/providers/lists_provider.dart';
import 'package:project/widgets/reviews.dart';
import 'package:project/widgets/starbuilder.dart';

/// A screen representing the movie details screen. This screen shows a movie
/// with every detail the movie has.
class MovieDetailScreen extends ConsumerWidget {
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
  void _addToWatchList(BuildContext context, WidgetRef ref) {
    ref.read(watchlistProvider.notifier).addToWatchlist(movie);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movie added to watchlist')));
  }

  /// Removes a movie from the watch list
  void _removeFromWatchList(BuildContext context, WidgetRef ref) {
    ref.read(watchlistProvider.notifier).removeFromWatchlist(movie);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movie removed from watchlist')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(watchlistProvider);
    final isInWatchList = watchlist.contains(movie);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Rating: ${movie.averageRating}',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${movie.ratings.length})',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      StarBuilder(rating: movie.averageRating),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      if (isInWatchList) {
                        _removeFromWatchList(context, ref);
                      } else {
                        _addToWatchList(context, ref);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer),
                    child: Text(
                      isInWatchList
                          ? 'Remove from Watchlist'
                          : 'Add to Watchlist',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Genre: $genreText',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                movie.description,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 12),
              Reviews(ratings: movie.ratings),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/models/movie.dart';
import 'package:project/providers/lists_provider.dart';
import 'package:project/service/firebaseService.dart';
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

  /// Adds a movie to the watch list
  void _addToWatchList(BuildContext context, WidgetRef ref) async {
    try {
      final firebaseKey =
          await FirebaseService.addMovieToFirebase(movie);
      if (firebaseKey != null) {
        ref.read(watchlistProvider.notifier).addToWatchlist(movie);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movie added to watchlist')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add movie to watchlist: $error")),
      );
    }
  }

  /// Removes a movie from the watch list
  void _removeFromWatchList(BuildContext context, WidgetRef ref) async {
    try {
      await FirebaseService.removeMovieById(movie.id);

      ref.read(watchlistProvider.notifier).removeFromWatchlist(movie);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Movie removed from watchlist')));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to remove moive to watchlist: $error"),
      ));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlist = ref.watch(watchlistProvider);
    final myList = ref.watch(myListProvider);
    final isInLists =
        watchlist.contains(movie) || myList.contains(movie);

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
                  child: SizedBox(
                    height: 320,
                    child: movie.poster,
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
                      if (isInLists) {
                        _removeFromWatchList(context, ref);
                      } else {
                        _addToWatchList(context, ref);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer),
                    child: Text(
                      isInLists ? 'Remove from Watchlist' : 'Add to Watchlist',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Genres:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              for (final genre in movie.genres)
                Text(
                  genre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
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

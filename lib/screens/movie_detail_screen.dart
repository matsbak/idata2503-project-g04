import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/forms/auth_utils.dart';
import 'package:project/models/movie.dart';
import 'package:project/providers/authentication_provider.dart';
import 'package:project/providers/lists_provider.dart';
import 'package:project/providers/ratings_notifier.dart';
import 'package:project/service/firebase_service.dart';
import 'package:project/widgets/reviews.dart';
import 'package:project/widgets/starbuilder.dart';

/// A screen representing the movie details screen. This screen shows a movie
/// with every detail the movie has.
class MovieDetailScreen extends ConsumerStatefulWidget {
  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  ConsumerState<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ratingsProvider.notifier).fetchRatings(widget.movie.id);
    });
  }

  /// Adds a movie to the watch list
  Future<void> _addToWatchList(BuildContext context, WidgetRef ref) async {
    try {
      // Get the current user's uid from the authentication provider
      final uid = getUidIfLoggedIn(ref);
      if (uid != null) {
        // Add the movie to the user's Firestore document
        final firebaseKey =
            await FirebaseService.addMovieToFirebase(widget.movie, uid!);
        if (firebaseKey != null) {
          ref.read(watchlistProvider.notifier).addToWatchlist(widget.movie);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Movie added to watchlist')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add movie to watchlist: $error")),
      );
    }
  }

  /// Removes a movie from the watch list
  Future<void> _removeFromWatchList(BuildContext context, WidgetRef ref) async {
    try {
      final uid = getUidIfLoggedIn(ref);
      if (uid != null) {
        await FirebaseService.removeMovieById(widget.movie.id, uid);
        ref.read(watchlistProvider.notifier).removeFromWatchlist(widget.movie);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Movie removed from watchlist')));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to remove moive to watchlist: $error"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final watchlist = ref.watch(watchlistProvider);
    final myList = ref.watch(myListProvider);
    final isInLists =
        watchlist.contains(widget.movie) || myList.contains(widget.movie);

    final ratings = ref.watch(ratingsProvider);
    final averageRating = ref.watch(ratingsProvider.notifier).averageRating;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movie.title,
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
                    child: widget.movie.poster,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.movie.title,
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
                            'Rating: $averageRating',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${ratings.length})',
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      StarBuilder(rating: averageRating),
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
              for (final genre in widget.movie.genres)
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
                widget.movie.description,
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              const SizedBox(height: 12),
              Reviews(ratings: ratings),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/forms/auth_utils.dart';
import 'package:project/models/movie.dart';
import 'package:project/models/rating.dart';
import 'package:project/providers/lists_provider.dart';
import 'package:project/providers/ratings_provider.dart';
import 'package:project/services/firebase_service.dart';
import 'package:project/widgets/starbuilder.dart';

// TODO Make main content area scrollable instead of entire modal
class WatchlistModal extends ConsumerStatefulWidget {
  const WatchlistModal(this.movie, {super.key});

  final Movie movie;

  @override
  ConsumerState<WatchlistModal> createState() {
    return _WatchlistModalState();
  }
}

class _WatchlistModalState extends ConsumerState<WatchlistModal> {
  bool isAddedToMyList = false;

  void _removeFromWatchlist(String title) async {
    final uid = AuthUtils.getUidIfLoggedIn(ref);
    if (uid != null) {
      await FirebaseService.removeMovieFromWatchlist(widget.movie.id, uid);
      ref.read(watchlistProvider.notifier).removeFromWatchlist(widget.movie);

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$title removed from watchlist'),
      ));
    }
  }

  Future<void> _addToMyList(BuildContext context, WidgetRef ref) async {
    try {
      final uid = AuthUtils.getUidIfLoggedIn(ref);
      if (uid != null) {
        final firebaseKey =
            await FirebaseService.addMovieToMylist(widget.movie, uid);
        if (firebaseKey != null) {
          ref.read(myListProvider.notifier).addToMyList(widget.movie);
          ref
              .read(watchlistProvider.notifier)
              .removeFromWatchlist(widget.movie);
          setState(() {
            isAddedToMyList = true;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('IDK.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add movie to mylist: $error")),
      );
    }
    //ScaffoldMessenger.of(context).clearSnackBars();
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //  content: Text('$title added to my list'),
    //));
  }

  //Removes a movie form the mylist, and adds it back to wtachlist
  Future<void> _removeFromMyList(BuildContext context, WidgetRef ref) async {
    try {
      final uid = AuthUtils.getUidIfLoggedIn(ref);
      if (uid != null) {
        await FirebaseService.removeMovieFromMylist(widget.movie.id, uid);
        ref.read(myListProvider.notifier).removeFromMyList(widget.movie);
        await FirebaseService.addMovieToWatchlist(widget.movie, uid);
        ref.read(watchlistProvider.notifier).addToWatchlist(widget.movie);
        setState(() {
          isAddedToMyList = false;
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to remove moive to mylist: $error"),
      ));
    }
  }

  /// Calculates the average of all movie ratings. This methods first checks if the user has added
  /// a rating during the application lifecycle, by checking the ratings provider. If a rating has
  /// been added, it is included in the calculation for all movie ratings.
  double _calculateAverageRating() {
    List<Rating> ratings = [...widget.movie.ratings];
    double avg = 0.0;

    Rating? rating =
        ref.watch(ratingsProvider.notifier).getRating(widget.movie.id);
    if (rating != null) {
      ratings = [...widget.movie.ratings, rating];
    }

    if (ratings.isNotEmpty) {
      avg =
          ratings.map((r) => r.score).reduce((a, b) => a + b) / ratings.length;
    }

    return double.parse(avg.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    double averageRating = _calculateAverageRating();

    return Container(
      margin: const EdgeInsets.only(
        top: 20.0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
                size: 28.0,
                color: Colors.white,
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10.0,
                  bottom: 24.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: 250.0,
                  child: widget.movie.poster,
                ),
              ),
            ),
            Text(
              widget.movie.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                StarBuilder(rating: averageRating),
                const SizedBox(
                  width: 4.0,
                ),
                Text(
                  averageRating.toString(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              widget.movie.description,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text('Done watching?',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(
              height: 8.0,
            ),
            FilledButton(
              onPressed: isAddedToMyList
                  ? () {
                      _removeFromMyList(context, ref);
                    }
                  : () {
                      _addToMyList(context, ref);
                    },
              child: SizedBox(
                width: 125.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isAddedToMyList
                        ? const Icon(
                            Icons.check,
                          )
                        : const Icon(
                            Icons.add,
                          ),
                    const SizedBox(
                      width: 2.0,
                    ),
                    const Text(
                      'Add to my list',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10.0,
              ),
              child: FilledButton.tonal(
                onPressed: isAddedToMyList
                    ? null
                    : () {
                        _removeFromWatchlist(widget.movie.title);
                      },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 2.0,
                    ),
                    Text(
                      'Remove',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

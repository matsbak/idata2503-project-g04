import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/forms/auth_utils.dart';
import 'package:project/models/movie.dart';
import 'package:project/models/rating.dart';
import 'package:project/providers/lists_provider.dart';
import 'package:project/providers/ratings_provider.dart';
import 'package:project/services/firebase_service.dart';
import 'package:project/widgets/reviews.dart';
import 'package:project/widgets/starbuilder.dart';

/// A screen representing the movie details screen.
class MovieDetailScreen extends ConsumerStatefulWidget {
  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  ConsumerState<MovieDetailScreen> createState() {
    return _MovieDetailScreenState();
  }
}

class _MovieDetailScreenState extends ConsumerState<MovieDetailScreen> {
  /// Initializes the ratings to be used in the widget. This method first checks what ratings are
  /// already present in the movie object, and then appends the rating in the ratings provider if
  /// it is present for the movie.
  List<Rating> _initializeRatings() {
    List<Rating> ratings = [...widget.movie.ratings];

    Rating? rating =
        ref.watch(ratingsProvider.notifier).getRating(widget.movie.id);
    if (rating != null) {
      ratings = [...ratings, rating];
    }

    return ratings;
  }

  /// Calculates the average of all ratings. The ratings are the initial ratings.
  double _calculateAverageRating() {
    List<Rating> ratings = _initializeRatings();
    double avg = 0.0;

    if (ratings.isNotEmpty) {
      avg =
          ratings.map((r) => r.score).reduce((a, b) => a + b) / ratings.length;
    }

    return double.parse(avg.toStringAsFixed(2));
  }

  /// Adds a movie to the watch list
  Future<void> _addToWatchList(BuildContext context, WidgetRef ref) async {
    try {
      final uid = AuthUtils.getUidIfLoggedIn(ref);
      if (uid != null) {
        final firebaseKey =
            await FirebaseService.addMovieToWatchlist(widget.movie, uid);
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

  @override
  Widget build(BuildContext context) {
    // Lists providers
    final watchlist = ref.watch(watchlistProvider);
    final myList = ref.watch(myListProvider);

    final isInLists =
        watchlist.contains(widget.movie) || myList.contains(widget.movie);

    // Ratings providers
    final ratings = _initializeRatings();
    final averageRating = _calculateAverageRating();

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
      body: OrientationBuilder(
        builder: (context, orientation) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: orientation == Orientation.landscape
                  ? _buildLandscapeLayout(
                      context, isInLists, ratings, averageRating)
                  : _buildPortraitLayout(
                      context, isInLists, ratings, averageRating),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context, bool isInLists,
      List<Rating> ratings, double averageRating) {
    return Column(
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
        const SizedBox(height: 16),
        _buildMovieDetails(context, isInLists, averageRating, ratings),
      ],
    );
  }

  Widget _buildLandscapeLayout(BuildContext context, bool isInLists,
      List<Rating> ratings, double averageRating) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 320,
            width: 200,
            child: widget.movie.poster,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMovieDetails(context, isInLists, averageRating, ratings),
        ),
      ],
    );
  }

  Widget _buildMovieDetails(BuildContext context, bool isInLists,
      double averageRating, List<Rating> ratings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.movie.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              'Rating: $averageRating',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '(${ratings.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        StarBuilder(rating: averageRating),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: isInLists
              ? null // Disables button if movie is already present in lists
              : () {
                  _addToWatchList(context, ref);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
          icon: Icon(
            isInLists ? Icons.check : Icons.add,
            color: Colors.white,
          ),
          label: Text(
            isInLists ? 'Added to Watchlist' : 'Add to Watchlist',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Genres:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: widget.movie.genres.map((genre) {
            return Chip(
              label: Text(genre),
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Text(
          widget.movie.description,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        const SizedBox(height: 12),
        Reviews(ratings: ratings),
      ],
    );
  }
}

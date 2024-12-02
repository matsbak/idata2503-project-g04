import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/models/rating.dart';

class RatingsNotifier extends StateNotifier<Map<int, Rating>> {
  RatingsNotifier() : super({});

  /// Gets the rating for the movie with the specified movie ID. If no rating with the specified
  /// movie ID is found, null is returned.
  Rating? getRating(int movieId) {
    Rating? movieRating;
    if (state.keys.contains(movieId)) {
      movieRating = state[movieId]!;
    }
    return movieRating;
  }

  /// Adds the specified movie ID and the specified rating to the rating for the movie. The
  /// specified movie ID as acts a key and the specified rating acts as a value.
  void addRating(int movieId, Rating rating) {
    Map<int, Rating> ratings = {movieId: rating};
    state = {...state, ...ratings};
  }
}

final ratingsProvider =
    StateNotifierProvider<RatingsNotifier, Map<int, Rating>>((ref) {
  return RatingsNotifier();
});

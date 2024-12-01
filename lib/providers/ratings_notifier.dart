import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/rating.dart';
import 'package:project/services/firebase_service.dart';

class RatingsNotifier extends StateNotifier<List<Rating>> {
  RatingsNotifier() : super([]);

  Future<void> fetchRatings(int movieId) async {
    try {
      final ratings = await FirebaseService.fetchRatingForMovie(movieId);
      state = ratings; // Update the state
    } catch (error) {
      state = []; // Clear state in case of error
    }
  }

  /// Method to calculate average rating
  double get averageRating {
    if (state.isEmpty) return 0;
    final avg = state.map((rating) => rating.score).reduce((a, b) => a + b) /
        state.length;
    return double.parse(avg.toStringAsFixed(2));
  }
}

final ratingsProvider =
    StateNotifierProvider<RatingsNotifier, List<Rating>>((ref) {
  return RatingsNotifier();
});

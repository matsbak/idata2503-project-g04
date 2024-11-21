import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/models/rating.dart';
import 'package:project/service/firebase_service.dart';

class RatingsNotifier extends StateNotifier<List<Rating>> {
  RatingsNotifier() : super([]);

  Future<void> fetchRatings(String movieId) async {
    try {
      final ratings = await FirebaseService.fetchRatingForMovie(movieId);
      state = ratings; // Update the state
    } catch (error) {
      state = []; // Clear state in case of error
    }
  }
}

final ratingsProvider =
    StateNotifierProvider<RatingsNotifier, List<Rating>>((ref) {
  return RatingsNotifier();
});

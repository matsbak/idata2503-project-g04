import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/models/movie.dart';

class WatchlistNotifier extends StateNotifier<List<Movie>> {
  WatchlistNotifier() : super([]);

  void addToWatchlist(Movie movie) {
    state = [...state, movie];
  }
}

final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, List<Movie>>((ref) {
  return WatchlistNotifier();
});

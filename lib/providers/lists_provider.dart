import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/models/movie.dart';

class WatchlistNotifier extends StateNotifier<List<Movie>> {
  WatchlistNotifier() : super([]);

  void fillWatchList(List<Movie> movies) {
    state = [...state, ...movies];
  }

  void clearWatchlist() {
    state = [];
  }

  void addToWatchlist(Movie movie) {
    if (!state.contains(movie)) {
      state = [...state, movie];
    }
  }

  void removeFromWatchlist(Movie movie) {
    state = state.where((m) => m != movie).toList();
  }
}

class MyListNotifier extends StateNotifier<List<Movie>> {
  MyListNotifier() : super([]);

  void fillMyList(List<Movie> movies) {
    state = [...state, ...movies];
  }

  void clearMylist() {
    state = [];
  }

  void addToMyList(Movie movie) async {
    state = [...state, movie];
  }

  void removeFromMyList(Movie movie) {
    state = state.where((m) => m != movie).toList();
  }
}

final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, List<Movie>>((ref) {
  return WatchlistNotifier();
});

final myListProvider =
    StateNotifierProvider<MyListNotifier, List<Movie>>((ref) {
  return MyListNotifier();
});

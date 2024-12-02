import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:project/models/movie.dart';
import 'package:project/providers/lists_provider.dart';
import 'package:project/services/firebase_service.dart';

class AuthenticationProvider extends StateNotifier<AuthenticationState> {
  AuthenticationProvider(this.ref) : super(AuthenticationState.loggedOut());
  
  final Ref ref;

  void login(String uid) {
    state = AuthenticationState.loggedIn(uid);
    fetchAndFillWatchlist(uid);
    fetchAndFillMylist(uid);
  }

  void fetchAndFillMylist(String uid) async {
    List<Movie> watchlistMovies = await FirebaseService.fetchMylistMovies(uid);
    ref.read(myListProvider.notifier).fillMyList(watchlistMovies);
  }

  void fetchAndFillWatchlist(String uid) async {
    List<Movie> watchlistMovies =
        await FirebaseService.fetchWatchlistMovies(uid);
    ref.read(watchlistProvider.notifier).fillWatchList(watchlistMovies);
  }

  void logout() {
    ref.read(watchlistProvider.notifier).clearWatchlist();
    ref.read(myListProvider.notifier).clearMylist();
    state = AuthenticationState.loggedOut();
  }
}

class AuthenticationState {
  final bool isLoggedIn;
  final String? uid;

  AuthenticationState._({required this.isLoggedIn, this.uid});

  factory AuthenticationState.loggedIn(String uid) {
    return AuthenticationState._(isLoggedIn: true, uid: uid);
  }

  factory AuthenticationState.loggedOut() {
    return AuthenticationState._(isLoggedIn: false);
  }
}

final authProvider =
    StateNotifierProvider<AuthenticationProvider, AuthenticationState>((ref) {
  return AuthenticationProvider(ref);
});

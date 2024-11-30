import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationProvider extends StateNotifier<AuthenticationState> {
  AuthenticationProvider() : super(AuthenticationState.loggedOut());

  void login(String uid) {
    state = AuthenticationState.loggedIn(uid);
  }

  void logout() {
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
  return AuthenticationProvider();
});

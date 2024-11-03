import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthenticationProvider extends StateNotifier<bool> {
  AuthenticationProvider() : super(false);

  void login() {
    state = true;
  }

  void logout() {
    state = false;
  }
}

final authProvider = StateNotifierProvider<AuthenticationProvider, bool>((ref) {
  return AuthenticationProvider();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/providers/authentication_provider.dart';

String? getUidIfLoggedIn(WidgetRef ref) {
  final authState = ref.read(authProvider);
  if (authState.isLoggedIn && authState.uid != null) {
    return authState.uid;
  }
  return null;
}

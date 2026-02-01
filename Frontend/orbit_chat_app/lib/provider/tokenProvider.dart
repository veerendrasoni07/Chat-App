import 'package:flutter_riverpod/flutter_riverpod.dart';

class TokenProvider extends StateNotifier<String?> {
  TokenProvider() : super(null);

  void setToken(String token) {
    state = token;
  }
}

final tokenProvider =
    StateNotifierProvider<TokenProvider, String?>((ref) => TokenProvider());

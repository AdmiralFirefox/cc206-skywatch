import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, String>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<String> {
  ThemeNotifier() : super("");

  void changeTheme(String theme) {
    state = theme;
  }
}

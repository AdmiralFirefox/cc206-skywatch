import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cc206_skywatch/utils/bookmarked_place.dart';

final bookmarkProvider =
    StateNotifierProvider<BookmarkNotifier, List<BookmarkedPlace>>(
        (ref) => BookmarkNotifier());

class BookmarkNotifier extends StateNotifier<List<BookmarkedPlace>> {
  late SharedPreferences prefs;
  var uuid = const Uuid();
  BookmarkNotifier() : super([]) {
    _init();
  }

  Future _init() async {
    prefs = await SharedPreferences.getInstance();
    var bookmarks = prefs.getString("bookmarks");
    state = bookmarks != null
        ? (jsonDecode(bookmarks) as List)
            .map((i) => BookmarkedPlace.fromJson(i))
            .toList()
        : [];
  }

  void toggleBookmark(String placeName) {
    final isExist = state.any((place) => place.placeName == placeName);

    if (isExist) {
      state = state.where((place) => place.placeName != placeName).toList();
    } else {
      state = [...state, BookmarkedPlace(id: uuid.v4(), placeName: placeName)];
    }

    prefs.setString(
        "bookmarks", jsonEncode(state.map((place) => place.toJson()).toList()));
  }
}

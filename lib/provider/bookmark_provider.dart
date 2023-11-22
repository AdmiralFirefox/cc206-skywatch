import 'package:cc206_skywatch/utils/bookmarked_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final bookmarkProvider =
    StateNotifierProvider<BookmarkNotifier, List<BookmarkedPlace>>(
        (ref) => BookmarkNotifier());

class BookmarkNotifier extends StateNotifier<List<BookmarkedPlace>> {
  var uuid = const Uuid();
  BookmarkNotifier() : super([]);

  void toggleBookmark(String placeName) {
    final isExist = state.any((place) => place.placeName == placeName);

    if (isExist) {
      state = state.where((place) => place.placeName != placeName).toList();
    } else {
      state = [...state, BookmarkedPlace(id: uuid.v4(), placeName: placeName)];
    }
  }
}

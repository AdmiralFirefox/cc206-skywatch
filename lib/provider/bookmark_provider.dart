import 'package:cc206_skywatch/utils/bookmarked_place.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class BookmarkProvider extends ChangeNotifier {
  var uuid = const Uuid();
  final List<BookmarkedPlace> _bookmarkedPlaces = [];
  List<BookmarkedPlace> get bookmarkedPlaces => _bookmarkedPlaces;

  void toggleBookmark(String placeName) {
    final isExist =
        _bookmarkedPlaces.any((place) => place.placeName == placeName);

    if (isExist) {
      _bookmarkedPlaces.removeWhere((place) => place.placeName == placeName);
    } else {
      _bookmarkedPlaces.add(
        BookmarkedPlace(id: uuid.v4(), placeName: placeName),
      );
    }

    notifyListeners();
  }

  bool isExist(String placeName) {
    final isExist =
        _bookmarkedPlaces.any((place) => place.placeName == placeName);
    return isExist;
  }
}

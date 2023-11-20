import 'package:flutter/cupertino.dart';
import 'package:cc206_skywatch/utils/searched_place.dart';
import 'package:uuid/uuid.dart';

class SearchedPlaceProvider extends ChangeNotifier {
  var uuid = const Uuid();
  List<SearchedPlace> _searchedPlaces = [];
  List<SearchedPlace> get searchedPlaces => _searchedPlaces;

  void addToSearchHistory(String placeName, double placeTemp) {
    int existingIndex = _searchedPlaces
        .indexWhere((searchedPlace) => searchedPlace.placeName == placeName);

    // If it exists, remove the existing entry
    if (existingIndex != -1) {
      _searchedPlaces.removeAt(existingIndex);
    }

    // Add the new entry to the list
    _searchedPlaces.add(
      SearchedPlace(id: uuid.v4(), placeName: placeName, placeTemp: placeTemp),
    );

    notifyListeners();
  }

  void removeFromSearchHistory(String placeName) {
    _searchedPlaces.removeWhere((place) => place.placeName == placeName);
  }

  void clearSearches() {
    _searchedPlaces = [];
    notifyListeners();
  }
}

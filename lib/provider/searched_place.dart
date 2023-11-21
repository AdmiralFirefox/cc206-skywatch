import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc206_skywatch/utils/searched_place.dart';
import 'package:uuid/uuid.dart';

final searchedPlaceProvider =
    StateNotifierProvider<SearchedPlaceNotifier, List<SearchedPlace>>(
        (ref) => SearchedPlaceNotifier());

class SearchedPlaceNotifier extends StateNotifier<List<SearchedPlace>> {
  var uuid = const Uuid();

  SearchedPlaceNotifier() : super([]);

  void addToSearchHistory(String placeName, double placeTemp) {
    int existingIndex = state
        .indexWhere((searchedPlace) => searchedPlace.placeName == placeName);

    // If it exists, remove the existing entry
    if (existingIndex != -1) {
      state = state.where((place) => place.placeName != placeName).toList();
    }

    // Add the new entry to the list
    state = [
      ...state,
      SearchedPlace(id: uuid.v4(), placeName: placeName, placeTemp: placeTemp)
    ];
  }

  void removeFromSearchHistory(String placeName) {
    state = state.where((place) => place.placeName != placeName).toList();
  }

  void clearSearches() {
    state = [];
  }
}

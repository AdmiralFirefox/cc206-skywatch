import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cc206_skywatch/utils/searched_place.dart';

final searchedPlaceProvider =
    StateNotifierProvider<SearchedPlaceNotifier, List<SearchedPlace>>(
        (ref) => SearchedPlaceNotifier());

class SearchedPlaceNotifier extends StateNotifier<List<SearchedPlace>> {
  late SharedPreferences prefs;
  var uuid = const Uuid();
  SearchedPlaceNotifier() : super([]) {
    _init();
  }

  Future _init() async {
    prefs = await SharedPreferences.getInstance();
    var searchedPlaces = prefs.getString("searchedPlaces");
    state = searchedPlaces != null
        ? (jsonDecode(searchedPlaces) as List)
            .map((i) => SearchedPlace.fromJson(i))
            .toList()
        : [];
  }

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

    prefs.setString("searchedPlaces",
        jsonEncode(state.map((place) => place.toJson()).toList()));
  }

  void removeFromSearchHistory(String placeName) {
    state = state.where((place) => place.placeName != placeName).toList();

    prefs.setString("searchedPlaces",
        jsonEncode(state.map((place) => place.toJson()).toList()));
  }

  void clearSearches() {
    state = [];

    prefs.setString("searchedPlaces",
        jsonEncode(state.map((place) => place.toJson()).toList()));
  }
}

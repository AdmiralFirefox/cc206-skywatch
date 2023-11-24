import 'package:cc206_skywatch/utils/place_location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationProvider = StateNotifierProvider<LocationNotifier, PlaceLocation>(
    (ref) => LocationNotifier());

class LocationNotifier extends StateNotifier<PlaceLocation> {
  LocationNotifier() : super(PlaceLocation(longitude: 0, latitude: 0));

  void updateLocation(double placeLongitude, double placeLatitude) {
    state = PlaceLocation(longitude: placeLongitude, latitude: placeLatitude);
  }
}

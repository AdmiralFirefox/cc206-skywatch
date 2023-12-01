import 'package:flutter/material.dart';
import 'package:cc206_skywatch/provider/searched_place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchHistoryDrawer extends ConsumerWidget {
  final Function() setWeatherDataFuture;
  final Function(String) setSubmittedText;
  final VoidCallback onTilePressed;

  const SearchHistoryDrawer({
    super.key,
    required this.setWeatherDataFuture,
    required this.setSubmittedText,
    required this.onTilePressed,
  });

  Widget _emptyListState() {
    return ListView(
      padding: EdgeInsets.zero,
      children: const [
        SizedBox(
          height: 120.0,
          child: DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(24, 66, 90, 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  color: Colors.white,
                  size: 25.0,
                ),
                SizedBox(width: 10.0),
                Text(
                  "Recent Searches",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: Text(
            "No recent searches",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchHistoryNotifier = ref.read(searchedPlaceProvider.notifier);
    final searchedPlaces = ref.watch(searchedPlaceProvider);

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: searchedPlaces.isEmpty
          ? _emptyListState()
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 120.0,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(24, 66, 90, 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              "Recent Searches",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          child: const Text(
                            "Clear All",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                            ),
                          ),
                          onTap: () {
                            searchHistoryNotifier.clearSearches();
                          },
                        )
                      ],
                    ),
                  ),
                ),
                ...searchedPlaces.reversed.map((searchedPlace) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "${searchedPlace.placeTemp.ceil()}°",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  searchedPlace.placeName,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.5,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          child: const Icon(
                            Icons.delete,
                            color: Color.fromRGBO(252, 96, 66, 1),
                            size: 24.0,
                          ),
                          onTap: () {
                            searchHistoryNotifier.removeFromSearchHistory(
                              searchedPlace.placeName,
                            );
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      setSubmittedText(searchedPlace.placeName);
                      setWeatherDataFuture();
                      Navigator.pop(context);
                      onTilePressed();
                    },
                  );
                }),
              ],
            ),
    );
  }
}

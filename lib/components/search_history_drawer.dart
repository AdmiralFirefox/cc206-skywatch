import 'package:flutter/material.dart';
import 'package:cc206_skywatch/utils/searched_place.dart';

class SearchHistoryDrawer extends StatefulWidget {
  final List<SearchedPlace> searchedPlaces;

  const SearchHistoryDrawer({super.key, required this.searchedPlaces});

  @override
  _SearchHistoryDrawerState createState() => _SearchHistoryDrawerState();
}

class _SearchHistoryDrawerState extends State<SearchHistoryDrawer> {
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
            "No recent Searches",
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

  Widget _recentSearchesContent() {
    return ListView(
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
                    setState(() {
                      widget.searchedPlaces.clear();
                    });
                  },
                )
              ],
            ),
          ),
        ),
        ...widget.searchedPlaces.reversed.map((searchedPlace) {
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
                    setState(() {
                      widget.searchedPlaces.remove(searchedPlace);
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: widget.searchedPlaces.isEmpty
          ? _emptyListState()
          : _recentSearchesContent(),
    );
  }
}

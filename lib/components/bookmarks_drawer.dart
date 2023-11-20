import 'package:flutter/material.dart';
import 'package:cc206_skywatch/utils/bookmarked_place.dart';
import 'package:cc206_skywatch/provider/bookmark_provider.dart';
import 'package:provider/provider.dart';

class BookmarksDrawer extends StatefulWidget {
  final List<BookmarkedPlace> favoritePlaces;
  final Function(BookmarkedPlace) onFavoritePlaceRemoved;

  const BookmarksDrawer({
    super.key,
    required this.favoritePlaces,
    required this.onFavoritePlaceRemoved,
  });

  @override
  State<BookmarksDrawer> createState() => _BookmarksDrawerState();
}

class _BookmarksDrawerState extends State<BookmarksDrawer> {
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
                  Icons.favorite,
                  color: Colors.white,
                  size: 25.0,
                ),
                SizedBox(width: 10.0),
                Text(
                  "Bookmarks",
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
            "No bookmarked place",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookmarkProvider>(context);
    final bookmarkedPlaces = provider.bookmarkedPlaces;

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: bookmarkedPlaces.isEmpty
          ? _emptyListState()
          : ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(
                  height: 120.0,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(24, 66, 90, 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 25.0,
                        ),
                        SizedBox(width: 10.0),
                        Text(
                          "Bookmarks",
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
                ...bookmarkedPlaces.reversed.map((favoritePlace) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            favoritePlace.placeName,
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
                        const SizedBox(width: 10),
                        GestureDetector(
                          child: const Icon(
                            Icons.favorite,
                            color: Color.fromRGBO(231, 84, 128, 1),
                            size: 28.0,
                          ),
                          onTap: () {
                            provider.toggleBookmark(favoritePlace.placeName);
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
            ),
    );
  }
}

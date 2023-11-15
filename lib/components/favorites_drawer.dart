import 'package:flutter/material.dart';

class BookmarkedCountry {
  String name;

  BookmarkedCountry({required this.name});
}

class BookmarksDrawer extends StatelessWidget {
  const BookmarksDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<BookmarkedCountry> dummySearchData = [
      BookmarkedCountry(name: "Iloilo City"),
      BookmarkedCountry(name: "Bacolod City"),
      BookmarkedCountry(name: "Manila"),
    ];

    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: ListView(
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
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: const Text(
                      "Bookmarks",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ...dummySearchData.map((searchCountry) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 170),
                    child: Text(
                      searchCountry.name,
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
                  GestureDetector(
                    child: const Icon(
                      Icons.favorite,
                      color: Color.fromRGBO(231, 84, 128, 1),
                      size: 28.0,
                    ),
                    onTap: () {
                      print("Added to Favorites");
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

import 'package:flutter/material.dart';

class SearchCountry {
  String name;
  int temp;

  SearchCountry({required this.name, required this.temp});
}

class SearchHistoryDrawer extends StatelessWidget {
  const SearchHistoryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    List<SearchCountry> dummySearchData = [
      SearchCountry(name: "Iloilo City", temp: 26),
      SearchCountry(name: "Bacolod City", temp: 25),
      SearchCountry(name: "Manila", temp: 26),
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
                    Icons.history,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: const Text(
                      "Recent Searches",
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "${searchCountry.temp.toString()}°",
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
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
                    ],
                  ),
                  GestureDetector(
                    child: const Icon(
                      Icons.delete,
                      color: Color.fromRGBO(252, 96, 66, 1),
                      size: 24.0,
                    ),
                    onTap: () {
                      print("Deleted");
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

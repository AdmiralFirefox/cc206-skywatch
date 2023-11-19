import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cc206_skywatch/components/bookmarks_drawer.dart';
import 'package:cc206_skywatch/components/search_history_drawer.dart';
import 'package:cc206_skywatch/features/search_page.dart';
import 'package:cc206_skywatch/utils/searched_place.dart';
import 'package:cc206_skywatch/utils/bookmarked_place.dart';

void main() async {
  runApp(const MyApp());
  await dotenv.load();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<SearchedPlace> searchedPlaces = [];
  List<BookmarkedPlace> favoritePlaces = [];
  bool isFavoritePlaceExist = false;

  @override
  Widget build(BuildContext context) {
    const AssetImage backgroundImage =
        AssetImage('assets/images/main-background.jpg');

    return MaterialApp(
      title: "SkyWatch",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              "SkyWatch",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: const Color.fromRGBO(24, 66, 90, 1),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: SizedBox(
                height: 50.0,
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 4.0,
                  indicatorColor: Color.fromRGBO(252, 96, 66, 1),
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.home_filled,
                        color: Colors.white,
                        size: 26.0,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: <Widget>[
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  );
                },
              )
            ],
          ),
          body: TabBarView(
            children: [
              const Icon(
                Icons.home,
                color: Colors.black,
                size: 50.0,
              ),
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: backgroundImage,
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                  child: SearchPage(
                    searchedPlaces: searchedPlaces,
                    favoritePlaces: favoritePlaces,
                    isFavoritePlaceExist: isFavoritePlaceExist,
                  ),
                ),
              ),
            ],
          ),
          drawer: BookmarksDrawer(
            favoritePlaces: favoritePlaces,
            onFavoritePlaceRemoved: (favoritePlace) {
              setState(() {
                favoritePlaces.remove(favoritePlace);
                isFavoritePlaceExist = false;
              });
            },
          ),
          endDrawer: SearchHistoryDrawer(searchedPlaces: searchedPlaces),
        ),
      ),
    );
  }
}

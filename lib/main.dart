import 'package:cc206_skywatch/provider/searched_place.dart';
import 'package:flutter/material.dart';
import 'package:cc206_skywatch/features/HomePage.dart';
import 'package:dio/dio.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc206_skywatch/components/bookmarks_drawer.dart';
import 'package:cc206_skywatch/components/search_history_drawer.dart';
import 'package:cc206_skywatch/features/search_page.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
  await dotenv.load();
  tz.initializeTimeZones();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with TickerProviderStateMixin {
  Future<Map<String, dynamic>> weatherDataFuture =
      Future.value({'empty': true});
  Future<Map<String, dynamic>> weatherForecastFuture =
      Future.value({'empty': true});
  String submittedText = "";
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final searchHistoryNotifier = ref.read(searchedPlaceProvider.notifier);

    const AssetImage backgroundImage =
        AssetImage('assets/images/main-background.jpg');

    // Fetch Weather Data
    Future<Map<String, dynamic>> fetchWeatherData() async {
      if (submittedText.isEmpty) {
        return {'empty': true};
      }

      var dio = Dio();
      var response = await dio.get(
        'https://api.openweathermap.org/data/2.5/weather?q=$submittedText&units=metric&appid=${dotenv.env['WEATHER_API_KEY']}',
      );

      if (response.data != null) {
        searchHistoryNotifier.addToSearchHistory(
          "${response.data['name']}, ${response.data['sys']['country']}",
          response.data['main']['temp'],
        );
      }

      return response.data;
    }

    // Fetch Forecast Data
    Future<Map<String, dynamic>> fetchForecastData() async {
      var dio = Dio();
      var response = await dio.get(
          "https://api.openweathermap.org/data/2.5/forecast?q=$submittedText&units=metric&appid=${dotenv.env['WEATHER_API_KEY']}");

      return response.data;
    }

    void setSubmittedText(String textValue) {
      setState(() {
        submittedText = textValue;
      });
    }

    void setWeatherDataFuture() {
      setState(() {
        weatherDataFuture = fetchWeatherData();
        weatherForecastFuture = fetchForecastData();
      });
    }

    return MaterialApp(
      title: 'Skywatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: SizedBox(
                height: 50.0,
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 4.0,
                  indicatorColor: const Color.fromRGBO(252, 96, 66, 1),
                  tabs: const [
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
            controller: _tabController,
            children: [
              HomePage(
                onButtonPressed: () {
                  _tabController?.animateTo(1);
                },
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
                    weatherDataFuture: weatherDataFuture,
                    weatherForecastFuture: weatherForecastFuture,
                    setWeatherDataFuture: setWeatherDataFuture,
                    setSubmittedText: setSubmittedText,
                  ),
                ),
              ),
            ],
          ),
          drawer: BookmarksDrawer(
            setWeatherDataFuture: setWeatherDataFuture,
            setSubmittedText: setSubmittedText,
          ),
          endDrawer: SearchHistoryDrawer(
            setWeatherDataFuture: setWeatherDataFuture,
            setSubmittedText: setSubmittedText,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}

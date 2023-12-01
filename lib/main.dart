import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:timezone/data/latest.dart' as tz_init;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc206_skywatch/provider/searched_place.dart';
import 'package:cc206_skywatch/provider/theme_provider.dart';
import 'package:cc206_skywatch/features/HomePage.dart';
import 'package:cc206_skywatch/features/search_page.dart';
import 'package:cc206_skywatch/components/bookmarks_drawer.dart';
import 'package:cc206_skywatch/components/search_history_drawer.dart';

void main() async {
  runApp(const ProviderScope(child: MyApp()));
  await dotenv.load();
  tz_init.initializeTimeZones();
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
  Future<Map<String, dynamic>> weatherAQIFuture = Future.value({'empty': true});
  String submittedText = "";
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var tabTheme = Theme.of(context);
    final searchHistoryNotifier = ref.read(searchedPlaceProvider.notifier);
    final themeNotifier = ref.read(themeProvider.notifier);
    final theme = ref.watch(themeProvider);

    AssetImage backgroundImage = AssetImage(theme == "day"
        ? 'assets/images/day-background.jpg'
        : theme == "night"
            ? 'assets/images/night-background.jpg'
            : 'assets/images/main-background.jpg');

    // Check day/night cycle
    void checkDayNightCycle(int timeZoneOffSetValue) {
      int currentTime = tz.TZDateTime.now(tz.local).millisecondsSinceEpoch;
      currentTime = (currentTime - (currentTime % 1000)) ~/ 1000;

      final int timestamp = currentTime;
      final int timeZoneOffset = timeZoneOffSetValue;

      tz.TZDateTime date =
          tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, timestamp * 1000);

      final int localTimestamp =
          timestamp + date.timeZoneOffset.inSeconds + timeZoneOffset;

      tz.TZDateTime localDate = tz.TZDateTime.fromMillisecondsSinceEpoch(
          tz.local, localTimestamp * 1000);

      final int localHour = localDate.hour;

      if (localHour >= 6 && localHour < 18) {
        themeNotifier.changeTheme("day");
      } else if (localHour >= 18 || localHour < 6) {
        themeNotifier.changeTheme("night");
      } else {
        themeNotifier.changeTheme("");
      }
    }

    // Fetch AQI Data
    Future<Map<String, dynamic>> fetchAQIData(
        double longitude, double latitude) async {
      var dio = Dio();
      var response = await dio.get(
          "https://api.openweathermap.org/data/2.5/air_pollution?lat=$latitude&lon=$longitude&appid=${dotenv.env['WEATHER_API_KEY']}");

      return response.data;
    }

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

        setState(() {
          weatherAQIFuture = fetchAQIData(
              response.data['coord']['lon'], response.data['coord']['lat']);
        });

        checkDayNightCycle(response.data["timezone"]);
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
      title: 'SkyWatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromRGBO(24, 66, 90, 1),
        ),
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
                child: Theme(
                  data: tabTheme.copyWith(
                    colorScheme: tabTheme.colorScheme.copyWith(
                      surfaceVariant: Colors.transparent,
                    ),
                  ),
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
                decoration: BoxDecoration(
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
                    weatherAQIFuture: weatherAQIFuture,
                  ),
                ),
              ),
            ],
          ),
          drawer: BookmarksDrawer(
            setWeatherDataFuture: setWeatherDataFuture,
            setSubmittedText: setSubmittedText,
            onTilePressed: () {
              _tabController?.animateTo(1);
            },
          ),
          endDrawer: SearchHistoryDrawer(
            setWeatherDataFuture: setWeatherDataFuture,
            setSubmittedText: setSubmittedText,
            onTilePressed: () {
              _tabController?.animateTo(1);
            },
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

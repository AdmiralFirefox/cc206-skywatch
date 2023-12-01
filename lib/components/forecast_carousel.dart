import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc206_skywatch/provider/theme_provider.dart';

class ForecastCarousel extends ConsumerWidget {
  final Future<Map<String, dynamic>> weatherForecastFuture;

  const ForecastCarousel({
    super.key,
    required this.weatherForecastFuture,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);

    Color themeColor() {
      switch (theme) {
        case "day":
          return const Color.fromRGBO(24, 66, 90, 0.8);
        case "night":
          return const Color.fromRGBO(74, 69, 91, 0.75);
        default:
          return const Color.fromRGBO(24, 66, 90, 0.8);
      }
    }

    String dateFormat(int locationDateValue, int timeZoneOffSetValue) {
      final timestamp = locationDateValue;
      final timeZoneOffset = timeZoneOffSetValue;
      final date =
          tz.TZDateTime.fromMillisecondsSinceEpoch(tz.UTC, timestamp * 1000);
      final localDate = date.add(Duration(seconds: timeZoneOffset));
      final formattedDate = DateFormat('MMM d').format(localDate);

      return formattedDate;
    }

    String timeFormat(int locationDateValue, int timeZoneOffSetValue) {
      final timestamp = locationDateValue;
      final timeZoneOffset = timeZoneOffSetValue;
      final date =
          tz.TZDateTime.fromMillisecondsSinceEpoch(tz.UTC, timestamp * 1000);
      final localDate = date.add(Duration(seconds: timeZoneOffset));
      final formattedDate = DateFormat('h:mm a').format(localDate);

      return formattedDate;
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: weatherForecastFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            margin: const EdgeInsets.only(top: 20.0),
            padding: const EdgeInsets.only(top: 40.0, bottom: 35.0),
            decoration: BoxDecoration(
              color: themeColor(),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SpinKitRing(
                      color: Colors.white,
                      size: 60.0,
                    )
                  ],
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            margin: const EdgeInsets.only(top: 20.0),
            decoration: BoxDecoration(
              color: themeColor(),
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.only(
              top: 25.0,
              right: 16.0,
              bottom: 25.0,
              left: 16.0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Failed getting forecast data. Please try again later.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          var forecastData = snapshot.data;

          List<dynamic> forecastList = forecastData?['list'];

          return Container(
            margin: const EdgeInsets.only(top: 20.0),
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 20.0,
            ),
            decoration: BoxDecoration(
              color: themeColor(),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CarouselSlider(
                options: CarouselOptions(
                  viewportFraction: 0.34,
                  enableInfiniteScroll: true,
                  autoPlay: false,
                  disableCenter: true,
                  aspectRatio: 1.96,
                  initialPage: 1,
                ),
                items: forecastList.map((place) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            dateFormat(
                              place['dt'],
                              forecastData?['city']['timezone'],
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            timeFormat(
                              place['dt'],
                              forecastData?['city']['timezone'],
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 13.0,
                            ),
                          ),
                          CachedNetworkImage(
                            imageUrl:
                                "http://openweathermap.org/img/w/${place['weather'][0]['icon']}.png",
                            placeholder: (context, url) => const SpinKitRing(
                              color: Colors.white,
                              size: 42.0,
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.error_rounded,
                              color: Colors.white,
                              size: 35.0,
                            ),
                            width: 48.0,
                          ),
                          Text(
                            "${place['main']['temp'].ceil().toString()}°",
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 3.0),
                            child: Text(
                              place['weather'][0]['main'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:carousel_slider/carousel_slider.dart';

class ForecastCarousel extends StatelessWidget {
  final Future<Map<String, dynamic>> weatherForecastFuture;

  const ForecastCarousel({
    super.key,
    required this.weatherForecastFuture,
  });

  @override
  Widget build(BuildContext context) {
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

    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(24, 66, 90, 75),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: weatherForecastFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              } else if (snapshot.hasError) {
                return const Text("Error");
              } else {
                var forecastData = snapshot.data;

                List<dynamic> forecastList = forecastData?['list'];

                return Expanded(
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
                                Image.network(
                                  'http://openweathermap.org/img/w/${place['weather'][0]['icon']}.png',
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
          ),
        ],
      ),
    );
  }
}

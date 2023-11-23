import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc206_skywatch/provider/bookmark_provider.dart';

class WeatherMainInfo extends ConsumerWidget {
  final Map<String, dynamic> data;

  const WeatherMainInfo({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarkNotifier = ref.read(bookmarkProvider.notifier);
    final bookmarkedPlaces = ref.watch(bookmarkProvider);
    bool placeExist = bookmarkedPlaces.any((place) =>
        place.placeName == "${data['name']}, ${data['sys']['country']}");

    String formatDate(int timezoneOffSet) {
      final utcTime = tz.TZDateTime.now(tz.UTC);
      final localTime = utcTime.add(Duration(seconds: timezoneOffSet));
      final formattedDate = DateFormat('h:mm a, MMM d, yyyy').format(localTime);

      return formattedDate;
    }

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.only(
            top: 35.0,
            right: 16.0,
            bottom: 25.0,
            left: 16.0,
          ),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(24, 66, 90, 75),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "${data['name']}, ${data['sys']['country']}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        fontSize: 27.0,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                formatDate(data['timezone']),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${data['main']['temp'].ceil()}°",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 38.0,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${data['main']['temp_min'].ceil()}°",
                            style: const TextStyle(
                              color: Color.fromRGBO(129, 183, 228, 1),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 25.0,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            "${data['main']['temp_max'].ceil()}°",
                            style: const TextStyle(
                              color: Color.fromRGBO(253, 128, 104, 1),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 25.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'http://openweathermap.org/img/w/${data['weather'][0]['icon']}.png',
                        width: 50.0,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${data['weather'][0]['description']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          right: 5,
          top: 23,
          child: IconButton(
            onPressed: () {
              bookmarkNotifier
                  .toggleBookmark("${data['name']}, ${data['sys']['country']}");
            },
            icon: placeExist
                ? const Icon(
                    Icons.favorite,
                    size: 32.0,
                    color: Color.fromRGBO(231, 84, 128, 1),
                  )
                : const Icon(
                    Icons.favorite_outline,
                    size: 32.0,
                    color: Color.fromRGBO(231, 84, 128, 1),
                  ),
          ),
        ),
      ],
    );
  }
}

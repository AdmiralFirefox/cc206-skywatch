import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cc206_skywatch/provider/theme_provider.dart';
import 'package:cc206_skywatch/components/aqi_info.dart';

class WeatherExtraInfo extends ConsumerWidget {
  final Map<String, dynamic> data;
  final Future<Map<String, dynamic>> weatherAQIFuture;

  const WeatherExtraInfo({
    super.key,
    required this.data,
    required this.weatherAQIFuture,
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
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.only(
        top: 25.0,
        right: 20.0,
        bottom: 25.0,
        left: 20.0,
      ),
      decoration: BoxDecoration(
        color: themeColor(),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          ExtraInfoContent(
            imagePath: "assets/icons/sunrise.png",
            imageWidth: 45.0,
            imageHeight: 45.0,
            spaceHeight: 10.0,
            title: "Sunrise",
            value: timeFormat(
              data["sys"]["sunrise"],
              data["timezone"],
            ),
          ),
          ExtraInfoContent(
            imagePath: "assets/icons/sunset.png",
            imageWidth: 51.0,
            imageHeight: 51.0,
            spaceHeight: 10.0,
            title: "Sunset",
            value: timeFormat(
              data["sys"]["sunset"],
              data["timezone"],
            ),
          ),
          ExtraInfoContent(
            imagePath: "assets/icons/humidity.png",
            imageWidth: 45.0,
            imageHeight: 45.0,
            spaceHeight: 10.0,
            title: "Humidity",
            value: "${data["main"]["humidity"]}%",
          ),
          ExtraInfoContent(
            imagePath: "assets/icons/pressure.png",
            imageWidth: 65.0,
            imageHeight: 65.0,
            spaceHeight: 1.0,
            title: "Pressure",
            value: "${data["main"]["pressure"]} hPa",
          ),
          ExtraInfoContent(
            imagePath: "assets/icons/wind.png",
            imageWidth: 45.0,
            imageHeight: 45.0,
            spaceHeight: 10.0,
            title: "Wind",
            value: "${data["wind"]["speed"]} m/s",
          ),
          ExtraInfoContent(
            imagePath: "assets/icons/visibility.png",
            imageWidth: 45.0,
            imageHeight: 45.0,
            spaceHeight: 10.0,
            title: "Visibility",
            value: "${(data["visibility"] / 1000).round()} km",
          ),
          ExtraInfoContent(
            imagePath: "assets/icons/cloudy-day.png",
            imageWidth: 50.0,
            imageHeight: 50.0,
            spaceHeight: 10.0,
            title: "Cloudiness",
            value: "${data["clouds"]["all"]}%",
          ),
          AQIInfo(weatherAQIFuture: weatherAQIFuture),
        ],
      ),
    );
  }
}

class ExtraInfoContent extends StatelessWidget {
  final String imagePath;
  final double imageWidth;
  final double imageHeight;
  final double spaceHeight;
  final String title;
  final String value;

  const ExtraInfoContent({
    super.key,
    required this.imagePath,
    required this.imageWidth,
    required this.imageHeight,
    required this.spaceHeight,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(218, 243, 247, 1),
        borderRadius: BorderRadius.circular(5.0),
      ),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            (imagePath),
            width: imageWidth,
            height: imageHeight,
          ),
          SizedBox(height: spaceHeight),
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              fontSize: 16.5,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              fontSize: 14.5,
            ),
          )
        ],
      ),
    );
  }
}

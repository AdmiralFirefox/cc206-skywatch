import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AQIInfo extends StatelessWidget {
  final Future<Map<String, dynamic>> weatherAQIFuture;

  const AQIInfo({
    super.key,
    required this.weatherAQIFuture,
  });

  @override
  Widget build(BuildContext context) {
    Color getContainerColor(int aqi) {
      switch (aqi) {
        case 1:
          return const Color.fromRGBO(88, 218, 171, 1);
        case 2:
          return const Color.fromRGBO(88, 218, 171, 1);
        case 3:
          return const Color.fromRGBO(238, 230, 87, 1);
        case 4:
          return const Color.fromRGBO(252, 185, 65, 1);
        case 5:
          return const Color.fromRGBO(252, 96, 66, 1);
        default:
          return const Color.fromRGBO(218, 243, 247, 1);
      }
    }

    return FutureBuilder<Map<String, dynamic>>(
      future: weatherAQIFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(218, 243, 247, 1),
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(5.0),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "AQI",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5,
                  ),
                ),
                SizedBox(height: 5.0),
                SpinKitThreeBounce(
                  color: Colors.black,
                  size: 25.0,
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromRGBO(218, 243, 247, 1),
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(5.0),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "AQI",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5,
                  ),
                ),
                SizedBox(height: 2.0),
                Text(
                  "----",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          );
        } else {
          var data = snapshot.data;

          return Container(
            decoration: BoxDecoration(
              color: getContainerColor(data!["list"][0]["main"]["aqi"]),
              borderRadius: BorderRadius.circular(5.0),
            ),
            padding: const EdgeInsets.all(5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "AQI",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w700,
                    fontSize: 16.5,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  data["list"][0]["main"]["aqi"].toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontFamily: "Poppins",
                    fontSize: 14.0,
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}

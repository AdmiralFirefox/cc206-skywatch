import 'package:flutter/material.dart';

class AQIInfo extends StatelessWidget {
  final Future<Map<String, dynamic>> weatherAQIFuture;

  const AQIInfo({
    super.key,
    required this.weatherAQIFuture,
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
          const Text(
            "AQI",
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w700,
              fontSize: 16.5,
            ),
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: weatherAQIFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              } else if (snapshot.hasError) {
                return const Text("Error");
              } else {
                var data = snapshot.data;

                return Text(data!["list"][0]["main"]["aqi"].toString());
              }
            },
          )
        ],
      ),
    );
  }
}

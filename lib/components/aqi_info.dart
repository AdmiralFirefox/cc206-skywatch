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

    return Stack(
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: weatherAQIFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                width: MediaQuery.of(context).size.width,
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
                width: MediaQuery.of(context).size.width,
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
                width: MediaQuery.of(context).size.width,
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
        ),
        Positioned(
          right: -2,
          top: -1,
          child: IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const AQIAlert(),
            ),
            icon: const Icon(
              Icons.info,
              color: Colors.black,
              size: 24.0,
            ),
          ),
        ),
      ],
    );
  }
}

class AQIAlert extends StatelessWidget {
  const AQIAlert({super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14.0,
      fontFamily: "Poppins",
      fontWeight: FontWeight.w600,
    );

    return Theme(
      data: Theme.of(context).copyWith(
          dialogBackgroundColor: const Color.fromRGBO(218, 243, 247, 1)),
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text(
          "What is AQI?",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.0,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "The Air Quality Index (AQI) is a system that is used to tell the air quality of a place. It tells you how clean or polluted is the air. The AQI can be categorized into the following:",
              style: textStyle,
            ),
            const SizedBox(height: 23.0),
            Text(
              "1 - Good",
              style: textStyle,
            ),
            Text(
              "2 - Fair",
              style: textStyle,
            ),
            Text(
              "3 - Moderate",
              style: textStyle,
            ),
            Text(
              "4 - Poor",
              style: textStyle,
            ),
            Text(
              "5 - Very Poor",
              style: textStyle,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Close'),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Colors.deepPurple,
                fontFamily: "Poppins",
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

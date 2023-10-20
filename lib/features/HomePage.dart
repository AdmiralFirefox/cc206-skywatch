import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key); // Fix the constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 45,
            top: 50,
            right: 45,
            bottom: 20,
          ),
          child: Column(
            children: [
              const Icon(
                Icons.cloud_sharp,
                color: Color.fromARGB(255, 84, 157, 175),
                size: 60.0,
                semanticLabel: 'cloud',
              ),
              const Text(
                "SkyWatch: Global Weather Monitoring System \n",
                style: TextStyle(
                  fontSize: 45.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              RichText(
                text: const TextSpan(
                  text:
                      "A weather application to know the weather of a specific place, either be a city or country.",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .deepOrange, // Use 'primary' for button background color
                ),
                onPressed: () {
                  print("Searching...");
                },
                child: const Text(
                  'Start Searching',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

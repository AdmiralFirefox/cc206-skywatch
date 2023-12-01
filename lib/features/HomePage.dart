import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onButtonPressed;

  const HomePage({Key? key, required this.onButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/main-background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromRGBO(24, 66, 90, 0.75),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(25.0),
          margin: const EdgeInsets.only(
            left: 45.0,
            top: 40.0,
            right: 45.0,
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                ('assets/images/web-logo.png'),
                width: 57.0,
                height: 57.0,
              ),
              const SizedBox(
                height: 23.0,
              ),
              const Text(
                "SkyWatch: Global Weather Monitoring System",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w700,
                  fontSize: 23.0,
                  height: 1.25,
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              const Text(
                "A weather application to know the weather of a specific place, either be a city or country.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                  height: 1.40,
                ),
              ),
              const SizedBox(
                height: 27.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(252, 96, 66, 1),
                ),
                onPressed: () {
                  onButtonPressed();
                },
                child: const Text(
                  'Start Searching',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
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

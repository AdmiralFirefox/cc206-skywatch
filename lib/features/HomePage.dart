import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key); // Fix the constructor

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
            color: const Color.fromRGBO(94, 121, 122, 0.7),
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
                width: 50.0,
                height: 50.0,
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                "SkyWatch: Global Weather Monitoring System \n",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "A weather application to know the weather of a specific place, either be a city or country.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                  fontSize: 13.0,
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                  ),
                  backgroundColor: const Color.fromRGBO(252, 96, 66, 1),
                ),
                onPressed: () {
                  print("Searching...");
                },
                child: const Text(
                  'Start Searching',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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

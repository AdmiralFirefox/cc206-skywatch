import 'package:flutter/material.dart';

void main() {
  runApp(const SearchPage());
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Icon(
              Icons.house,
              color: Colors.black,
              size: 40.0,
              semanticLabel: 'Text to announce in accessibility modes',
            ),
            const Text(
              "SkyWatch",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            RichText(
              text: const TextSpan(
                text: "Search for a City or Country",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: TextFormField(
                onSaved: (String? value) {},
              ),
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              onPressed: () {
                print("Searching...");
              },
              child: const Text(
                'Search Country',
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
    );
  }
}

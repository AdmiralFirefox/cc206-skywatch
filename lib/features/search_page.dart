import 'package:cc206_skywatch/components/search/search_form.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    const AssetImage backgroundImage =
        AssetImage('assets/images/main-background.jpg');

    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.only(
            left: 15,
            top: 50,
            right: 15,
            bottom: 20,
          ),
          child: const Column(
            children: [
              SearchForm(),
            ],
          ),
        ),
      ),
    );
  }
}

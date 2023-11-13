import 'package:cc206_skywatch/components/search/search_form.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();
  String submittedText = "";

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
          child: Column(
            children: [
              SearchForm(
                textController: textController,
                handleOnTap: () {
                  setState(() {
                    submittedText = textController.text;
                    textController.text = "";
                  });
                },
                handleOnSubmit: (String value) {
                  setState(() {
                    submittedText = value;
                    textController.text = "";
                  });
                },
              ),
              Text(
                submittedText,
                style: const TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

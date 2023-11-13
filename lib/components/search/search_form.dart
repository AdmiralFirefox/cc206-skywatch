import 'package:flutter/material.dart';

class SearchForm extends StatelessWidget {
  final TextEditingController textController;
  final void Function()? handleOnTap;
  final void Function(String) handleOnSubmit;

  const SearchForm(
      {super.key,
      required this.textController,
      required this.handleOnTap,
      required this.handleOnSubmit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: textController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
            borderSide: const BorderSide(
              color: Colors.deepOrangeAccent,
              width: 2.5,
            ),
          ),
          hintText: "Search for a City/Country",
          hintStyle: const TextStyle(
            color: Colors.black,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: GestureDetector(
            onTap: handleOnTap,
            child: const Icon(Icons.search),
          ),
        ),
        textInputAction: TextInputAction.done, // Set it to done
        // Handle the submission when "Done" is pressed
        onFieldSubmitted: (value) {
          handleOnSubmit(value);
        },
      ),
    );
  }
}

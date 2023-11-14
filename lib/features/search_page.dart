import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();
  String submittedText = "";
  bool isEmpty = false;

  final List<String> _options = const <String>[
    'New York',
    'Tokyo',
    'Manila',
    'Seoul'
  ];

  String? validateInput(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter a valid value.';
    }
    return null;
  }

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
              Container(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') {
                        return const Iterable<String>.empty();
                      }
                      return _options.where((option) => option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    },
                    optionsViewBuilder: (BuildContext context,
                        AutocompleteOnSelected<String> onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          color: Colors.white, // Autocomplete Background color
                          elevation: 4.0,
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: options.length,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                final String option = options.elementAt(index);
                                return InkWell(
                                  onTap: () => onSelected(option),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      option,
                                      style: const TextStyle(
                                        // Autocomplete Text Color
                                        color: Colors.black,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    onSelected: (String selection) {
                      setState(() {
                        submittedText = selection;
                        FocusManager.instance.primaryFocus?.unfocus();
                      });
                    },
                    fieldViewBuilder: (BuildContext context,
                        TextEditingController textEditingController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted) {
                      return TextFormField(
                        controller: textEditingController,
                        focusNode: focusNode,
                        validator: validateInput,
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
                            onTap: () {
                              if (validateInput(textEditingController.text) ==
                                  null) {
                                setState(() {
                                  submittedText = textEditingController.text;
                                  textEditingController.text = "";
                                });
                                isEmpty = false;
                              } else {
                                isEmpty = true;
                              }
                              focusNode.unfocus();
                            },
                            child: const Icon(Icons.search),
                          ),
                        ),
                        textInputAction: TextInputAction.done, // Set it to done
                        // Handle the submission when "Done" is pressed
                        onFieldSubmitted: (value) {
                          if (validateInput(value) == null) {
                            setState(() {
                              submittedText = value;
                              textEditingController.text = "";
                            });
                            isEmpty = false;
                          } else {
                            isEmpty = true;
                          }
                          focusNode.unfocus();
                        },
                      );
                    },
                  );
                }),
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

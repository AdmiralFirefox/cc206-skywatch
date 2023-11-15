import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CountryData {
  final String name;
  final String region;
  final String country;

  CountryData({
    required this.name,
    required this.region,
    required this.country,
  });
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();
  String submittedText = "";
  bool isEmpty = false;
  Timer? _debounce;

  List<CountryData> _options = [];

  // Fetch Autofill Country Data
  void fetchCountryData(String place) async {
    String url =
        'https://wft-geo-db.p.rapidapi.com/v1/geo/cities?minPopulation=5000&namePrefix=$place';

    try {
      var response = await Dio().get(
        url,
        options: Options(
          headers: {
            'X-RapidAPI-Key': dotenv.env['RAPID_API_KEY'],
            'X-RapidAPI-Host': 'wft-geo-db.p.rapidapi.com'
          },
        ),
      );

      List<Map<String, dynamic>> cities = List<Map<String, dynamic>>.from(
          response.data['data'].map((dynamic city) => {
                'name': city['city'],
                'region': city['region'],
                'country': city['country'],
              }));

      setState(() {
        _options = cities
            .map((city) => CountryData(
                  name: city['name'],
                  region: city['region'],
                  country: city['country'],
                ))
            .toList();

        // Trigger a text change to update the options list
        final currentText = textController.text;
        textController.text = '$currentText ';
        textController.text = currentText;
      });
    } catch (e) {
      print('Error fetching country data: $e');
    }
  }

  String? validateInput(String? value) {
    if (value!.trim().isEmpty) {
      return 'Please enter a valid value.';
    }
    return null;
  }

  // Debounce onChange value
  void _onSearchTextChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    if (value.isNotEmpty) {
      _debounce = Timer(const Duration(milliseconds: 350), () {
        fetchCountryData(value);
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const AssetImage backgroundImage =
        AssetImage('assets/images/main-background.jpg');

    return Center(
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
              child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                return Autocomplete<CountryData>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<CountryData>.empty();
                    }
                    return _options.where((option) => option.name
                        .toLowerCase()
                        .contains(textEditingValue.text.toLowerCase()));
                  },
                  optionsViewBuilder: (BuildContext context,
                      AutocompleteOnSelected<CountryData> onSelected,
                      Iterable<CountryData> options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        color: Colors.white,
                        elevation: 4.0,
                        child: SizedBox(
                          width: constraints.maxWidth,
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: options.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              final CountryData option =
                                  options.elementAt(index);
                              return InkWell(
                                onTap: () => onSelected(option),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option.name,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        "${option.region}, ${option.country}",
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                  onSelected: (CountryData selection) {
                    setState(() {
                      submittedText = selection.name;
                      textController.text = "";
                      FocusManager.instance.primaryFocus?.unfocus();
                    });
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    textController = textEditingController;

                    return TextFormField(
                      controller: textController,
                      focusNode: focusNode,
                      onChanged: _onSearchTextChanged,
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
                            if (validateInput(textController.text) == null) {
                              setState(() {
                                submittedText = textController.text;
                                textController.text = "";
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
                            textController.text = "";
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
    );
  }
}

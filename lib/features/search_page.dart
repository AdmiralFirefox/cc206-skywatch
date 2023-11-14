import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
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
  String submittedText = "";
  bool isEmpty = false;

  List<CountryData> _options = [];

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
                        onChanged: (String value) {
                          fetchCountryData(value);
                        },
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

import 'package:cc206_skywatch/components/weather_main_info.dart';
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
  Future<Map<String, dynamic>> weatherDataFuture =
      Future.value({'empty': true});
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

  // Fetch Weather Data
  Future<Map<String, dynamic>> fetchWeatherData() async {
    if (submittedText.isEmpty) {
      return {'empty': true};
    }

    var dio = Dio();
    var response = await dio.get(
      'https://api.openweathermap.org/data/2.5/weather?q=$submittedText&units=metric&appid=${dotenv.env['WEATHER_API_KEY']}',
    );
    return response.data;
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
    return Container(
      padding: const EdgeInsets.only(
        left: 30,
        top: 35,
        right: 30,
        bottom: 20,
      ),
      child: Column(
        children: [
          LayoutBuilder(
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
                          final CountryData option = options.elementAt(index);
                          return InkWell(
                            onTap: () => onSelected(option),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                  weatherDataFuture = fetchWeatherData();
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
                            weatherDataFuture = fetchWeatherData();
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
                        weatherDataFuture = fetchWeatherData();
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
          FutureBuilder<Map<String, dynamic>>(
            future: weatherDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                var data = snapshot.data;
                if (data != null && data['empty'] == true) {
                  return const Text('Welcome to weather app');
                } else {
                  return Column(
                    children: [
                      WeatherMainInfo(data: data!),
                    ],
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

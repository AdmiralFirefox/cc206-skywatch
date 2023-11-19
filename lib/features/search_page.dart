import 'package:cc206_skywatch/components/weather_main_info.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cc206_skywatch/utils/searched_place.dart';
import 'package:cc206_skywatch/utils/favorite_place.dart';

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

//ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  final List<SearchedPlace> searchedPlaces;
  final List<FavoritePlace> favoritePlaces;
  bool isFavoritePlaceExist;

  SearchPage(
      {Key? key,
      required this.searchedPlaces,
      required this.favoritePlaces,
      required this.isFavoritePlaceExist})
      : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
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

    if (response.data != null) {
      SearchedPlace newPlace = SearchedPlace(
        placeName:
            "${response.data['name']}, ${response.data['sys']['country']}",
        placeTemp: response.data['main']['temp'],
      );

      // Check if a place with the same name already exists in the searchedPlaces
      int index = widget.searchedPlaces
          .indexWhere((place) => place.placeName == newPlace.placeName);

      // If it does, remove it
      if (index != -1) {
        widget.searchedPlaces.removeAt(index);
      }

      // Add the new place to the searchedPlaces
      widget.searchedPlaces.add(newPlace);

      // Check if place exist in favoritePlaces
      String placeName =
          "${response.data['name']}, ${response.data['sys']['country']}";
      int existingPlaceIndex = widget.favoritePlaces
          .indexWhere((place) => place.placeName == placeName);

      if (existingPlaceIndex != -1) {
        widget.isFavoritePlaceExist = true;
      } else {
        widget.isFavoritePlaceExist = false;
      }
    }

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
                return Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.only(top: 40.0, bottom: 35.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(24, 66, 90, 75),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 50.0,
                            width: 50.0,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 35.0),
                          Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w700,
                              fontSize: 25.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(24, 66, 90, 75),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: const EdgeInsets.only(
                    top: 25.0,
                    right: 16.0,
                    bottom: 25.0,
                    left: 16.0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "We couldn't find what you're looking for",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0,
                                height: 1.25,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Text(
                              "Double check your spelling and make sure that place exist.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                height: 1.40,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                var data = snapshot.data;
                if (data != null && data['empty'] == true) {
                  return Container(
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.only(
                      top: 25.0,
                      right: 17.0,
                      bottom: 25.0,
                      left: 17.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(24, 66, 90, 75),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Search for a City or Country",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 23.0,
                                  height: 1.25,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                "Suggestion: Try searching your place to get started.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0,
                                  height: 1.40,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      WeatherMainInfo(
                        data: data!,
                        favoritePlaces: widget.favoritePlaces,
                        isFavoritePlaceExist: widget.isFavoritePlaceExist,
                        onFavoriteToggle: (bool isFavorite) {
                          setState(() {
                            widget.isFavoritePlaceExist = isFavorite;
                          });
                        },
                      ),
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

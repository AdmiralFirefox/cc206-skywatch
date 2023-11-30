import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cc206_skywatch/utils/autofill_place.dart';
import 'package:cc206_skywatch/provider/theme_provider.dart';
import 'package:cc206_skywatch/components/forecast_carousel.dart';
import 'package:cc206_skywatch/components/weather_main_info.dart';
import 'package:cc206_skywatch/components/weather_extra_info.dart';

class SearchPage extends ConsumerStatefulWidget {
  final Future<Map<String, dynamic>> weatherDataFuture;
  final Future<Map<String, dynamic>> weatherForecastFuture;
  final Function() setWeatherDataFuture;
  final Function(String) setSubmittedText;
  final Future<Map<String, dynamic>> weatherAQIFuture;

  const SearchPage({
    Key? key,
    required this.weatherDataFuture,
    required this.weatherForecastFuture,
    required this.setWeatherDataFuture,
    required this.setSubmittedText,
    required this.weatherAQIFuture,
  }) : super(key: key);

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  TextEditingController textController = TextEditingController();
  Timer? _debounce;

  List<AutoFillPlace> _options = [];

  // Fetch Autofill Country Data
  Future<void> fetchCountryData(String place) async {
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
            .map((city) => AutoFillPlace(
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
    final theme = ref.watch(themeProvider);

    Color themeColor() {
      switch (theme) {
        case "day":
          return const Color.fromRGBO(24, 66, 90, 75);
        case "night":
          return const Color.fromRGBO(74, 69, 91, 75);
        default:
          return const Color.fromRGBO(24, 66, 90, 75);
      }
    }

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
            return Autocomplete<AutoFillPlace>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<AutoFillPlace>.empty();
                }
                return _options.where((option) => option.name
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<AutoFillPlace> onSelected,
                  Iterable<AutoFillPlace> options) {
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
                          final AutoFillPlace option = options.elementAt(index);
                          return InkWell(
                            onTap: () => onSelected(option),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    option.name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Text(
                                    "${option.region}, ${option.country}",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontFamily: "Poppins",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13.0,
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
              onSelected: (AutoFillPlace selection) {
                widget.setSubmittedText(
                    "${selection.name}, ${selection.country}");
                widget.setWeatherDataFuture();

                setState(() {
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
                  style: const TextStyle(
                    color: Colors.black, // Text color
                    fontSize: 15.5,
                    fontFamily: "Poppins", // Text size
                    fontWeight: FontWeight.w500, // Text weight
                  ),
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
                      color: Colors.black54,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 15.5,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        if (validateInput(textController.text) == null) {
                          widget.setSubmittedText(textController.text);
                          widget.setWeatherDataFuture();

                          setState(() {
                            textController.text = "";
                          });
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
                      widget.setSubmittedText(value);
                      widget.setWeatherDataFuture();

                      setState(() {
                        textController.text = "";
                      });
                    }
                    focusNode.unfocus();
                  },
                );
              },
            );
          }),
          FutureBuilder<Map<String, dynamic>>(
            future: widget.weatherDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.only(top: 40.0, bottom: 35.0),
                  decoration: BoxDecoration(
                    color: themeColor(),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SpinKitRing(
                            color: Colors.white,
                            size: 60.0,
                          ),
                          SizedBox(height: 25.0),
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
                    color: themeColor(),
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
                      color: themeColor(),
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
                      WeatherMainInfo(data: data!),
                      ForecastCarousel(
                        weatherForecastFuture: widget.weatherForecastFuture,
                      ),
                      WeatherExtraInfo(
                        data: data,
                        weatherAQIFuture: widget.weatherAQIFuture,
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

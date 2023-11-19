import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cc206_skywatch/utils/favorite_place.dart';
import 'package:uuid/uuid.dart';

//ignore: must_be_immutable
class WeatherMainInfo extends StatefulWidget {
  final Map<String, dynamic> data;
  final List<FavoritePlace> favoritePlaces;
  bool isFavoritePlaceExist;
  final Function(bool) onFavoriteToggle;

  WeatherMainInfo({
    super.key,
    required this.data,
    required this.favoritePlaces,
    required this.isFavoritePlaceExist,
    required this.onFavoriteToggle,
  });

  @override
  State<WeatherMainInfo> createState() => _WeatherMainInfoState();
}

class _WeatherMainInfoState extends State<WeatherMainInfo> {
  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();

    String formatDate(int timezoneOffSet) {
      DateTime utcTime = DateTime.now().toUtc();
      Duration offset = Duration(seconds: timezoneOffSet);
      DateTime localTime = utcTime.add(offset);
      DateFormat dateFormat = DateFormat('h:mm a, MMM d, yyyy');
      String formattedDate = dateFormat.format(localTime);

      return formattedDate;
    }

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20),
          padding: const EdgeInsets.only(
            top: 35.0,
            right: 16.0,
            bottom: 25.0,
            left: 16.0,
          ),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(24, 66, 90, 75),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "${widget.data['name']}, ${widget.data['sys']['country']}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                        fontSize: 27.0,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                formatDate(widget.data['timezone']),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.data['main']['temp'].ceil()}°",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 38.0,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.data['main']['temp_min'].ceil()}°",
                            style: const TextStyle(
                              color: Color.fromRGBO(129, 183, 228, 1),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 25.0,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            "${widget.data['main']['temp_max'].ceil()}°",
                            style: const TextStyle(
                              color: Color.fromRGBO(253, 128, 104, 1),
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              fontSize: 25.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                        'http://openweathermap.org/img/w/${widget.data['weather'][0]['icon']}.png',
                        width: 50.0,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        '${widget.data['weather'][0]['description']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        Positioned(
          right: 5,
          top: 23,
          child: IconButton(
            onPressed: () {
              setState(() {
                String placeName =
                    "${widget.data['name']}, ${widget.data['sys']['country']}";
                int existingPlaceIndex = widget.favoritePlaces
                    .indexWhere((place) => place.placeName == placeName);

                if (existingPlaceIndex != -1) {
                  widget.favoritePlaces.removeAt(existingPlaceIndex);
                  widget.onFavoriteToggle(false);
                } else {
                  widget.favoritePlaces.add(FavoritePlace(
                    id: uuid.v4(),
                    placeName: placeName,
                  ));
                  widget.onFavoriteToggle(true);
                }
              });
            },
            icon: widget.isFavoritePlaceExist
                ? const Icon(
                    Icons.favorite,
                    size: 32.0,
                    color: Color.fromRGBO(231, 84, 128, 1),
                  )
                : const Icon(
                    Icons.favorite_outline,
                    size: 32.0,
                    color: Color.fromRGBO(231, 84, 128, 1),
                  ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class WeatherMainInfo extends StatelessWidget {
  final Map<String, dynamic> data;

  const WeatherMainInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('Temperature: ${data['main']['temp']}'),
        Text('Min Temperature: ${data['main']['temp_min']}'),
        Text('Max Temperature: ${data['main']['temp_max']}'),
        Text('Name: ${data['name']}'),
        Text('Country: ${data['sys']['country']}'),
        Text('Timezone: ${data['timezone']}'),
        Image.network(
            'http://openweathermap.org/img/w/${data['weather'][0]['icon']}.png'),
        Text('Description: ${data['weather'][0]['description']}'),
      ],
    );
  }
}

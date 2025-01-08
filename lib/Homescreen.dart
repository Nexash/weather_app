import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Homescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final TextEditingController _locationController = TextEditingController();
  String _weatherData = '';

  void _fetchWeather() async {
    final location = _locationController.text;
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$location&appid=YOUR_API_KEY'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _weatherData = data['weather'][0]['description'];
      });
    } else {
      setState(() {
        _weatherData = 'Error fetching weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Enter location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: Text('Save/Update'),
            ),
            SizedBox(height: 20),
            Text(_weatherData),
          ],
        ),
      ),
    );
  }
}
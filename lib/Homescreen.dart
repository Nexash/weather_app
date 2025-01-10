import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'dart:ui';

import 'package:weather_app/weather_intro_screen.dart'; // For BackdropFilter

class Homescreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherIntroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Intro Page"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: Text("Welcome to the Weather Intro Page"),
      ),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final TextEditingController location = TextEditingController();
  String _weatherName = '';
  String _weatherTemp = '';
  String _weatherImage = 'assets/cloud.png'; // Default image
  String _lastLocation = ''; // Store the last searched location

  @override
  void initState() {
    super.initState();
    _loadWeatherData(); // Load saved weather data when the app starts
  }

  // Load saved weather data from SharedPreferences
  void _loadWeatherData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLocation = prefs.getString('location');
    String? savedWeatherName = prefs.getString('weatherName');
    String? savedWeatherTemp = prefs.getString('weatherTemp');
    String? savedWeatherImage = prefs.getString('weatherImage');

    if (savedLocation != null && savedWeatherName != null) {
      setState(() {
        _lastLocation = savedLocation;
        _weatherName = savedWeatherName;
        _weatherTemp = savedWeatherTemp ?? '';
        _weatherImage = savedWeatherImage ?? 'assets/cloud.png';
        location.text = savedLocation; // Set the location in the text field
      });
    }
  }

  // Fetch weather data based on the user's location
  void _fetchWeather() async {
    final maplocation = location.text;
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$maplocation&appid=19fcb507331285160128c01bc11034f4&units=metric'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final description = data['weather'][0]['description'];

      setState(() {
        _weatherName = " $description\n";
        _weatherTemp = " ${data['main']['temp']}°C";

        // Set the weather image based on the description
        if (description.contains('cloud')) {
          _weatherImage = 'assets/cloud.png';
        } else if (description.contains('rain')) {
          _weatherImage = 'assets/rainy-day.png';
        } else if (description.contains('storm')) {
          _weatherImage = 'assets/storm.png';
        } else if (description.contains('sun')) {
          _weatherImage = 'assets/sun.png';
        } else {
          _weatherImage = 'assets/cloud.png'; // Default image
        }
      });

      // Save the weather data and location in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('location', maplocation);
      prefs.setString('weatherName', _weatherName);
      prefs.setString('weatherTemp', _weatherTemp);
      prefs.setString('weatherImage', _weatherImage);
    } else {
      setState(() {
        _weatherName = 'Error fetching weather data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.lightBlueAccent, // Make AppBar transparent
        elevation: 0, // Remove shadow
        actions: [
          IconButton(
            icon: Icon(Icons.help),
            onPressed: () {
              // Push to WeatherIntroPage when the icon is pressed
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherIntroScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/weather.jpg'), // Single background image
            fit: BoxFit.cover, // This makes the image cover the entire screen
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: location,
                decoration: InputDecoration(labelText: 'Enter location'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchWeather,
                child: Text(location.text.isEmpty ? 'Save' : 'Update'),
              ),
              SizedBox(height: 50),
              Column(
                children: [
                  // Show "Choose a location" text if weather data is not yet fetched
                  (_weatherName.isEmpty && _weatherTemp.isEmpty)
                      ? Text("Choose a location")
                      : Column(
                    children: [
                      Image.asset(
                        _weatherImage,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 30),
                      Text(_weatherTemp),
                      Text(_weatherName),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

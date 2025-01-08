import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; // For scheduling a delayed action
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/Homescreen.dart'; // For saving the 'Skip' button action

class WeatherIntroScreen extends StatefulWidget {
  @override
  _WeatherIntroScreenState createState() => _WeatherIntroScreenState();
}

class _WeatherIntroScreenState extends State<WeatherIntroScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically redirect to homepage after 5 seconds if no action taken
    Future.delayed(Duration(seconds: 50), () {
      _navigateToHomepage();
    });
  }

  // Method to check if the Skip button was clicked, to prevent showing the page next time
  void _onSkipButtonClicked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSkipped', true);
    Homescreen();
  }

  // Navigate to the homepage (replace with your actual homepage widget)
  void _navigateToHomepage() {
    Navigator.pushReplacementNamed(context, '/Homepage'); // Assumes '/home' is defined in your routes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://www.vhv.rs/dpng/d/427-4270068_gold-retro-decorative-frame-png-free-download-transparent.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'We show weather for you',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Skip Button
                ElevatedButton(
                  onPressed: _onSkipButtonClicked,
                  child: Text('Skip'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
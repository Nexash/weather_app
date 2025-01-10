import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/Homescreen.dart'; // Assuming Homescreen is already implemented

class WeatherIntroScreen extends StatefulWidget {
  @override
  _WeatherIntroScreenState createState() => _WeatherIntroScreenState();
}

class _WeatherIntroScreenState extends State<WeatherIntroScreen> {
  @override
  void initState() {
    super.initState();
    // Automatically redirect to homepage after 5 seconds if no action taken
    Future.delayed(Duration(seconds: 5), () {
      _navigateToHomepage();
    });
  }

  // Method to check if the Skip button was clicked, to prevent showing the page next time
  void _onSkipButtonClicked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSkipped', true);

    // Navigate to the homepage
    _navigateToHomepage();
  }

  // Navigate to the homepage (replace with your actual homepage widget)
  void _navigateToHomepage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Homescreen()), // Navigating to Homescreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setting the body background color to white
      body: Container(
        color: Colors.white, // Set the body background to white
        child: Stack(
          children: [
            // Container with image inside the body
            Container(
              margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20, bottom: 50),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/back.png'),
                  fit: BoxFit.fill, // Background image
                ),
              ),
              child: Center(
                // Centered text and button inside the image container
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'We show weather for you',
                      style: TextStyle(
                        fontSize: 25,
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
            ),
          ],
        ),
      ),
    );
  }
}

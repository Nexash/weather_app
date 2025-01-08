import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/Homescreen.dart';
import 'package:weather_app/weather_intro_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isSkipped = prefs.getBool('isSkipped') ?? false;

  runApp(MyApp(isSkipped: isSkipped));
}

class MyApp extends StatelessWidget {
  final bool isSkipped;

  const MyApp({super.key, required this.isSkipped});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: isSkipped ? '/home' : '/',
      routes: {
        '/': (context) => WeatherIntroScreen(),
        '/home': (context) => WeatherIntroScreen(),
        '/Homepage': (context) => Homescreen(),// Replace with your actual homepage widget
      },
    );
  }
}

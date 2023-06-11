import 'package:flutter/material.dart';
import 'package:barterit/screens/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BarterIt',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme.apply()),
      ),
      home: const SplashScreen(),
    );
  }
}


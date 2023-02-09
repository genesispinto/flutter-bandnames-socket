import 'package:flutter/material.dart';

import 'package:band_names_app/screens/home.dart';


void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home':(context) => const HomePage()
      },
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.white) ),
    );
  }
}
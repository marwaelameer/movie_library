
import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MovieLibraryApp());
}

class MovieLibraryApp extends StatelessWidget {
  const MovieLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Library',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

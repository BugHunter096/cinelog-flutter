import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/film_library_controller.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CineLogApp());
}

class CineLogApp extends StatelessWidget {
  const CineLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilmLibraryController()..load(),
      child: MaterialApp(
        title: 'CineLog',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
          scaffoldBackgroundColor: const Color(0xFFF8FAFC),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'quiz_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // Déjà là
      title: 'Quiz ESEN - HAMMAMI Oumaima',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const QuizScreen(),
      builder: (context, child) {
        // CETTE LIGNE TUE LA BARRE JAUNE MÊME EN DEBUG FORCÉ !
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
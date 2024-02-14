import 'package:affection_alerts/env/envied.dart';
import 'package:affection_alerts/home.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';

void main() {
  OpenAI.apiKey = Env.apiKey;
  OpenAI.requestsTimeOut = const Duration(minutes: 2);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

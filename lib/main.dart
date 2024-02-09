import 'package:flutter/material.dart';
import 'package:sorteador_ro/src/home_page.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color(0xff6f1a07))),
      home: const HomePage(),
    ),
  );
}

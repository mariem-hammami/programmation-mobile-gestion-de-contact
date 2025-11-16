import 'package:flutter/material.dart';
import 'router.dart';

/// Liste globale d'utilisateurs
List<Map<String, String>> usersList = [];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Application Authentification',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
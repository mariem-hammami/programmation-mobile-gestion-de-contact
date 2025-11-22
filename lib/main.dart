import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'router.dart';

/// Liste globale d'utilisateurs
List<Map<String, String>> usersList = [];

void main() {
  /// 🔧 Initialisation SQLite pour Desktop (Windows / Linux / MacOS)
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

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

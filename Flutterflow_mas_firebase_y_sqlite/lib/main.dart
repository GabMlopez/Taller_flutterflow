import 'package:flutter/material.dart';
import './controladores/router.dart';

void main() {

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mezclador',

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
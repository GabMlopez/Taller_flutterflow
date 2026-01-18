import 'package:flutter/material.dart';
import './pages/provider/user_provider.dart';
import 'package:provider/provider.dart';

import './controladores/mongo_connection.dart';
import './controladores/router.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  try {
    final dbService = await DatabaseService.instance;
    runApp(
      MultiProvider(
        providers: [
          Provider<DatabaseService>.value(value: dbService),
          ChangeNotifierProvider.value(value: userProvider),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e, stack) {
    print('ERROR CRÍTICO EN MAIN: $e');
    print('Stack: $stack');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Error al iniciar: $e')),
      ),
    ));
  }
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

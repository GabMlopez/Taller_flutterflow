import 'package:flutter/material.dart';
import 'package:flutter_group_chat/presentation/components/user_input.dart';
import 'package:provider/provider.dart';
import 'presentation/layouts/chat_list.dart';
import 'presentation/layouts/login_page.dart';
import 'presentation/layouts/chat_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'presentation/providers/user_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    ChangeNotifierProvider(create: (_) => UserProvider(),
      child: MainApp(),)
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => ChatList(),
        '/chat': (context) => ChatPage()
      },
      home: LoginPage(),
    );
  }
}

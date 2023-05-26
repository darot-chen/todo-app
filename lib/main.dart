import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app_challenge/theme_config.dart';

import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(systemNavigationBarColor: Colors.transparent));
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ThemeConfig.lightColorScheme,
        primaryColor: ThemeConfig.lightColorScheme.primary,
        scaffoldBackgroundColor: ThemeConfig.lightColorScheme.background,
        textTheme: ThemeConfig.textTheme,
      ),
      home: const HomeScreen(),
    );
  }
}

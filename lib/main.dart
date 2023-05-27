import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_challenge/config/theme_config.dart';
import 'package:todo_app_challenge/provider/todo_list_provider.dart';

import 'view/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        todoListProvider,
      ],
      child: const MyApp(),
    ),
  );
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

import 'package:fire_crud/screens/screens.dart';
import 'package:fire_crud/themes/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo Firebase',
      initialRoute: LoginScreen.routerName,
      routes: {
        LoginScreen.routerName: (_) => LoginScreen(),
        RegisterScreen.routerName: (_) => RegisterScreen(),
        HomeScreen.routerName: (_) => HomeScreen(),
      },
      theme: AppTheme.lightTheme,
    );
  }
}

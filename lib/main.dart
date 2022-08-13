import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fire_crud/screens/screens.dart';
import 'package:fire_crud/services/services.dart';
import 'package:fire_crud/themes/app_theme.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthService())],
      child: MyApp(),
    );
  }
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
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: AppTheme.lightTheme,
    );
  }
}

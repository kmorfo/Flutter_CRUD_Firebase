import 'package:fire_crud/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fire_crud/services/services.dart';

class HomeScreen extends StatelessWidget {
  static const String routerName = "HomeScreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo Firebase'),
        actions: [
          IconButton(
              onPressed: () {
                authService.signOut();
                Navigator.pushReplacementNamed(context, LoginScreen.routerName);
              },
              icon: Icon(Icons.login_outlined))
        ],
      ),
      body: Center(
        child: Text('HomeScreen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

import 'package:flutter/material.dart';

class NotificationsService {
  //Se obtiene el key de materialapp del main
  static late GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = new SnackBar(
        content: Text(
      message,
      style: TextStyle(color: Colors.white, fontSize: 20),
    ));

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}

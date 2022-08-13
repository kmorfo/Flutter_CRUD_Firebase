import 'package:flutter/material.dart';

import '../firebase_options.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  //Se obtiene la APIKEY del archivo de configuracion de firebase
  final String _firebaseToken = DefaultFirebaseOptions.currentPlatform.apiKey;

  
}

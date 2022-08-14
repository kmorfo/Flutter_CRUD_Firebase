import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../firebase_options.dart';

typedef OAuthSignIn = void Function();

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  //Se obtiene la APIKEY del archivo de configuracion de firebase
  final String _firebaseToken = DefaultFirebaseOptions.currentPlatform.apiKey;

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  String error = '';
  String verificationId = '';

  bool _isLoading = false;

  void set isLoading(bool value) => _isLoading;
  bool get isLoading => _isLoading;

  Future<String?> signInWithGoogle() async {
    isLoading = true;
    try {
      // Trigger the authentication flow

      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      if (googleAuth != null) {
        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Once signed in, return the UserCredential
        await _auth.signInWithCredential(credential);
        error = '';
        return null;
      }
    } on FirebaseAuthException catch (e) {
      error = '${e.message}';
      return error;
    } finally {
      isLoading = false;
    }
  }

  Future<String?> mailLogin(String email, String password) async {
    isLoading = true;

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      error = '';
      return null;
    } on FirebaseAuthMultiFactorException catch (e) {
      error = '${e.message}';
      final auth = FirebaseAuth.instance;
      return error;
    } catch (e) {
      error = '${e}';
      return error;
    } finally {
      isLoading = false;
    }
  }

  Future<String?> emailRegister(String email, String password) async {
    isLoading = true;

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthMultiFactorException catch (e) {
      error = '${e.message}';

      final auth = FirebaseAuth.instance;
    } on FirebaseAuthException catch (e) {
      error = '${e.message}';
      return error;
    } catch (e) {
      error = '${e}';
    } finally {
      isLoading = false;
    }
  }

  /// Example code for sign out.
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  Future<String> readToken() async {
    return await FirebaseAuth.instance.currentUser != null?'LOGIN':'';
  }
}

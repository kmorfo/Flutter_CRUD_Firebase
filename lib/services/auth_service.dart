import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef OAuthSignIn = void Function();

class AuthService extends ChangeNotifier {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  String error = '';
  String verificationId = '';

  final bool _isLoading = false;

  set isLoading(bool value) => _isLoading;
  bool get isLoading => _isLoading;

  //Abre el dialog para iniciar la session con una cuenta de google
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
    } on Exception catch (e) {
      error = '$e';
      isLoading = false;
      return error;
    } finally {
      isLoading = false;
    }
  }

  //Login del usuario/pass enviado por parametros 
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

  //Registra el usuario/pass enviado por parametros 
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
      error = '$e';
    } finally {
      isLoading = false;
    }
  }

  // Cerrar la sesion del usuario
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  //Comprueba si el usuariol ya tiene la session iniciada anteriormente
  Future<String> readToken() async {
    return await FirebaseAuth.instance.currentUser != null?'LOGIN':'';
  }
}

import 'dart:io';

import 'package:ch_db_admin/shared/exceptions/app_exception.dart';
import 'package:ch_db_admin/shared/exceptions/firebase_exception.dart'
    as custom;
import 'package:ch_db_admin/shared/exceptions/network_exception.dart';
import 'package:ch_db_admin/src/login/data/models/user_login_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRemoteS {
  final auth = FirebaseAuth.instance;

  Future<User?> signIn(UserLoginCredentialsModel data) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Catch specific Firebase authentication errors and throw a custom exception
      if (e.code == 'user-not-found') {
        throw custom.FirebaseAuthException('No user found for that email.',
            code: e.code);
      } else if (e.code == 'wrong-password') {
        throw custom.FirebaseAuthException('Wrong password provided.',
            code: e.code);
      } else {
        throw custom.FirebaseAuthException(
            'Authentication failed: ${e.message}',
            code: e.code);
      }
    } on SocketException catch (e) {
      // If another type of exception occurs, it might be a network issue or something unexpected.
      if (e.toString().contains('network')) {
        throw NetworkException('Network connection failed.');
      } else {
        throw AppException('An unknown error occurred: ${e.toString()}');
      }
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<String> logOut() async {
    try {
      await auth.signOut();
      return 'Signed out successfully';
    } catch (e) {
      print(e);
      throw AppException('Failed to logout: ${e.toString()}');
    }
  }
}

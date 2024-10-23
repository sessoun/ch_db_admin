import 'dart:developer';
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
      log('here: $e');

      log(e.code);

      throw custom.FirebaseAuthException(e.message ?? 'Authentication error',
          code: e.code);
    } on SocketException catch (e) {
      // If another type of exception occurs, it might be a network issue or something unexpected.
      log('here: $e');
      throw NetworkException(e.message);
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

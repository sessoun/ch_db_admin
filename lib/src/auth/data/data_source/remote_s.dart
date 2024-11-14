import 'dart:developer';
import 'dart:io';

import 'package:ch_db_admin/shared/exceptions/app_exception.dart';
import 'package:ch_db_admin/shared/exceptions/firebase_exception.dart'
    as custom;
import 'package:ch_db_admin/shared/exceptions/network_exception.dart';
import 'package:ch_db_admin/src/auth/data/models/user_login_credentials.dart';
import 'package:ch_db_admin/src/dependencies/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      log('here: $e');

      log(e.code);

      throw custom.FirebaseAuthException(e.message ?? 'Authentication error',
          code: e.code);
    } on SocketException catch (e) {
      log('here: $e');
      throw NetworkException(e.message);
    } on Exception catch (e) {
      throw AppException(e.toString());
    }
  }

  Future<String> logOut() async {
    try {
      await auth.signOut();
      await locator.get<SharedPreferences>().clear();
      return 'Signed out successfully';
    } catch (e) {
      print(e);
      throw AppException('Failed to logout: ${e.toString()}');
    }
  }
}

import 'package:ch_db_admin/src/login/data/models/user_login_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRemoteS {
  final auth = FirebaseAuth.instance;

  Future<String> login(UserLoginCredentialsModel credentials) async {
    try {
      var userCredentials = await auth.signInWithEmailAndPassword(
        email: credentials.email,
        password: credentials.password,
      );
      return userCredentials.user?.uid ?? '';
    } catch (e) {
      print(e);
      throw Exception('Failed to register: ${e.toString()}');
    }
  }

  Future<String> logOut() async {
    try {
      await auth.signOut();
      return 'Signed out successfully';
    } catch (e) {
      print(e);
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }
}

import 'package:ch_db_admin/src/login/data/models/user_login_credentials.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginRemoteS {
  final auth = FirebaseAuth.instance;

  Future login(UserLoginCredentialsModel data) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: data.email,
        password: data.password,
      );
      print(auth.currentUser?.uid);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }
}

import 'package:ch_db_admin/src/auth/domain/entities/user_credentials.dart';

class UserLoginCredentialsModel extends UserLoginCredentials {
  UserLoginCredentialsModel({required super.email, required super.password});
  toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}

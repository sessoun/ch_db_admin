import 'package:ch_db_admin/shared/exceptions/app_exception.dart';

class FirebaseAuthException extends AppException {
  FirebaseAuthException(super.message, {super.code});
}
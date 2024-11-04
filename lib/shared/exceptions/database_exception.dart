import 'package:ch_db_admin/shared/exceptions/app_exception.dart';

class DatabaseException extends AppException {
  DatabaseException(super.message, {super.code});
}
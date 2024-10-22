import 'package:ch_db_admin/shared/exceptions/app_exception.dart';

class NetworkException extends AppException {
  NetworkException(super.message, {super.code});
}
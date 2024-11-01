import 'package:ch_db_admin/shared/failure.dart';
import 'package:ch_db_admin/shared/usecase.dart';
import 'package:ch_db_admin/src/login/domain/entities/user_credentials.dart';
import 'package:ch_db_admin/src/login/domain/usecase/log_out.dart';
import 'package:ch_db_admin/src/login/domain/usecase/sign_in.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends ChangeNotifier {
  final SignIn _signIn;
  final SignOut _signOut;

  AuthController({
    required SignIn signIn,
    required SignOut signOut,
  })  : _signIn = signIn,
        _signOut = signOut;

        bool _isLoading = false;
        get isLoading => _isLoading;

  Future<Either<Failure, User?>> signIn(UserLoginCredentials data) async {
    _isLoading = true;
    notifyListeners();
    final result = await _signIn(Params(data));
     _isLoading = false;
    notifyListeners();
    return result.fold((failure) {
      return left(Failure(failure.message));
    }, (success) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('organisation_id',success!.uid);
      return right(success);
    });
  }

  Future<Either<Failure,String>> signOut()async{
 final result = await _signOut(NoParams());
    return result.fold((failure) {
      return left(Failure(failure.message));
    }, (success) {
      return right(success);
    });
  }
}

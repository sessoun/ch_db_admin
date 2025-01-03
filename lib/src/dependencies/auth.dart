import 'package:ch_db_admin/src/auth/data/data_source/remote_s.dart';
import 'package:ch_db_admin/src/auth/data/repository/auth_repo_impl.dart';
import 'package:ch_db_admin/src/auth/domain/repository/auth_repo.dart';
import 'package:ch_db_admin/src/auth/domain/usecase/log_out.dart';
import 'package:ch_db_admin/src/auth/domain/usecase/reset_password.dart';
import 'package:ch_db_admin/src/auth/domain/usecase/sign_in.dart';
import 'package:ch_db_admin/src/auth/presentation/controller/auth_controller.dart';
import 'package:get_it/get_it.dart';

void initAuthDep() {
  locator.registerLazySingleton<LoginRemoteS>(() => LoginRemoteS());
  locator.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(locator.get()));
  locator.registerLazySingleton<SignIn>(() => SignIn(locator.get()));
  locator.registerLazySingleton<SignOut>(() => SignOut(locator.get()));
  locator
      .registerLazySingleton<ResetPassword>(() => ResetPassword(locator.get()));
}

final authController = AuthController(
    signIn: locator.get(),
    signOut: locator.get(),
    resetPassword: locator.get());

final locator = GetIt.instance;

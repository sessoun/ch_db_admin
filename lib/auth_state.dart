import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/src/auth/presentation/ui/login.dart';
import 'package:ch_db_admin/src/main_view/presentation/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

final triggerPasswordReset = TriggerPasswordReset();

class AuthState extends StatefulWidget {
  const AuthState({super.key});

  @override
  State<AuthState> createState() => _AuthStateState();
}

class _AuthStateState extends State<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  AppUpdateInfo? _updateInfo;

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });

      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.startFlexibleUpdate().then(
          (result) => InAppUpdate.completeFlexibleUpdate(),
        );
      }
    }).catchError((e) {
      NotificationUtil.showError(context, e.toString());
    });
  }

  @override
  void initState() {
    checkForUpdate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentUser = _auth.currentUser;
    return currentUser == null ? const LoginView() : const HomeView();
  }
}

class TriggerPasswordReset extends ValueNotifier<String?> {
  TriggerPasswordReset() : super(null);

  void setPassword(String password) {
    value = password;
  }
}

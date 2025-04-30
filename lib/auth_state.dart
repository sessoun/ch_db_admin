import 'package:ch_db_admin/shared/notification_util.dart';
import 'package:ch_db_admin/src/auth/presentation/ui/login.dart';
import 'package:ch_db_admin/src/main_view/presentation/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

// ✅ Global instance to track entered password
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

  // Platform messages are asynchronous, so we initialize in an async method.
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
  // static final String defaultPassword = dotenv.env['DEFAULT_PASSWORD']!;
  // bool isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkPasswordStatus();
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   WidgetsBinding.instance.addPersistentFrameCallback((_) {
  //     _checkPasswordStatus();
  //   });
  // }

  // Future<void> _checkPasswordStatus() async {
  //   currentUser = _auth.currentUser;
  //   if (currentUser == null || triggerPasswordReset.value == null) return;
  //
  //   // 🔥 Compare entered password with default
  //   if (triggerPasswordReset.value == defaultPassword) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if (mounted) {
  //         _showPasswordResetDialog();
  //       }
  //     });
  //   }
  // }
  //
  // Future<void> _showPasswordResetDialog() async {
  //   if (!mounted) return;
  //   await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: const Text("Password Reset Required"),
  //         content: const Text(
  //           "You are using the default password. Please reset your password now.",
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () async {
  //               setState(() => isLoading = true);
  //               await FirebaseAuth.instance.sendPasswordResetEmail(
  //                 email: currentUser!.email!,
  //               );
  //
  //               await FirebaseAuth.instance.signOut();
  //               if (mounted) {
  //                 setState(() {
  //                   currentUser = null;
  //                 });
  //               }
  //               setState(() => isLoading = true);
  //
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text("Reset Now"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

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

// ✅ ValueNotifier to track entered password globally
//This class checks if the password being used is the default one
class TriggerPasswordReset extends ValueNotifier<String?> {
  TriggerPasswordReset() : super(null);

  void setPassword(String password) {
    value = password;
  }
}

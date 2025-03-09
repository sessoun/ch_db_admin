import 'package:ch_db_admin/src/auth/presentation/ui/login.dart';
import 'package:ch_db_admin/src/main_view/presentation/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  static final String defaultPassword = dotenv.env['DEFAULT_PASSWORD']!;
  bool isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   _checkPasswordStatus();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      _checkPasswordStatus(); // ✅ Call after widget is in the tree.
    });
  }

  Future<void> _checkPasswordStatus() async {
    currentUser = _auth.currentUser;
    if (currentUser == null || triggerPasswordReset.value == null) return;

    // 🔥 Compare entered password with default
    if (triggerPasswordReset.value == defaultPassword) {
      _showPasswordResetDialog();
    }
  }

  Future<void> _showPasswordResetDialog() async {
    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text("Password Reset Required"),
          content: const Text(
            "You are using the default password. Please reset your password now.",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                setState(() => isLoading = true);
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: currentUser!.email!,
                );

                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  setState(() {
                    currentUser = null;
                  });
                }
                setState(() => isLoading = true);

                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const LoginView(),
                ));
              },
              child: const Text("Reset Now"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return currentUser == null ? const LoginView() : const HomeView();
  }
}

// ✅ ValueNotifier to track entered password globally
class TriggerPasswordReset extends ValueNotifier<String?> {
  TriggerPasswordReset() : super(null);

  void setPassword(String password) {
    value = password;
  }
}


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService authService = AuthService();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  String message = '';
  bool isLoading = false;

  Future<void> logout() async {
    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      await authService.signOut();
    } catch (e) {
      if (mounted) {
        setState(() {
          message = 'Could not sign out.';
        });
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updatePassword() async {
    String oldPassword = oldPasswordController.text;
    String newPassword = newPasswordController.text;

    if (newPassword.length < 6) {
      setState(() {
        message = 'New password must be at least 6 characters.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      await authService.changePassword(newPassword);

      if (mounted) {
        setState(() {
          message = 'Password updated.';
        });
        oldPasswordController.clear();
        newPasswordController.clear();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        try {
          User? user = authService.currentUser;

          if (user == null || user.email == null ||
              oldPassword.isEmpty) {
            throw Exception('Current password required');
          }

          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: oldPassword,
          );

          await user.reauthenticateWithCredential(credential);
          await authService.changePassword(newPassword);

          if (mounted) {
            setState(() {
              message = 'Password updated.';
            });
            oldPasswordController.clear();
            newPasswordController.clear();
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              message = 'Could not verify current password.';
            });
          }
        }
      } else {
        if (mounted) {
          setState(() {
            message = 'Could not update password.';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          message = 'Something went wrong.';
        });
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Email: ${user?.email ?? "No email"}'),
            const SizedBox(height: 20),
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
            const SizedBox(height: 20),
            if (message.isNotEmpty)
              Text(message),
            const SizedBox(height: 10),
            if (isLoading)
              const CircularProgressIndicator()
            else ...[
              ElevatedButton(
                onPressed: updatePassword,
                child: const Text('Update Password'),
              ),
              ElevatedButton(
                onPressed: logout,
                child: const Text('Sign Out'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

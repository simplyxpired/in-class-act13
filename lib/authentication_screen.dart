
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_service.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final AuthService authService = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  String message = '';

  Future<void> submit() async {
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        message = 'Please enter a valid email.';
      });
      return;
    }

    if (password.length < 6) {
      setState(() {
        message = 'Password must be at least 6 characters.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      message = '';
    });

    try {
      if (isLogin) {
        await authService.signIn(email, password);
      } else {
        await authService.register(email, password);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          if (e.code == 'email-already-in-use') {
            message = 'This email is already registered.';
          } else if (e.code == 'weak-password') {
            message = 'Please use a stronger password.';
          } else if (e.code == 'invalid-credential' ||
              e.code == 'wrong-password' ||
              e.code == 'user-not-found') {
            message = 'Incorrect email or password.';
          } else {
            message = 'Authentication failed. Please try again.';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          message = 'Something went wrong. Try again.';
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 20),
            if (message.isNotEmpty)
              Text(message),
            const SizedBox(height: 10),
            if (isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: submit,
                child: Text(isLogin ? 'Login' : 'Register'),
              ),
            TextButton(
              onPressed: isLoading ? null : () {
                setState(() {
                  isLogin = !isLogin;
                  message = '';
                });
              },
              child: Text(
                isLogin ? 'Create Account' : 'Back to Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

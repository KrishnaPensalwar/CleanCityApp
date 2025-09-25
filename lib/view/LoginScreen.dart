import 'package:cleancity/view/HomeActivity.dart';
import 'package:cleancity/viewmodel/LoginViewModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

final logger = Logger();
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginViewModel _viewModel = LoginViewModel();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    Fluttertoast.showToast(msg: "Please enter $email and $password");


    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter email and password");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final user = await _viewModel.login(email, password);

      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Welcome ${user.fullName}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeActivity()),
      );
    } catch (e) {
      Navigator.of(context).pop(); // close loader
      Fluttertoast.showToast(msg: "Login Failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _onLoginPressed,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}

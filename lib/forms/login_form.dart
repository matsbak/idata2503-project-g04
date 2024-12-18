import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

//used in sigunupform as well, needs to be refactored
final _firebase = FirebaseAuth.instance;

class LoginForm extends StatefulWidget {
  const LoginForm({
    super.key,
    required this.onLoginSuccess,
    required this.onSwitchToSignup,
  });

  final void Function(String uid) onLoginSuccess;
  final VoidCallback onSwitchToSignup; // Callback to switch to signup form

  @override
  State<LoginForm> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final user = userCredentials.user;
        if (user != null) {
          String uid = user.uid;
          widget.onLoginSuccess(uid);
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Authentication failed.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter your email'
                  : null,
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter your password'
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Not a user yet?',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 8,
                ),
                TextButton(
                  onPressed: widget.onSwitchToSignup,
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

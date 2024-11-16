import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/forms/login_form.dart';

final _firebase = FirebaseAuth.instance;

class SignupForm extends StatefulWidget {
  final VoidCallback onSignupSuccess;
  final VoidCallback onSwitchToLogin; // Callback to switch to login form

  const SignupForm({
    super.key,
    required this.onSignupSuccess,
    required this.onSwitchToLogin,
  });

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        widget.onSignupSuccess();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          //....
        }
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          //TextFormField(
          //  decoration: const InputDecoration(labelText: 'Name'),
          //  keyboardType: TextInputType.name,
          //  validator: (value) => value == null || value.isEmpty
          //      ? 'Please enter your name'
          //      : null,
          //),
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
            onPressed: _signup,
            child: const Text('Sign Up'),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: widget.onSwitchToLogin,
            child: const Text(
              'Already a user? Log in',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

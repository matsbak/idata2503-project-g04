import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/forms/login_form.dart';
import 'package:project/forms/signup_form.dart';
import 'package:project/providers/authentication_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _showLoginForm = false;
  bool _showSignupForm = false;

  void _toggleLoginForm() {
    setState(() {
      _showLoginForm = !_showLoginForm;
      _showSignupForm = false; // Hide signup form when showing login form
    });
  }

  void _toggleSignupForm() {
    setState(() {
      _showSignupForm = !_showSignupForm;
      _showLoginForm = false; // Hide login form when showing signup form
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: isLoggedIn
          ? _buildLoggedInContent(context, ref)
          : _showLoginForm
          ? LoginForm(
        onLoginSuccess: () {
          ref.read(authProvider.notifier).login();
        },
        onSwitchToSignup: _toggleSignupForm, // Switch to signup
      )
          : _showSignupForm
          ? SignupForm(
        onSignupSuccess: () {
          setState(() {
            _showSignupForm = false; // Hide the signup form after success
          });
        },
        onSwitchToLogin: _toggleLoginForm, // Switch to login
      )
          : _buildLoggedOutContent(context),
    );
  }

  Widget _buildLoggedInContent(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey.shade300, // Placeholder for profile image
          child: const Icon(Icons.person, size: 50, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Text(
          'Welcome, User!', // Placeholder username
          style: Theme.of(context).textTheme.titleLarge, // Updated TextTheme property
        ),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        Expanded(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              child: const Text('Logout'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoggedOutContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Please log in to view your profile.',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _toggleLoginForm,
            child: const Text('Login'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _toggleSignupForm,
            child: const Text('Signup'),
          ),
        ],
      ),
    );
  }
}

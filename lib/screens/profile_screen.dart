import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/forms/login_form.dart';
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

  void _toggleLoginForm() {
    setState(() {
      _showLoginForm = !_showLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: isLoggedIn
            ? _buildLoggedInContent(context, ref)
            : _showLoginForm
                ? LoginForm(onLoginSuccess: () {
                    ref.read(authProvider.notifier).logout();
                    _toggleLoginForm();
                  })
                : _buildLoggedOutContent(context, ref),
      ),
    );
  }

  Widget _buildLoggedInContent(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Welcome, User!',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            ref.read(authProvider.notifier).logout();
          },
          child: const Text('Logout'),
        ),
      ],
    );
  }

  Widget _buildLoggedOutContent(BuildContext context, WidgetRef ref) {
    return Column(
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
      ],
    );
  }
}

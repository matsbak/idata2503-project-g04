import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/forms/login_form.dart';
import 'package:project/forms/signup_form.dart';
import 'package:project/providers/authentication_provider.dart';
import 'settings_screen.dart';

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
  String? _profileImagePath;

  Future<void> _pickProfileImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowCompression: true,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _profileImagePath = result.files.single.path;
      });
    }
  }

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
    final authState = ref.watch(authProvider);

    final bool isLoggedIn = authState.isLoggedIn;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),
        ],
      ),
      body: authState.isLoggedIn
          ? _buildLoggedInContent(context, ref)
          : _showLoginForm
          ? LoginForm(
        onLoginSuccess: (String uid) {
          ref.read(authProvider.notifier).login(uid);
        },
        onSwitchToSignup: _toggleSignupForm, // Switch to signup
      )
          : _showSignupForm
          ? SignupForm(
        onSignupSuccess: () {
          setState(() {
            _showSignupForm =
            false; // Hide the signup form after success
          });
        },
        onSwitchToLogin: _toggleLoginForm, // Switch to login
      )
          : _buildLoggedOutContent(context),
    );
  }

  Widget _buildLoggedInContent(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    final String email = user?.email ?? 'user@example.com';
    final String username = email.split('@').first;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        // Profile Picture
        GestureDetector(
          onTap: _pickProfileImage,
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: _profileImagePath != null
                ? Image.file(File(_profileImagePath!)).image
                : null,
            child: _profileImagePath == null
                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                : null,
          ),
        ),
        const SizedBox(height: 16),

        // Welcome Message
        Text(
          'Welcome, $username!', // Replace with dynamic username
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),

        // Logout Button
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

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/forms/login_form.dart';
import 'package:project/forms/signup_form.dart';
import 'package:project/providers/authentication_provider.dart';
import 'package:project/providers/lists_provider.dart';
import 'settings_screen.dart';
import 'package:project/widgets/rating_line_chart.dart';

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
      _showSignupForm = false;
    });
  }

  void _toggleSignupForm() {
    setState(() {
      _showSignupForm = !_showSignupForm;
      _showLoginForm = false;
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
                  onSwitchToSignup: _toggleSignupForm,
                )
              : _showSignupForm
                  ? SignupForm(
                      onSignupSuccess: () {
                        setState(() {
                          _showSignupForm = false;
                        });
                      },
                      onSwitchToLogin: _toggleLoginForm,
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

            // Welcome Message
            Text(
              'Welcome, $username!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 40),

            // Stats Section
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Recently Added
                Column(
                  children: [
                    Text(
                      'Recently Added',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Inception',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                  child: VerticalDivider(
                    color: Colors.grey,
                    thickness: 1,
                    width: 40, // Space between items
                  ),
                ),
                // Avg Rating
                Column(
                  children: [
                    Text(
                      'Avg Rating',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '4.5',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Chart Section
            const SizedBox(
              height: 250,
              child: RatingLineChart(),
            ),
            const SizedBox(height: 20),

            // Logout Button
            ElevatedButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
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

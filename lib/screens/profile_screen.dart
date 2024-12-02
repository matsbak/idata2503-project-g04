import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/forms/auth_utils.dart';
import 'package:project/forms/login_form.dart';
import 'package:project/forms/signup_form.dart';
import 'package:project/providers/authentication_provider.dart';
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
  bool _isUploading = false;
  String? _previousUserId;
  String? _profileImagePath;
  String? _profileImageUrl; // URL to uploaded image in firebase storage

  @override
  void initState() {
    super.initState();
    _fetchProfileImageUrl();
  }

  Future<void> _fetchProfileImageUrl() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final imageUrl = userDoc.data()?['profileImageUrl'] as String?;

      setState(() {
        _profileImageUrl = imageUrl; // Update with the new user's profile image
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch profile image: $e'),
        ),
      );
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        return;
      }

      final File file = File(pickedFile.path);

      setState(() {
        _isUploading = true;
      });

      final uid = getUidIfLoggedIn(ref);
      if (uid == null) {
        throw Exception('User not logged in.');
      }

      final storageRef = FirebaseStorage.instance.ref().child('profile_images/$uid');
      await storageRef.putFile(file);
      final imageUrl = await storageRef.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
        'profileImageUrl': imageUrl,
        'user': FirebaseAuth.instance.currentUser?.email,
      }, SetOptions(merge: true));

      setState(() {
        _profileImageUrl = imageUrl;
        _isUploading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to upload profile image: $e'),
        ),
      );
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
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && (user.uid != _previousUserId)) {
      _previousUserId = user.uid;
      _fetchProfileImageUrl();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (authState.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: authState.isLoggedIn
          ? _buildLoggedInContent(context, ref)
          : SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_showLoginForm)
                LoginForm(
                  onLoginSuccess: (String uid) {
                    ref.read(authProvider.notifier).login(uid);
                  },
                  onSwitchToSignup: _toggleSignupForm,
                )
              else if (_showSignupForm)
                SignupForm(
                  onSignupSuccess: () {
                    setState(() {
                      _showSignupForm = false;
                    });
                  },
                  onSwitchToLogin: _toggleLoginForm,
                )
              else
                _buildLoggedOutContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoggedInContent(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final String email = user?.email ?? 'user@example.com';
    final String username = email.split('@').first;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            GestureDetector(
              onTap: _pickProfileImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : null,
                child: _isUploading
                    ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.blue,
                )
                    : _profileImageUrl == null
                    ? const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey,
                )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Welcome Message
            Text(
              'Welcome, $username!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 40),

            const SizedBox(height: 40),

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

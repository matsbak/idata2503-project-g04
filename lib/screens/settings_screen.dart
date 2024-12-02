import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project/providers/authentication_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current Firebase user
    final user = FirebaseAuth.instance.currentUser;

    // Retrieve the user's email
    final String email = user?.email ?? 'user@example.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              const Text(
                'ACCOUNT',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildEditableField(
                  context: context,
                  label: 'Email Adress',
                  value: email,
                  onTap: () => _showChangeEmailDialog(context, user),
              ),
              const Divider(height: 1, color: Colors.grey),

              _buildEditableField(
                  context: context,
                  label: 'Change Password',
                  value: '*********',
                  onTap: () => _showChangePasswordDialog(context, user),
              ),
              const Divider(height: 1, color: Colors.grey),

              const SizedBox(height: 16),

              const Text(
                'Account Management',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              _buildEditableField(
                  context: context,
                  label: 'Delete Account',
                  value: '',
                  onTap: () => _showDeleteAccountDialog(context, ref, user),
                  isDestructive: true,
              ),
              const Divider(height: 1, color: Colors.grey),

              _buildEditableField(
                  context: context,
                  label: 'Logout',
                  value: '',
                  isDestructive: true,
                  onTap: () {
                    ref.read(authProvider.notifier).logout();
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
  }

  // Build Editable Field
  Widget _buildEditableField({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDestructive ? Colors.red : Colors.white,
              ),
            ),
            if (value.isNotEmpty)
              Text(
                value,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            if (value.isEmpty)
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }

  // Show Change Email Dialog
  void _showChangeEmailDialog(BuildContext context, User? user) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Email'),
          content: TextField(
            controller: emailController,
            decoration: const InputDecoration(
              hintText: 'Enter new email',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  if (user != null) {
                    await user.verifyBeforeUpdateEmail(emailController.text.trim());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Verification email sent to the new address'),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update email: $e')),
                  );
                }
              },
              child: const Text('Send Verification'),
            ),
          ],
        );
      },
    );
  }

  // Show Change Password Dialog
  void _showChangePasswordDialog(BuildContext context, User? user) {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Password'),
          content: TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              hintText: 'Enter new password',
            ),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  if (user != null) {
                    await user.updatePassword(passwordController.text.trim());
                  }
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password updated successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update password: $e')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Show Delete Account Dialog
  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref, User? user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                if (user != null) {
                  await user.delete();
                }
                ref.read(authProvider.notifier).logout();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Account deleted successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to delete account: $e')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

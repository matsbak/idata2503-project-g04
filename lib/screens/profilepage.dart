import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Column(
          children: [
            Icon(
              Icons.account_circle,
              size: 200,
            ),
            Text('Lynet McBrennevin')
          ],
        ),
      ),
    );
  }
}

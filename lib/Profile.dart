import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), // You can change the icon
            tooltip: 'Settings',
            onPressed: () {
              // Action when icon is pressed
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Settings tapped!')));
            },
          ),
        ],
      ),
      body: const Center(child: Text('Profile Page')),
    );
  }
}

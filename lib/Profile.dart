import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
              label: const Text('Sign in with Google'),
              onPressed: () {
                // TODO: Implement Google sign-in
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.facebook, color: Colors.blue),
              label: const Text('Sign in with Facebook'),
              onPressed: () {
                // TODO: Implement Facebook sign-in
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const FaIcon(
                FontAwesomeIcons.instagram,
                color: Colors.purple,
              ),
              label: const Text('Sign in with Instagram'),
              onPressed: () {
                // TODO: Implement Instagram sign-in
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Or fill in your information:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Handle manual sign-in
              },
              child: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

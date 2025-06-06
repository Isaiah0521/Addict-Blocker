import 'package:flutter/material.dart';

class InstalledAppsPage extends StatelessWidget {
  const InstalledAppsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example static list of apps
    final apps = [
      {'name': 'YouTube', 'icon': Icons.ondemand_video},
      {'name': 'Instagram', 'icon': Icons.camera_alt},
      {'name': 'Facebook', 'icon': Icons.facebook},
      {'name': 'Twitter', 'icon': Icons.alternate_email},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Installed Apps')),
      body: ListView.builder(
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          return ListTile(
            leading: Icon(app['icon'] as IconData),
            title: Text(app['name'] as String),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('${app['name']} tapped!')));
            },
          );
        },
      ),
    );
  }
}

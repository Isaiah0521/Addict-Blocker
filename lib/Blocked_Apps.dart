import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

// Helper to filter only apps with icons
List<ApplicationWithIcon> _appsWithIcons(List<Application> apps) {
  const allowedPackages = [
    'com.android.chrome',
    'com.google.android.youtube',
    'com.google.android.googlequicksearchbox', // Google app
    'com.google.android.apps.maps',
    'com.android.vending', // Play Store
    'com.facebook.katana',
    'com.instagram.android',
    'com.twitter.android',
    'com.snapchat.android',
    'com.whatsapp',
    // Add more as needed
  ];

  return apps
      .whereType<ApplicationWithIcon>()
      .where(
        (app) =>
            (!app.systemApp || allowedPackages.contains(app.packageName)) &&
            !app.appName.toLowerCase().contains('license'),
      )
      .toList();
}

// Create a new page for the full app list
class FullAppListPage extends StatelessWidget {
  final List<ApplicationWithIcon> apps;
  const FullAppListPage({super.key, required this.apps});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Installed Apps')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index];
          String appName = app.appName;
          if (appName.length > 6) {
            appName = '${appName.substring(0, 6)}...';
          }
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(app.icon, width: 40, height: 40),
              const SizedBox(height: 4),
              Text(
                appName,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
              ),
            ],
          );
        },
      ),
    );
  }
}

class BlockedAppsPage extends StatefulWidget {
  const BlockedAppsPage({super.key});

  @override
  State<BlockedAppsPage> createState() => _BlockedAppsPageState();
}

class _BlockedAppsPageState extends State<BlockedAppsPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _blockedApps = [];

  // Switch states for blocking features

  List<Application>? _installedApps;
  int _appsToShow = 25;

  @override
  void initState() {
    super.initState();
    _fetchInstalledApps();
  }

  Future<void> _fetchInstalledApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
    );
    if (!mounted) return; // <-- Add this line
    setState(() {
      _installedApps = apps;
    });
  }

  void _addApp() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _blockedApps.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blocked Apps')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter app name to block',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Show 5x5 grid of installed apps with "More" button if needed
            _installedApps == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Builder(
                        builder: (context) {
                          final iconApps = _appsWithIcons(_installedApps!);
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 0.8,
                                ),
                            itemCount:
                                iconApps.length > _appsToShow
                                    ? _appsToShow
                                    : iconApps.length,
                            itemBuilder: (context, index) {
                              final app = iconApps[index];
                              String appName = app.appName;
                              if (appName.length > 6) {
                                appName = '${appName.substring(0, 6)}...';
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.memory(app.icon, width: 40, height: 40),
                                  const SizedBox(height: 4),
                                  Text(
                                    appName,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 2,
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                    if (_installedApps!
                            .whereType<ApplicationWithIcon>()
                            .length >
                        _appsToShow)
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => FullAppListPage(
                                    apps: _appsWithIcons(_installedApps!),
                                  ),
                            ),
                          );
                        },
                        child: const Text('More'),
                      ),
                  ],
                ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addApp, child: const Text('Add App')),
            const SizedBox(height: 20),
            ..._blockedApps.map((app) => ListTile(title: Text(app))),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

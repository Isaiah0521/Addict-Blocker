import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

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
  final List<String> blockedApps;
  final void Function(String packageName) onToggleBlock;

  const FullAppListPage({
    super.key,
    required this.apps,
    required this.blockedApps,
    required this.onToggleBlock,
  });

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
          final isBlocked = blockedApps.contains(app.packageName);
          String appName = app.appName;
          if (appName.length > 6) appName = '${appName.substring(0, 6)}...';
          return GestureDetector(
            onTap: () => onToggleBlock(app.packageName),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.memory(app.icon, width: 40, height: 40),
                    if (isBlocked)
                      const Icon(Icons.block, color: Colors.red, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  appName,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: isBlocked ? Colors.red : Colors.black,
                  ),
                  maxLines: 2,
                ),
              ],
            ),
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
  List<String> _blockedApps = [];
  List<Application>? _installedApps;
  int _appsToShow = 25;

  @override
  void initState() {
    super.initState();
    _loadBlockedApps();
    _fetchInstalledApps();
  }

  Future<void> _loadBlockedApps() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _blockedApps = prefs.getStringList('blocked_apps') ?? [];
    });
  }

  Future<void> _saveBlockedApps() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('blocked_apps', _blockedApps);
  }

  Future<void> _fetchInstalledApps() async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
    );
    if (!mounted) return;
    setState(() {
      _installedApps = apps;
    });
  }

  void _toggleBlockApp(String packageName) {
    setState(() {
      if (_blockedApps.contains(packageName)) {
        _blockedApps.remove(packageName);
      } else {
        _blockedApps.add(packageName);
      }
    });
    _saveBlockedApps();
    updateBlockedAppsOnNative(_blockedApps);
  }

  Future<void> updateBlockedAppsOnNative(List<String> blockedApps) async {
    const platform = MethodChannel('com.example.addict_blocker2/admin');
    await platform.invokeMethod('updateBlockedApps', {
      'blockedApps': blockedApps,
    });
  }

  @override
  Widget build(BuildContext context) {
    final iconApps = _appsWithIcons(_installedApps ?? []);
    return Scaffold(
      appBar: AppBar(title: const Text('Blocked Apps')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Show 5x5 grid of installed apps with "More" button if needed
            _installedApps == null
                ? const Center(child: CircularProgressIndicator())
                : Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: GridView.builder(
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
                          final isBlocked = _blockedApps.contains(
                            app.packageName,
                          );
                          String appName = app.appName;
                          if (appName.length > 6) {
                            appName = '${appName.substring(0, 6)}...';
                          }
                          return GestureDetector(
                            onTap: () => _toggleBlockApp(app.packageName),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Image.memory(
                                      app.icon,
                                      width: 40,
                                      height: 40,
                                    ),
                                    if (isBlocked)
                                      const Icon(
                                        Icons.block,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appName,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        isBlocked ? Colors.red : Colors.black,
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (iconApps.length > _appsToShow)
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => FullAppListPage(
                                    apps: iconApps,
                                    blockedApps: _blockedApps,
                                    onToggleBlock: _toggleBlockApp,
                                  ),
                            ),
                          );
                        },
                        child: const Text('More'),
                      ),
                  ],
                ),
            const Divider(),
            ..._blockedApps.map(
              (pkg) => ListTile(
                title: Text(pkg),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () => _toggleBlockApp(pkg),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

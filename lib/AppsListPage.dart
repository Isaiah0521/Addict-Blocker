import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class AppListPage extends StatefulWidget {
  const AppListPage({super.key});

  @override
  State<AppListPage> createState() => _AppListPageState();
}

class _AppListPageState extends State<AppListPage> {
  List<Application>? apps;

  @override
  void initState() {
    super.initState();
    _fetchApps();
  }

  Future<void> _fetchApps() async {
    List<Application> installedApps = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: false,
    );
    setState(() {
      apps = installedApps;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (apps == null) {
      return Scaffold(
        appBar: AppBar(title: Text('App List')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('App List')),
      body: ListView.builder(
        itemCount: apps!.length,
        itemBuilder: (context, index) {
          final app = apps![index];
          return ListTile(
            leading:
                app is ApplicationWithIcon
                    ? Image.memory(app.icon, width: 40, height: 40)
                    : null,
            title: Text(app.appName),
            subtitle: Text(app.packageName),
          );
        },
      ),
    );
  }
}

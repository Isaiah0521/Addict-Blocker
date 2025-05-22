import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'visit_data.dart';

class BlockedAppsPage extends StatefulWidget {
  const BlockedAppsPage({super.key});

  @override
  State<BlockedAppsPage> createState() => _BlockedAppsPageState();
}

class _BlockedAppsPageState extends State<BlockedAppsPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _blockedApps = [];

  void _addApp() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _blockedApps.add(_controller.text);
        Provider.of<VisitData>(
          context,
          listen: false,
        ).addAppVisit(_controller.text);
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
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter app name to block',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _addApp, child: const Text('Add App')),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _blockedApps.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(_blockedApps[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

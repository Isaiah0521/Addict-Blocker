import 'package:flutter/material.dart';

class BlockedAppsPage extends StatefulWidget {
  const BlockedAppsPage({super.key});

  @override
  State<BlockedAppsPage> createState() => _BlockedAppsPageState();
}

class _BlockedAppsPageState extends State<BlockedAppsPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _blockedApps = [];

  // Switch states for blocking features
  bool _blockYoutubeShorts = false;
  bool _blockInstagramReels = false;
  bool _blockFacebookReels = false;
  bool _blockTiktokReels = false;

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
              child: ListView(
                children: [
                  ..._blockedApps.map((app) => ListTile(title: Text(app))),
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Block YouTube Shorts'),
                    value: _blockYoutubeShorts,
                    onChanged: (val) {
                      setState(() => _blockYoutubeShorts = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Block Instagram Reels'),
                    value: _blockInstagramReels,
                    onChanged: (val) {
                      setState(() => _blockInstagramReels = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Block Facebook Reels'),
                    value: _blockFacebookReels,
                    onChanged: (val) {
                      setState(() => _blockFacebookReels = val);
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Block TikTok Reels'),
                    value: _blockTiktokReels,
                    onChanged: (val) {
                      setState(() => _blockTiktokReels = val);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

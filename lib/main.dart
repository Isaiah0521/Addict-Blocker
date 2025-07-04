import 'dart:collection';
import 'dart:io';
import 'Chart_Page.dart';
import 'Strict_Mode.dart';
import 'Blocked_list.dart';
import 'Profile.dart';
import 'Blocked_Apps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'visit_data.dart';
import 'package:flame_audio/flame_audio.dart';
import 'AudioSystem.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'AppsListPage.dart';

bool _blockYoutubeShorts = false;
bool _blockInstagramReels = false;
bool _blockFacebookReels = false;
bool _blockTiktokReels = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlameAudio.bgm.initialize();
  FlameAudio.bgm.play('song1-temp.mp3', volume: 0.5);
  runApp(
    ChangeNotifierProvider(create: (_) => VisitData(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Holy Shield'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _musicOn = true;

  // List of pages for each tab (Profile page removed)
  static final List<Widget> _pages = <Widget>[
    BlockedWebsitesPage(), // Block-list tab
    BlockedAppsPage(), // Blocked Apps tab
    StrictModePage(), // Strict Mode tab
    ChartPage(), // Chart tab
  ];

  // Handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleMusic() {
    setState(() {
      _musicOn = !_musicOn;
      if (_musicOn) {
        FlameAudio.bgm.play('song1-temp.mp3', volume: 0.5);
      } else {
        FlameAudio.bgm.stop();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    const platform = MethodChannel('com.example.addict_blocker2/admin');
    platform.setMethodCallHandler((call) async {
      if (call.method == "showBlockedMessage") {
        final blockedApp = call.arguments as String?;
        if (blockedApp != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Uh oh, you cannot add this app')),
          );
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAdminPrompt();
    });
  }

  void _showAdminPrompt() async {
    final shouldRequest = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Admin Access Required'),
            content: const Text(
              'To block websites like YouTube, this app needs device admin access. Grant access?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Yes'),
              ),
            ],
          ),
    );
    if (shouldRequest == true) {
      // Call native code to request admin access
      requestAdminAccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              Icons.music_note,
              color: _musicOn ? Colors.green : Colors.red,
            ),
            tooltip: _musicOn ? 'Turn music off' : 'Turn music on',
            onPressed: _toggleMusic,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main page content
          _pages[_selectedIndex],
          // Profile icon positioned at the top right, below the app bar
          Positioned(
            top: 16, // Adjust as needed for spacing below the app bar
            right: 16,
            child: SafeArea(
              child: IconButton(
                icon: const Icon(Icons.person, size: 32),
                tooltip: 'Profile',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 97, 56, 41),
        unselectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Block-list'),
          BottomNavigationBarItem(
            icon: Icon(Icons.block),
            label: 'Blocked Apps',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.lock), // Angel icon here
            label: 'Strict Mode',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Chart'),
        ],
      ),
    );
  }
}

// Define the new page
class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Page')),
      body: const Center(
        child: Text('This is a new page!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}

class BlockedWebsitesPage extends StatefulWidget {
  const BlockedWebsitesPage({super.key});

  @override
  State<BlockedWebsitesPage> createState() => _BlockedWebsitesPageState();
}

class _BlockedWebsitesPageState extends State<BlockedWebsitesPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _blockedWebsites = [];

  void _addWebsite() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _blockedWebsites.add(_controller.text);
        // Increment visit count for the website
        Provider.of<VisitData>(
          context,
          listen: false,
        ).addWebsiteVisit('google.com');
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blocked Websites')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter website to block',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addWebsite,
              child: const Text('Add Website'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _blockedWebsites.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(_blockedWebsites[index]));
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppListPage()),
                );
              },
              child: const Text('App List'),
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
            SwitchListTile(
              title: const Text('Block YouTube Shorts'),
              value: _blockYoutubeShorts,
              onChanged: (val) {
                setState(() => _blockYoutubeShorts = val);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> openAccessibilitySettings() async {
  const platform = MethodChannel('com.example.addict_blocker2/accessibility');
  await platform.invokeMethod('openAccessibilitySettings');
}

Future<void> requestAdminAccess() async {
  const platform = MethodChannel('com.example.addict_blocker2/admin');
  await platform.invokeMethod('requestAdmin');
}

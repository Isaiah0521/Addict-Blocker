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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlameAudio.bgm.initialize();
  FlameAudio.bgm.play('song1.mp3', volume: 0.5);
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
          ), // New tab
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_clock),
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
          ],
        ),
      ),
    );
  }
}

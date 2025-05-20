import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StrictModePage extends StatefulWidget {
  const StrictModePage({Key? key}) : super(key: key);

  @override
  State<StrictModePage> createState() => _StrictModePageState();
}

class _StrictModePageState extends State<StrictModePage> {
  bool accountabilityOn = false;
  String selectedOption = 'Timer';
  DateTime? strictModeEnd;

  final List<String> options = ['Timer', 'Remote Lock'];

  @override
  void initState() {
    super.initState();
    _loadStrictModeState();
  }

  Future<void> _loadStrictModeState() async {
    final prefs = await SharedPreferences.getInstance();
    final endMillis = prefs.getInt('strictModeEnd');
    if (endMillis != null) {
      strictModeEnd = DateTime.fromMillisecondsSinceEpoch(endMillis);
      if (strictModeEnd!.isAfter(DateTime.now())) {
        setState(() {
          accountabilityOn = true;
        });
      } else {
        prefs.remove('strictModeEnd');
      }
    }
  }

  Future<void> _toggleAccountability(bool value) async {
    if (value) {
      final end = DateTime.now().add(const Duration(hours: 24));
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('strictModeEnd', end.millisecondsSinceEpoch);
      setState(() {
        accountabilityOn = true;
        strictModeEnd = end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLocked =
        accountabilityOn &&
        strictModeEnd != null &&
        strictModeEnd!.isAfter(DateTime.now());
    final timeLeft =
        isLocked ? strictModeEnd!.difference(DateTime.now()) : Duration.zero;

    return Scaffold(
      appBar: AppBar(title: const Text('Strict Mode')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('Accountability Mode'),
              value: accountabilityOn,
              onChanged: isLocked ? null : _toggleAccountability,
              subtitle:
                  isLocked
                      ? Text(
                        'Locked for ${timeLeft.inHours}h ${(timeLeft.inMinutes % 60)}m',
                      )
                      : null,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: selectedOption,
              items:
                  options
                      .map(
                        (opt) => DropdownMenuItem(value: opt, child: Text(opt)),
                      )
                      .toList(),
              onChanged:
                  isLocked
                      ? null
                      : (val) {
                        setState(() {
                          selectedOption = val!;
                        });
                      },
              decoration: const InputDecoration(
                labelText: 'Accountability Option',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            if (isLocked)
              Text(
                'Strict Mode is enabled. You cannot turn it off for 24 hours.',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class StrictModePage extends StatefulWidget {
  const StrictModePage({super.key});

  @override
  State<StrictModePage> createState() => _StrictModePageState();
}

class _StrictModePageState extends State<StrictModePage> {
  bool _remoteLockActivated = false;

  void _showContactDialog(BuildContext context) {
    String selected = 'phone';
    final TextEditingController _controller = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder:
              (context, setStateDialog) => AlertDialog(
                title: const Text('Enter Contact Information'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'phone',
                          groupValue: selected,
                          onChanged:
                              (val) => setStateDialog(() {
                                selected = val!;
                                errorMessage = null; // Clear error on switch
                              }),
                        ),
                        const Text('Phone Number'),
                        Radio<String>(
                          value: 'email',
                          groupValue: selected,
                          onChanged:
                              (val) => setStateDialog(() {
                                selected = val!;
                                errorMessage = null; // Clear error on switch
                              }),
                        ),
                        const Text('Email'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Add this line for the label above the textbox
                    Text(
                      selected == 'phone'
                          ? 'Please enter your phone number:'
                          : 'Please enter your email:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      keyboardType:
                          selected == 'phone'
                              ? TextInputType.phone
                              : TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText:
                            selected == 'phone' ? 'Phone number' : 'Email',
                        border: const OutlineInputBorder(),
                      ),
                      autofillHints:
                          selected == 'phone'
                              ? [AutofillHints.telephoneNumber]
                              : [AutofillHints.email],
                      inputFormatters:
                          selected == 'phone'
                              ? [
                                FilteringTextInputFormatter.digitsOnly,
                                TextInputFormatter.withFunction((
                                  oldValue,
                                  newValue,
                                ) {
                                  if (newValue.text.contains(
                                    RegExp(r'[A-Za-z]'),
                                  )) {
                                    setStateDialog(() {
                                      errorMessage =
                                          'Invalid character: Only numbers allowed for phone number';
                                    });
                                    return oldValue;
                                  }
                                  setStateDialog(() {
                                    errorMessage = null;
                                  });
                                  return newValue;
                                }),
                              ]
                              : null,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.trim().isEmpty) {
                        setStateDialog(() {
                          errorMessage =
                              'Invalid, you did not put anything in the textbox';
                        });
                        return;
                      }
                      setState(() {
                        _remoteLockActivated = true;
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Strict Mode')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Remote Lock Section
            Card(
              elevation: 2,
              child: ListTile(
                leading: const FaIcon(FontAwesomeIcons.lock),
                title: const Text('Remote Lock'),
                subtitle: const Text('Lock your device remotely.'),
                trailing: ElevatedButton(
                  onPressed:
                      _remoteLockActivated
                          ? null
                          : () => _showContactDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _remoteLockActivated
                            ? Colors.grey
                            : Colors
                                .brown, // Brown when active, grey when deactivated
                  ),
                  child: Text(
                    _remoteLockActivated ? 'Activated' : 'Activate',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Timer Section
            Card(
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.timer, color: Colors.brown),
                title: const Text('Timer'),
                subtitle: const Text('Set a strict mode timer.'),
                trailing: ElevatedButton(
                  onPressed: () {
                    // TODO: Implement timer logic
                  },
                  child: const Text('Set Timer'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

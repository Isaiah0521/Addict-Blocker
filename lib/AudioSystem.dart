import 'package:flutter/material.dart';
import 'package:flame_audio/flame_audio.dart';

class AudioSystemWidget extends StatefulWidget {
  const AudioSystemWidget({super.key});

  @override
  State<AudioSystemWidget> createState() => _AudioSystemWidgetState();
}

class _AudioSystemWidgetState extends State<AudioSystemWidget> {
  @override
  void initState() {
    super.initState();
    // Initialize the audio system
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('song1.mp3', volume: 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Replace with your widget tree
  }
}

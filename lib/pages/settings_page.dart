import 'package:brain_benchmark/constants.dart';
import 'package:brain_benchmark/data/preferences.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  static String routeName = "/settings";
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Preferences preferences;
  final TextEditingController _usernameController = TextEditingController();

  late int seconds;
  late int level;

  @override
  void initState() {
    final box = Hive.box("preferences");
    if (box.get("settings") == null) {
      box.put("settings", Preferences.initial());
    }
    preferences = box.get("settings");
    seconds = preferences.secondsToMemorize;
    level = preferences.startingLevel;
    _usernameController.text = preferences.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Row(
            children: [
              Text(
                "Seconds to memorize: ${seconds}s",
                style: bodyStyle,
              ),
              Expanded(
                child: Slider(
                  divisions: 10,
                  label: seconds.toString(),
                  value: seconds.toDouble(),
                  onChanged: _updateSecondsToMemorize,
                  onChangeEnd: _saveSecondsToMemorize,
                  min: 1,
                  max: 10,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Starting level: $level",
                  style: bodyStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Slider(
                  divisions: 15,
                  label: level.toString(),
                  value: level.toDouble(),
                  onChanged: _updateStartingLevel,
                  onChangeEnd: _saveStartingLevel,
                  min: 1,
                  max: 15,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              const Expanded(
                flex: 1,
                child: Text(
                  "Playing as:",
                  style: bodyStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _usernameController,
                  onSubmitted: _saveUsername,
                  style: bodyStyle,
                  decoration: const InputDecoration.collapsed(
                    hintText: null,
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateSecondsToMemorize(double value) {
    setState(() {
      seconds = value.toInt();
    });
  }

  void _saveSecondsToMemorize(double value) {
    preferences.secondsToMemorize = value.toInt();
    preferences.save();
  }

  void _updateStartingLevel(double value) {
    setState(() {
      level = value.toInt();
    });
  }

  void _saveStartingLevel(double value) {
    preferences.startingLevel = value.toInt();
    preferences.save();
  }

  void _saveUsername(String username) {
    preferences.username = username;
    preferences.save();
  }
}

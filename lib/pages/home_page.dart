import 'package:brain_benchmark/pages/game_page.dart';
import 'package:brain_benchmark/pages/leaderboard_page.dart';
import 'package:flutter/material.dart';

import 'settings_page.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memory benchmark"),
        actions: [
          GestureDetector(
            child: const Icon(Icons.settings),
            onTap: () {
              Navigator.pushNamed(context, SettingsPage.routeName);
            },
          ),
          const SizedBox(
            width: 16,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, GamePage.routeName);
                },
                label: const Text("New game"),
                icon: const Icon(Icons.play_arrow),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, LeaderboardPage.routeName);
                },
                label: const Text("Leaderboard"),
                icon: const Icon(Icons.leaderboard_outlined),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_benchmark/constants.dart';
import 'package:brain_benchmark/pages/hanoi_page.dart';
import 'package:brain_benchmark/pages/numbers_game_page.dart';
import 'package:flutter/gestures.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                        text:
                            'Please select a game to play\n(or suggest a new one to include ',
                        style: TextStyle()),
                    TextSpan(
                      text: 'here',
                      recognizer: TapGestureRecognizer()..onTap = () {},
                      style: bodySmall.copyWith(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                      ),
                    ),
                    const TextSpan(text: ')'),
                  ],
                  style: bodySmall.copyWith(color: Colors.black),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: const [
                    _GameCard(
                      title: "Number guess",
                      routeName: NumbersGamePage.routeName,
                      imagePath: "assets/numbers.jpg",
                    ),
                    _GameCard(
                      title: "Hanoi tower",
                      routeName: HanoiPage.routeName,
                      imagePath: "assets/hanoi.jpg",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  final String title;
  final String routeName;
  final String imagePath;
  const _GameCard({
    super.key,
    required this.title,
    required this.routeName,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.colorBurn,
            ),
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
              ),
            ),
            AutoSizeText(
              title,
              style: bodyStyle.copyWith(
                color: Colors.white,
              ),
              minFontSize: 10,
              maxFontSize: 20,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

/* IntrinsicWidth(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, NumbersGamePage.routeName);
                  },
                  label: const Text("New game"),
                  icon: const Icon(Icons.play_arrow),
                ),
                const SizedBox(height: 40),
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
           */

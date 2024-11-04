import 'package:auto_size_text/auto_size_text.dart';
import 'package:brain_benchmark/constants.dart';
import 'package:brain_benchmark/pages/hanoi_page.dart';
import 'package:brain_benchmark/pages/memory_page.dart';
import 'package:brain_benchmark/pages/numbers_game_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'reaction_speed.dart';

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
        title: const Text("Brain Tester"),
        /* actions: [
          GestureDetector(
            child: const Icon(Icons.settings),
            onTap: () {
              Navigator.pushNamed(context, SettingsPage.routeName);
            },
          ),
          const SizedBox(
            width: 16,
          ),
        ], */
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
                      description:
                          'Memorize the growing sequence of numbers shown. Each round adds a new digit—how long can you keep up? Test your memory skills and see how far you can go!',
                    ),
                    _GameCard(
                      title: "Hanoi tower",
                      routeName: HanoiPage.routeName,
                      imagePath: "assets/hanoi.jpg",
                      description:
                          'Move the entire stack to a new peg, one disk at a time. Remember, a larger disk can’t go on top of a smaller one!',
                    ),
                    _GameCard(
                      title: "Memory",
                      routeName: MemoryGamePage.routeName,
                      imagePath: "assets/hanoi.jpg",
                      description:
                          'Match the cards by remembering their positions. Clear the board by finding all pairs!',
                    ),
                    _GameCard(
                      title: "Reaction speed",
                      routeName: ReactionGamePage.routeName,
                      imagePath: "assets/hanoi.jpg",
                      description:
                          'Tap as fast as you can when the light turns green. How quick are your reflexes?',
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
  const _GameCard({
    super.key,
    required this.title,
    required this.routeName,
    required this.imagePath,
    required this.description,
  });

  final String title;
  final String routeName;
  final String imagePath;
  final String description;

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
              Colors.black.withOpacity(0.5),
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
                onPressed: () {
                  _showInfo(context);
                },
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

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title, style: bodyStyle),
          content: Text(description),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

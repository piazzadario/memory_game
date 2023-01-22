import 'package:brain_benchmark/constants.dart';
import 'package:brain_benchmark/data/game.dart';
import 'package:brain_benchmark/data/leaderboard.dart';
import 'package:brain_benchmark/data/preferences.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard"),
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: Hive.box("preferences").listenable(),
        builder: (context, box, child) {
          final Preferences preferences = box.get("settings");
          final Leaderboard leaderboard = preferences.leaderboard;
          if (leaderboard.isEmpty) {
            return const Center(child: _NoRecordsCard());
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Table(
              children: [
                const TableRow(
                  children: [
                    Text(
                      "User",
                      style: bodyStyle,
                    ),
                    Text(
                      "Date",
                      style: bodyStyle,
                    ),
                    Text(
                      "Seconds",
                      style: bodyStyle,
                    ),
                    Text(
                      "Score",
                      style: bodyStyle,
                    ),
                  ],
                ),
                ...List.generate(leaderboard.records.length, (index) {
                  final Game game = leaderboard.records[index];
                  return TableRow(
                    children: [
                      Text(
                        game.username,
                        style: bodyStyle,
                      ),
                      Text(
                        game.formattedDate,
                        style: bodyStyle,
                      ),
                      Text(
                        game.secondsToMemorize.toString(),
                        style: bodyStyle,
                      ),
                      Text(
                        game.score.toString(),
                        style: bodyStyle,
                      ),
                    ],
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NoRecordsCard extends StatelessWidget {
  const _NoRecordsCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Row(
          children: const [
            Icon(Icons.leaderboard),
            SizedBox(
              width: 16,
            ),
            Text("No records found."),
          ],
        ),
      ),
    );
  }
}

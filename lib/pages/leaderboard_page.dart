import 'package:brain_benchmark/constants.dart';
import 'package:brain_benchmark/data/game.dart';
import 'package:brain_benchmark/data/leaderboard.dart';
import 'package:brain_benchmark/data/preferences.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LeaderboardPage extends StatelessWidget {
  static String routeName = "/leaderboard";
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
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: _NoRecordsCard(),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Table(
              columnWidths: const {
                0: FixedColumnWidth(60),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(2),
              },
              children: [
                const TableRow(
                  children: [
                    Text(
                      "#",
                      style: bodyStyle,
                    ),
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
                    decoration: BoxDecoration(color: _rowColor(index + 1)),
                    children: [
                      Text(
                        (index + 1).toString(),
                        style: bodyStyle,
                      ),
                      Text(
                        game.username,
                        style: bodyStyle,
                      ),
                      Text(
                        game.formattedDateHour,
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

  Color? _rowColor(int position) {
    if (position == 1) {
      return const Color.fromARGB(255, 176, 162, 34);
    }
    if (position == 2) {
      return Colors.grey.shade300;
    }
    if (position == 3) {
      return const Color.fromARGB(255, 169, 88, 7);
    }

    return null;
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

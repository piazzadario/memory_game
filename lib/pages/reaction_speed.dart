import 'dart:async';
import 'dart:math';

import 'package:brain_benchmark/constants.dart';
import 'package:flutter/material.dart';

class ReactionGamePage extends StatefulWidget {
  const ReactionGamePage({super.key});
  static const String routeName = "/reaction";

  @override
  State<ReactionGamePage> createState() => _ReactionGamePageState();
}

class _ReactionGamePageState extends State<ReactionGamePage> {
  String displayText = "Wait...";
  bool waitingForTap = false;
  late DateTime startTime;
  Timer? timer;

  void _startGame() {
    setState(() {
      displayText = "Wait...";
      waitingForTap = false;
    });

    // Random delay before showing "GO!"
    int delay = Random().nextInt(3000) + 2000; // Between 2 and 5 seconds

    timer = Timer(Duration(milliseconds: delay), () {
      setState(() {
        displayText = "GO!";
        waitingForTap = true;
        startTime = DateTime.now(); // Record the time when "GO!" appears
      });
    });
  }

  void _handleTap() {
    if (waitingForTap) {
      final reactionTime = DateTime.now().difference(startTime).inMilliseconds;

      setState(() {
        displayText = "Reaction Time: ${reactionTime}ms\nTap to play again!";
        waitingForTap = false;
      });

      timer?.cancel(); // Stop any ongoing timers
    } else {
      _startGame();
    }
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel any timers when the widget is disposed
    super.dispose();
  }

  @override
  void initState() {
    _startGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reaction time'),
      ),
      backgroundColor: Colors.blueGrey,
      body: GestureDetector(
        onTap: _handleTap,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    displayText,
                    textAlign: TextAlign.center,
                    style: subtitleStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

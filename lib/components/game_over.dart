import 'package:flutter/material.dart';

import '../constants.dart';

class GameOver extends StatelessWidget {
  final String correctAnswer;
  final String answer;
  final VoidCallback onRestart;

  const GameOver({
    super.key,
    required this.answer,
    required this.correctAnswer,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Game Over!",
            style: headlineStyle.copyWith(
              color: const Color.fromARGB(255, 114, 11, 11),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "Correct answer:",
            style: bodyStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            correctAnswer,
            style: subtitleStyle,
            textAlign: TextAlign.center,
          ),
          const Text(
            "Your answer:",
            style: bodyStyle,
            textAlign: TextAlign.center,
          ),
          if (answer.isNotEmpty)
            RichText(
              text: TextSpan(
                children: _coloredAnswer,
              ),
              textAlign: TextAlign.center,
            )
          else
            const Text(
              "No answer provided",
              style: subtitleStyle,
              textAlign: TextAlign.center,
            ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onRestart,
                icon: const Icon(Icons.restart_alt),
                label: const Text("Restart"),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  List<InlineSpan> get _coloredAnswer {
    if (correctAnswer.length != answer.length) {
      return answer.characters
          .map(
            (e) => TextSpan(
              text: e,
              style: subtitleStyle.copyWith(color: Colors.red),
            ),
          )
          .toList();
    }

    List<InlineSpan> result = [];
    for (int i = 0; i < correctAnswer.length; i++) {
      Color color = correctAnswer[i] == answer[i] ? Colors.green : Colors.red;
      result.add(
        TextSpan(
          text: answer[i],
          style: subtitleStyle.copyWith(color: color),
        ),
      );
    }
    return result;
  }
}

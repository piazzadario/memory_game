import 'package:flutter/material.dart';

import '../constants.dart';

class CorrectAnswer extends StatelessWidget {
  final String answer;
  final VoidCallback onContinue;

  const CorrectAnswer({
    super.key,
    required this.answer,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Correct!",
            style: headlineStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "Level $_level",
            style: bodyStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            answer,
            style: subtitleStyle,
            textAlign: TextAlign.center,
          ),
          
          Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onContinue,
                icon: const Icon(Icons.play_arrow),
                label: Text("Level ${_level+1}"),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  int get _level {
    return answer.length;
  }
}

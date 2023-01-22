import 'dart:math';

import 'package:brain_benchmark/data/game.dart';
import 'package:brain_benchmark/data/preferences.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../components/game_over.dart';
import '../constants.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isGuessing = false;
  int _level = 1;
  String _numberToGuess = "";
  String _userAnswer = "";
  bool _gameOver = false;
  late Preferences preferences;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    final box = Hive.box("preferences");
    if (box.get("settings") == null) {
      box.put("settings", Preferences.initial());
    }

    preferences = box.get("settings");
    _level = preferences.startingLevel;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: preferences.secondsToMemorize),
    )..addListener(() {
        setState(() {});
      });
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _showGuessInput();
      }
    });
    _numberToGuess = _generateRandomNumber();
    _controller.forward();
    super.initState();
  }

  void _showGuessInput() => setState(() {
        _isGuessing = true;
      });

  void _showNumberToGuess() => setState(() {
        _isGuessing = false;
      });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _gameOver
          ? GameOver(
              answer: _userAnswer,
              correctAnswer: _numberToGuess,
              onRestart: _restartGame,
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _isGuessing
                    ? [
                        TextField(
                          autofocus: true,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.number,
                          onSubmitted: _validateInput,
                        ),
                      ]
                    : [
                        LinearProgressIndicator(
                          value: 1 - _controller.value,
                          semanticsLabel: 'Linear progress indicator',
                          backgroundColor: Colors.grey.shade200,
                          color: _progressColor,
                        ),
                        Center(
                          child: Text(
                            _numberToGuess,
                            style: subtitleStyle,
                          ),
                        ),
                      ],
              ),
            ),
    );
  }

  Color get _progressColor {
    double remaining = 100 - (_controller.value * 100);
    if (remaining >= 60) {
      return Colors.green;
    }

    if (remaining >= 20) {
      return Colors.orange;
    }

    return Colors.red;
  }

  void _validateInput(String input) {
    _focusNode.unfocus();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        _userAnswer = input;
        if (input == _numberToGuess) {
          _proceedToNextLevel();
          return;
        }

        if (preferences.startingLevel != _level &&
            preferences.leaderboard.shouldAddRecord(_gameRecord)) {
          preferences.leaderboard.insertRecord(_gameRecord);
          preferences.save();
        }

        _showGameOver();
      },
    );
  }

  void _proceedToNextLevel() {
    _level++;
    _numberToGuess = _generateRandomNumber();
    _controller.reset();
    _showNumberToGuess();
    _controller.forward();
  }

  void _showGameOver() => setState(() {
        _gameOver = true;
      });

  String _generateRandomNumber() {
    StringBuffer number = StringBuffer();
    for (int i = 0; i < _level; i++) {
      number.write(Random().nextInt(10));
    }

    return number.toString();
  }

  void _restartGame() {
    _controller.reset();
    setState(() {
      _level = 1;
      _numberToGuess = _generateRandomNumber();
      _gameOver = false;
      _isGuessing = false;
      _userAnswer = "";
    });
    _controller.forward();
  }

  Game get _gameRecord {
    return Game(
      username: preferences.username,
      score: _level - 1,
      secondsToMemorize: preferences.secondsToMemorize,
      date: DateTime.now(),
    );
  }
}

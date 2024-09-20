import 'dart:math';

import 'package:brain_benchmark/components/correct_answer.dart';
import 'package:brain_benchmark/data/game.dart';
import 'package:brain_benchmark/data/preferences.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../components/game_over.dart';
import '../constants.dart';

class GamePage extends StatefulWidget {
  static String routeName = "/game";
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _MyWidgetState();
}

enum GameStatus {
  gameOver,
  correctAnswer,
  memorizing,
  guessing;
}

class _MyWidgetState extends State<GamePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _textController = TextEditingController();
  GameStatus _gameStatus = GameStatus.memorizing;
  int _level = 1;
  String _numberToGuess = "";
  String _userAnswer = "";
  late Preferences preferences;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    final box = Hive.box("preferences");
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
        _gameStatus = GameStatus.guessing;
      });

  void _showNumberToGuess() => setState(() {
        _gameStatus = GameStatus.memorizing;
      });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Level $_level"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame,
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(context)),
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
    _textController.clear();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        _userAnswer = input;

        if (input == _numberToGuess) {
          _showCorrectAnswer();
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

  void _showCorrectAnswer() => setState(() {
        _gameStatus = GameStatus.correctAnswer;
      });

  void _proceedToNextLevel() {
    _level++;
    _numberToGuess = _generateRandomNumber();
    _controller.reset();
    _showNumberToGuess();
    _controller.forward();
  }

  void _showGameOver() => setState(() {
        _gameStatus = GameStatus.gameOver;
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
      _gameStatus = GameStatus.memorizing;
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

  Widget _buildBody(BuildContext context) {
    switch (_gameStatus) {
      case GameStatus.gameOver:
        return GameOver(
          answer: _userAnswer,
          correctAnswer: _numberToGuess,
          onRestart: _restartGame,
        );
      case GameStatus.correctAnswer:
        return CorrectAnswer(
          answer: _userAnswer,
          onContinue: _proceedToNextLevel,
        );
      case GameStatus.memorizing:
      case GameStatus.guessing:
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: _gameStatus == GameStatus.guessing
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.stretch,
            children: (_gameStatus == GameStatus.guessing)
                ? [
                    TextField(
                      controller: _textController,
                      autofocus: true,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      onSubmitted: _validateInput,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _validateInput(_textController.text);
                      },
                      child: const Text("Submit"),
                    ),
                  ]
                : [
                    LinearProgressIndicator(
                      value: 1 - _controller.value,
                      semanticsLabel: 'Linear progress indicator',
                      color: _progressColor,
                    ),
                    Center(
                      child: Text(
                        _numberToGuess,
                        style: headlineStyle,
                      ),
                    ),
                  ],
          ),
        );
    }
  }
}

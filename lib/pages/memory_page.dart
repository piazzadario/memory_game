import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({super.key});

  static const String routeName = "/memory";

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> {
  List<String> cardValues = [];
  List<bool> cardFlipped = [];
  List<int> selectedCards = [];
  bool allowSelection = true;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    setState(() {
      cardValues = _generateCardValues();
      cardFlipped = List.generate(cardValues.length, (index) => false);
      selectedCards.clear();
      allowSelection = true;
    });
  }

  List<String> _generateCardValues() {
    List<String> values = [];
    for (int i = 1; i <= 10; i++) {
      values.add(i.toString()); // Aggiungi coppie di numeri
      values.add(i.toString());
    }
    values.shuffle(Random());
    return values;
  }

  void _onCardTap(int index) {
    if (allowSelection && !cardFlipped[index] && selectedCards.length < 2) {
      setState(() {
        cardFlipped[index] = true;
        selectedCards.add(index);
      });

      if (selectedCards.length == 2) {
        _checkMatch();
      }
    }
  }

  void _checkMatch() {
    setState(() {
      allowSelection = false;
    });

    Timer(Duration(seconds: 1), () {
      if (cardValues[selectedCards[0]] == cardValues[selectedCards[1]]) {
        // Matched, keep them flipped
        setState(() {
          selectedCards.clear();
        });
        _checkForWin();
      } else {
        // Not matched, flip them back
        setState(() {
          cardFlipped[selectedCards[0]] = false;
          cardFlipped[selectedCards[1]] = false;
          selectedCards.clear();
        });
      }
      setState(() {
        allowSelection = true;
      });
    });
  }

  // Controlla se tutte le carte sono state girate
  void _checkForWin() {
    if (cardFlipped.every((flipped) => flipped)) {
      _showWinDialog();
    }
  }

  // Mostra il dialog di vittoria
  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hai vinto!'),
          content: Text('Complimenti! Hai trovato tutte le coppie.'),
          actions: [
            TextButton(
              child: Text('Gioca ancora'),
              onPressed: () {
                Navigator.of(context).pop();
                _initializeGame(); // Ricomincia il gioco
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memory Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _initializeGame,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: cardValues.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _onCardTap(index),
              child: CardWidget(
                isFlipped: cardFlipped[index],
                cardValue: cardValues[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final bool isFlipped;
  final String cardValue;

  CardWidget({required this.isFlipped, required this.cardValue});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return RotationYTransition(
          turns: animation,
          child: child,
        );
      },
      child: isFlipped
          ? Container(
              key: ValueKey(true),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  cardValue,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            )
          : Container(
              key: ValueKey(false),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
    );
  }
}

class RotationYTransition extends StatelessWidget {
  final Animation<double> turns;
  final Widget child;

  RotationYTransition({required this.turns, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: turns,
      builder: (context, child) {
        final angle = turns.value * pi;
        final transform = Matrix4.identity()..rotateY(angle);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: turns.value > 0.5
              ? Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: child,
                )
              : child,
        );
      },
      child: child,
    );
  }
}

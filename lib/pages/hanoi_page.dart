import 'package:flutter/material.dart';

class HanoiPage extends StatefulWidget {
  const HanoiPage({super.key});

  static const String routeName = '/hanoi';

  @override
  State<HanoiPage> createState() => _HanoiPageState();
}

class _HanoiPageState extends State<HanoiPage> {
  int _numDisks = 3;
  int _moves = 0;
  List<List<int>> _towers = [[], [], []];

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _towers = List.generate(3, (index) => []);
      for (int i = _numDisks; i >= 1; i--) {
        _towers[0].add(i);
      }
      _moves = 0;
    });
  }

  void _moveDisk(int from, int to) {
    if (_towers[from].isEmpty) return;
    if (_towers[to].isNotEmpty && _towers[to].last < _towers[from].last) return;

    setState(() {
      _towers[to].add(_towers[from].removeLast());
      _moves++;
    });
  }

  bool _checkWin() {
    return _towers[2].length == _numDisks;
  }

  Widget _buildTower(int index) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth =
              constraints.maxWidth; // Larghezza massima per una colonna
          return DragTarget<int>(
            onAcceptWithDetails: (fromTower) {
              if (fromTower.data == index) {
                return;
              }
              _moveDisk(fromTower.data, index);
              if (_checkWin()) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('You won!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _resetGame();
                        },
                        child: const Text('Play again'),
                      ),
                    ],
                  ),
                );
              }
            },
            builder: (context, candidateData, rejectedData) => Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (int disk in _towers[index].reversed)
                  AbsorbPointer(
                    absorbing: _towers[index].last != disk,
                    child: Draggable<int>(
                      data: index,
                      feedback: DiskWidget(
                        diskSize: disk,
                        maxWidth: maxWidth,
                        numDisks: _numDisks,
                        showNumber: false,
                      ),
                      childWhenDragging: const SizedBox(),
                      child: DiskWidget(
                        diskSize: disk,
                        maxWidth: maxWidth,
                        numDisks: _numDisks,
                      ),
                    ),
                  ),
                Container(
                  height: 10,
                  color: Colors.grey,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hanoi tower'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetGame,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Number of disks:'),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: _numDisks,
                  items: List.generate(10, (index) => index + 3).map((value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _numDisks = value!;
                      _resetGame();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(width: 10),
            Text('Moves: $_moves/ ${(1 << _numDisks) - 1}'),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTower(0),
                  const SizedBox(width: 10),
                  _buildTower(1),
                  const SizedBox(width: 10),
                  _buildTower(2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiskWidget extends StatelessWidget {
  DiskWidget({
    super.key,
    required this.diskSize,
    required this.maxWidth,
    required this.numDisks,
    this.showNumber = true,
  }) : _color = _colors[(diskSize % _colors.length)];

  final int diskSize;
  final double maxWidth; // Larghezza massima del disco
  final Color _color;
  final int numDisks;

  final bool showNumber;

  static const List<Color> _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
  ];

  @override
  Widget build(BuildContext context) {
    double width = maxWidth * (diskSize / numDisks);
    return Container(
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 2),
      height: 20,
      width: width,
      child: showNumber
          ? Center(
              child: Text(
                '$diskSize',
                style: TextStyle(
                  color: _color == Colors.yellow ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}

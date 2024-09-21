import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'game.g.dart';

@HiveType(typeId: 1)
class Game extends HiveObject implements Comparable<Game> {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final int score;

  @HiveField(2)
  final int secondsToMemorize;

  @HiveField(3)
  final DateTime date;

  Game({
    required this.username,
    required this.score,
    required this.secondsToMemorize,
    required this.date,
  });

  String get formattedDateHour {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  int compareTo(Game other) {
    if (score > other.score) {
      return -1;
    }

    if (score < other.score) {
      return 1;
    }

    return secondsToMemorize < other.secondsToMemorize ? -1 : 0;
  }
}

extension on int {
  String get _toTwoDigits {
    if (this < 10) {
      return "0${this}";
    }

    return toString();
  }
}

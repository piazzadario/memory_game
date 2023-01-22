import 'package:hive/hive.dart';

part 'game.g.dart';

@HiveType(typeId: 1)
class Game extends HiveObject {
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
    return "${date.day}/${date.month}/${date.year} - ${date.hour._toTwoDigits}:${date.minute._toTwoDigits}";
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

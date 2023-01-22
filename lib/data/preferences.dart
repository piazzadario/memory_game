import 'package:hive/hive.dart';

import 'leaderboard.dart';

part 'preferences.g.dart';

@HiveType(typeId: 0)
class Preferences extends HiveObject {
  @HiveField(0,defaultValue: "user")
  String username;
  @HiveField(1,defaultValue: 5)
  int secondsToMemorize;
  @HiveField(2,defaultValue: 1)
  int startingLevel;
  @HiveField(3,defaultValue: [])
  Leaderboard leaderboard;

  Preferences({
    required this.secondsToMemorize,
    required this.startingLevel,
    required this.username,
    required this.leaderboard,
  });

  factory Preferences.initial() {
    return Preferences(
      secondsToMemorize: 5,
      startingLevel: 1,
      username: "user",
      leaderboard: Leaderboard(records: []),
    );
  }
}

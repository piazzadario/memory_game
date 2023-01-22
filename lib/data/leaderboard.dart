import 'package:brain_benchmark/data/game.dart';
import 'package:hive/hive.dart';

part 'leaderboard.g.dart';

@HiveType(typeId: 2)
class Leaderboard extends HiveObject {
  @HiveField(0)
  List<Game> records;

  Leaderboard({
    required this.records,
  });

  void insertRecord(Game record) {
    int i = 0;

    for (i = 0; i < records.length && i < 10; i++) {
      if (record.score > records[i].score) {
        records.insert(i, record);
        return;
      }
    }

    if (i < 10) {
      records.insert(i, record);
    }
  }

  bool shouldAddRecord(Game record) {
    if (record.score == 0) {
      return false;
    }

    if (records.length < 10) {
      return true;
    }

    return records.any((rec) => rec.score < record.score);
  }

  bool get isEmpty => records.isEmpty;
}

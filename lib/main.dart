import 'package:brain_benchmark/data/game.dart';
import 'package:brain_benchmark/data/leaderboard.dart';
import 'package:brain_benchmark/data/preferences.dart';
import 'package:brain_benchmark/pages/game_page.dart';
import 'package:brain_benchmark/pages/leaderboard_page.dart';
import 'package:brain_benchmark/pages/settings_page.dart';
import 'package:brain_benchmark/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeHive();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight])
      .then(
    (_) {
      runApp(const MyApp());
    },
  );
}

Future<void> _initializeHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(GameAdapter());
  Hive.registerAdapter(LeaderboardAdapter());
  Hive.registerAdapter(PreferencesAdapter());
  final box = await Hive.openBox("preferences");
  Preferences? pref = box.get("settings");
  if (pref == null) {
    box.put("settings", Preferences.initial());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brain benchmark',
      theme: lightTheme,
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        GamePage.routeName: (context) => const GamePage(),
        LeaderboardPage.routeName: (context) => const LeaderboardPage(),
        SettingsPage.routeName: (context) => const SettingsPage(),
      },
    );
  }
}

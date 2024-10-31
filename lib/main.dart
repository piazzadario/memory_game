import 'package:brain_benchmark/components/banner_ad.dart';
import 'package:brain_benchmark/data/game.dart';
import 'package:brain_benchmark/data/leaderboard.dart';
import 'package:brain_benchmark/data/preferences.dart';
import 'package:brain_benchmark/firebase_options.dart';
import 'package:brain_benchmark/pages/memory_page.dart';
import 'package:brain_benchmark/pages/numbers_game_page.dart';
import 'package:brain_benchmark/pages/hanoi_page.dart';
import 'package:brain_benchmark/pages/leaderboard_page.dart';
import 'package:brain_benchmark/pages/reaction_speed.dart';
import 'package:brain_benchmark/pages/settings_page.dart';
import 'package:brain_benchmark/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/adapters.dart';

import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  MobileAds.instance.initialize();
  await _initializeHive();
  runApp(const MyApp());
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
      builder: (context, child) {
        return Column(
          children: [
            Expanded(child: child!),
            const AnchoredBanner(),
            SizedBox(height: MediaQuery.of(context).padding.bottom)
          ],
        );
      },
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        HanoiPage.routeName: (context) => const HanoiPage(),
        MemoryGamePage.routeName: (context) => const MemoryGamePage(),
        NumbersGamePage.routeName: (context) => const NumbersGamePage(),
        ReactionGamePage.routeName: (context) => const ReactionGamePage(),
        LeaderboardPage.routeName: (context) => const LeaderboardPage(),
        SettingsPage.routeName: (context) => const SettingsPage(),
      },
    );
  }
}

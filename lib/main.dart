import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kirro/menu/login.dart';
import 'package:kirro/menu/mainPage.dart';
import 'package:kirro/menu/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Mengecek apakah data sudah ada
  bool dataExists = prefs.getBool('dataExists') ?? false;

  if (!dataExists) {
    List<Map<String, dynamic>> gameLevels = [
      {
        'arah': 'Arah Bebas',
        'checked': false,
        'datatosend': '',
      },
      {
        'arah': 'Rumah Sakit',
        'checked': false,
        'datatosend': '[M, M, M]',
      },
      {
        'arah': 'Sekolah',
        'checked': false,
        'datatosend': '[M, M, L, M]',
      },
      {
        'arah': 'Musium',
        'checked': false,
        'datatosend': '[M, M, R]',
      },
      {
        'arah': 'Teater',
        'checked': false,
        'datatosend': '[M, L, M, L, M]',
      },
      {
        'arah': 'Supermarket',
        'checked': false,
        'datatosend': '[M, R, M, R, M]',
      },
      {
        'arah': 'Kantor Pos',
        'checked': false,
        'datatosend': '[M, R, M, L, M]',
      },
      {
        'arah': 'Bank',
        'checked': false,
        'datatosend': '[M, L, M, R, M, R, M]',
      },
      {
        'arah': 'Bandara',
        'checked': false,
        'datatosend': '[M, L, M, R, M, L, M]',
      },
    ];

    // Menyimpan data ke shared preferences
    await prefs.setString('gameLevels', jsonEncode(gameLevels));

    // Menandai bahwa data sudah tersimpan
    await prefs.setBool('dataExists', true);
  }

  runApp(const KirroApp());
}

class KirroApp extends StatelessWidget {
  const KirroApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

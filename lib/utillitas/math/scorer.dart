 import 'package:kirro/global_Variabel/variabel.dart';

import '../database/database_user.dart';


void hitungSkor({required int waktuPenyelesaian, required int waktuTerlama}) async {
  DatabaseUser databaseUser = DatabaseUser();

  
  int skor;

  int skorMaksimal = 100;
  int batasSkorMinimum = 10;

  if (waktuPenyelesaian <= waktuTerlama) {
    // Jika waktu penyelesaian kurang dari atau sama dengan waktu terlama, skor maksimal diberikan.
    skor = skorMaksimal;
  } else {
    // Jika waktu penyelesaian melebihi waktu terlama, kurangkan skor secara linier.
    skor = skorMaksimal - ((waktuPenyelesaian - waktuTerlama) ~/ 2);
    
    // Pastikan skor tidak kurang dari batas skor minimum.
    if (skor < batasSkorMinimum) {
      skor = batasSkorMinimum;
    }
  }
  int? userScore = await databaseUser.getScoreByName(selectedAccount);
  userScore = (userScore! + skor);
  await databaseUser.updateUserByName(selectedAccount, score: userScore);
  print('score telah diperbaharui ${userScore}');

}

// mendapatkan nilai dari waktu pengerjaan


// menghitung rata rata dari semua nilai setiap arah/jalur
// Future<String> calculateAverageScore() async {
//   List<Map<String, dynamic>> levels = await dbHelper.getGameLevels();
//   int totalScore = 0;
//   int checkedCount = 0;

//   for (var level in levels) {
//     if (level['checked'] == 1) {
//       totalScore += level['score'] as int; // Explicitly cast to int
//       checkedCount++;
//     }
//   }

//   double averageScore = checkedCount > 0 ? totalScore / checkedCount : 0;
//   String formattedAverageScore = averageScore.toStringAsFixed(2);
//   return formattedAverageScore;
// }

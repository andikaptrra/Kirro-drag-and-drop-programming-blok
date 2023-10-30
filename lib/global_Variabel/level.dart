List<Map<String, dynamic>> levelStory = [
  {
    'lv': 1,
    'lvName': 'Pengenalan',
    'isiLv': {
      'subLv': 1,
      'subStory': {
        'story1': 'Dr. Nova terbangun dalam keadaan bingung di lokasi terjatuhnya pesawat. Dia merasa tidak bisa hanya diam dan memutuskan untuk mulai menjelajahi planet ini dalam upaya untuk menemukan profesor yang hilang. Tujuannya adalah memulai perjalanan ke Sabana.',
        'story2': 'Dr. Nova melihat terdapat sebuah tebing, Dr. Nova dan Hirro pergi ke tebing tersebut untuk mengecek lokasi yang ada disana ',
        'story3': 'Dari tebing Hirro mendeteksi adanya pohon pohon tinggi yang dapat hidup di planet ini, mereka mencoba untuk mengecek tumbuhan tersebut di hutan',
        'story4': 'Saat disungai Dr. Nova dan Hirro mendengar aliran air, yang menandakan terdapatnya sungai di planet ini. mereka mencoba mencari ke sungai',
        'story5': 'Setelah melempas haus, Dr. Nova dan hirro melanjutkan perjalanan, mereka melihat hamparan padang pasir di sana, mereka mencoba untuk mengecek lokasi tersebut',
        'story6': 'seletah melakukan perjalanan seharian, kondisi fisik Dr. Nova menurun sehingga mereka memutuskan untuk kembali ke pesawat mereka jatuh.',
      },
      'time': {
        'time1': 30,
        'time2': 50,
        'time3': 50,
        'time4': 40,
        'time5': 50,
        'time6': 75,
      },
      'jawaban': {
        'jawaban1': ['W', 'A', 'W'],
        'jawaban2': ['U', 'W', 'A', 'W', 'A', 'W','W'], // Sabana -> tebing
        'jawaban3': ['U', 'W', 'A', 'W', 'A', 'W'], // Tebing -> hutan
        'jawaban4': ['U', 'W', 'A', 'W', 'W'], // hutan -> sungai
        'jawaban5': ['U', 'W', 'A', 'W', 'D', 'W' ,'A', 'W'], // Sungai ->  Gurun
        'jawaban6': ['U', 'W', 'A', 'W', 'D', 'W', 'A', 'W', 'W'], // Gurun -> Lokasi awal
      },
    },
  },
  {
    'lv': 2,
    'lvName': 'Penjelajahan Lanjutan',
    'isiLv': {
      'subLv': 1,
      'subStory': {
        'story1': 'Setelah menjelajahi planet, Dr. Nova dan Hirro, robot setia, menemukan cara untuk menggunakan kartu RFID untuk berinteraksi dengan lingkungan sekitar. Mereka siap untuk menghadapi tantangan baru. mereka pergi ke sabana',
        'story2': 'Dr. Nova melihat pegunungan yang tinggi, mereka akhirnya pergi ke gunung. untuk melihat lokasi sekitar',
        'story3': 'saat di gunung mereka melihat sebuah pesisir pantai dengan banyak hewan disana, sebelum pergi pesisir pergi ke sungai mengambil kebutuhan air minum',
        'story4': 'saat telah selesai ke sungai mereka melanjutkan ke sabana terlebih dahulu',
        'story5': 'segera ke pisir untuk mencari sumber makanan',
        'story6': 'saat melakukan perburuan, kaki Dr. Nova terkilir dan mereka harus segar kembali ke pesawat mereka yg hancur',
      },
      'time': {
        'time1': 30,
        'time2': 60,
        'time3': 50,
        'time4': 50,
        'time5': 60,
        'time6': 30,
      },
      'jawaban': {
        'jawaban1': ['M', 'L', 'M', 'G'], // Start -> sabana
        'jawaban2': ['M', 'L', 'M', 'L', 'M', 'R', 'M', 'R', 'M', 'G'], // sabaan -> gunung
        'jawaban3': ['M', 'R', 'M', 'M', 'G'], // gurun -> o
        'jawaban4': ['M', 'M', 'M', 'L', 'M', 'R', 'M', 'R', 'M', 'G'],// pesisir -> sungai
        'jawaban5': ['M', 'L', 'M', 'R', 'M', 'R','M', 'G'], 
        'jawaban6': ['M', 'L', 'M', 'L', 'M', 'M', 'G'],
      },
    },
  },
  {
    'lv': 3,
    'lvName': 'Bertahan Hidup',
    'isiLv': {
      'subLv': 1,
      'subStory': {
        'story1': 'Dr. Nova mengobati lukanya, ia tidak bisa melanjutkan perjalanan ini, Dr. Nova mengupgrade hirro menggunakan blok program. Dia merasa khawatir dan membuat hirro dapat di program dari jarak jauh. Dengan bantuan Hirro, pergi Pesisir untuk berburu hewan.Setelah perjalanan panjang, persediaan Dr. Nova mulai menipis. Dia merasa khawatir dan menyadari bahwa mereka harus segera mencari makanan. Dengan bantuan Hirro, mereka pergi ke Pesisir untuk berburu hewan.',
        'story2': 'Hirro kembali menuju gurun',
        'story3': 'Hirro pergi ke hutan untuk mencari sumber makanan herbal',
        'story4': 'Hirro lanjut perjalanan ke tebing',
        'story5': 'Hirro pergi ke sabana',
        'story6': 'Hirro pulang ke tempat titik awal',
      },
      'time': {
        'time1': 50,
        'time2': 30,
        'time3': 60,
        'time4': 40,
        'time5': 50,
        'time6': 50,
      },
      'jawaban': {
        'jawaban1': ['M', 'M', 'R', 'M', 'R', 'M'],
        'jawaban2': ['M', 'M', 'R', 'M'],
        'jawaban3': ['M', 'R', 'M', 'L', 'M', 'L', 'M', 'R', 'M'],
        'jawaban4': ['M', 'R', 'M', 'R', 'M'],
        'jawaban5': ['M', 'M', 'R', 'M', 'R', 'M'],
        'jawaban6': ['M', 'R', 'M'],
      },
    },
  },
  {
    'lv': 4,
    'lvName': 'Peningkatan Hirro',
    'isiLv': {
      'subLv': 1,
      'subStory': {
        'story1': 'karena cidera yang dialami Dr. Nova, ia membuat agar hirro dapat bergerak lebih leluasa menggunakan pemrograman kondisi dan perulangan, Dr. Nova memprogram hirro agar pergi menjelajah kembali, Hirro pergi ke Gurun',
        'story2': 'Hirro pergi ketebing, ia harus bergegas dengan mencari jalan tecepat',
        'story3': 'Hirro mengambil persediaan air ke sungai',
        'story4': 'Hirro pergi ke pesisir',
        'story5': 'saat ingin kembali hirro menemukan jalan baru dengan melihat pesawat yang rusak, hirro pergi ke pesawat',
        'story6': 'saat disana hiro berjumpa dengan professor, mereka bergegas untuk segera kembali ke tempat Dr. Nova',
      },
      'time': {
        'time1': 60,
        'time2': 50,
        'time3': 45,
        'time4': 55,
        'time5': 40,
        'time6': 55,
      },
      'jawaban': {
        'jawaban1': ['F', 'M', 'M', 'I', 'P','R', 'M', 'I', 'P', 'L', 'M', 'I', 'P', 'R', 'M'],
        'jawaban2': ['M', 'I', 'P', 'L', 'M', 'I', 'P', 'R', 'F', 'M', 'M', 'M'],
        'jawaban3': ['M', 'I', 'P', 'L', 'F', 'M', 'M', 'M'],
        'jawaban4': ['M', 'I', 'P', 'L', 'M', 'I', 'P', 'R', 'F', 'M', 'M', 'M'],
        'jawaban5': ['M', 'I', 'P', 'R','M'],
        'jawaban6': ['F', 'M', 'M', 'I', 'P', 'L', 'F', 'M', 'M'],
      },
    },
  },
  {
    'lv': 5,
    'lvName': 'Final Chapter',
    'isiLv': {
      'subLv': 1,
      'subStory': {
        'story1': 'Setelah bertemu Dr Nova. Professor membantu menyembuhkan cidera Dr. Nova, Profesor memberitahukan bahwa mereka harus bergegas keluar dari planet ini, karena gunung berapi yang sebentar lagi akan meletus, mereka harus mempersiapkan agar bisa kembali ke bumi. Profesor memberitahukan bahwa terdapat puing satelit didekat tebing, hirro harus mengambil puing tersebut untuk memperbaiki tanki bahan bakar, grapper hirro sudah diperbaiki oleh profesor. segera hirro pergi ke tebing',
        'story2': 'Segera ambil puing dari satelit yang ada disana berikan kepada professor yang berada di tempat awal',
        'story3': 'Setelah mengambil puing dari satelit Dr. Nova dan Professor membutuhkan air untuk perbekalan ambil air tersebut di sungai',
        'story4': 'Bawa air tersebut ke titik awal',
        'story5': 'Ternyata karena kebocoran tanki bahan bakar pada pesawat kosong, hirro harus mengambil bahan bakar tersebut ke pesawat professor',
        'story6': 'Setelah mengambil bahan bakar bawa bahan bakar tersebut ke professor yang berada titik awal',
      },
      'time': {
        'time1': 60,
        'time2': 60,
        'time3': 75,
        'time4': 75,
        'time5': 60,
        'time6': 60,
      },
      'jawaban': {
        'jawaban1': ['F', 'M', 'M', 'I', 'P', 'L', 'F', 'M', 'M', 'I', 'B', 'T'],
        'jawaban2': ['F', 'M', 'M', 'I', 'P', 'R', 'F', 'M', 'M', 'I', 'B', 'O'],
        'jawaban3': ['F', 'M', 'M', 'I', 'P', 'L', 'M', 'I', 'P', 'R', 'F', 'M', 'M', 'M', 'I', 'B', 'T'],
        'jawaban4': ['F', 'M', 'M', 'M', 'I', 'P', 'L', 'M', 'I', 'P', 'R', 'F', 'M', 'M', 'I', 'B', 'O'],
        'jawaban5': ['F', 'M', 'M', 'I', 'P', 'R', 'F', 'M', 'M', 'I', 'B', 'T'],
        'jawaban6': ['F', 'M', 'M', 'I', 'P', 'L', 'F', 'M', 'M', 'I', 'B', 'O'],
      },
    },
  },
];

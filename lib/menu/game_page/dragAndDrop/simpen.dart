// import 'dart:convert';
// import 'dart:math';
// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/rendering.dart';
// import 'package:kirro/utillitas/bluetooth_services.dart';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../../utillitas/popUp.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:kirro/menu/game_page/create_program.dart';
// import 'package:kirro/menu/game_page/joyPad.dart';
// import 'package:kirro/menu/game_page/dragAndDrop/dragandDrop.dart';
// import 'package:kirro/utillitas/bluetooth_services.dart';
// import 'package:kirro/widgets/button.dart';
// import 'package:kirro/utillitas/audio_background.dart';
// import 'package:kirro/utillitas/button_audio.dart';
// import 'dart:async';

// import 'package:flutter/rendering.dart';
// import 'dart:math';

// import 'package:kirro/utillitas/bluetooth_services.dart';
// import 'dart:io';

// import 'package:flutter/material.dart';
// // import 'package:flutter/src/widgets/container.dart';
// // import 'package:flutter/src/widgets/framework.dart';
// import 'dart:async';

// // import 'dart:convert';
// // For using PlatformException
// import 'package:flutter/services.dart';
// // import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:kirro/utillitas/popUp.dart';
// import 'package:ndialog/ndialog.dart';

// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart' as p;
// import 'package:kirro/utillitas/database_helper.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../utillitas/math/scorer.dart';
// // import 'package:just_audio/just_audio.dart';

// class mainPage extends StatefulWidget {
//   @override
//   _mainPageState createState() => _mainPageState();
// }

// class _mainPageState extends State<mainPage>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   DatabaseHelper dbHelper = DatabaseHelper();
//   double _backgroundPosition = 0;
//   bool _showWidget = true;
//   bool _showWidget2 = false;
//   bool changeImg = true;
//   late Stopwatch _stopwatch = Stopwatch();
//   Timer? _timer;
//   Duration _elapsedTime = Duration.zero;
//   Duration _elapsedCountDownTime = Duration(seconds: 0);
//   bool _isRunning = false;
//   String thisBackground = 'assets/background/bg5.png';
//   List bgList = [
//     'assets/background/bg1.png',
//     'assets/background/bg2.png',
//     'assets/background/bg3.png',
//     'assets/background/bg4.png',
//     'assets/background/bg5.png'
//   ];

//   // ======== Variable for joyPad
//   BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
//   // Initializing a global key, as it would help us in showing a SnackBar later
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   // Get the instance of the Bluetooth
//   FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
//   // Track the Bluetooth connection with the remote device
//   BluetoothConnection? connection;
//   // Variabel untuk menyimpan data yang diterima dari serial
//   String _receivedData = "Tidak ada data";
//   // Inisialisasi stream untuk menerima data dari serial
//   // StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;

//   String proses = 'Sending';

//   int pengulangan = 0;

//   bool pengiriman = false;

//   int? _deviceState;

//   String _messageBuffer = '';

//   bool isDisconnecting = false;
//   List textData = [];

//   String? nameDirection;

//   // To track whether the device is still connected to Bluetooth
//   bool get isConnected => connection != null && connection!.isConnected;

//   // Define some variables, which will be required later
//   List<BluetoothDevice> _devicesList = [];
//   BluetoothDevice? _device;
//   bool _connected = false;
//   bool _isButtonUnavailable = false;

//   bool? send;

//   String changePage = 'MAIN';
//   String buttonPressed = '';
//   String arrowPressed = '';
//   bool restarOnTap = false;
//   bool okOnTap = false;
//   double joystickX = 0.0;
//   double joystickY = 0.0;
//   String dataYangdiIsi = '';
//   String buttonMaju = 'W0000000000000000000';
//   String buttonMundur = 'S0000000000000000000';
//   String buttonKanan = 'D0000000000000000000';
//   String buttonKiri = 'A0000000000000000000';
//   String buttonY = 'Z0000000000000000000';
//   String buttonX = 'X0000000000000000000';
//   String buttonA = 'C0000000000000000000';
//   String buttonB = 'V0000000000000000000';
//   String diam = 'J0000000000000000000';
//   bool majuClick = false;
//   bool kiriClick = false;
//   bool kananClick = false;
//   bool mundurClick = false;
//   bool arahBebas = false;
//   String? selectedValue;

//   // Route Menu
//   String menuJoypad = 'JOYPAD';
//   String menuProgram = 'PROGRAM';
//   String menuUtama = 'MAIN';
//   String menuBluetooth = 'BLUE';
//   String menuLevel = 'LEVEL';
//   String menuContoh = 'CONTOH';
//   String menuInfo = 'INFO';

//   // Drag And Drop
//   // List<Map<String, dynamic>> dragableWidget = [];
//   List<Widget> dragableWidget = [];
//   List undoHistory = [];
//   List dataToSend = [];
//   double lokasiX = 0;
//   double lokasiY = 0;
//   List<Map<String, double>> theLastLocation = [];
//   double shadowY = 0;
//   double shadowX = 0;
//   bool bluetoothCond = false;

//   int indexData = 0;
//   String mustDataToSend = '';
//   int _inputNumber = 0;

//   @override
//   void initState() {
//     super.initState();

//     _stopwatch = Stopwatch();
//     // Panggil checkConnectionStatus setiap 1 detik
//     Timer.periodic(Duration(seconds: 1), (_) {
//       checkConnectionStatus();
//     });

//     // playSound();

//     AudioService.play();

//     _controller =
//         AnimationController(vsync: this, duration: Duration(seconds: 2));
//     _animation = Tween(begin: 0.0, end: -350.0).animate(_controller)
//       ..addListener(() {
//         setState(() {
//           _backgroundPosition = _animation.value;
//         });
//       });

//     FlutterBluetoothSerial.instance.state.then((state) {
//       setState(() {
//         _bluetoothState = state;
//       });
//     });

//     _deviceState = 0; // neutral

//     // If the bluetooth of the device is not enabled,
//     // then request permission to turn on bluetooth
//     // as the app starts up
//     // turnOffBluetooth(); // Listen for further state changes
//     FlutterBluetoothSerial.instance
//         .onStateChanged()
//         .listen((BluetoothState state) {
//       setState(() {
//         _bluetoothState = state;
//         if (_bluetoothState == BluetoothState.STATE_OFF) {
//           _isButtonUnavailable = true;
//         }
//         getPairedDevices();
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _stopwatch.stop();
//     _timer?.cancel();

//     _controller.dispose();

//     if (isConnected) {
//       isDisconnecting = true;
//       connection?.dispose();
//       var lateconnection = null;
//     }

//     super.dispose();
//   }

//   String formatDuration(Duration duration) {
//     String twoDigits(int n) {
//       if (n >= 10) return "$n";
//       return "0$n";
//     }

//     String minutes = twoDigits(duration.inMinutes.remainder(60));
//     String seconds = twoDigits(duration.inSeconds.remainder(60));
//     String mseconds = twoDigits(duration.inMicroseconds.remainder(60));

//     return "$minutes:$seconds:$mseconds";
//   }

//   void _startCountDown(int time) {
//     _elapsedCountDownTime = Duration(seconds: time);
//     _countDown();
//   }

//   void _countDown() {
//     _stopwatch.start();
//     _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
//       setState(() {
//         if (_elapsedCountDownTime.inSeconds > 0) {
//           _elapsedCountDownTime = _elapsedCountDownTime - Duration(seconds: 1);
//           print('ini timer : ${_elapsedCountDownTime.inSeconds}');
//         } else {
//           _stopwatch.stop();
//           _timer?.cancel();
//           _isRunning = false;
//           changePage = menuLevel;
//           showCustomDialog(context, "Yahh waktu habis...", "assets/images/sad.png");
//         }
//       });
//     });
//     setState(() {
//       _isRunning = true;
//     });
//   }

//   void showCustomDialog(BuildContext context, String text, String imageAsset) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           elevation: 8,
//           backgroundColor: Colors.transparent,
//           child: Container(
//             padding: EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(15),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   spreadRadius: 5,
//                   blurRadius: 7,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.asset(
//                   imageAsset,
//                   height: 100,
//                   width: 100,
//                 ),
//                 SizedBox(height: 16),
//                 Text(text),
//                 SizedBox(height: 16),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('Oke'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _startTimer() {
//     _stopwatch.start();
//     _timer = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
//       setState(() {
//         _elapsedTime = _stopwatch.elapsed;
//         print('ini timer : ${_elapsedTime}');
//       });
//     });
//     setState(() {
//       _isRunning = true;
//     });
//   }

//   void _stopTimer() {
//     _stopwatch.stop();
//     _timer?.cancel();
//     setState(() {
//       _isRunning = false;
//     });
//   }

//   void _resetTimer() {
//     _stopwatch.reset();
//     setState(() {
//       _elapsedTime = Duration.zero;
//     });
//   }

//   // void turnOffBluetooth() async {
//   //   await FlutterBluetoothSerial.instance.requestDisable();
//   // }

//   // Future<bool?> isBluetoothEnabled() async {
//   //   return await FlutterBluetoothSerial.instance.isEnabled;
//   // }

//   // // ============== Bluetooth Function
//   // Future<bool> enableBluetooth() async {
//   //   // Retrieving the current Bluetooth state
//   //   _bluetoothState = await FlutterBluetoothSerial.instance.state;

//   //   // If the bluetooth is off, then turn it on first
//   //   // and then retrieve the devices that are paired.
//   //   if (_bluetoothState == BluetoothState.STATE_OFF) {
//   //     await FlutterBluetoothSerial.instance.requestEnable();
//   //     await getPairedDevices();
//   //     bluetoothCond = true;
//   //     return true;
//   //   } else {
//   //     await getPairedDevices();
//   //   }
//   //   return false;
//   // }

//   // Future<bool> disableBluetooth() async {
//   //   _bluetoothState = await FlutterBluetoothSerial.instance.state;

//   //   // If the bluetooth is off, then turn it on first
//   //   // and then retrieve the devices that are paired.
//   //   if (_bluetoothState == BluetoothState.STATE_ON) {
//   //     await FlutterBluetoothSerial.instance.requestDisable;
//   //     await getPairedDevices();
//   //     bluetoothCond = false;
//   //     return false;
//   //   } else {
//   //     await getPairedDevices();
//   //   }
//   //   return true;
//   // }

//   // For retrieving and storing the paired devices
//   // in a list.
//   Future<void> getPairedDevices() async {
//     List<BluetoothDevice> devices = [];

//     // To get the list of paired devices
//     try {
//       devices = await _bluetooth.getBondedDevices();
//     } on PlatformException {
//       print("Error");
//     }

//     // It is an error to call [setState] unless [mounted] is true.
//     if (!mounted) {
//       return;
//     }

//     // Store the [devices] list in the [_devicesList] for accessing
//     // the list outside this class
//     setState(() {
//       _devicesList = devices;
//     });
//   }

//   bool isSwitched = false;
//   bool isLoading = false;

//   // Define some variables, which will be required later
//   Color bgColor = Color.fromARGB(255, 214, 211, 211);

//   Future<void> sendDataJoyPad(String data) async {
//     if (_connected) {
//       print('data terkirim ${data}');
//       _sendMessageString(data);
//     } else {
//       print('belum tersambung');
//     }
//   }

//   Future<void> sendDataProgram(String cond) async {
//     showLoadingDialog(context);
//     if (cond == 'contoh') {
//       List dataReady = dataToSend;
//       bool containsG = dataReady.contains('G');
//       !containsG ? dataReady.add('G') : null;

//       if (dataReady.length <= 19) {
//         int maxInd = 19 - dataReady.length;
//         for (var i = 0; i < maxInd; i++) {
//           dataReady.add('X');
//         }
//       }

//       dataReady.add('G');

//       // MULAU PROSES PENGGABUNGAN LIST DAN MENGIRIM DATA
//       String _puzzleSend = dataReady.join();
//       print('ini data yang di kirim : ${_puzzleSend}');
//       // menggunakan String

//       _sendMessageString(_puzzleSend);

//       print('ini data panjang : ${dataReady.length}');
//       dataReady.removeWhere((element) => element == 'G');
//       dataReady.removeWhere((element) => element == 'X');
//       print('ini data ready dari page bluetooth dikembalikan : ${dataReady}');

//       Timer(Duration(seconds: 2), () {
//         hideLoadingDialog(context);
//         dataToSend.clear();
//         dragableWidget.clear();
//         setState(() {});
//       });
//     } else {
//       if (dataToSend[0] == 'B') {
//         _sendMessageString('${dataToSend[0]}');
//         dataToSend.clear();
//         Timer(Duration(seconds: 2), () {
//           hideLoadingDialog(context);
//         });
//       } else {
//         List dataReady = dataToSend;
//         bool containsG = dataReady.contains('G');
//         !containsG ? dataReady.add('G') : null;

//         if (dataReady.length <= 19) {
//           int maxInd = 19 - dataReady.length;
//           for (var i = 0; i < maxInd; i++) {
//             dataReady.add('X');
//           }
//         }

//         dataReady.add('G');

//         // MULAU PROSES PENGGABUNGAN LIST DAN MENGIRIM DATA
//         String _puzzleSend = dataReady.join();
//         print('ini data yang di kirim : ${_puzzleSend}');
//         // menggunakan String

//         _sendMessageString(_puzzleSend);

//         // menggunakan Hex
//         // _sendMessageHex(_puzzleSend);

//         // for (var data in dataReady) {
//         // await Future.delayed(Duration(milliseconds: 500), () {
//         // _sendMessageHex(data);
//         // });
//         // }
//         // MENGIRIM KODE GOGO
//         // _sendMessageString('G');
//         // _sendMessageHex('G');
//         // hideLoadingDialog(context);
//         print('ini data panjang : ${dataReady.length}');
//         dataReady.removeWhere((element) => element == 'G');
//         dataReady.removeWhere((element) => element == 'X');
//         print('ini data ready dari page bluetooth dikembalikan : ${dataReady}');

//         Timer(Duration(seconds: 2), () {
//           hideLoadingDialog(context);
//         });
//       }
//     }
//   }

//   void showLoadingDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible:
//           false, // Prevent dismissing the dialog by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Mengirim Ke Hirro...'),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void showConnectDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible:
//           false, // Prevent dismissing the dialog by tapping outside
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 16),
//               Text('Menyambungkan dengan Hirro...'),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void hideLoadingDialog(BuildContext context) {
//     Navigator.of(context).pop();
//   }

//   DateTime? currentBackPressTime;

//   Future<bool> _onWillPop() async {
//     DateTime now = DateTime.now();

//     // Jika waktu terakhir tombol "back" ditekan belum ada atau sudah lebih dari 2 detik yang lalu,
//     // simpan waktu sekarang sebagai waktu terakhir dan beri notifikasi bahwa aplikasi tidak akan keluar
//     if (currentBackPressTime == null ||
//         now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
//       currentBackPressTime = now;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Tekan tombol back lagi untuk keluar.'),
//         ),
//       );
//       return false;
//     }

//     // Jika waktu terakhir tombol "back" ditekan adalah dalam rentang 2 detik,
//     // maka izinkan aplikasi untuk keluar
//     return true;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final wdLayer = MediaQuery.of(context).size.width;
//     final backgroundWidth = wdLayer * 2;
//     final hgLayer = MediaQuery.of(context).size.height;

//     if (changeImg == true) {
//       Random random = Random();

//       int randomNumber = random.nextInt(5);

//       thisBackground = bgList[randomNumber];
//       changeImg = false;
//     }
//     Widget InfoMenu() {
//       return Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color.fromARGB(255, 223, 58, 47),
//               Color.fromARGB(255, 247, 184, 89)
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(height: 20),
//             Row(
//               children: [
//                 IconButton(
//                     onPressed: () {
//                       changePage = menuUtama;
//                       setState(() {});
//                     },
//                     icon: Icon(Icons.arrow_back_ios_new_rounded,
//                         color: Colors.white)),
//                 SizedBox(width: 20),
//                 Text('INFO PEMAIN',
//                     style: TextStyle(
//                         fontSize: 26,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white))
//               ],
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             Text('Hallo', style: TextStyle(fontSize: 16, color: Colors.white)),
//             Text('Berikut adalah nilai kamu',
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white)),
//             SizedBox(
//               height: 50,
//             ),
//             Container(
//               width: 150,
//               height: 150,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 gradient: LinearGradient(
//                   colors: [Colors.red, Colors.orange],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       'Score',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.white,
//                       ),
//                     ),
//                     FutureBuilder<String>(
//                       future: calculateAverageScore(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           return Text(
//                             snapshot.data!,
//                             style: TextStyle(
//                               fontSize: 34,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           );
//                         } else if (snapshot.hasError) {
//                           return Text('Error');
//                         } else {
//                           return CircularProgressIndicator();
//                         }
//                       },
//                     ),
//                     FutureBuilder<String>(
//                       future: calculateAverageScore(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           final averageScore = double.tryParse(snapshot.data!);
//                           if (averageScore != null) {
//                             final intelligenceLevel =
//                                 determineIntelligenceLevel(
//                                     averageScore.toInt());
//                             return Text(
//                               intelligenceLevel,
//                               style: TextStyle(
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             );
//                           } else {
//                             return Text('Invalid score');
//                           }
//                         } else if (snapshot.hasError) {
//                           return Text('Error');
//                         } else {
//                           return CircularProgressIndicator();
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 35, right: 35),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Rute',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Colors.white),
//                   ),
//                   Text(
//                     'Score',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: Colors.white),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//                 child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: dbHelper.getGameLevels(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   List<Map<String, dynamic>> levels = snapshot.data!;
//                   return ListView.builder(
//                     itemCount: levels.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       Map<String, dynamic> level = levels[index];
//                       return ListTile(
//                         title: Padding(
//                             padding: const EdgeInsets.only(bottom: 8),
//                             child: levels[index]['checked'] == 1
//                                 ? Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(30.0),
//                                       gradient: LinearGradient(
//                                         colors: [
//                                           Color(0xFFFF4E50),
//                                           Color(0xFFF9D423)
//                                         ],
//                                         begin: Alignment.topLeft,
//                                         end: Alignment.bottomRight,
//                                       ),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.white.withOpacity(0.2),
//                                           offset: Offset(-6.0, -6.0),
//                                           blurRadius: 16.0,
//                                         ),
//                                         BoxShadow(
//                                           color: Colors.black.withOpacity(0.3),
//                                           offset: Offset(6.0, 6.0),
//                                           blurRadius: 16.0,
//                                         ),
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.1),
//                                           offset: Offset(-6.0, 6.0),
//                                           blurRadius: 16.0,
//                                         ),
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.1),
//                                           offset: Offset(6.0, -6.0),
//                                           blurRadius: 16.0,
//                                         ),
//                                       ],
//                                       border: Border.all(
//                                         color: Colors.grey.shade400,
//                                         width: 2.0,
//                                       ),
//                                     ),
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(15.0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             levels[index]['arah'],
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 16,
//                                               color: Colors.white,
//                                             ),
//                                           ),
//                                           Column(
//                                             children: [
//                                               Text(
//                                                 levels[index]['score']
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 16,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 levels[index]['time']
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: 16,
//                                                   color: Colors.white,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                 : Container()),
//                       );
//                     },
//                   );
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else {
//                   return Container(
//                       child: Center(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         CircularProgressIndicator(
//                           color: Colors.white,
//                         ),
//                         Text('Loading...',
//                             style:
//                                 TextStyle(fontSize: 16, color: Colors.white)),
//                       ],
//                     ),
//                   ));
//                 }
//               },
//             )),
//           ],
//         ),
//       );
//     }

//     Widget DragAndDropWidget() {
//       return Stack(
//         children: [
//           Column(
//             children: [
//               SizedBox(
//                 height: hgLayer * 0.06,
//               ),
//               Container(
//                 height: 200,
//                 alignment: Alignment.bottomCenter,
//                 color: Colors.red,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 20),
//                   child: Column(
//                     children: [
//                       Center(
//                         child: Text(
//                           'BLOK KODE',
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black),
//                         ),
//                       ),
//                       Container(
//                         height: hgLayer * 0.12,
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   SizedBox(width: 8),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 25),
//                                     child: blocksMotion('kanan'),
//                                   ),
//                                   SizedBox(width: 8),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 25),
//                                     child: blocksMotion('kiri'),
//                                   ),
//                                   SizedBox(width: 8),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 25),
//                                     child: blocksMotion('lurus'),
//                                   ),
//                                   SizedBox(width: 8),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           LayoutBuilder(builder: (context, constraints) {
//             lokasiX = constraints.biggest.width / 2 - 50;
//             lokasiY = constraints.biggest.height / 2 - 50;

//             return Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height * 0.78,
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: Offset(0, -3), // Mengatur offset bayangan ke atas
//                     ),
//                   ],
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(25.0),
//                     topRight: Radius.circular(25.0),
//                   ),
//                   image: DecorationImage(
//                     image: AssetImage('assets/background/bgGame.jpg'),
//                     fit: BoxFit.cover,
//                     colorFilter: ColorFilter.mode(
//                       Colors.black.withOpacity(0.05),
//                       BlendMode.darken, // Mengatur tingkat kegelapan gambar
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//           shadowX != 0 && shadowY != 0
//               ? shadowBlock(shadowY, shadowX)
//               : Container(),
//           ...dragableWidget,
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20, left: 5),
//             child: Align(
//               alignment: Alignment.bottomLeft,
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       Icons.info_outline_rounded,
//                       size: 50,
//                       color: Colors.white,
//                     ),
//                     onPressed: () {
//                       print('ini data thelastlocation ${theLastLocation}');
//                       print('ini data dragablewidget ${dragableWidget}');
//                       showDialog(
//                         context: context,
//                         builder: (BuildContext context) {
//                           return PopupDialog(
//                             message:
//                                 'Pindahkan Blok Kode ke Dalam Lembar Eksekusi',
//                             txtButton: 'OKE',
//                           );
//                         },
//                       );
//                     },
//                   ),
//                   arahBebas == false
//                       ? Padding(
//                           padding: const EdgeInsets.only(left: 30),
//                           child: Row(
//                             children: [
//                               Text('Waktu : ',
//                                   style: TextStyle(
//                                       fontSize: 16, color: Colors.white)),
//                               Text(
//                                 _elapsedTime != null
//                                     ? formatDuration(_elapsedCountDownTime)
//                                     : '00:00:00',
//                                 style: TextStyle(
//                                     fontSize: 16, color: Colors.white),
//                               ),
//                             ],
//                           ),
//                         )
//                       : Container()
//                 ],
//               ),
//             ),
//           ),
//           dragableWidget.isNotEmpty && theLastLocation.isNotEmpty
//               ? Padding(
//                   padding: const EdgeInsets.only(right: 5, bottom: 15),
//                   child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         RawMaterialButton(
//                           onPressed: () {
//                             if (dragableWidget.isNotEmpty &&
//                                 theLastLocation.isNotEmpty &&
//                                 dataToSend.isNotEmpty &&
//                                 undoHistory.isNotEmpty) {
//                               if (undoHistory.last == 'bawah') {
//                                 dataToSend.removeLast();
//                               } else if (undoHistory.last == 'atas') {
//                                 dataToSend.removeAt(0);
//                               }
//                               dragableWidget.removeLast();
//                               theLastLocation.removeLast();
//                               undoHistory.removeLast();
//                             }
//                             setState(() {});
//                           },
//                           shape: CircleBorder(),
//                           padding: EdgeInsets.all(16.0),
//                           elevation: 2.0,
//                           fillColor: Colors.blue,
//                           child: Icon(
//                             Icons.undo_outlined,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         RawMaterialButton(
//                           onPressed: () async {
//                             if (arahBebas == false) {
//                               _stopTimer();
//                               int formattedDuration = _elapsedTime.inSeconds;
//                               // Dalam Detik
//                               print(
//                                   'waktu debug : waktu akhir ${formattedDuration} detik');

//                               //============

//                               dbHelper.printGameLevels();
//                               print(
//                                   'data to send dari yang semestinya ${mustDataToSend}');
//                               print('data to send dari program ${dataToSend}');
//                               if (mustDataToSend.toString() ==
//                                   dataToSend.toString()) {
//                                 List<Map<String, dynamic>> levels =
//                                     await getGameLevels();
//                                 show('selamat level selanjutnya telah terbuka');

//                                 print('debug android ${indexData}');

//                                 dbHelper.updateTimer(
//                                     indexData, formatDuration(_elapsedTime));
//                                 // Memasukan data Score
//                                 switch (indexData) {
//                                   case 1: // Rumah sakit
//                                     dbHelper.updateScoreStatus(indexData,
//                                         calculateScore(formattedDuration, 6));
//                                     break;
//                                   case 2: // Sekolah
//                                     dbHelper.updateScoreStatus(indexData,
//                                         calculateScore(formattedDuration, 6));
//                                     break;
//                                   case 3: // Musium
//                                     dbHelper.updateScoreStatus(indexData,
//                                         calculateScore(formattedDuration, 10));
//                                     break;
//                                   case 4: // Teater
//                                     dbHelper.updateScoreStatus(indexData,
//                                         calculateScore(formattedDuration, 10));
//                                     break;
//                                   case 5: // Supermarket
//                                     dbHelper.updateScoreStatus(indexData,
//                                         calculateScore(formattedDuration, 15));
//                                     break;
//                                   case 6: // Kantor Pos
//                                     dbHelper.updateScoreStatus(indexData,
//                                         calculateScore(formattedDuration, 15));
//                                     break;
//                                   case 7: // Bank
//                                     dbHelper.updateScoreStatus(indexData,
//                                         calculateScore(formattedDuration, 16));
//                                     break;
//                                   case 8: // Bandara
//                                     dbHelper.updateScoreStatus(indexData,
//                                         calculateScore(formattedDuration, 16));
//                                     break;
//                                   default:
//                                 }
//                                 dbHelper.updateCheckedStatus(indexData, true);
//                               } else {
//                                 show(
//                                     'yahh arah yang anda berikan kurang benar :(');
//                               }
//                             }
//                             //======= Timer dan penilaian

//                             sendDataProgram('');
//                             if (_connected) {}
//                           },
//                           shape: CircleBorder(),
//                           padding: EdgeInsets.all(16.0),
//                           elevation: 2.0,
//                           fillColor: Colors.green,
//                           child: Icon(
//                             Icons.send,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : Container(),
//           Container(
//             height: hgLayer * 0.08,
//             width: wdLayer,
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: Offset(0, 3), // Mengatur offset bayangan ke bawah
//                 ),
//               ],
//               color: Color.fromARGB(255, 185, 97, 89),
//               borderRadius: BorderRadius.only(
//                 bottomRight: Radius.circular(25.0),
//                 bottomLeft: Radius.circular(25.0),
//               ),
//             ),
//             child: Row(
//               // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(
//                     onPressed: () {
//                       changePage = menuLevel;
//                       mustDataToSend = '';
//                       dragableWidget.clear();
//                       theLastLocation.clear();
//                       dataToSend.clear();
//                       indexData = 0;
//                       _stopTimer();
//                       _resetTimer();
//                       arahBebas = false;
//                       setState(() {});
//                     },
//                     icon: Icon(Icons.arrow_back_ios_new_rounded,
//                         color: Colors.white)),
//                 SizedBox(
//                   width: 20,
//                 ),
//                 Text(
//                   'PROGRAM DRAG AND DROP',
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//               ],
//             ),
//           )
//         ],
//       );
//     }

//     Widget ContohDragAndDropWidget() {
//       return Stack(
//         children: [
//           Column(
//             children: [
//               SizedBox(
//                 height: hgLayer * 0.06,
//               ),
//               Container(
//                 height: 200,
//                 alignment: Alignment.bottomCenter,
//                 color: Colors.red,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 20),
//                   child: Column(
//                     children: [
//                       Center(
//                         child: Text(
//                           'BLOK KODE',
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black),
//                         ),
//                       ),
//                       Container(
//                         height: hgLayer * 0.14,
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   SizedBox(width: 8),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 25),
//                                     child: blocksMotionFor('kanan'),
//                                   ),
//                                   SizedBox(width: 8),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 25),
//                                     child: blocksMotionFor('kiri'),
//                                   ),
//                                   SizedBox(width: 8),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 25),
//                                     child: blocksMotionFor('lurus'),
//                                   ),
//                                   SizedBox(width: 8),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           LayoutBuilder(builder: (context, constraints) {
//             lokasiX = constraints.biggest.width / 2 - 50;
//             lokasiY = constraints.biggest.height / 2 - 50;

//             return Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height * 0.78,
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: Offset(0, -3), // Mengatur offset bayangan ke atas
//                     ),
//                   ],
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(25.0),
//                     topRight: Radius.circular(25.0),
//                   ),
//                   image: DecorationImage(
//                     image: AssetImage('assets/background/bgGame.jpg'),
//                     fit: BoxFit.cover,
//                     colorFilter: ColorFilter.mode(
//                       Colors.black.withOpacity(0.05),
//                       BlendMode.darken, // Mengatur tingkat kegelapan gambar
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),

//           shadowX != 0 && shadowY != 0
//               ? shadowBlock(shadowY, shadowX + 20)
//               : Container(),
//           Center(
//             child: Container(
//               child: Stack(
//                 children: [
//                   Image.asset(
//                     'assets/images/base.png',
//                     scale: 1,
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(left: wdLayer * 0.25),
//                     child: Container(
//                         width: wdLayer * 0.5,
//                         child: Row(
//                           children: [
//                             Text(
//                               _inputNumber.toString(),
//                               style: TextStyle(
//                                   fontSize: 20, fontWeight: FontWeight.bold),
//                             ),
//                             SizedBox(
//                               width: 30,
//                             ),
//                             Container(
//                               width: 40,
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // Aksi ketika tombol diklik
//                                   if (_inputNumber <= 24) {
//                                     _inputNumber++;
//                                   }
//                                   setState(() {});
//                                   print(_inputNumber);
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   primary: Colors
//                                       .green, // Ubah warna latar belakang tombol menjadi hijau
//                                 ),
//                                 child: Text(
//                                   '\u002B', // Karakter Unicode untuk simbol plus
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                     color: Colors
//                                         .white, // Ubah warna teks menjadi putih
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Container(
//                               width: 40,
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   // Aksi ketika tombol diklik
//                                   if (_inputNumber >= 1) {
//                                     _inputNumber--;
//                                   }
//                                   setState(() {});
//                                   print(_inputNumber);
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   primary: Colors
//                                       .green, // Ubah warna latar belakang tombol menjadi hijau
//                                 ),
//                                 child: Text(
//                                   '\u2212', // Karakter Unicode untuk simbol minus
//                                   style: TextStyle(fontSize: 16.0),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )),
//                   )
//                 ],
//               ),
//             ),
//           ),

//           ...dragableWidget,
//           // RawMaterialButton(
//           //   onPressed: () {
//           //     print('ini data yang akan di kirim  :  ${dataToSend}');
//           //   },
//           //   shape: CircleBorder(),
//           //   padding: EdgeInsets.all(16.0),
//           //   elevation: 2.0,
//           //   fillColor: Colors.green,
//           //   child: Icon(
//           //     Icons.check,
//           //     color: Colors.white,
//           //   ),
//           // ),
//           Padding(
//             padding: const EdgeInsets.only(bottom: 20, left: 5),
//             child: Align(
//               alignment: Alignment.bottomLeft,
//               child: IconButton(
//                 icon: Icon(
//                   Icons.info_outline_rounded,
//                   size: 50,
//                   color: Colors.white,
//                 ),
//                 onPressed: () {
//                   print('ini data thelastlocation ${theLastLocation}');
//                   print('ini data dragablewidget ${dragableWidget}');
//                   showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       String _message = '';
//                       if (_inputNumber == '0') {
//                         _message = 'Atur Banyaknya Perulangan';
//                       } else if (dragableWidget.isEmpty) {
//                         _message =
//                             'Pindahkan Blok Kode ke Dalam Blok Perulangan';
//                       }
//                       print(_message);
//                       print(_inputNumber);

//                       return PopupDialog(
//                         message: _message,
//                         txtButton: 'OKE',
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//           dragableWidget.isNotEmpty
//               ? Padding(
//                   padding: const EdgeInsets.only(right: 5, bottom: 15),
//                   child: Align(
//                     alignment: Alignment.bottomRight,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         RawMaterialButton(
//                           onPressed: () {
//                             if (dragableWidget.isNotEmpty &&
//                                 dataToSend.isNotEmpty) {
//                               dragableWidget.clear();
//                               dataToSend.clear();
//                             }
//                             setState(() {});
//                           },
//                           shape: CircleBorder(),
//                           padding: EdgeInsets.all(16.0),
//                           elevation: 2.0,
//                           fillColor: Colors.blue,
//                           child: Icon(
//                             Icons.undo_outlined,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         dragableWidget.isNotEmpty && _inputNumber != 0
//                             ? RawMaterialButton(
//                                 onPressed: () {
//                                   List<dynamic> copyDataToSend = [];
//                                   if (dataToSend.isNotEmpty) {
//                                     copyDataToSend = [dataToSend[0]];
//                                     if (_inputNumber > 1) {
//                                       for (var i = 0;
//                                           i < _inputNumber - 1;
//                                           i++) {
//                                         dataToSend.add(copyDataToSend[0]);
//                                       }
//                                     }
//                                   }
//                                   print('ini copy data ${dataToSend}');
//                                   sendDataProgram('contoh');
//                                   print(
//                                       'ini banyaknya perulangan : ${_inputNumber}');
//                                   //    showDialog(
//                                   //   context: context,
//                                   //   builder: (BuildContext context) {
//                                   //     return AlertDialog(
//                                   //       title: Text('Apakah data ingin di kirim?'),
//                                   //       actions: [
//                                   //         TextButton(
//                                   //           onPressed: () {
//                                   //             Navigator.pop(context);
//                                   //           },
//                                   //           child: Text('YES'),
//                                   //         ),
//                                   //         TextButton(
//                                   //           onPressed: () {
//                                   //             Navigator.pop(context);
//                                   //           },
//                                   //           child: Text('NO'),
//                                   //         ),
//                                   //       ],
//                                   //     );
//                                   //   },
//                                   // );
//                                   if (_connected) {}
//                                 },
//                                 shape: CircleBorder(),
//                                 padding: EdgeInsets.all(16.0),
//                                 elevation: 2.0,
//                                 fillColor: Colors.green,
//                                 child: Icon(
//                                   Icons.send,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : Container()
//                       ],
//                     ),
//                   ),
//                 )
//               : Container(),

//           Container(
//             height: hgLayer * 0.08,
//             width: wdLayer,
//             decoration: BoxDecoration(
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: Offset(0, 3), // Mengatur offset bayangan ke bawah
//                 ),
//               ],
//               color: Color.fromARGB(255, 185, 97, 89),
//               borderRadius: BorderRadius.only(
//                 bottomRight: Radius.circular(25.0),
//                 bottomLeft: Radius.circular(25.0),
//               ),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                     onPressed: () {
//                       changePage = menuUtama;
//                       _inputNumber = 0;
//                       mustDataToSend = '';
//                       dragableWidget.clear();
//                       theLastLocation.clear();
//                       dataToSend.clear();
//                       setState(() {});
//                     },
//                     icon: Icon(Icons.arrow_back_ios_new_rounded,
//                         color: Colors.white)),
//                 Text(
//                   'PROGRAM DRAG AND DROP PERULANGAN',
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//               ],
//             ),
//           )
//         ],
//       );
//     }

//     Widget BluetoothConnectWidget() {
//       return Padding(
//         padding: const EdgeInsets.only(left: 8, right: 8, bottom: 30, top: 20),
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(30.0),
//             gradient: LinearGradient(
//               colors: [Color(0xFFFF4E50), Color(0xFFF9D423)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.white.withOpacity(0.2),
//                 offset: Offset(-6.0, -6.0),
//                 blurRadius: 16.0,
//               ),
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.3),
//                 offset: Offset(6.0, 6.0),
//                 blurRadius: 16.0,
//               ),
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 offset: Offset(-6.0, 6.0),
//                 blurRadius: 16.0,
//               ),
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.1),
//                 offset: Offset(6.0, -6.0),
//                 blurRadius: 16.0,
//               ),
//             ],
//             border: Border.all(
//               color: Colors.grey.shade400,
//               width: 2.0,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(4.0),
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Align(
//                       alignment: Alignment.centerLeft,
//                       child: Container(
//                           decoration: BoxDecoration(
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.2),
//                                   offset: Offset(2.0, 2.0),
//                                   blurRadius: 1.0,
//                                 ),
//                               ],
//                               borderRadius: BorderRadius.circular(25),
//                               color: _bluetoothState.isEnabled
//                                   ? Colors.blue
//                                   : Colors.orange),
//                           child: IconButton(
//                               onPressed: () {
//                                 future() async {
//                                   // async lambda seems to not working
//                                   if (_bluetoothState.isEnabled) {
//                                     await _bluetooth.requestDisable();
//                                   } else {
//                                     await _bluetooth.requestEnable();
//                                   }
//                                   setState(() {});
//                                 }

//                                 future().then((_) {
//                                   setState(() {});
//                                 });
//                               },
//                               icon: Icon(
//                                   _bluetoothState.isEnabled
//                                       ? Icons.bluetooth_disabled_rounded
//                                       : Icons.bluetooth_connected_rounded,
//                                   color: Colors.white)))),
//                   Align(
//                     alignment: Alignment.center,
//                     child: DropdownButton(
//                       underline: SizedBox(),
//                       items: _getDeviceItems(),
//                       onChanged: (value) => setState(() => _device = value!),
//                       value: _devicesList.isNotEmpty ? _device : null,
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.blue,
//                         elevation: 2,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                       ),
//                       onPressed: _device == null || !_bluetoothState.isEnabled
//                           ? null
//                           : _connected
//                               ? _disconnect
//                               : _connect,
//                       child: Text(_connected ? 'Putuskan' : 'Sambungkan'),
//                     ),
//                   ),
//                 ]),
//           ),
//         ),
//       );
//     }

//     Widget JoyPadWidget() {
//       return WillPopScope(
//         onWillPop: () async => false,
//         child: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/background/bgGameJoy.jpg'),
//               fit: BoxFit.fill,
//             ),
//           ),
//           child: Stack(
//             children: [
//               Center(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 200,
//                       width: 200,
//                       child: Stack(
//                         children: [
//                           Align(
//                               alignment: Alignment.bottomCenter,
//                               child: GestureDetector(
//                                 onTapDown: (_) {
//                                   print(
//                                       'ini data yang di kirim : ${buttonKanan}');
//                                   sendDataJoyPad(buttonKanan);
//                                   setState(() {
//                                     kiriClick = true;
//                                     arrowPressed = 'KANAN';
//                                     // buttonKanan == null
//                                     //     ? changePage = menuProgram
//                                     //     : null;
//                                   });
//                                   // print(arrowPressed);
//                                   // if (buttonKanan != null) {
//                                   //   sendDataJoyPad('D');
//                                   //   print('tombol D');
//                                   // }
//                                 },
//                                 onTapUp: (_) {
//                                   setState(() {
//                                     arrowPressed = '';
//                                   });
//                                   kiriClick = false;
//                                   print(arrowPressed);
//                                   sendDataJoyPad(diam);
//                                   print('ini data yang di kirim : ${diam}');
//                                 },
//                                 child: AnimatedContainer(
//                                   duration: Duration(milliseconds: 100),
//                                   child: Container(
//                                       height: 90,
//                                       child: Image.asset(arrowPressed == 'KANAN'
//                                           ? 'assets/images/arrow.png'
//                                           : 'assets/images/arrowOnClick.png')),
//                                 ),
//                               )),
//                           Align(
//                               alignment: Alignment.topCenter,
//                               child: Transform.rotate(
//                                 angle: 180 * 0.0174533,
//                                 child: GestureDetector(
//                                   onTapDown: (_) {
//                                     setState(() {
//                                       print(
//                                           'ini data yang di kirim : ${buttonKiri}');
//                                       sendDataJoyPad(buttonKiri);
//                                       kananClick = true;
//                                       arrowPressed = 'KIRI';
//                                       // buttonKiri == null
//                                       //     ? changePage = menuProgram
//                                       //     : null;
//                                     });
//                                     // print(arrowPressed);
//                                     // if (buttonKiri != null) {
//                                     //   sendDataJoyPad('A');
//                                     //   print('tombol A');
//                                     // }
//                                   },
//                                   onTapUp: (_) {
//                                     setState(() {
//                                       arrowPressed = '';
//                                     });
//                                     kananClick = false;
//                                     print(arrowPressed);
//                                     sendDataJoyPad(diam);
//                                     print('ini data yang di kirim : ${diam}');
//                                   },
//                                   child: Container(
//                                       height: 90,
//                                       child: Image.asset(arrowPressed == 'KIRI'
//                                           ? 'assets/images/arrow.png'
//                                           : 'assets/images/arrowOnClick.png')),
//                                 ),
//                               )),
//                           Align(
//                               alignment: Alignment.centerRight,
//                               child: Transform.rotate(
//                                 angle: 270 * 0.0174533,
//                                 child: GestureDetector(
//                                   onTapDown: (_) {
//                                     print(
//                                         'ini data yang di kirim : ${buttonMaju}');
//                                     sendDataJoyPad(buttonMaju);
//                                     // buttonMaju != null;
//                                     setState(() {
//                                       majuClick = true;
//                                       arrowPressed = 'MAJU';
//                                       // buttonMaju == null
//                                       //     ? changePage = menuProgram
//                                       //     : null;
//                                     });
//                                     // print(arrowPressed);
//                                     // if (buttonMaju != null) {
//                                     //   sendDataJoyPad('W');
//                                     //   print('tombol W');
//                                     // }
//                                   },
//                                   onTapUp: (_) {
//                                     setState(() {
//                                       arrowPressed = '';
//                                     });
//                                     majuClick = false;
//                                     print(arrowPressed);
//                                     sendDataJoyPad(diam);
//                                     print('ini data yang di kirim : ${diam}');
//                                   },
//                                   child: Container(
//                                       height: 90,
//                                       child: Image.asset(arrowPressed == 'MAJU'
//                                           ? 'assets/images/arrow.png'
//                                           : 'assets/images/arrowOnClick.png')),
//                                 ),
//                               )),
//                           Align(
//                               alignment: Alignment.centerLeft,
//                               child: Transform.rotate(
//                                 angle: 90 * 0.0174533,
//                                 child: GestureDetector(
//                                   onTapDown: (_) {
//                                     print(
//                                         'ini data yang di kirim : ${buttonMundur}');
//                                     sendDataJoyPad(buttonMundur);
//                                     // buttonMaju != null;
//                                     setState(() {
//                                       majuClick = true;
//                                       arrowPressed = 'MUNDUR';
//                                       // buttonMundur == null
//                                       //     ? changePage = menuProgram
//                                       //     : null;
//                                     });
//                                     // print(arrowPressed);
//                                     // if (buttonMundur != null) {
//                                     //   sendDataJoyPad('S');
//                                     //   print('tombol S');
//                                     // }
//                                   },
//                                   onTapUp: (_) {
//                                     setState(() {
//                                       arrowPressed = '';
//                                     });
//                                     majuClick = false;
//                                     print(arrowPressed);
//                                     sendDataJoyPad(diam);
//                                     print('ini data yang di kirim : ${diam}');
//                                   },
//                                   child: Container(
//                                       height: 90,
//                                       child: Image.asset(arrowPressed ==
//                                               'MUNDUR'
//                                           ? 'assets/images/arrow.png'
//                                           : 'assets/images/arrowOnClick.png')),
//                                 ),
//                               ))
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 150),
//                     Container(
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               // BUTTON A
//                               Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: GestureDetector(
//                                   onTapDown: (_) {
//                                     setState(() {
//                                       buttonPressed = 'A';
//                                       sendDataJoyPad(buttonA);
//                                       print(buttonPressed);
//                                     });
//                                   },
//                                   onTapUp: (_) {
//                                     setState(() {
//                                       buttonPressed = '';
//                                       sendDataJoyPad(diam);
//                                       print(buttonPressed);
//                                     });
//                                   },
//                                   child: AnimatedContainer(
//                                     duration: Duration(milliseconds: 100),
//                                     width: 80,
//                                     height: 80,
//                                     decoration: BoxDecoration(
//                                       color: buttonPressed == 'A'
//                                           ? Colors.blue.withOpacity(0.8)
//                                           : Colors.blue,
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         buttonPressed == 'A'
//                                             ? BoxShadow(
//                                                 color: Colors.blue
//                                                     .withOpacity(0.8),
//                                                 offset: Offset(0, 3),
//                                                 blurRadius: 6,
//                                                 spreadRadius: 0,
//                                               )
//                                             : BoxShadow(
//                                                 color: Colors.blue
//                                                     .withOpacity(0.5),
//                                                 offset: Offset(0, 1),
//                                                 blurRadius: 3,
//                                                 spreadRadius: 0,
//                                               ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                         child: Transform(
//                                       transform: Matrix4.rotationZ(
//                                           pi / 2), // Sudut rotasi dalam radian
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         'A',
//                                         style: TextStyle(
//                                             fontSize: 24,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     )),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: 20),
//                               // BUTTON Y
//                               Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: GestureDetector(
//                                   onTapDown: (_) {
//                                     setState(() {
//                                       buttonPressed = 'Y';
//                                       print(buttonPressed);
//                                       sendDataJoyPad(buttonY);
//                                     });
//                                   },
//                                   onTapUp: (_) {
//                                     setState(() {
//                                       buttonPressed = '';
//                                       sendDataJoyPad(diam);
//                                       print(buttonPressed);
//                                     });
//                                   },
//                                   child: AnimatedContainer(
//                                     duration: Duration(milliseconds: 100),
//                                     width: 80,
//                                     height: 80,
//                                     decoration: BoxDecoration(
//                                       color: buttonPressed == 'Y'
//                                           ? Colors.green.withOpacity(0.8)
//                                           : Colors.green,
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         buttonPressed == 'Y'
//                                             ? BoxShadow(
//                                                 color: Colors.green
//                                                     .withOpacity(0.8),
//                                                 offset: Offset(0, 3),
//                                                 blurRadius: 6,
//                                                 spreadRadius: 0,
//                                               )
//                                             : BoxShadow(
//                                                 color: Colors.green
//                                                     .withOpacity(0.5),
//                                                 offset: Offset(0, 1),
//                                                 blurRadius: 3,
//                                                 spreadRadius: 0,
//                                               ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                         child: Transform(
//                                       transform: Matrix4.rotationZ(
//                                           pi / 2), // Sudut rotasi dalam radian
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         'Y',
//                                         style: TextStyle(
//                                             fontSize: 24,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     )),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: GestureDetector(
//                                   onTapDown: (_) {
//                                     setState(() {
//                                       buttonPressed = 'X';
//                                       sendDataJoyPad(buttonX);
//                                       print(buttonPressed);
//                                     });
//                                   },
//                                   onTapUp: (_) {
//                                     setState(() {
//                                       buttonPressed = '';
//                                       sendDataJoyPad(diam);
//                                       print(buttonPressed);
//                                     });
//                                   },
//                                   child: AnimatedContainer(
//                                     duration: Duration(milliseconds: 100),
//                                     width: 80,
//                                     height: 80,
//                                     decoration: BoxDecoration(
//                                       color: buttonPressed == 'X'
//                                           ? Colors.red.withOpacity(0.8)
//                                           : Colors.red,
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         buttonPressed == 'X'
//                                             ? BoxShadow(
//                                                 color:
//                                                     Colors.red.withOpacity(0.8),
//                                                 offset: Offset(0, 3),
//                                                 blurRadius: 6,
//                                                 spreadRadius: 0,
//                                               )
//                                             : BoxShadow(
//                                                 color:
//                                                     Colors.red.withOpacity(0.5),
//                                                 offset: Offset(0, 1),
//                                                 blurRadius: 3,
//                                                 spreadRadius: 0,
//                                               ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                         child: Transform(
//                                       transform: Matrix4.rotationZ(
//                                           pi / 2), // Sudut rotasi dalam radian
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         'X',
//                                         style: TextStyle(
//                                             fontSize: 24,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     )),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 30),
//                               Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: GestureDetector(
//                                   onTapDown: (_) {
//                                     setState(() {
//                                       buttonPressed = 'B';
//                                       sendDataJoyPad(buttonB);
//                                       print(buttonPressed);
//                                     });
//                                   },
//                                   onTapUp: (_) {
//                                     setState(() {
//                                       buttonPressed = '';
//                                       sendDataJoyPad(diam);
//                                       print(buttonPressed);
//                                     });
//                                   },
//                                   child: AnimatedContainer(
//                                     duration: Duration(milliseconds: 100),
//                                     width: 80,
//                                     height: 80,
//                                     decoration: BoxDecoration(
//                                       color: buttonPressed == 'B'
//                                           ? Colors.yellow.withOpacity(0.8)
//                                           : Colors.yellow,
//                                       shape: BoxShape.circle,
//                                       boxShadow: [
//                                         buttonPressed == 'B'
//                                             ? BoxShadow(
//                                                 color: Colors.yellow
//                                                     .withOpacity(0.8),
//                                                 offset: Offset(0, 3),
//                                                 blurRadius: 6,
//                                                 spreadRadius: 0,
//                                               )
//                                             : BoxShadow(
//                                                 color: Colors.yellow
//                                                     .withOpacity(0.5),
//                                                 offset: Offset(0, 1),
//                                                 blurRadius: 3,
//                                                 spreadRadius: 0,
//                                               ),
//                                       ],
//                                     ),
//                                     child: Center(
//                                         child: Transform(
//                                       transform: Matrix4.rotationZ(
//                                           pi / 2), // Sudut rotasi dalam radian
//                                       alignment: Alignment.center,
//                                       child: Text(
//                                         'B',
//                                         style: TextStyle(
//                                             fontSize: 24,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     )),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(15.0),
//                 child: Align(
//                     alignment: Alignment.topRight,
//                     child: Transform(
//                       transform: Matrix4.rotationZ(
//                           pi / 2), // Sudut rotasi dalam radian
//                       alignment: Alignment.center,
//                       child: IconButton(
//                           onPressed: () {
//                             changePage = menuUtama;
//                             setState(() {});
//                           },
//                           icon: Icon(
//                             Icons.arrow_back_ios,
//                             color: Colors.white,
//                             size: 30,
//                           )),
//                     )),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 20, bottom: 50),
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: Transform.rotate(
//                     angle: 180 * 0.0174533,
//                     child: Container(
//                       width: 50,
//                       height: 150,
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.all(Radius.circular(10)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Color.fromARGB(255, 77, 75, 75)
//                                   .withOpacity(0.9),
//                               offset: Offset(3, 0),
//                               blurRadius: 10,
//                               spreadRadius: 0,
//                             )
//                           ]),
//                       child: Transform.rotate(
//                           angle: 270 * 0.0174533,
//                           child: Center(
//                               child: Text(
//                             '${arrowPressed}',
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ))),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     Widget LevelGameWidget() {
//       return Container(
//           // Set properties for the Container
//           width: double.infinity,
//           height: hgLayer,
//           padding: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topRight,
//               end: Alignment.bottomLeft,
//               colors: [
//                 Color.fromARGB(255, 197, 40, 28),
//                 Color.fromARGB(255, 228, 171, 85)
//               ],
//             ),
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: MediaQuery.of(context).padding.top,
//               ),
//               Container(
//                 child: Row(
//                   children: [
//                     IconButton(
//                         onPressed: () {
//                           changePage = menuUtama;
//                           setState(() {});
//                         },
//                         icon: Icon(Icons.arrow_back_ios_new_rounded,
//                             color: Colors.white)),
//                     Text('Pilih Arah',
//                         style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white)),
//                   ],
//                 ),
//               ),
//               Expanded(
//                   child: FutureBuilder<List<Map<String, dynamic>>>(
//                 future: dbHelper.getGameLevels(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     List<Map<String, dynamic>> levels = snapshot.data!;
//                     return ListView.builder(
//                       itemCount: levels.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         Map<String, dynamic> level = levels[index];

//                         return ListTile(
//                           title: Padding(
//                             padding: const EdgeInsets.only(bottom: 8),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(30.0),
//                                 gradient: LinearGradient(
//                                   colors: levels[index]['arah'] == 'Arah Bebas'
//                                       ? levels[levels.length - 1]['checked'] ==
//                                               1
//                                           ? [
//                                               Color.fromARGB(255, 78, 161, 255),
//                                               Color.fromARGB(255, 35, 39, 249)
//                                             ]
//                                           : [
//                                               Color.fromARGB(255, 82, 95, 110),
//                                               Color.fromARGB(255, 39, 39, 48)
//                                             ]
//                                       : levels[index - 1]['checked'] == 1 ||
//                                               levels[index]['checked'] == 1 ||
//                                               levels[index]['arah'] ==
//                                                   'Rumah Sakit'
//                                           ? [
//                                               Color(0xFFFF4E50),
//                                               Color(0xFFF9D423)
//                                             ]
//                                           : [
//                                               Color.fromARGB(
//                                                   255, 170, 170, 170),
//                                               Color.fromARGB(255, 105, 105, 105)
//                                             ],
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.white.withOpacity(0.2),
//                                     offset: Offset(-6.0, -6.0),
//                                     blurRadius: 16.0,
//                                   ),
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.3),
//                                     offset: Offset(6.0, 6.0),
//                                     blurRadius: 16.0,
//                                   ),
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.1),
//                                     offset: Offset(-6.0, 6.0),
//                                     blurRadius: 16.0,
//                                   ),
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.1),
//                                     offset: Offset(6.0, -6.0),
//                                     blurRadius: 16.0,
//                                   ),
//                                 ],
//                                 border: Border.all(
//                                   color: Colors.grey.shade400,
//                                   width: 2.0,
//                                 ),
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(15.0),
//                                 child: Center(
//                                   child: Text(
//                                     levels[index]['arah'],
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 16,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           // Add appropriate logic or actions here
//                           onTap: () {
//                             // Action to be performed when a level is selected, such as navigating to that level
//                             bool _movePage = false;

//                             if (level['arah'] == 'Arah Bebas') {
//                               if (levels[levels.length - 1]['checked'] == 0) {
//                                 print(levels[levels.length - 1]);
//                                 show(
//                                     'Arah Bebas akan terbuka jika sudah menyelesaikan semua Tujuan');
//                               } else {
//                                 arahBebas = true;
//                                 // show('Level sudah terbuka');
//                                 _movePage =
//                                     true; // Set _movePage to true when level is already open
//                               }
//                             } else {
//                               if (level['arah'] != 'Rumah Sakit') {
//                                 if (levels[index - 1]['checked'] == 0) {
//                                   show('Selesaikan dulu level sebelumnya');
//                                 } else {
//                                   // show('Level sudah terbuka');
//                                   _movePage =
//                                       true; // Set _movePage to true when level is already open
//                                 }
//                               } else {
//                                 // show('Level sudah terbuka');
//                                 _movePage = true;
//                                 // if (gameLevels[index]['checked'] == false) {
//                                 //   show('Selesaikan dulu level sebelumnya');
//                                 // } else {
//                                 //   show('Level sudah terbuka');
//                                 //   _movePage = true; // Set _movePage to true when level is already open
//                                 // }
//                               }
//                             }

//                             if (_movePage) {
//                               mustDataToSend =
//                                   levels[index]['datatosend'].toString();
//                               changePage = menuProgram;
//                               indexData = index;
//                               setState(() {});
//                             }

//                             // if (_movePage) {
//                             //   // showDialog(
//                             //   //   context: context,
//                             //   //   builder: (BuildContext context) {
//                             //   //     return AlertDialog(
//                             //   //       title: Text('Apakah anda akan langsung mulai?'),
//                             //   //       actions: [
//                             //   //         TextButton(
//                             //   //           onPressed: () {
//                             //   //             // Tindakan saat tombol "Ya" ditekan
//                             //   //             Navigator.of(context)
//                             //   //                 .pop(true); // Mengirim nilai true

//                             //   //             dragableWidget = dragableConvert(gameLevels[index]['dragablewidget']);
//                             //   //             dataToSend = dataToSendConvert(gameLevels[index]['datatosend']);
//                             //   //             theLastLocation = theLastLocationConvert(gameLevels[index]['thelastlocation']);
//                             //   //           },
//                             //   //           child: Text('Contoh'),
//                             //   //         ),
//                             //   //         TextButton(
//                             //   //           onPressed: () {
//                             //   //             // Tindakan saat tombol "Tidak" ditekan

//                             //   //             mustDataToSend = theLastLocationConvert(gameLevels[index]['datatosend']) as String;
//                             //   //             Navigator.of(context)
//                             //   //                 .pop(false); // Mengirim nilai false
//                             //   //           },
//                             //   //           child: Text('Mulai'),
//                             //   //         ),
//                             //   //       ],
//                             //   //     );
//                             //   //   },
//                             //   // );
//                             //
//                             // }

//                             print('Selected level: ${levels[index]['arah']}');
//                           },
//                         );
//                       },
//                     );
//                   } else if (snapshot.hasError) {
//                     return Text('Error: ${snapshot.error}');
//                   } else {
//                     return Container(
//                         child: Center(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           CircularProgressIndicator(
//                             color: Colors.white,
//                           ),
//                           Text('Loading...',
//                               style:
//                                   TextStyle(fontSize: 16, color: Colors.white)),
//                         ],
//                       ),
//                     ));
//                   }
//                 },
//               )),
//             ],
//           ));
//     }

//     Widget MainMenu() {
//       return Stack(
//         children: [
//           Positioned(
//             bottom: 0,
//             left: _backgroundPosition,
//             child: Image.asset(
//               thisBackground,
//               width: backgroundWidth,
//             ),
//           ),
//           Center(
//             child: AnimatedOpacity(
//               opacity: _showWidget ? 1.0 : 0.0,
//               duration: Duration(milliseconds: 500),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/logo/logo.png',
//                     width: wdLayer * 0.8,
//                   ),
//                   SizedBox(
//                     height: 100,
//                   ),
//                   // FloatingActionButton(onPressed: () {
//                   //   print('clicked');
//                   //     setState(() {
//                   //       _showWidget = false;
//                   //     });
//                   //     _controller.forward().then((value) {
//                   //       setState(() {
//                   //         _showWidget2 = true;
//                   //       });
//                   //       _controller.forward();
//                   //     });
//                   // }),

//                   // AluminumButton(
//                   //   label: 'Play',
//                   //   onPressed: () {
//                   //     print('clicked');
//                   //     setState(() {
//                   //       _showWidget = false;
//                   //     });
//                   //     _controller.forward().then((value) {
//                   //       setState(() {
//                   //         _showWidget2 = true;
//                   //       });
//                   //       _controller.forward();
//                   //     });
//                   //   },
//                   // ),
//                 ],
//               ),
//             ),
//           ),
//           Center(
//             child: AnimatedOpacity(
//               opacity: _showWidget2 ? 1.0 : 0.0,
//               duration: Duration(milliseconds: 500),
//               child: Stack(
//                 children: [
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       BluetoothConnectWidget(),
//                       SizedBox(
//                         height: 50,
//                       ),
//                       AluminumButton(
//                         label: 'BUAT PROGRAM',
//                         onPressed: () {
//                           if (_bluetoothState.isEnabled) {
//                             if (_device == null || _connected == false) {
//                               show('sambungkan bluetooth HIRRO');
//                             } else {
//                               changePage = menuLevel;
//                               setState(() {});
//                               // showDialog(
//                               //   context: context,
//                               //   builder: (BuildContext context) {
//                               //     return AlertDialog(
//                               //       title: Text(
//                               //           'Apakah anda akan langsung mulai?'),
//                               //       actions: [
//                               //         TextButton(
//                               //           onPressed: () {
//                               //             // Tindakan saat tombol "Ya" ditekan
//                               //             changePage = menuContoh;
//                               //             setState(() {});
//                               //             Navigator.of(context)
//                               //                 .pop(true); // Mengirim nilai true
//                               //           },
//                               //           child: Text('Contoh Program'),
//                               //         ),
//                               //         TextButton(
//                               //           onPressed: () {
//                               //             // Tindakan saat tombol "Tidak" ditekan

//                               //             changePage = menuLevel;
//                               //             setState(() {});
//                               //             Navigator.of(context).pop(false);
//                               //           },
//                               //           child: Text('Mulai Main'),
//                               //         ),
//                               //       ],
//                               //     );
//                               //   },
//                               // );
//                               print(changePage);
//                               // changePage = menuJoypad;
//                               // setState(() {});
//                             }
//                           } else {
//                             show('nyalakan bluetooth');
//                           }

//                           // if (bluetoothCond) {
//                           //   if (_device == null) {
//                           //     show('sambungkan bluetooth HIRRO');
//                           //   } else {
//                           //     changePage = menuProgram;
//                           //     setState(() {});
//                           //   }
//                           // } else {
//                           //   show('nyalakan bluetooth');
//                           // }
//                         },
//                       ),
//                       SizedBox(
//                         height: 50,
//                       ),
//                       AluminumButton(
//                         label: 'JOYPAD',
//                         onPressed: () {
//                           if (_bluetoothState.isEnabled) {
//                             if (_device == null || _connected == false) {
//                               show('sambungkan bluetooth HIRRO');
//                             } else {
//                               changePage = menuJoypad;
//                               setState(() {});
//                             }
//                           } else {
//                             show('nyalakan bluetooth');
//                           }
//                         },
//                       )
//                     ],
//                   ),
//                   Align(
//                     alignment: Alignment.bottomRight,
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 60, right: 40),
//                       child: IconButton(
//                           onPressed: () {
//                             changePage = menuInfo;
//                             setState(() {});
//                           },
//                           icon: Icon(
//                             Icons.info_outline_rounded,
//                             size: 50,
//                             color: Colors.white,
//                           )),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     Future<void> openAppSettings() async {
//       if (await Permission.location.request().isGranted) {
//         // Izin lokasi telah diberikan
//         return;
//       }

//       if (await Permission.location.isPermanentlyDenied) {
//         // Izin lokasi telah ditolak secara permanen
//         // Tampilkan pesan atau tindakan yang sesuai
//         return;
//       }

//       try {
//         await openAppSettings();
//       } on PlatformException catch (e) {
//         print('Error: ${e.message}');
//       }
//     }

//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//           floatingActionButton: _showWidget2 == false
//               ? Padding(
//                   padding: const EdgeInsets.only(bottom: 250),
//                   child: AluminumButton(
//                     label: 'Play',
//                     onPressed: () {
//                       setState(() {
//                         // ButtonAudioService.playButtonSound();
//                         _showWidget = false;
//                         _showWidget2 = true;
//                         _controller.forward();
//                       });
//                     },
//                   ),
//                 )
//               : null,
//           floatingActionButtonLocation:
//               FloatingActionButtonLocation.centerFloat,
//           body: changePage == menuUtama
//               ? MainMenu()
//               : changePage == menuJoypad
//                   ? JoyPadWidget()
//                   : changePage == menuProgram
//                       ? DragAndDropWidget()
//                       : changePage == menuLevel
//                           ? LevelGameWidget()
//                           : changePage == menuContoh
//                               ? ContohDragAndDropWidget()
//                               : changePage == menuInfo
//                                   ? InfoMenu()
//                                   : Container()),
//     );
//   }

//   List<DropdownMenuItem> _getDeviceItems() {
//     List<DropdownMenuItem> items = [];
//     if (_devicesList.isEmpty) {
//       items.add(DropdownMenuItem(
//         child: Text(
//           'Tidak ada device',
//           style: TextStyle(
//               fontSize: 12,
//               color: Colors.blue[900],
//               fontWeight: FontWeight.bold),
//         ),
//       ));
//     } else {
//       _devicesList.forEach((device) {
//         items.add(DropdownMenuItem(
//           value: device,
//           child: Text(
//             '  ${device.name}',
//             style:
//                 TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
//           ),
//         ));
//       });
//     }
//     return items;
//   }

//   void checkConnectionStatus() async {
//     if (connection != null && !connection!.isConnected) {
//       setState(() {
//         _connected = false;
//       });
//     }
//   }

//   void _connect() async {
//     if (_device == null) {
//       show('No device selected');
//     } else {
//       if (!isConnected) {
//         showConnectDialog(context);
//         await BluetoothConnection.toAddress(_device?.address)
//             .then((_connection) {
//           print('Connected to the device');
//           connection = _connection;

//           setState(() {
//             _connected = true;
//           });

//           connection?.input?.listen(null).onDone(() {
//             if (isDisconnecting) {
//               print('Disconnecting locally!');
//             } else {
//               print('Disconnected remotely!');
//             }
//             if (this.mounted) {
//               setState(() {});
//             }
//           });
//         }).catchError((error) {
//           hideLoadingDialog(context);
//           print('Cannot connect, exception occurred');
//           print(error);
//           show('Cannot connect, Try again');
//         });
//         hideLoadingDialog(context);
//         show('Device connected');

//         setState(() {
//           _isButtonUnavailable = false;
//           bgColor = Colors.white;
//         });
//         dataToSend.add('B');
//         sendDataProgram('');
//       }
//     }
//   }

//   // Method to disconnect bluetooth
//   void _disconnect() async {
//     setState(() {
//       _deviceState = 0;
//       bgColor = Color.fromARGB(255, 214, 211, 211);
//     });

//     await connection?.close();
//     show('Device disconnected');

//     if (connection != null && connection!.isConnected) {
//       setState(() {
//         _device = null;
//       });
//     } else {
//       setState(() {
//         _connected = false;
//       });
//     }
//   }

//   void sendHexData(String hexData) async {
//     hexData =
//         hexData.replaceAll(' ', ''); // Remove any spaces from the hex string

//     // Check if the hex string has an odd length
//     if (hexData.length % 2 != 0) {
//       hexData = '0$hexData'; // Add a leading '0' if the length is odd
//     }

//     List<int> bytes = [];

//     for (var i = 0; i < hexData.length; i += 2) {
//       String hex = hexData.substring(
//           i, i + 2); // Extract two characters from the hex string
//       int value = int.parse(hex, radix: 16); // Parse the hex value

//       bytes.add(value); // Add the parsed value to the byte list
//     }

//     Uint8List data = Uint8List.fromList(bytes);
//     connection!.output.add(data);
//     await connection!.output.allSent;
//   }

//   void _sendMessageString(String value1) async {
//     value1 = value1.trim();
//     // print('value ${value1}');
//     if (value1.isNotEmpty) {
//       try {
//         List<int> list = value1.codeUnits;
//         Uint8List bytes = Uint8List.fromList(list);
//         print(bytes);
//         connection?.output.add(bytes);
//         await connection?.output.allSent;
//       } catch (e) {
//         setState(() {});
//       }
//     }
//   }

//   Future<List<Map<String, dynamic>>> getGameLevels() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? gameLevelsString = prefs.getString('gameLevels');

//     if (gameLevelsString != null) {
//       List<dynamic> gameLevelsJson = jsonDecode(gameLevelsString);
//       List<Map<String, dynamic>> gameLevels =
//           List<Map<String, dynamic>>.from(gameLevelsJson);
//       return gameLevels;
//     } else {
//       return [];
//     }
//   }

//   void saveData(req) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<Map<String, dynamic>> gameLevels = await getGameLevels();
//     gameLevels[1]['checked'] = true;
//     await prefs.setString('gameLevels', jsonEncode(gameLevels));
//   }

//   // Widget shadowBlock(double thisY, thisX) {
//   //   return Positioned(
//   //       left: thisX,
//   //       top: thisY,
//   //       child: Container(
//   //         decoration: BoxDecoration(
//   //             color: Color.fromARGB(71, 0, 0, 0),
//   //             borderRadius: BorderRadius.all(Radius.circular(10))),
//   //         width: 300,
//   //         height: 65,
//   //       ));
//   // }

//   // void addWidgetDragable(double yAxis, double xAxis, String condition) {
//   //   setState(() {
//   //     dragableWidget.add(
//   //       Positioned(
//   //         left: xAxis,
//   //         top: yAxis,
//   //         child: Container(
//   //           child: Stack(
//   //             children: [
//   //               Image.asset(
//   //                 condition == 'kanan'
//   //                     ? 'assets/images/Kanan.png'
//   //                     : condition == 'kiri'
//   //                         ? 'assets/images/Kiri.png'
//   //                         : condition == 'lurus'
//   //                             ? 'assets/images/maju.png'
//   //                             : condition == 'mundur'
//   //                                 ? 'assets/images/mundur.png'
//   //                                 : 'assets/images/mundur.png',
//   //                 scale: 1,
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       ),
//   //     );
//   //   });
//   // }

//   // Widget blocksMotion(String condition) {
//   //   return Draggable(
//   //     child: Container(
//   //       child: Image.asset(
//   //         condition == 'kanan'
//   //             ? 'assets/images/Kanan.png'
//   //             : condition == 'kiri'
//   //                 ? 'assets/images/Kiri.png'
//   //                 : condition == 'lurus'
//   //                     ? 'assets/images/maju.png'
//   //                     : condition == 'mundur'
//   //                         ? 'assets/images/mundur.png'
//   //                         : 'assets/images/mundur.png',
//   //         scale: 1.5,
//   //       ),
//   //     ),
//   //     feedback: Container(
//   //       color: Colors.transparent,
//   //       child: Image.asset(
//   //         condition == 'kanan'
//   //             ? 'assets/images/Kanan.png'
//   //             : condition == 'kiri'
//   //                 ? 'assets/images/Kiri.png'
//   //                 : condition == 'lurus'
//   //                     ? 'assets/images/maju.png'
//   //                     : condition == 'mundur'
//   //                         ? 'assets/images/mundur.png'
//   //                         : 'assets/images/mundur.png',
//   //         scale: 1,
//   //       ),
//   //     ),
//   //     childWhenDragging: Container(
//   //       color: Colors.transparent,
//   //       child: Image.asset(
//   //         condition == 'kanan'
//   //             ? 'assets/images/Kanan.png'
//   //             : condition == 'kiri'
//   //                 ? 'assets/images/Kiri.png'
//   //                 : condition == 'lurus'
//   //                     ? 'assets/images/maju.png'
//   //                     : condition == 'mundur'
//   //                         ? 'assets/images/mundur.png'
//   //                         : 'assets/images/mundur.png',
//   //         scale: 1,
//   //       ),
//   //     ),
//   //     onDraggableCanceled: (velocity, offset) {
//   //       RenderBox renderBox = context.findRenderObject() as RenderBox;
//   //       Offset globalOffset = renderBox.localToGlobal(offset);
//   //       double yBlokAxis = offset.dy - 55;
//   //       double xBlokAxis = offset.dx;
//   //       print('Yblok : ${yBlokAxis} xblok : ${xBlokAxis}');

//   //       double yAxis = MediaQuery.of(context).size.height / 2 - 30;
//   //       double xAxis = MediaQuery.of(context).size.width / 2 - 107.5;

//   //       double threshold = 150.0;

//   //       bool isNear = (yBlokAxis - yAxis).abs() <= threshold &&
//   //           (xBlokAxis - xAxis).abs() <= threshold;

//   //       if (isNear) {
//   //         print('Widget dekat dengan yAxis dan xAxis');
//   //         if (dragableWidget.length >= 1) {
//   //           showDialog(
//   //             context: context,
//   //             builder: (BuildContext context) {
//   //               return Transform.rotate(
//   //                 angle: 90 * 0.0174533,
//   //                 child: PopupDialog(
//   //                   message: 'Anda Tidak Bisa Menambah Blok Lagi',
//   //                   txtButton: 'OKE',
//   //                 ),
//   //               );
//   //             },
//   //           );
//   //         } else {
//   //           addWidgetDragable(yAxis, xAxis, condition);
//   //         }
//   //       } else {
//   //         print('Widget tidak dekat dengan yAxis dan xAxis');
//   //       }
//   //       shadowX = 0;
//   //       shadowY = 0;
//   //       setState(() {});
//   //     },
//   //     onDragUpdate: (dragDetails) {
//   //       print(
//   //           'Object amber dragged to X: ${dragDetails.localPosition.dx}, Y: ${dragDetails.localPosition.dy}');

//   //       shadowX = MediaQuery.of(context).size.width / 2 - 120;
//   //       shadowY = MediaQuery.of(context).size.height / 2 - 27;
//   //       setState(() {});
//   //     },
//   //   );
//   // }

//   // void updateJoystickPosition(Offset position) {
//   //   setState(() {
//   //     double radius = 100;
//   //     double dx = (position.dx - 100) / radius;
//   //     double dy = (position.dy - 100) / radius;

//   //     double distance = dx * dx + dy * dy;
//   //     if (distance > 1) {
//   //       double scale = 1 / sqrt(distance);
//   //       dx *= scale;
//   //       dy *= scale;
//   //     }

//   //     joystickX = dx;
//   //     joystickY = dy;
//   //   });
//   // }

//   // void resetJoystick() {
//   //   setState(() {
//   //     joystickX = 0.0;
//   //     joystickY = 0.0;
//   //   });
//   // }

//   Future show(
//     String message, {
//     Duration duration: const Duration(seconds: 2),
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 100));
//     ScaffoldMessenger.of(context).showSnackBar(
//       new SnackBar(
//         content: new Text(
//           message,
//         ),
//         duration: duration,
//       ),
//     );
//   }

//   Widget shadowBlock(double thisY, thisX) {
//     return Positioned(
//         left: thisX,
//         top: thisY,
//         child: Container(
//           decoration: BoxDecoration(
//               color: Color.fromARGB(71, 0, 0, 0),
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           width: 246,
//           height: 50,
//         ));
//   }

//   void addWidgetDragable(double topYAxis, double topXAxis, double bottomYAxis,
//       double bottomXAxis, String condition, String position) {
//     double? xAxis;
//     double? yAxis;

//     if (position == 'top') {
//       xAxis = topXAxis;
//       yAxis = topYAxis;
//       theLastLocation.add({
//         'bottomDX': bottomXAxis,
//         'bottomDY': bottomYAxis,
//         // jika widget di simpan di atas, nilai top yang di ganti
//         'topDX': xAxis,
//         'topDY': yAxis,
//       });
//     } else if (position == 'bottom') {
//       xAxis = bottomXAxis;
//       yAxis = bottomYAxis;
//       theLastLocation.add({
//         // jika widget di simpan di bawag, nilai bottom yang di ganti
//         'bottomDX': xAxis,
//         'bottomDY': yAxis,
//         'topDX': topXAxis,
//         'topDY': topYAxis,
//       });
//     } else if (position == 'awal') {
//       xAxis = topXAxis;
//       yAxis = topYAxis;
//       theLastLocation.add({
//         // jika widget di simpan di bawag, nilai bottom yang di ganti
//         'bottomDX': topXAxis,
//         'bottomDY': topYAxis,
//         'topDX': topXAxis,
//         'topDY': topYAxis,
//       });
//     }

//     setState(() {
//       if (dragableWidget.length <= 7) {
//         print(dragableWidget.length);
//         dragableWidget.add(
//           Positioned(
//             left: xAxis,
//             top: yAxis,
//             child: Container(
//               child: Stack(
//                 children: [
//                   Image.asset(
//                     condition == 'kanan'
//                         ? 'assets/images/Kanan.png'
//                         : condition == 'kiri'
//                             ? 'assets/images/Kiri.png'
//                             : condition == 'lurus'
//                                 ? 'assets/images/Lurus.png'
//                                 : 'assets/images/belok kanan.png',
//                     scale: 1.1,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       }
//     });
//     print('${theLastLocation.last}');
//   }

//   void addWidgetDragableFor(double yAxis, double xAxis, String condition) {
//     setState(() {
//       dragableWidget.add(
//         Positioned(
//           left: xAxis,
//           top: yAxis,
//           child: Container(
//             child: Stack(
//               children: [
//                 Image.asset(
//                   condition == 'kanan'
//                       ? 'assets/images/Kanan.png'
//                       : condition == 'kiri'
//                           ? 'assets/images/Kiri.png'
//                           : condition == 'lurus'
//                               ? 'assets/images/maju.png'
//                               : condition == 'mundur'
//                                   ? 'assets/images/mundur.png'
//                                   : 'assets/images/mundur.png',
//                   scale: 1,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   Widget blocksMotionFor(String condition) {
//     return Draggable(
//       child: Container(
//         child: Image.asset(
//           condition == 'kanan'
//               ? 'assets/images/Kanan.png'
//               : condition == 'kiri'
//                   ? 'assets/images/Kiri.png'
//                   : condition == 'lurus'
//                       ? 'assets/images/maju.png'
//                       : condition == 'mundur'
//                           ? 'assets/images/mundur.png'
//                           : 'assets/images/mundur.png',
//           scale: 1.5,
//         ),
//       ),
//       feedback: Container(
//         color: Colors.transparent,
//         child: Image.asset(
//           condition == 'kanan'
//               ? 'assets/images/Kanan.png'
//               : condition == 'kiri'
//                   ? 'assets/images/Kiri.png'
//                   : condition == 'lurus'
//                       ? 'assets/images/maju.png'
//                       : condition == 'mundur'
//                           ? 'assets/images/mundur.png'
//                           : 'assets/images/mundur.png',
//           scale: 1,
//         ),
//       ),
//       childWhenDragging: Container(
//         color: Colors.transparent,
//         child: Image.asset(
//           condition == 'kanan'
//               ? 'assets/images/Kanan.png'
//               : condition == 'kiri'
//                   ? 'assets/images/Kiri.png'
//                   : condition == 'lurus'
//                       ? 'assets/images/maju.png'
//                       : condition == 'mundur'
//                           ? 'assets/images/mundur.png'
//                           : 'assets/images/mundur.png',
//           scale: 1,
//         ),
//       ),
//       onDraggableCanceled: (velocity, offset) {
//         RenderBox renderBox = context.findRenderObject() as RenderBox;
//         Offset globalOffset = renderBox.localToGlobal(offset);
//         double yBlokAxis = offset.dy - 55;
//         double xBlokAxis = offset.dx;
//         print('Yblok : ${yBlokAxis} xblok : ${xBlokAxis}');

//         double yAxis = MediaQuery.of(context).size.height / 2 - 30;
//         double xAxis = MediaQuery.of(context).size.width / 2 - 107.5;

//         double threshold = 150.0;

//         bool isNear = (yBlokAxis - yAxis).abs() <= threshold &&
//             (xBlokAxis - xAxis).abs() <= threshold;

//         if (isNear) {
//           print('Widget dekat dengan yAxis dan xAxis');
//           if (dragableWidget.length >= 1) {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return Transform.rotate(
//                   angle: 90 * 0.0174533,
//                   child: PopupDialog(
//                     message: 'Anda Tidak Bisa Menambah Blok Lagi',
//                     txtButton: 'OKE',
//                   ),
//                 );
//               },
//             );
//           } else {
//             addWidgetDragableFor(yAxis, xAxis, condition);
//             switch (condition) {
//               case 'kanan':
//                 dataToSend.add('R');
//                 break;
//               case 'kiri':
//                 dataToSend.add('L');

//                 break;
//               case 'lurus':
//                 dataToSend.add('M');
//                 break;
//               default:
//             }
//           }
//         } else {
//           print('Widget tidak dekat dengan yAxis dan xAxis');
//         }
//         shadowX = 0;
//         shadowY = 0;
//         setState(() {});
//       },
//       onDragUpdate: (dragDetails) {
//         print(
//             'Object amber dragged to X: ${dragDetails.localPosition.dx}, Y: ${dragDetails.localPosition.dy}');

//         shadowX = MediaQuery.of(context).size.width / 2 - 120;
//         shadowY = MediaQuery.of(context).size.height / 2 - 27;
//         setState(() {});
//       },
//     );
//   }

//   Widget blocksMotion(String condition) {
//     return Draggable(
//       child: Container(
//         child: Image.asset(
//           condition == 'kanan'
//               ? 'assets/images/Kanan.png'
//               : condition == 'kiri'
//                   ? 'assets/images/Kiri.png'
//                   : condition == 'lurus'
//                       ? 'assets/images/Lurus.png'
//                       : 'assets/images/belok kanan.png',
//           scale: 1.5,
//         ),
//       ),
//       feedback: Container(
//         color: Colors.transparent,
//         child: Image.asset(
//           condition == 'kanan'
//               ? 'assets/images/Kanan.png'
//               : condition == 'kiri'
//                   ? 'assets/images/Kiri.png'
//                   : condition == 'lurus'
//                       ? 'assets/images/Lurus.png'
//                       : 'assets/images/belok kanan.png',
//           scale: 1.5,
//         ),
//       ),
//       childWhenDragging: Container(
//         color: Colors.transparent,
//         child: Image.asset(
//           condition == 'kanan'
//               ? 'assets/images/Kanan.png'
//               : condition == 'kiri'
//                   ? 'assets/images/Kiri.png'
//                   : condition == 'lurus'
//                       ? 'assets/images/Lurus.png'
//                       : 'assets/images/belok kanan.png',
//           scale: 1.5,
//         ),
//       ),
//       onDraggableCanceled: (velocity, offset) async {
//         RenderBox renderBox = context.findRenderObject() as RenderBox;
//         Offset globalOffset = renderBox.localToGlobal(offset);

//         double yAxis = offset.dy;
//         double xAxis = offset.dx;

//         if (yAxis >= 200) {
//           if (arahBebas == false) {
//             if (dragableWidget.isEmpty) {
//               if (_elapsedTime == Duration.zero) {
//                 print('waktu debug : mulai waktu');
//                 _resetTimer();
//                 _startTimer();
//                 _startCountDown(await dbHelper.getMaxTimer(indexData));
//               }
//             }
//           }

//           if (dragableWidget.length <= 7) {
//             List<Map<String, double>> lastLocationCopy = [...theLastLocation];

//             for (Map<String, double> location in lastLocationCopy) {
//               print(
//                   'cek kondisi awal position : ${location['position']} topDX : ${location['topDX']}, topDY : ${location['topDY']}, bottomDX : ${location['bottomDX']}, bottomDY : ${location['bottomDY']}, ');

//               double toplocdX = theLastLocation.last['topDX']!;
//               double toplocdY = theLastLocation.last['topDY']!;
//               double bottomlocdX = theLastLocation.last['bottomDX']!;
//               double bottomlocdY = theLastLocation.last['bottomDY']!;

//               if (theLastLocation.length <= 1) {
//                 if (theLastLocation.indexOf(location) == 0) {
//                   double locdX = location['topDX']!;
//                   double locdY = location['topDY']!;

//                   if (yAxis <= locdY) {
//                     print("Simpan di atas");
//                     undoHistory.add('atas');

//                     double topyAxis = locdY - 48;
//                     double topxAxis = locdX;
//                     addWidgetDragable(
//                         topyAxis,
//                         topxAxis,
//                         bottomlocdY.toDouble(),
//                         bottomlocdX.toDouble(),
//                         condition,
//                         'top');

//                     switch (condition) {
//                       case 'lurus':
//                         dataToSend.insert(0, 'M');
//                         break;
//                       case 'kanan':
//                         dataToSend.insert(0, 'R');
//                         break;
//                       case 'kiri':
//                         dataToSend.insert(0, 'L');
//                         break;
//                       default:
//                     }

//                     // switch (condition) {
//                     //   case 'lurus':
//                     //     dataToSend.insert(0, '0231323030353044373431443403');
//                     //     break;
//                     //   case 'kanan':
//                     //     dataToSend.insert(0, '0234423030433633343230393903');
//                     //     break;
//                     //   case 'kiri':
//                     //     dataToSend.insert(0, '0231303030393245374236443303');
//                     //     break;
//                     //   default:
//                     // }

//                   } else {
//                     print("Simpan di bawah");
//                     undoHistory.add('bawah');

//                     double bottomyAxis = locdY + 48;
//                     double bottomxAxis = locdX;

//                     addWidgetDragable(toplocdY.toDouble(), toplocdX.toDouble(),
//                         bottomyAxis, bottomxAxis, condition, 'bottom');

//                     switch (condition) {
//                       case 'lurus':
//                         dataToSend.add('M');
//                         break;
//                       case 'kanan':
//                         dataToSend.add('R');
//                         break;
//                       case 'kiri':
//                         dataToSend.add('L');
//                         break;
//                       default:
//                     }
//                     // switch (condition) {
//                     //   case 'lurus':
//                     //     dataToSend.add('0231323030353044373431443403');
//                     //     break;
//                     //   case 'kanan':
//                     //     dataToSend.add('0234423030433633343230393903');
//                     //     break;
//                     //   case 'kiri':
//                     //     dataToSend.add('0231303030393245374236443303');
//                     //     break;
//                     //   default:
//                     // }
//                   }
//                 }
//               } else {
//                 if (yAxis <= toplocdY && location == theLastLocation.last) {
//                   print("Simpan di atas");
//                   undoHistory.add('atas');

//                   double topyAxis = toplocdY - 48;
//                   double topxAxis = toplocdX;

//                   addWidgetDragable(topyAxis, topxAxis, bottomlocdY.toDouble(),
//                       bottomlocdX.toDouble(), condition, 'top');

//                   switch (condition) {
//                     case 'lurus':
//                       dataToSend.insert(0, 'M');
//                       break;
//                     case 'kanan':
//                       dataToSend.insert(0, 'R');
//                       break;
//                     case 'kiri':
//                       dataToSend.insert(0, 'L');
//                       break;
//                     default:
//                   }

//                   // switch (condition) {
//                   //   case 'lurus':
//                   //     dataToSend.insert(0, '0231323030353044373431443403');
//                   //     break;
//                   //   case 'kanan':
//                   //     dataToSend.insert(0, '0234423030433633343230393903');
//                   //     break;
//                   //   case 'kiri':
//                   //     dataToSend.insert(0, '0231303030393245374236443303');
//                   //     break;
//                   //   default:
//                   // }

//                   print('masukan widget');
//                 } else if (yAxis >= bottomlocdY &&
//                     location == theLastLocation.last) {
//                   print("Simpan di bawah");
//                   undoHistory.add('bawah');

//                   double bottomyAxis = bottomlocdY + 48;
//                   double bottomxAxis = bottomlocdX;

//                   addWidgetDragable(toplocdY.toDouble(), toplocdX.toDouble(),
//                       bottomyAxis, bottomxAxis, condition, 'bottom');

//                   switch (condition) {
//                     case 'lurus':
//                       dataToSend.add('M');
//                       break;
//                     case 'kanan':
//                       dataToSend.add('R');
//                       break;
//                     case 'kiri':
//                       dataToSend.add('L');
//                       break;
//                     default:
//                   }

//                   // switch (condition) {
//                   //   case 'lurus':
//                   //     dataToSend.add('0231323030353044373431443403');
//                   //     break;
//                   //   case 'kanan':
//                   //     dataToSend.add('0234423030433633343230393903');
//                   //     break;
//                   //   case 'kiri':
//                   //     dataToSend.add('0231303030393245374236443303');
//                   //     break;
//                   //   default:
//                   // }
//                   print('masukan widget');
//                 }
//               }
//             }

//             if (dragableWidget.isEmpty && theLastLocation.isEmpty) {
//               undoHistory.add('bawah');
//               addWidgetDragable(yAxis, xAxis, yAxis, xAxis, condition, 'awal');
//               print('widget pertama tersimpan ${yAxis} ${xAxis}');

//               switch (condition) {
//                 case 'lurus':
//                   dataToSend.add('M');
//                   break;
//                 case 'kanan':
//                   dataToSend.add('R');
//                   break;
//                 case 'kiri':
//                   dataToSend.add('L');
//                   break;
//                 default:
//               }

//               // switch (condition) {
//               //   case 'lurus':
//               //     dataToSend.add('0231323030353044373431443403');
//               //     break;
//               //   case 'kanan':
//               //     dataToSend.add('0234423030433633343230393903');
//               //     break;
//               //   case 'kiri':
//               //     dataToSend.add('0231303030393245374236443303');
//               //     break;
//               //   default:
//               // }
//             }
//           } else {
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return PopupDialog(
//                   message: 'Block sudah penuh',
//                   txtButton: 'OKE',
//                 );
//               },
//             );
//           }
//         }

//         shadowX = 0;
//         shadowY = 0;
//         setState(() {});

//         print(theLastLocation);
//       },
//       onDragUpdate: (dragDetails) {
//         print(
//             'Object amber dragged to X: ${dragDetails.localPosition.dx}, Y: ${dragDetails.localPosition.dy}');

//         RenderBox renderBoxShadow = context.findRenderObject() as RenderBox;
//         Offset globalOffsetShadow =
//             renderBoxShadow.localToGlobal(dragDetails.localPosition);

//         double yAxisShadow = globalOffsetShadow.dy - 55;
//         double xAxisShadow = globalOffsetShadow.dx - 55;

//         bool isSameValueExistsShadow = false;
//         double toleranceShadow = double.maxFinite; // Toleransi maksimal
//         double dxShadow = 0;
//         double dyShadow = 0;

//         if (theLastLocation.isNotEmpty) {
//           for (Map<String, double> location in theLastLocation) {
//             dxShadow = location['bottomDX']!;
//             dyShadow = location['bottomDY']!;
//             dxShadow = location['topDX']!;
//             dyShadow = location['topDY']!;

//             if ((dxShadow - xAxisShadow).abs() <= toleranceShadow &&
//                 (dyShadow - yAxisShadow).abs() <= toleranceShadow) {
//               isSameValueExistsShadow = true;
//               break;
//             }
//           }
//         }

//         if (!isSameValueExistsShadow) {
//           shadowX = 0;
//           shadowY = 0;
//         } else if (yAxisShadow <= theLastLocation.last['topDY']!) {
//           print("bayangan di atas");

//           shadowX = theLastLocation.last['topDX']! + 5;
//           shadowY = theLastLocation.last['topDY']! - 34;
//         } else if (yAxisShadow >= theLastLocation.last['bottomDY']!) {
//           print("bayangan di bawah");

//           shadowX = theLastLocation.last['bottomDX']! + 5;
//           shadowY = theLastLocation.last['bottomDY']! + 25;
//         }
//         setState(() {});
//       },
//     );
//   }
// }
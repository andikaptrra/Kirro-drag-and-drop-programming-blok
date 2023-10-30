import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:kirro/global_Variabel/variabel.dart';
import 'package:kirro/global_Variabel/level.dart';
import 'package:kirro/utillitas/bluetooth_services.dart';

import 'package:flutter/material.dart';
import 'package:kirro/widgets/popUpCustom.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utillitas/popUp.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:kirro/menu/game_page/create_program.dart';
import 'package:kirro/utillitas/bluetooth_services.dart';
import 'package:kirro/widgets/button.dart';
import 'package:kirro/utillitas/audio_background.dart';
import 'package:kirro/utillitas/button_audio.dart';
import 'dart:async';

import 'package:flutter/rendering.dart';
import 'dart:math';

import 'package:kirro/utillitas/bluetooth_services.dart';
import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'dart:async';

// import 'dart:convert';
// For using PlatformException
import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:kirro/utillitas/popUp.dart';
import 'package:ndialog/ndialog.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

import '../utillitas/database/database_user.dart';
import '../utillitas/math/scorer.dart';
import '../widgets/dropDown.dart';
import '../widgets/leaderBoard.dart';
// import 'package:just_audio/just_audio.dart';

class mainPage extends StatefulWidget {
  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  StreamController<int> _controllerTimer = StreamController<int>();
  late Stream<int> timerStream;
  late Animation<double> _animation;

  double _backgroundPosition = 0;
  bool _showWidget = true;
  bool _showWidget2 = false;
  late ReceivePort _receivePort;
  late Isolate _isolate;
  bool _isRunning = false;
  int _secondsElapsed = 0;
  String thisBackground = 'assets/background/bg5.jpg';
  List bgList = [
    'assets/background/bg2.jpg',
    'assets/background/bg3.jpg',
    'assets/background/bg4.jpg',
    'assets/background/bg5.jpg'
  ];

  // ======== Variable for joyPad
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  // Initializing a global key, as it would help us in showing a SnackBar later
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // Get the instance of the Bluetooth
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  // Track the Bluetooth connection with the remote device
  BluetoothConnection? connection;
  // Variabel untuk menyimpan data yang diterima dari serial
  String _receivedData = "Tidak ada data";
  // Inisialisasi stream untuk menerima data dari serial
  // StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  DatabaseUser databaseUser = DatabaseUser();

  TextEditingController registerController = TextEditingController();

  String proses = 'Sending';

  int pengulangan = 0;

  bool pengiriman = false;

  int? _deviceState;

  String _messageBuffer = '';

  bool isDisconnecting = false;
  List textData = [];

  String? nameDirection;

  // To track whether the device is still connected to Bluetooth
  bool get isConnected => connection != null && connection!.isConnected;

  // Define some variables, which will be required later
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _isButtonUnavailable = false;

  bool? send;

  String buttonPressed = '';
  String arrowPressed = '';
  bool restarOnTap = false;
  bool okOnTap = false;
  double joystickX = 0.0;
  double joystickY = 0.0;
  String dataYangdiIsi = '';
  // String buttonMaju = 'W0000000000000000000';
  // String buttonMundur = 'S0000000000000000000';
  // String buttonKanan = 'D0000000000000000000';
  // String buttonKiri = 'A0000000000000000000';
  // String buttonY = 'Z0000000000000000000';
  // String buttonX = 'X0000000000000000000';
  // String buttonA = 'C0000000000000000000';
  // String buttonB = 'V0000000000000000000';
  // String diam = 'J0000000000000000000';
  bool majuClick = false;
  bool kiriClick = false;
  bool kananClick = false;
  bool mundurClick = false;
  bool arahBebas = false;
  bool blokState = true;
  String? selectedValue;

  // Route Menu

  // Drag And Drop
  // List<Map<String, dynamic>> dragableWidget = [];
  List<Widget> dragableWidget = [];
  List<Widget> conditionBlokWidget = [];
  List<Widget> statementBlokWidget = [];
  List<Widget> bodyBlokWidget = [];
  List<String> blokHistory = [];
  List undoHistory = [];
  List dataToSend = [];
  double lokasiX = 0;
  double lokasiY = 0;
  List<Map<String, double>> theLastLocation = [];
  double shadowY = 0;
  double shadowX = 0;
  bool bluetoothCond = false;

  int indexData = 0;
  String mustDataToSend = '';
  int _inputNumber = 0;

  Future<void> updateUserByName(
    DatabaseUser dbUser,
    String targetName, {
    String? lastLevel,
    String? subLevel,
    int? score,
  }) async {
    final DatabaseUser dbUser = DatabaseUser();
    // Update the lastLevel for the user
    if (lastLevel != null) {
      await dbUser.updateUserByName(targetName, lastLevel: lastLevel);
    }

    // Update the subLevel for the user
    if (subLevel != null) {
      await dbUser.updateUserByName(targetName, subLevel: subLevel);
    }

    // Update the score for the user
    if (score != null) {
      await dbUser.updateUserByName(targetName, score: score);
    }

    print('User data updated successfully.');
  }

  Future<String?> getLastLevel() async {
    final List<User> users = await databaseUser.getUsers();
    if (users.isNotEmpty) {
      return users[0].lastLevel;
    } else {
      return null;
    }
  }

  Future<int?> getIndexUser() async {
    int? userIndex = await databaseUser.getUserIndexByName(selectedAccount);
    return userIndex;
  }

  Future<User?> getUserData(String userName) async {
    final List<User> users = await databaseUser.getUsers();

    for (User user in users) {
      if (user.name == userName) {
        return user;
      }
    }

    return null; // Jika tidak ada pengguna dengan nama yang cocok.
  }

  Future<String?> getsubLevel() async {
    final List<User> users = await databaseUser.getUsers();
    if (users.isNotEmpty) {
      return users[0].subLevel;
    } else {
      return null;
    }
  }

  Future<User?> getUserInfoByName(String searchName) {
    return databaseUser.getUserByName(searchName);
  }

  Future<void> getUserInfo({required String nama}) async {
    dataUser.clear();

    int? index;

    final List<User> users = await databaseUser.getUsers();

    for (int i = 0; i < users.length; i++) {
      if (users[i].name.toLowerCase() == nama.toLowerCase()) {
        index = i; // Fixed assignment
        break; // You can exit the loop once you find a match
      }
    }

    if (index != null && index >= 0 && index < users.length) {
      // Check for null before accessing index
      dataUser = {
        'userName': users[index].name,
        'lastLevel': users[index].lastLevel,
        'subLevel': users[index].subLevel,
        'score': users[index].score,
      };
      print(dataUser);
    } else {
      print('User not found.');
    }
  }

  Future<void> getAllUser() async {
    userList = await databaseUser.getUsers();

    usersRank = userList
        .map((user) => LeaderboardUser(name: user.name, score: user.score))
        .toList();

    usersRank.sort((a, b) => b.score.compareTo(a.score));
  }

  Future<List<String>> getAllName() async {
    return await databaseUser.getUserNames();
  }

  Future<void> toListAllName() async {
    nameUsers = await getAllName();
    if (nameUsers.contains('tambah akun')) {
      nameUsers.remove('tambah akun');
    }
    // Tambah "tambah akun" di index terakhir
    nameUsers.add('tambah akun');
  }

  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controllerTimer = StreamController<int>();
    timerStream = _controllerTimer.stream.asBroadcastStream();
    _receivePort = ReceivePort();

    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      // Panggil setState atau fungsi lain yang akan memicu refresh tampilan
      setState(() {});
    });

    toListAllName();
    getAllUser();

    // Panggil checkConnectionStatus setiap 1 detik
    Timer.periodic(Duration(seconds: 1), (_) {
      checkConnectionStatus();
    });

    // playSound();

    AudioService.play();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = Tween(begin: 0.0, end: -350.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _backgroundPosition = _animation.value;
        });
      });

    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    _deviceState = 0; // neutral

    // If the bluetooth of the device is not enabled,
    // then request permission to turn on bluetooth
    // as the app starts up
    // turnOffBluetooth(); // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
        if (_bluetoothState == BluetoothState.STATE_OFF) {
          _isButtonUnavailable = true;
        }
        getPairedDevices();
      });
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes menit, $remainingSeconds detik';
  }

  void _startTimer() {
    print('timer start');
    if (!_isRunning) {
      _isRunning = true;
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _secondsElapsed++;
        _controllerTimer.add(_secondsElapsed);
      });
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      _isRunning = false;
      timer?.cancel(); // Menghentikan timer dengan cancel
    }
  }

  void _resetTimer() {
    if (!_isRunning) {
      _secondsElapsed = 0;
      _controllerTimer.add(_secondsElapsed);
    }
  }

  @override
  void dispose() {
    AudioService.stop(); // Menghentikan pemutaran audio saat layar dihapus
    _controllerTimer.close();
    super.dispose();
    _timer?.cancel();

    _controller.dispose();

    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      var lateconnection = null;
    }
  }

  void clearAll() {
    blokChange = 'program';
    mustDataToSend = '';
    dragableWidget.clear();
    theLastLocation.clear();
    blokHistory.clear();
    dataToSend.clear();
    conditionBlokWidget.clear();
    statementBlokWidget.clear();
    locationStatement.clear();
    locationBody.clear();
    flexText.clear();
    bodyBlokWidget.clear();
    indexData = 0;
    setState(() {});
  }

  void setInstruction(
      {required BuildContext context,
      required String message,
      required List answer,
      required bool rotate}) {
    kunjaw = answer;
    mustDataToSend = answer.toString();
    print('monitor: setInstruction : message : ${answer}');
    print('monitor: setInstruction : message : ${answer}');

    if (rotate) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Transform.rotate(
            angle: 90 * (pi / 180), // 90 derajat dalam radian
            child: TextStory(
              message: message,
              buttonText: 'Oke',
              width: MediaQuery.of(context).size.height * 0.8,
              height: MediaQuery.of(context).size.width,
              onButtonPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Transform.rotate(
                      angle: 90 * (pi / 180), // 90 derajat dalam radian
                      child: TextStory(
                        message: 'Mulai Permainan?',
                        buttonText: 'Mulai',
                        width: MediaQuery.of(context).size.height * 0.8,
                        height: MediaQuery.of(context).size.width,
                        onButtonPressed: () {
                          Navigator.pop(context);
                          _startTimer();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return TextStory(
            message: message,
            buttonText: 'Oke',
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height,
            onButtonPressed: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return TextStory(
                    message: 'Mulai Permainan?',
                    buttonText: 'Mulai',
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height,
                    onButtonPressed: () {
                      Navigator.pop(context);
                      _startTimer();
                    },
                  );
                },
              );
            },
          );
        },
      );
    }
  }

  void showCustomDialog(BuildContext context, String text, String imageAsset) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 8,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imageAsset,
                  height: 100,
                  width: 100,
                ),
                SizedBox(height: 16),
                Text(text),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Oke'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void pauseAudio() {
    print('pause');
    AudioService.pause(); // Menghentikan sementara pemutaran audio
  }

  // For retrieving and storing the paired devices
  // in a list.
  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    // To get the list of paired devices
    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    // It is an error to call [setState] unless [mounted] is true.
    if (!mounted) {
      return;
    }

    // Store the [devices] list in the [_devicesList] for accessing
    // the list outside this class
    setState(() {
      _devicesList = devices;
    });
  }

  bool isSwitched = false;
  bool isLoading = false;

  // Define some variables, which will be required later
  Color bgColor = Color.fromARGB(255, 214, 211, 211);
  Future<void> sendDataJoyPad(String data) async {
    if (_connected) {
      print('data terkirim ${data}');
      _sendMessageString(data);
    } else {
      print('belum tersambung');
    }
  }

  // Future<void> sendDataJoyPad(
  //     {required String data, required String condition}) async {
  //   if (condition == 'free') {
  //     if (_connected) {
  //       _sendMessageString(data);
  //     } else {
  //       if (receivedData == '') {
  //         _sendMessageString(data);
  //       }
  //     }
  //     print('data terkirim ${data}');
  //   }
  // }

  Future<void> sendDataProgram(String cond) async {
    // showLoadingDialog(context);
    if (cond == 'contoh') {
      List dataReady = dataToSend;
      bool containsG = dataReady.contains('G');
      !containsG ? dataReady.add('G') : null;

      if (dataReady.length <= 19) {
        int maxInd = 19 - dataReady.length;
        for (var i = 0; i < maxInd; i++) {
          dataReady.add('X');
        }
      }

      dataReady.add('G');

      // MULAU PROSES PENGGABUNGAN LIST DAN MENGIRIM DATA
      String _puzzleSend = dataReady.join();
      print('ini data yang di kirim : ${_puzzleSend}');
      // menggunakan String

      _sendMessageString(_puzzleSend);

      print('ini data panjang : ${dataReady.length}');
      dataReady.removeWhere((element) => element == 'G');
      dataReady.removeWhere((element) => element == 'X');
      print('ini data ready dari page bluetooth dikembalikan : ${dataReady}');

      Timer(Duration(seconds: 2), () {
        // hideLoadingDialog(context);
        dataToSend.clear();
        dragableWidget.clear();
        setState(() {});
      });
    } else {
      if (dataToSend[0] == 'B') {
        _sendMessageString('${dataToSend[0]}');
        dataToSend.clear();
        Timer(Duration(seconds: 2), () {
          // hideLoadingDialog(context);
        });
      } else {
        List dataReady = dataToSend;
        bool containsG = dataReady.contains('G');
        !containsG ? dataReady.add('G') : null;

        if (dataReady.length <= 19) {
          int maxInd = 19 - dataReady.length;
          for (var i = 0; i < maxInd; i++) {
            dataReady.add('X');
          }
        }

        dataReady.add('G');

        // MULAU PROSES PENGGABUNGAN LIST DAN MENGIRIM DATA
        String _puzzleSend = dataReady.join();
        print('ini data yang di kirim : ${_puzzleSend}');
        // menggunakan String

        _sendMessageString(_puzzleSend);

        // menggunakan Hex
        // _sendMessageHex(_puzzleSend);

        // for (var data in dataReady) {
        // await Future.delayed(Duration(milliseconds: 500), () {
        // _sendMessageHex(data);
        // });
        // }
        // MENGIRIM KODE GOGO
        // _sendMessageString('G');
        // _sendMessageHex('G');
        // hideLoadingDialog(context);
        print('ini data panjang : ${dataReady.length}');
        dataReady.removeWhere((element) => element == 'G');
        dataReady.removeWhere((element) => element == 'X');
        print('ini data ready dari page bluetooth dikembalikan : ${dataReady}');

        Timer(Duration(seconds: 2), () {
          // hideLoadingDialog(context);
        });
      }
    }
  }

  void _listenForData() {
    connection!.input!.listen((data) async {
      receivedData = String.fromCharCodes(data);
      combineReceived += receivedData;
      print('perbandingan 3 ${receivedData}');
      String cleanedData = '';
      String resultString = '';
      bool dialog = false;

      // print('alldata ${receivedData}');
      print('monitor : level Two = ${dataUser['lastLevel'] == '2'}');

      if (listeningData) {
        if (combineReceived.contains('G')) {
          if (combineReceived.contains('hirro')) {
            resultString = combineReceived;
            print(
                'monitor resultString :  ${resultString}, kunjaw ${kunjaw.join()}');
            // while (combineReceived.startsWith('LL') ||
            //     combineReceived.startsWith('RR')) {
            //   combineReceived = combineReceived.substring(2);
            // }
            if (combineReceived.contains(kunjaw.join())) {
              print('monitor : Jawaban benar');

              hitungSkor(
                  waktuPenyelesaian: _secondsElapsed,
                  waktuTerlama: levelStory[1]['isiLv']['time']
                      ['time${int.parse(subLevel) - 1}']);
              await databaseUser.updateUserByName(selectedAccount,
                  subLevel: subLevel != '' ? subLevel : '1');
              _stopTimer();
              toListAllName();
              getAllUser();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return TextStory(
                    message:
                        'Kartu yang kamu masukan sudah benar, hirro pergi ke lokasi yang di tuju!',
                    buttonText: 'Oke',
                    width: MediaQuery.of(context).size.height * 0.8,
                    height: MediaQuery.of(context).size.width,
                    onButtonPressed: () {
                      Navigator.of(context).pop();
                    },
                  );
                },
              );
            }
            dialog = true;
          }
          // Lakukan sesuatu dengan data yang lengkap, misalnya mencetaknya
          print("Data lengkap combine: $combineReceived");

          // Setelah melakukan sesuatu dengan data, Anda dapat mereset receivedData
          combineReceived = "";
        }

        if (receivedData.contains('maju')) {
          print(receivedData);
          print('robot sedang berjalan');
          _showPopup();
        } else if (receivedData.contains('jalan')) {
          print(receivedData);
          print('robot sedang berjalan');
          _showPopup();
        }

        if (receivedData.contains('done')) {
          print(receivedData);
          print('robot selesai eksekusi');
          _closePopup();
        }
      }
    }).onDone(() {
      _disconnect();
    });
  }

  void showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent, // Set background transparan
          content: Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                colors: [Color(0xFFFF4E50), Color(0xFFF9D423)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: Colors.grey.shade400,
                width: 2.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Buat Akun Baru',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: registerController,
                    style: TextStyle(
                        color:
                            Colors.white), // Ganti warna teks yang diketikkan
                    decoration: InputDecoration(
                      labelText: 'Nama Pengguna',
                      hintText: 'Masukkan nama pengguna',
                      labelStyle: TextStyle(color: Colors.white),
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AluminumButton(
                      click: true,
                      label: 'Ok',
                      onPressed: () async {
                        final newName = registerController.text;
                        final existingNames = await databaseUser.getUserNames();

                        if (existingNames.contains(newName)) {
                          // Nama sudah digunakan
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Nama sudah digunakan.')),
                          );
                        } else {
                          final newUser = User(
                            name: newName,
                            lastLevel: '1',
                            subLevel: '1',
                            score: 0,
                          );
                          await databaseUser.insertUser(newUser);
                          toListAllName();
                          getAllUser();
                          setState(() {});
                          registerController.clear();
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Mengirim Ke Hirro...'),
            ],
          ),
        );
      },
    );
  }

  void showConnectDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Menyambungkan dengan Hirro...'),
            ],
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  DateTime? currentBackPressTime;

  Future<bool> _onWillPop() async {
    DateTime now = DateTime.now();

    // Jika waktu terakhir tombol "back" ditekan belum ada atau sudah lebih dari 2 detik yang lalu,
    // simpan waktu sekarang sebagai waktu terakhir dan beri notifikasi bahwa aplikasi tidak akan keluar
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tekan tombol back lagi untuk keluar.'),
        ),
      );
      return false;
    }

    // Jika waktu terakhir tombol "back" ditekan adalah dalam rentang 2 detik,
    // maka izinkan aplikasi untuk keluar
    return true;
  }

  void _showPopup() {
    setState(() {
      isPopupVisible = true;
    });
  }

  void _closePopup() {
    setState(() {
      isPopupVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wdLayer = MediaQuery.of(context).size.width;
    final backgroundWidth = wdLayer * 2;
    final hgLayer = MediaQuery.of(context).size.height;

    Widget ContohDragAndDropWidget() {
      return Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: hgLayer * 0.06,
              ),
              Container(
                height: 200,
                alignment: Alignment.bottomCenter,
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'BLOK KODE',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Container(
                        height: hgLayer * 0.14,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: blocksMotionProgram('kanan'),
                                  ),
                                  SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: blocksMotionKontrol('kiri'),
                                  ),
                                  SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: blocksMotionKontrol('lurus'),
                                  ),
                                  SizedBox(width: 8),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25),
                                    child: blocksMotionKontrol('lurus'),
                                  ),
                                  SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          LayoutBuilder(builder: (context, constraints) {
            lokasiX = constraints.biggest.width / 2 - 50;
            lokasiY = constraints.biggest.height / 2 - 50;

            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.78,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, -3), // Mengatur offset bayangan ke atas
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/background/bgGame.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.05),
                      BlendMode.darken, // Mengatur tingkat kegelapan gambar
                    ),
                  ),
                ),
              ),
            );
          }),

          shadowX != 0 && shadowY != 0
              ? shadowBlock(shadowY, shadowX + 20)
              : Container(),
          Center(
            child: Container(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/base.png',
                    scale: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: wdLayer * 0.25),
                    child: Container(
                        width: wdLayer * 0.5,
                        child: Row(
                          children: [
                            Text(
                              _inputNumber.toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Container(
                              width: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi ketika tombol diklik
                                  if (_inputNumber <= 24) {
                                    _inputNumber++;
                                  }
                                  setState(() {});
                                  print(_inputNumber);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors
                                      .green, // Ubah warna latar belakang tombol menjadi hijau
                                ),
                                child: Text(
                                  '\u002B', // Karakter Unicode untuk simbol plus
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors
                                        .white, // Ubah warna teks menjadi putih
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 40,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Aksi ketika tombol diklik
                                  if (_inputNumber >= 1) {
                                    _inputNumber--;
                                  }
                                  setState(() {});
                                  print(_inputNumber);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors
                                      .green, // Ubah warna latar belakang tombol menjadi hijau
                                ),
                                child: Text(
                                  '\u2212', // Karakter Unicode untuk simbol minus
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ),

          ...dragableWidget,
          // RawMaterialButton(
          //   onPressed: () {
          //     print('ini data yang akan di kirim  :  ${dataToSend}');
          //   },
          //   shape: CircleBorder(),
          //   padding: EdgeInsets.all(16.0),
          //   elevation: 2.0,
          //   fillColor: Colors.green,
          //   child: Icon(
          //     Icons.check,
          //     color: Colors.white,
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 5),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                icon: Icon(
                  Icons.info_outline_rounded,
                  size: 50,
                  color: Colors.white,
                ),
                onPressed: () {
                  print('ini data thelastlocation ${theLastLocation}');
                  print('ini data dragablewidget ${dragableWidget}');
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      String _message = '';
                      if (_inputNumber == '0') {
                        _message = 'Atur Banyaknya Perulangan';
                      } else if (dragableWidget.isEmpty) {
                        _message =
                            'Pindahkan Blok Kode ke Dalam Blok Perulangan';
                      }
                      print(_message);
                      print(_inputNumber);

                      return PopupDialog(
                        message: _message,
                        txtButton: 'OKE',
                      );
                    },
                  );
                },
              ),
            ),
          ),
          dragableWidget.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 5, bottom: 15),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            if (dragableWidget.isNotEmpty &&
                                dataToSend.isNotEmpty) {
                              dragableWidget.clear();
                              dataToSend.clear();
                            }
                            setState(() {});
                          },
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16.0),
                          elevation: 2.0,
                          fillColor: Colors.blue,
                          child: Icon(
                            Icons.undo_outlined,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        dragableWidget.isNotEmpty && _inputNumber != 0
                            ? RawMaterialButton(
                                onPressed: () {
                                  List<dynamic> copyDataToSend = [];
                                  if (dataToSend.isNotEmpty) {
                                    copyDataToSend = [dataToSend[0]];
                                    if (_inputNumber > 1) {
                                      for (var i = 0;
                                          i < _inputNumber - 1;
                                          i++) {
                                        dataToSend.add(copyDataToSend[0]);
                                      }
                                    }
                                  }
                                  print('ini copy data ${dataToSend}');
                                  sendDataProgram('contoh');
                                  print(
                                      'ini banyaknya perulangan : ${_inputNumber}');
                                  //    showDialog(
                                  //   context: context,
                                  //   builder: (BuildContext context) {
                                  //     return AlertDialog(
                                  //       title: Text('Apakah data ingin di kirim?'),
                                  //       actions: [
                                  //         TextButton(
                                  //           onPressed: () {
                                  //             Navigator.pop(context);
                                  //           },
                                  //           child: Text('YES'),
                                  //         ),
                                  //         TextButton(
                                  //           onPressed: () {
                                  //             Navigator.pop(context);
                                  //           },
                                  //           child: Text('NO'),
                                  //         ),
                                  //       ],
                                  //     );
                                  //   },
                                  // );
                                  if (_connected) {}
                                },
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(16.0),
                                elevation: 2.0,
                                fillColor: Colors.green,
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                )
              : Container(),

          Container(
            height: hgLayer * 0.08,
            width: wdLayer,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Mengatur offset bayangan ke bawah
                ),
              ],
              color: Color.fromARGB(255, 185, 97, 89),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(25.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    onPressed: () {
                      changePage = menuUtama;
                      _inputNumber = 0;
                      mustDataToSend = '';
                      dragableWidget.clear();
                      theLastLocation.clear();
                      dataToSend.clear();
                      setState(() {});
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white)),
                Text(
                  'PROGRAM DRAG AND DROP PERULANGAN',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          )
        ],
      );
    }

    Widget BluetoothConnectWidget() {
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 30, top: 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: LinearGradient(
              colors: [Color(0xFFFF4E50), Color(0xFFF9D423)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                offset: Offset(-6.0, -6.0),
                blurRadius: 16.0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: Offset(6.0, 6.0),
                blurRadius: 16.0,
              ),
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: Offset(-6.0, 6.0),
                blurRadius: 16.0,
              ),
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                offset: Offset(6.0, -6.0),
                blurRadius: 16.0,
              ),
            ],
            border: Border.all(
              color: Colors.grey.shade400,
              width: 2.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 1.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(25),
                              color: _bluetoothState.isEnabled
                                  ? Colors.blue
                                  : Colors.orange),
                          child: IconButton(
                              onPressed: () {
                                future() async {
                                  // async lambda seems to not working
                                  if (_bluetoothState.isEnabled) {
                                    await _bluetooth.requestDisable();
                                  } else {
                                    await _bluetooth.requestEnable();
                                  }
                                  setState(() {});
                                }

                                future().then((_) {
                                  setState(() {});
                                });
                              },
                              icon: Icon(
                                  _bluetoothState.isEnabled
                                      ? Icons.bluetooth_disabled_rounded
                                      : Icons.bluetooth_connected_rounded,
                                  color: Colors.white)))),
                  Align(
                    alignment: Alignment.center,
                    child: DropdownButton(
                      underline: SizedBox(),
                      items: _getDeviceItems(),
                      onChanged: (value) => setState(() => _device = value!),
                      value: _devicesList.isNotEmpty ? _device : null,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: _device == null || !_bluetoothState.isEnabled
                          ? null
                          : _connected
                              ? _disconnect
                              : _connect,
                      child: Text(_connected ? 'Putuskan' : 'Sambungkan'),
                    ),
                  ),
                ]),
          ),
        ),
      );
    }

    Widget BluetoothMenu() {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 223, 58, 47),
              Color.fromARGB(255, 247, 184, 89)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                gradient: LinearGradient(
                  colors: [Color(0xFFFF4E50), Color(0xFFF9D423)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    offset: Offset(-6.0, -6.0),
                    blurRadius: 16.0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    offset: Offset(6.0, 6.0),
                    blurRadius: 16.0,
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    offset: Offset(-6.0, 6.0),
                    blurRadius: 16.0,
                  ),
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    offset: Offset(6.0, -6.0),
                    blurRadius: 16.0,
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 2.0,
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          changePage = menuUtama;
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        )),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'KONEKSI BLUETOOTH', // Main Level
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BluetoothConnectWidget(),
          ],
        ),
      );
    }

    Widget JoyPadWidgetFree() {
      return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background/bgGameJoy.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTapDown: (_) {
                                  print(
                                      'ini data yang di kirim : ${buttonKanan}');
                                  sendDataJoyPad(buttonKananFree);
                                  setState(() {
                                    kiriClick = true;
                                    arrowPressed = 'KANAN';
                                    // buttonKanan == null
                                    //     ? changePage = menuProgram
                                    //     : null;
                                  });
                                  // print(arrowPressed);
                                  // if (buttonKanan != null) {
                                  //   sendDataJoyPad('D');
                                  //   print('tombol D');
                                  // }
                                },
                                onTapUp: (_) {
                                  setState(() {
                                    arrowPressed = '';
                                  });
                                  kiriClick = false;
                                  print(arrowPressed);
                                  sendDataJoyPad(diamFree);
                                  print('ini data yang di kirim : ${diam}');
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 100),
                                  child: Container(
                                      height: 90,
                                      child: Image.asset(arrowPressed == 'KANAN'
                                          ? 'assets/images/arrow.png'
                                          : 'assets/images/arrowOnClick.png')),
                                ),
                              )),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Transform.rotate(
                                angle: 180 * 0.0174533,
                                child: GestureDetector(
                                  onTapDown: (_) {
                                    setState(() {
                                      print(
                                          'ini data yang di kirim : ${buttonKiri}');
                                      sendDataJoyPad(buttonKiriFree);
                                      kananClick = true;
                                      arrowPressed = 'KIRI';
                                      // buttonKiri == null
                                      //     ? changePage = menuProgram
                                      //     : null;
                                    });
                                    // print(arrowPressed);
                                    // if (buttonKiri != null) {
                                    //   sendDataJoyPad('A');
                                    //   print('tombol A');
                                    // }
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      arrowPressed = '';
                                    });
                                    kananClick = false;
                                    print(arrowPressed);
                                    sendDataJoyPad(diamFree);
                                    print('ini data yang di kirim : ${diam}');
                                  },
                                  child: Container(
                                      height: 90,
                                      child: Image.asset(arrowPressed == 'KIRI'
                                          ? 'assets/images/arrow.png'
                                          : 'assets/images/arrowOnClick.png')),
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Transform.rotate(
                                angle: 270 * 0.0174533,
                                child: GestureDetector(
                                  onTapDown: (_) {
                                    print(
                                        'ini data yang di kirim : ${buttonMaju}');
                                    sendDataJoyPad(buttonMajuFree);
                                    // buttonMaju != null;
                                    setState(() {
                                      majuClick = true;
                                      arrowPressed = 'MAJU';
                                      // buttonMaju == null
                                      //     ? changePage = menuProgram
                                      //     : null;
                                    });
                                    // print(arrowPressed);
                                    // if (buttonMaju != null) {
                                    //   sendDataJoyPad('W');
                                    //   print('tombol W');
                                    // }
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      arrowPressed = '';
                                    });
                                    majuClick = false;
                                    print(arrowPressed);
                                    sendDataJoyPad(diamFree);
                                    print('ini data yang di kirim : ${diam}');
                                  },
                                  child: Container(
                                      height: 90,
                                      child: Image.asset(arrowPressed == 'MAJU'
                                          ? 'assets/images/arrow.png'
                                          : 'assets/images/arrowOnClick.png')),
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Transform.rotate(
                                angle: 90 * 0.0174533,
                                child: GestureDetector(
                                  onTapDown: (_) {
                                    print(
                                        'ini data yang di kirim : ${buttonMundur}');
                                    sendDataJoyPad(buttonMundurFree);
                                    // buttonMaju != null;
                                    setState(() {
                                      majuClick = true;
                                      arrowPressed = 'MUNDUR';
                                      // buttonMundur == null
                                      //     ? changePage = menuProgram
                                      //     : null;
                                    });
                                    // print(arrowPressed);
                                    // if (buttonMundur != null) {
                                    //   sendDataJoyPad('S');
                                    //   print('tombol S');
                                    // }
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      arrowPressed = '';
                                    });
                                    majuClick = false;
                                    print(arrowPressed);
                                    sendDataJoyPad(diamFree);
                                    print('ini data yang di kirim : ${diam}');
                                  },
                                  child: Container(
                                      height: 90,
                                      child: Image.asset(arrowPressed ==
                                              'MUNDUR'
                                          ? 'assets/images/arrow.png'
                                          : 'assets/images/arrowOnClick.png')),
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 150),
                    Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // BUTTON A
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTapDown: (_) {
                                    setState(() {
                                      buttonPressed = 'A';
                                      sendDataJoyPad(buttonAFree);
                                      print(buttonPressed);
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      buttonPressed = '';
                                      sendDataJoyPad(diamFree);
                                      print(buttonPressed);
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: buttonPressed == 'A'
                                          ? Colors.blue.withOpacity(0.8)
                                          : Colors.blue,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        buttonPressed == 'A'
                                            ? BoxShadow(
                                                color: Colors.blue
                                                    .withOpacity(0.8),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                                spreadRadius: 0,
                                              )
                                            : BoxShadow(
                                                color: Colors.blue
                                                    .withOpacity(0.5),
                                                offset: Offset(0, 1),
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                              ),
                                      ],
                                    ),
                                    child: Center(
                                        child: Transform(
                                      transform: Matrix4.rotationZ(
                                          pi / 2), // Sudut rotasi dalam radian
                                      alignment: Alignment.center,
                                      child: Text(
                                        'A',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              // BUTTON Y
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTapDown: (_) {
                                    setState(() {
                                      buttonPressed = 'Y';
                                      print(buttonPressed);
                                      sendDataJoyPad(buttonYFree);
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      buttonPressed = '';
                                      sendDataJoyPad(diamFree);
                                      print(buttonPressed);
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: buttonPressed == 'Y'
                                          ? Colors.green.withOpacity(0.8)
                                          : Colors.green,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        buttonPressed == 'Y'
                                            ? BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.8),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                                spreadRadius: 0,
                                              )
                                            : BoxShadow(
                                                color: Colors.green
                                                    .withOpacity(0.5),
                                                offset: Offset(0, 1),
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                              ),
                                      ],
                                    ),
                                    child: Center(
                                        child: Transform(
                                      transform: Matrix4.rotationZ(
                                          pi / 2), // Sudut rotasi dalam radian
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Y',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTapDown: (_) {
                                    setState(() {
                                      buttonPressed = 'X';
                                      sendDataJoyPad(buttonXFree);
                                      print(buttonPressed);
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      buttonPressed = '';
                                      sendDataJoyPad(diamFree);
                                      print(buttonPressed);
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: buttonPressed == 'X'
                                          ? Colors.red.withOpacity(0.8)
                                          : Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        buttonPressed == 'X'
                                            ? BoxShadow(
                                                color:
                                                    Colors.red.withOpacity(0.8),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                                spreadRadius: 0,
                                              )
                                            : BoxShadow(
                                                color:
                                                    Colors.red.withOpacity(0.5),
                                                offset: Offset(0, 1),
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                              ),
                                      ],
                                    ),
                                    child: Center(
                                        child: Transform(
                                      transform: Matrix4.rotationZ(
                                          pi / 2), // Sudut rotasi dalam radian
                                      alignment: Alignment.center,
                                      child: Text(
                                        'X',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTapDown: (_) {
                                    setState(() {
                                      buttonPressed = 'B';
                                      sendDataJoyPad(buttonBFree);
                                      print(buttonPressed);
                                    });
                                  },
                                  onTapUp: (_) {
                                    setState(() {
                                      buttonPressed = '';
                                      sendDataJoyPad(diamFree);
                                      print(buttonPressed);
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: buttonPressed == 'B'
                                          ? Colors.yellow.withOpacity(0.8)
                                          : Colors.yellow,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        buttonPressed == 'B'
                                            ? BoxShadow(
                                                color: Colors.yellow
                                                    .withOpacity(0.8),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                                spreadRadius: 0,
                                              )
                                            : BoxShadow(
                                                color: Colors.yellow
                                                    .withOpacity(0.5),
                                                offset: Offset(0, 1),
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                              ),
                                      ],
                                    ),
                                    child: Center(
                                        child: Transform(
                                      transform: Matrix4.rotationZ(
                                          pi / 2), // Sudut rotasi dalam radian
                                      alignment: Alignment.center,
                                      child: Text(
                                        'B',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          pi / 2), // Sudut rotasi dalam radian
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () {
                            listeningData = false;
                            changePage = menuUtama;
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 30,
                          )),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 50),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Transform.rotate(
                    angle: 180 * 0.0174533,
                    child: Container(
                      width: 50,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 77, 75, 75)
                                  .withOpacity(0.9),
                              offset: Offset(3, 0),
                              blurRadius: 10,
                              spreadRadius: 0,
                            )
                          ]),
                      child: Transform.rotate(
                          angle: 270 * 0.0174533,
                          child: Center(
                              child: Text(
                            '${arrowPressed}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      ;
    }

    Widget JoyPadWidget() {
      rotateCondition = true;
      return WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background/bgGameJoy.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: Stack(
                        children: [
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () {
                                  print(
                                      'ini data yang di kirim : ${buttonKanan}');
                                  sendDataJoyPad(buttonKanan);
                                  Future.delayed(Duration(milliseconds: 200),
                                      () {
                                    sendDataJoyPad(diam);
                                    checkAnswer(buttonKanan);
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 100),
                                  child: Container(
                                      height: 90,
                                      child: Image.asset(arrowPressed == 'KANAN'
                                          ? 'assets/images/arrow.png'
                                          : 'assets/images/arrowOnClick.png')),
                                ),
                              )),
                          Align(
                              alignment: Alignment.topCenter,
                              child: Transform.rotate(
                                angle: 180 * 0.0174533,
                                child: GestureDetector(
                                  onTap: () {
                                    print(
                                        'ini data yang di kirim : ${buttonKiri}');
                                    sendDataJoyPad(buttonKiri);
                                    Future.delayed(Duration(milliseconds: 200),
                                        () {
                                      sendDataJoyPad(diam);
                                      checkAnswer(buttonKiri);
                                    });
                                  },
                                  child: Container(
                                      height: 90,
                                      child: Image.asset(arrowPressed == 'KIRI'
                                          ? 'assets/images/arrow.png'
                                          : 'assets/images/arrowOnClick.png')),
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerRight,
                              child: Transform.rotate(
                                angle: 270 * 0.0174533,
                                child: GestureDetector(
                                  onTap: () {
                                    print(
                                        'ini data yang di kirim : ${buttonMaju}');
                                    sendDataJoyPad(buttonMaju);
                                    Future.delayed(Duration(milliseconds: 200),
                                        () {
                                      sendDataJoyPad(diam);
                                      checkAnswer(buttonMaju);
                                    });
                                  },
                                  child: Container(
                                      height: 90,
                                      child: Image.asset(arrowPressed == 'MAJU'
                                          ? 'assets/images/arrow.png'
                                          : 'assets/images/arrowOnClick.png')),
                                ),
                              )),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Transform.rotate(
                                angle: 90 * 0.0174533,
                                child: GestureDetector(
                                  onTap: () {
                                    print(
                                        'ini data yang di kirim : ${buttonMundur}');
                                    sendDataJoyPad(buttonMundur);
                                    Future.delayed(Duration(milliseconds: 200),
                                        () {
                                      sendDataJoyPad(diam);
                                      checkAnswer(buttonMundur);
                                    });
                                  },
                                  child: Container(
                                      height: 90,
                                      child: Image.asset(arrowPressed ==
                                              'MUNDUR'
                                          ? 'assets/images/arrow.png'
                                          : 'assets/images/arrowOnClick.png')),
                                ),
                              ))
                        ],
                      ),
                    ),
                    SizedBox(height: 150),
                    Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    sendDataJoyPad(buttonX);
                                    Future.delayed(Duration(milliseconds: 200),
                                        () {
                                      sendDataJoyPad(diam);
                                      checkAnswer(buttonX);
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: buttonPressed == 'X'
                                          ? Colors.red.withOpacity(0.8)
                                          : Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        buttonPressed == 'X'
                                            ? BoxShadow(
                                                color:
                                                    Colors.red.withOpacity(0.8),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                                spreadRadius: 0,
                                              )
                                            : BoxShadow(
                                                color:
                                                    Colors.red.withOpacity(0.5),
                                                offset: Offset(0, 1),
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                              ),
                                      ],
                                    ),
                                    child: Center(
                                        child: Transform(
                                      transform: Matrix4.rotationZ(
                                          pi / 2), // Sudut rotasi dalam radian
                                      alignment: Alignment.center,
                                      child: Text(
                                        'X',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                              // BUTTON A
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: GestureDetector(
                                  onTapDown: (_) {
                                    sendDataJoyPad(buttonA);
                                    Future.delayed(Duration(milliseconds: 200),
                                        () {
                                      sendDataJoyPad(diam);
                                      checkAnswer(buttonA);
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 100),
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: buttonPressed == 'A'
                                          ? Colors.blue.withOpacity(0.8)
                                          : Colors.blue,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        buttonPressed == 'A'
                                            ? BoxShadow(
                                                color: Colors.blue
                                                    .withOpacity(0.8),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                                spreadRadius: 0,
                                              )
                                            : BoxShadow(
                                                color: Colors.blue
                                                    .withOpacity(0.5),
                                                offset: Offset(0, 1),
                                                blurRadius: 3,
                                                spreadRadius: 0,
                                              ),
                                      ],
                                    ),
                                    child: Center(
                                        child: Transform(
                                      transform: Matrix4.rotationZ(
                                          pi / 2), // Sudut rotasi dalam radian
                                      alignment: Alignment.center,
                                      child: Text(
                                        'A',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                    alignment: Alignment.topRight,
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          pi / 2), // Sudut rotasi dalam radian
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () {
                            _stopTimer();
                            _resetTimer();
                            changePage = gameLevel;
                            getUserData(selectedAccount);

                            answerJoypad.clear();
                            setState(() {});
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 30,
                          )),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Transform(
                      transform: Matrix4.rotationZ(
                          pi / 2), // Sudut rotasi dalam radian
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Transform.rotate(
                                  angle: 90 *
                                      (pi / 180), // 90 derajat dalam radian
                                  child: TextStory(
                                    message: desiredStory,
                                    buttonText: 'Oke',
                                    width: MediaQuery.of(context).size.height *
                                        0.8,
                                    height: MediaQuery.of(context).size.width,
                                    onButtonPressed: () {
                                      _startTimer();
                                      Navigator.pop(context);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.info_outline_rounded,
                            color: Colors.white,
                            size: 30,
                          )),
                    )),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Transform.rotate(
                  angle: 180 * 0.0174533,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: 150,
                      height: 50,
                      child: Transform.rotate(
                        angle: 270 * 0.0174533,
                        child: StreamBuilder<int>(
                          stream: timerStream,
                          builder: (context, snapshot) {
                            final seconds = snapshot.data ?? 0;
                            final formattedTime = formatTime(seconds);
                            return Text(
                              '$formattedTime',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget CardPage() {
      rotateCondition = false;
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF4E50), Color(0xFFF9D423)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              offset: Offset(-6.0, -6.0),
              blurRadius: 16.0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: Offset(6.0, 6.0),
              blurRadius: 16.0,
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              offset: Offset(-6.0, 6.0),
              blurRadius: 16.0,
            ),
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              offset: Offset(6.0, -6.0),
              blurRadius: 16.0,
            ),
          ],
        ),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 60.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                colors: [Color(0xFFFF4E50), Color(0xFFF9D423)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  offset: Offset(-6.0, -6.0),
                  blurRadius: 16.0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: Offset(6.0, 6.0),
                  blurRadius: 16.0,
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  offset: Offset(-6.0, 6.0),
                  blurRadius: 16.0,
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  offset: Offset(6.0, -6.0),
                  blurRadius: 16.0,
                ),
              ],
              border: Border.all(
                color: Colors.grey.shade400,
                width: 2.0,
              ),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () async {
                        changePage = gameLevel;
                        getUserData(selectedAccount);
                        _stopTimer();
                        _resetTimer();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'KARTU RFID', // Main Level
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<int>(
              stream: timerStream,
              builder: (context, snapshot) {
                final seconds = snapshot.data ?? 0;
                final formattedTime = formatTime(seconds);
                return Column(
                  children: [
                    Text(
                      'Waktu',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      '$formattedTime',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 253, 93, 96),
                      Color.fromARGB(255, 177, 154, 40)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      offset: Offset(-6.0, -6.0),
                      blurRadius: 16.0,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(6.0, 6.0),
                      blurRadius: 16.0,
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      offset: Offset(-6.0, 6.0),
                      blurRadius: 16.0,
                    ),
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      offset: Offset(6.0, -6.0),
                      blurRadius: 16.0,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.shade400,
                    width: 2.0,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      desiredStory,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              width: 500,
              child: Image.asset(
                'assets/images/TAP.png',
                width: wdLayer * 0.8,
              ),
            ),
          ),
          Text(
            'Tempelkan Kartu Di Kepala Hirro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ]),
      );
    }

    void changeMenuBluetoothCheck({required String menuSelect}) {
      if (_bluetoothState.isEnabled) {
        if (_device == null || _connected == false) {
          show('sambungkan bluetooth HIRRO');
        } else {
          changePage = menuSelect;
          setState(() {});
        }
      } else {
        show('nyalakan bluetooth');
      }
    }

    Widget MainMenu() {
      return Stack(
        children: [
          Positioned(
            bottom: 0,
            left: _backgroundPosition,
            child: Image.asset('assets/background/bg1.jpg',
                width: backgroundWidth,
                height: MediaQuery.of(context).size.height,
                fit: BoxFit.fitHeight,
                scale: 0.1),
          ),
          Center(
            child: AnimatedOpacity(
              opacity: _showWidget ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/logo.png',
                    width: wdLayer * 0.8,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  // FloatingActionButton(onPressed: () {
                  //   print('clicked');
                  //     setState(() {
                  //       _showWidget = false;
                  //     });
                  //     _controller.forward().then((value) {
                  //       setState(() {
                  //         _showWidget2 = true;
                  //       });
                  //       _controller.forward();
                  //     });
                  // }),

                  // AluminumButton(
                  //   label: 'Play',
                  //   onPressed: () {
                  //     print('clicked');
                  //     setState(() {
                  //       _showWidget = false;
                  //     });
                  //     _controller.forward().then((value) {
                  //       setState(() {
                  //         _showWidget2 = true;
                  //       });
                  //       _controller.forward();
                  //     });
                  //   },
                  // ),
                ],
              ),
            ),
          ),
          Center(
            child: AnimatedOpacity(
              opacity: _showWidget2 ? 1.0 : 0.0,
              duration: Duration(milliseconds: 500),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Hallo, ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        AccountDropdown(
                            accountList: nameUsers,
                            selectedAccount: selectedAccount,
                            onChanged: (newValue) {
                              setState(() {
                                getUserInfo(nama: newValue!);
                                if (newValue == 'tambah akun') {
                                  showRegisterDialog(context);
                                }
                                getAllUser();
                                selectedAccount = newValue;
                              });
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        LeaderBoard(),
                        SizedBox(
                          height: 50,
                        ),
                        AluminumButton(
                          click: true,
                          label: 'MULAI BERMAIN',
                          onPressed: () async {
                            // masuk level 1
                            if (selectedAccount ==
                                '' /*|| _connected == false*/) {
                              if (selectedAccount == '') {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomPopup(
                                      message: 'Belum Memilih Akun',
                                      buttonText: 'Oke',
                                      onButtonPressed: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              }

                              //   if (_connected == false) {
                              //   showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return CustomPopup(
                              //         message: 'bluetooth Belum tersambung',
                              //         buttonText: 'Oke',
                              //         onButtonPressed: () {
                              //           Navigator.pop(context);
                              //           changePage = menuBluetooth;
                              //           setState(() {});
                              //         },
                              //       );
                              //     },
                              //   );
                              // } else {
                              //   listeningData = false;
                              //   changePage = menuJoypadFree;
                              //   setState(() {});
                              // }
                            } else {
                              listeningData = true;
                              changePage = gameLevel;
                              getUserData(selectedAccount);
                              setState(() {});

                              // Retrieve a User object by name
                              final User? user = await databaseUser
                                  .getUserByName(selectedAccount);

                              if (user != null) {
                                print('Name: ${user.name}');
                                print('Last Level: ${user.lastLevel}');
                                print('Sub Level: ${user.subLevel}');
                                print('Score: ${user.score}');
                              } else {
                                print(
                                    'User not found.'); // Handle the case when the user is not found
                              }
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AluminumButton(
                          click: dataUser.isNotEmpty &&
                                  int.parse(dataUser['lastLevel']) >= 5 &&
                                  int.parse(dataUser['subLevel']) >= 1
                              ? true
                              : false,
                          label: 'Joypad',
                          onPressed: () {
                            if (int.parse(dataUser['lastLevel']) >= 5 &&
                                int.parse(dataUser['subLevel']) >= 1) {
                              if (_connected == false) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomPopup(
                                      message: 'bluetooth Belum tersambung',
                                      buttonText: 'Oke',
                                      onButtonPressed: () {
                                        Navigator.pop(context);
                                        changePage = menuBluetooth;
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              } else {
                                listeningData = false;
                                changePage = menuJoypadFree;
                                setState(() {});
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomPopup(
                                    message: 'Selesaikan level 5',
                                    buttonText: 'Oke',
                                    onButtonPressed: () {
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AluminumButton(
                          click: dataUser.isNotEmpty &&
                                  int.parse(dataUser['lastLevel']) >= 5 &&
                                  int.parse(dataUser['subLevel']) >= 1
                              ? true
                              : false,
                          label: 'Blok program',
                          onPressed: () {
                            // masuk level 1
                            if (int.parse(dataUser['lastLevel']) >= 5 &&
                                int.parse(dataUser['subLevel']) >= 1) {
                              if (_connected == false) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return CustomPopup(
                                      message: 'Bluetooth belum Terhubung',
                                      buttonText: 'Oke',
                                      onButtonPressed: () {
                                        Navigator.pop(context);
                                        changePage = menuBluetooth;
                                        setState(() {});
                                      },
                                    );
                                  },
                                );
                              } else {
                                jenisProgram = 'program3';
                                infoPetunjuk =
                                    'Kamu dapat bebas menggerakan hirro';
                                freeProgram = true;
                                changePage = menuProgram;
                                setState(() {});
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomPopup(
                                    message: 'Selesaikan level 5',
                                    buttonText: 'Oke',
                                    onButtonPressed: () {
                                      Navigator.pop(context);
                                      setState(() {});
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 60, right: 40),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                changePage = menuBluetooth;
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.bluetooth,
                                size: 50,
                                color: Colors.white,
                              )),
                          SizedBox(width: 20),
                          IconButton(
                              onPressed: () {
                                // pauseAudio();
                                // _showPopup();
                                // _sendMessageString('Data dari flutter');
                                // _listenForData();
                                changePage = menuInfoPemain;
                                print('monitor : Data User = ${dataUser}');
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.info_outline_rounded,
                                size: 50,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    Widget InfoPemain() {
      return FutureBuilder<User?>(
          future: getUserInfoByName(selectedAccount),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              print('menampilkan info pemain');
              final User? user = snapshot.data;
              if (user != null) {
                return Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: _backgroundPosition,
                      child: Image.asset('assets/background/bg1.jpg',
                          width: backgroundWidth,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.fitHeight,
                          scale: 0.1),
                    ),
                    Center(
                      child: AnimatedOpacity(
                        opacity: _showWidget2 ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(155, 255, 78, 81),
                                              Color(0xFFF9D423)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              offset: Offset(-6.0, -6.0),
                                              blurRadius: 16.0,
                                            ),
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              offset: Offset(6.0, 6.0),
                                              blurRadius: 16.0,
                                            ),
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              offset: Offset(-6.0, 6.0),
                                              blurRadius: 16.0,
                                            ),
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              offset: Offset(6.0, -6.0),
                                              blurRadius: 16.0,
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,
                                                  height: 60.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30.0),
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Color(0xFFFF4E50),
                                                        Color(0xFFF9D423)
                                                      ],
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.white
                                                            .withOpacity(0.2),
                                                        offset:
                                                            Offset(-6.0, -6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.3),
                                                        offset:
                                                            Offset(6.0, 6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        offset:
                                                            Offset(-6.0, 6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.1),
                                                        offset:
                                                            Offset(6.0, -6.0),
                                                        blurRadius: 16.0,
                                                      ),
                                                    ],
                                                    border: Border.all(
                                                      color:
                                                          Colors.grey.shade400,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              child: IconButton(
                                                                onPressed: () {
                                                                  changePage =
                                                                      menuUtama;
                                                                  print(
                                                                      'kembali');
                                                                  setState(
                                                                      () {});
                                                                },
                                                                icon: Icon(
                                                                  Icons.close,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                                      Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'Info Pemain', // Main Level
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Name: ${user.name}',
                                                      style: TextStyle(
                                                        fontSize:
                                                            20, // Ubah ukuran font menjadi 20
                                                        color: Colors
                                                            .white, // Ubah warna teks menjadi putih
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Last Level: ${user.lastLevel}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Sub Level: ${user.subLevel}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Score: ${user.score}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 50),
                                                child: IconButton(
                                                    icon: Icon(
                                                        Icons
                                                            .delete_forever_rounded,
                                                        size: 50,
                                                        color: Colors.white),
                                                    onPressed: () async {
                                                      await databaseUser
                                                          .deleteUserByName(
                                                              selectedAccount);
                                                      selectedAccount = '';
                                                      toListAllName();
                                                      getAllUser();
                                                      changePage = menuUtama;
                                                      setState(() {});
                                                    }),
                                              )
                                            ])),
                                  ]),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 60, right: 40),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          changePage = menuBluetooth;
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.bluetooth,
                                          size: 50,
                                          color: Colors.white,
                                        )),
                                    SizedBox(width: 20),
                                    IconButton(
                                        onPressed: () {
                                          // pauseAudio();
                                          // _showPopup();
                                          // _sendMessageString('Data dari flutter');
                                          // _listenForData();
                                          changePage = menuUtama;
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.info_outline_rounded,
                                          size: 50,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                print('menampilkan container 1');
                return Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      left: _backgroundPosition,
                      child: Image.asset('assets/background/bg1.jpg',
                          width: backgroundWidth,
                          height: MediaQuery.of(context).size.height,
                          fit: BoxFit.fitHeight,
                          scale: 0.1),
                    ),
                    Center(
                      child: AnimatedOpacity(
                        opacity: _showWidget2 ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(155, 255, 78, 81),
                                              Color(0xFFF9D423)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              offset: Offset(-6.0, -6.0),
                                              blurRadius: 16.0,
                                            ),
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              offset: Offset(6.0, 6.0),
                                              blurRadius: 16.0,
                                            ),
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              offset: Offset(-6.0, 6.0),
                                              blurRadius: 16.0,
                                            ),
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              offset: Offset(6.0, -6.0),
                                              blurRadius: 16.0,
                                            ),
                                          ],
                                          border: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 2.0,
                                          ),
                                        ),
                                        child: Column(children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: 60.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFFFF4E50),
                                                    Color(0xFFF9D423)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.white
                                                        .withOpacity(0.2),
                                                    offset: Offset(-6.0, -6.0),
                                                    blurRadius: 16.0,
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    offset: Offset(6.0, 6.0),
                                                    blurRadius: 16.0,
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    offset: Offset(-6.0, 6.0),
                                                    blurRadius: 16.0,
                                                  ),
                                                  BoxShadow(
                                                    color: Colors.grey
                                                        .withOpacity(0.1),
                                                    offset: Offset(6.0, -6.0),
                                                    blurRadius: 16.0,
                                                  ),
                                                ],
                                                border: Border.all(
                                                  color: Colors.grey.shade400,
                                                  width: 2.0,
                                                ),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: Colors.red,
                                                          ),
                                                          child: IconButton(
                                                            onPressed: () {
                                                              changePage =
                                                                  menuUtama;
                                                              print('kembali');
                                                              setState(() {});
                                                            },
                                                            icon: Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Info Pemain', // Main Level
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]))
                                  ]),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 60, right: 40),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          changePage = menuBluetooth;
                                          setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.bluetooth,
                                          size: 50,
                                          color: Colors.white,
                                        )),
                                    SizedBox(width: 20),
                                    IconButton(
                                        onPressed: () {
                                          // pauseAudio();
                                          // _showPopup();
                                          // _sendMessageString('Data dari flutter');
                                          // _listenForData();
                                          // changePage = menuInfo;
                                          // setState(() {});
                                        },
                                        icon: Icon(
                                          Icons.info_outline_rounded,
                                          size: 50,
                                          color: Colors.white,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            } else {
              print('menampilkan container 2');
              return Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: _backgroundPosition,
                    child: Image.asset('assets/background/bg1.jpg',
                        width: backgroundWidth,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.fitHeight,
                        scale: 0.1),
                  ),
                  Center(
                    child: AnimatedOpacity(
                      opacity: _showWidget2 ? 1.0 : 0.0,
                      duration: Duration(milliseconds: 500),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(155, 255, 78, 81),
                                            Color(0xFFF9D423)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.white.withOpacity(0.2),
                                            offset: Offset(-6.0, -6.0),
                                            blurRadius: 16.0,
                                          ),
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            offset: Offset(6.0, 6.0),
                                            blurRadius: 16.0,
                                          ),
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            offset: Offset(-6.0, 6.0),
                                            blurRadius: 16.0,
                                          ),
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            offset: Offset(6.0, -6.0),
                                            blurRadius: 16.0,
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.9,
                                            height: 60.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xFFFF4E50),
                                                  Color(0xFFF9D423)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.2),
                                                  offset: Offset(-6.0, -6.0),
                                                  blurRadius: 16.0,
                                                ),
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                  offset: Offset(6.0, 6.0),
                                                  blurRadius: 16.0,
                                                ),
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  offset: Offset(-6.0, 6.0),
                                                  blurRadius: 16.0,
                                                ),
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.1),
                                                  offset: Offset(6.0, -6.0),
                                                  blurRadius: 16.0,
                                                ),
                                              ],
                                              border: Border.all(
                                                color: Colors.grey.shade400,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: Stack(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.red,
                                                        ),
                                                        child: IconButton(
                                                          onPressed: () {
                                                            changePage =
                                                                menuUtama;
                                                            print('kembali');
                                                            setState(() {});
                                                          },
                                                          icon: Icon(
                                                            Icons.close,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Info Pemain', // Main Level
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]))
                                ]),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 60, right: 40),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        changePage = menuBluetooth;
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.bluetooth,
                                        size: 50,
                                        color: Colors.white,
                                      )),
                                  SizedBox(width: 20),
                                  IconButton(
                                      onPressed: () {
                                        // pauseAudio();
                                        // _showPopup();
                                        // _sendMessageString('Data dari flutter');
                                        // _listenForData();
                                        // changePage = menuInfo;
                                        // setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.info_outline_rounded,
                                        size: 50,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          });
    }

    Future<void> openAppSettings() async {
      if (await Permission.location.request().isGranted) {
        // Izin lokasi telah diberikan
        return;
      }

      if (await Permission.location.isPermanentlyDenied) {
        // Izin lokasi telah ditolak secara permanen
        // Tampilkan pesan atau tindakan yang sesuai
        return;
      }

      try {
        await openAppSettings();
      } on PlatformException catch (e) {
        print('Error: ${e.message}');
      }
    }

    void printUserList(List<User> users) {
      for (var user in users) {
        print(
            'Name: ${user.name}, Last Level: ${user.lastLevel}, Score: ${user.score}');
      }
    }

    Widget SubLevel() {
      return RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () async {
          // Simulate data fetching
          await Future.delayed(Duration(seconds: 1));
          getUserData(selectedAccount);
          // Fetch data here or update your data source
          setState(() {});
        },
        child: FutureBuilder<User?>(
            future: getUserData(selectedAccount),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                User user = snapshot.data!;
                final String? lastLevel = user.lastLevel;
                return GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/background/lv${user.lastLevel}.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: 60.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF4E50), Color(0xFFF9D423)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  offset: Offset(-6.0, -6.0),
                                  blurRadius: 16.0,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: Offset(6.0, 6.0),
                                  blurRadius: 16.0,
                                ),
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  offset: Offset(-6.0, 6.0),
                                  blurRadius: 16.0,
                                ),
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.1),
                                  offset: Offset(6.0, -6.0),
                                  blurRadius: 16.0,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 2.0,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomPopup(
                                              message:
                                                  'Apakah anda ingin keluar dari permainan?',
                                              buttonText: 'Ya',
                                              onButtonPressed: () {
                                                Navigator.pop(context);
                                                dataUser.clear();
                                                selectedAccount = '';
                                                levelSebelumnya = 1;
                                                changePage = menuUtama;
                                                print('kembali');
                                                setState(() {});
                                              },
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: Colors.white,
                                      )),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${levelStory[int.parse(user.lastLevel) - 1]['lvName']}', // Main Level
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  2, // Number of columns in the grid
                              mainAxisSpacing:
                                  20.0, // Vertical spacing between items
                              crossAxisSpacing:
                                  20.0, // Horizontal spacing between items
                            ),
                            itemCount: 6, // Total number of items to display
                            shrinkWrap:
                                true, // Allow GridView to take the necessary space
                            physics:
                                NeverScrollableScrollPhysics(), // Disable scrolling of GridView
                            itemBuilder: (context, index) {
                              final levelText = (index + 1).toString();

                              bool subLevelOpen = false; // Default value

                              if (int.parse(user.subLevel) >= 1 &&
                                  int.parse(user.subLevel) <= 6) {
                                if (int.parse(user.subLevel) == 6 ||
                                    int.parse(levelText) ==
                                        int.parse(user.subLevel)) {
                                  subLevelOpen = true;
                                }
                              }

                              if (int.parse(user.lastLevel) > levelSebelumnya) {
                                print('mereset level');
                                if (index >= 1 && index <= 5) {
                                  subLevelOpen =
                                      false; // Set subLevelOpen to false for index 1 to 5
                                  // levelSebelumnya++;
                                  print(
                                      'ini level sebelumnya ${levelSebelumnya}');
                                  indexButton++;
                                  if (indexButton == 5) {
                                    indexButton = 0;
                                    levelSebelumnya = int.parse(user.lastLevel);
                                  }
                                }
                              }

                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: LevelButton(
                                  levelOpen: subLevelOpen,
                                  levelText: levelText,
                                  onTap: () async {
                                    setState(() {});
                                    if (subLevelOpen == false) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomPopup(
                                            message: 'Maaf Level Belum Terbuka',
                                            buttonText: 'Oke',
                                            onButtonPressed: () {
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    } else {
                                      desiredStory = levelStory[
                                                  int.parse(user.lastLevel) -
                                                      1]['isiLv']['subStory']
                                              ['story${index + 1}']
                                          .toString();

                                      List jawaban = levelStory[
                                              int.parse(dataUser['lastLevel']) -
                                                  1]['isiLv']['jawaban']
                                          ['jawaban${index + 1}'];

                                      print(
                                          'Jawaban : ${levelStory[int.parse(dataUser['lastLevel']) - 1]['isiLv']['jawaban']['jawaban${index + 1}']}');
                                      // control blok level
                                      // masuk halaman sesuai level
                                      if (index ==
                                          int.parse(user.subLevel) - 1) {
                                        print(
                                            'Monitor : ini index : ${index} dan ini subLevel : ${user.subLevel}');
                                        // Jika tombol yang ditekan sesuai dengan subLevel yang sekarang
                                        print(
                                            'Monitor : Tombol dengan level $levelText ditekan sesuai dengan subLevel yang sekarang');

                                        if (user.lastLevel == '2') {
                                          isFirstG = true;
                                        } else {
                                          isFirstG = false;
                                        }
                                        switch (user.subLevel) {
                                          case '1':
                                            print('buka level 2');
                                            dataUser['subLevel'] = '2';
                                            subLevel = '2';
                                            break;
                                          case '2':
                                            print('buka level 3');
                                            dataUser['subLevel'] = '3';
                                            subLevel = '3';
                                            break;
                                          case '3':
                                            print('buka level 4');
                                            dataUser['subLevel'] = '4';
                                            subLevel = '4';
                                            break;
                                          case '4':
                                            print('buka level 5');
                                            dataUser['subLevel'] = '5';
                                            subLevel = '5';
                                            break;
                                          case '5':
                                            print('FINAL SUB LEVEL');
                                            dataUser['subLevel'] = '6';
                                            subLevel = '6';
                                            break;
                                          default:
                                            print('Level tidak valid');
                                        }

                                        switch (dataUser['lastLevel']) {
                                          case '1':
                                            print(
                                                'Navigator to Joypad di sub level : ${index + 1}');
                                            subLevelDipilih = index + 1;
                                            cekIndex = 0;
                                            setInstruction(
                                                rotate: true,
                                                answer: jawaban,
                                                context: context,
                                                message: desiredStory);
                                            changePage = menuJoypad;
                                            break;
                                          case '2':
                                            print(
                                                'Navigator to Card di sub level : ${index + 1}');
                                            subLevelDipilih = index + 1;
                                            setInstruction(
                                                rotate: false,
                                                answer: jawaban,
                                                context: context,
                                                message: desiredStory);
                                            changePage = menuRFID;
                                            break;
                                          case '3':
                                            print(
                                                'Navigator to Program Blok di sub level : ${index + 1}');
                                            subLevelDipilih = index + 1;
                                            infoPetunjuk = desiredStory;
                                            setInstruction(
                                                rotate: false,
                                                answer: jawaban,
                                                context: context,
                                                message: desiredStory);
                                            jenisProgram = 'program1';
                                            changePage = menuProgram;
                                            break;
                                          case '4':
                                            print(
                                                'Navigator to Program Perulangan di sub level : ${index + 1}');
                                            subLevelDipilih = index + 1;
                                            infoPetunjuk = desiredStory;
                                            setInstruction(
                                                rotate: false,
                                                answer: jawaban,
                                                context: context,
                                                message: desiredStory);
                                            jenisProgram = 'program2';
                                            changePage = menuProgram;
                                            break;
                                          case '5':
                                            print(
                                                'Navigator to Masih Belum Ada di sub level : ${index + 1}');
                                            subLevelDipilih = index + 1;
                                            infoPetunjuk = desiredStory;
                                            setInstruction(
                                                rotate: false,
                                                answer: jawaban,
                                                context: context,
                                                message: desiredStory);
                                            jenisProgram = 'program3';
                                            changePage = menuProgram;
                                            break;
                                          default:
                                            print('Level tidak valid');
                                        }
                                      } else {
                                        switch (dataUser['lastLevel']) {
                                          case '1':
                                            print(
                                                'Navigator to Joypad di sub level : ${index + 1}');
                                            subLevelDipilih = index + 1;
                                            setInstruction(
                                                rotate: true,
                                                answer: jawaban,
                                                context: context,
                                                message: desiredStory);
                                            changePage = menuJoypad;
                                            break;
                                          case '2':
                                            print(
                                                'Navigator to Card di sub level : ${index + 1}');
                                            subLevelDipilih = index + 1;
                                            setInstruction(
                                                rotate: false,
                                                answer: jawaban,
                                                context: context,
                                                message: desiredStory);
                                            changePage = menuRFID;
                                            break;
                                          case '3':
                                            print(
                                                'Navigator to Program Blok di sub level : ${index + 1}');
                                            subLevelDipilih = index + 1;
                                            infoPetunjuk = desiredStory;
                                            setInstruction(
                                                rotate: false,
                                                answer: jawaban,
                                                context: context,
                                                message: desiredStory);
                                            jenisProgram = 'program1';
                                            changePage = menuProgram;
                                            break;
                                          case '4':
                                            print(
                                                'Navigator to Program Perulangan di sub level : ${index + 1}');
                                            subLevelDipilih = index + 1;
                                            infoPetunjuk = desiredStory;
                                            setInstruction(
                                                rotate: false,
                                                answer: jawaban,
                                                context: context,
                                                message: desiredStory);
                                            jenisProgram = 'program2';
                                            changePage = menuProgram;
                                            break;
                                          case '5':
                                            print(
                                                'Navigator to Masih Belum Ada di sub level : ${index + 1}');
                                            subLevelDipilih = index + 1;
                                            infoPetunjuk = desiredStory;
                                            setInstruction(
                                                rotate: false,
                                                answer: jawaban,
                                                context: context,
                                                message: desiredStory);
                                            jenisProgram = 'program3';
                                            changePage = menuProgram;
                                            break;
                                          default:
                                            print('Level tidak valid');
                                        }
                                      }
                                      print(
                                          'monitor :lastLevel : ${dataUser['lastLevel']} ,Sub Level : ${dataUser['subLevel']}');
                                      setState(() {});
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          int.parse(user.lastLevel) < 5
                              ? AluminumButton(
                                  click: int.parse(user.subLevel) > 1
                                      ? true
                                      : false,
                                  label: 'Lanjut ${user.lastLevel}',
                                  onPressed: () async {
                                    print(user.subLevel);
                                    if (int.parse(user.subLevel) > 1 &&
                                        int.parse(user.lastLevel) <= 5) {
                                      print('Next level');
                                      print(user.lastLevel);
                                      int levelInt = int.parse(user.lastLevel);
                                      levelInt++;

                                      if (user.lastLevel == '2') {
                                        levelTwo = true;
                                      } else {
                                        levelTwo = false;
                                      }

                                      await databaseUser.updateUserByName(
                                          selectedAccount,
                                          lastLevel: levelInt.toString());
                                      await databaseUser.updateUserByName(
                                          selectedAccount,
                                          subLevel: '1');
                                      dataUser['subLevel'] = '1';
                                      int _levelSelanjutnya =
                                          int.parse(dataUser['lastLevel']) + 1;
                                      dataUser['lastLevel'] =
                                          _levelSelanjutnya.toString();
                                      print(dataUser);
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomPopup(
                                            message:
                                                'Selesaikan rintangan pada level ini terlebih dahulu',
                                            buttonText: 'Oke',
                                            onButtonPressed: () {
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    }
                                    setState(() {});
                                  })
                              : Container()
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return Stack(children: []);
              }
            }),
      );
    }

    // program drag and drop
    Widget DragAndDropWidget(
        {required String condition,
        required String message,
        required bool free}) {
        
      listeningData = false;
      rotateCondition = false;
      return Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: hgLayer * 0.06,
              ),
              Container(
                height: 200,
                alignment: Alignment.bottomCenter,
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          'BLOK KODE',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      condition == 'program2' || condition == 'program3'
                          ? Container(
                              height: blokChange == 'program'
                                  ? hgLayer * 0.12
                                  : blokChange == 'kontrol'
                                      ? hgLayer * 0.20
                                      : hgLayer * 0.12,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        blokChange == 'program'
                                            ? Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(width: 8),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 25),
                                                    child: blocksMotionProgram(
                                                        'kanan'),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 25),
                                                    child: blocksMotionProgram(
                                                        'kiri'),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 25),
                                                    child: blocksMotionProgram(
                                                        'lurus'),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 25),
                                                    child: blocksMotionProgram(
                                                        'pb'),
                                                  ),
                                                  SizedBox(width: 8),
                                                ],
                                              )
                                            : blokChange == 'kontrol'
                                                ? Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      SizedBox(width: 8),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 25),
                                                        child:
                                                            blocksMotionKontrol(
                                                                'if'),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 25),
                                                        child:
                                                            blocksMotionKontrol(
                                                                'for'),
                                                      ),
                                                      SizedBox(width: 8),
                                                    ],
                                                  )
                                                : blokChange == 'statement'
                                                    ? Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          SizedBox(width: 8),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 25),
                                                            child: blocksMotionStatement(
                                                                'ada persimpangan'),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 25),
                                                            child:
                                                                blocksMotionStatement(
                                                                    '2 kali'),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 25),
                                                            child:
                                                                blocksMotionStatement(
                                                                    '3 kali'),
                                                          ),
                                                          SizedBox(width: 8),
                                                          condition ==
                                                                  'program3'
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 25),
                                                                  child: blocksMotionStatement(
                                                                      'ada benda'),
                                                                )
                                                              : Container(),
                                                          SizedBox(width: 8),
                                                          // Padding(
                                                          //   padding:
                                                          //       const EdgeInsets
                                                          //               .only(
                                                          //           top: 25),
                                                          //   child:
                                                          //       blocksMotionStatement(
                                                          //           '2 kali'),
                                                          // ),
                                                        ],
                                                      )
                                                    : blokChange == 'body'
                                                        ? Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            children: [
                                                              SizedBox(
                                                                  width: 8),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            25),
                                                                child: blocksMotionBody(
                                                                    'belok kanan'),
                                                              ),
                                                              SizedBox(
                                                                  width: 8),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            25),
                                                                child:
                                                                    blocksMotionBody(
                                                                        'maju'),
                                                              ),
                                                              SizedBox(
                                                                  width: 8),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            25),
                                                                child: blocksMotionBody(
                                                                    'belok kiri'),
                                                              ),
                                                              SizedBox(
                                                                  width: 8),
                                                              condition == 'program3'
                                                                  ? Padding(padding: const EdgeInsets.only(top:25),
                                                                      child: blocksMotionBody( 'ambil barang'),): Container(),
                                                              SizedBox(
                                                                  width: 8),
                                                              condition == 'program3'
                                                                  ? Padding(padding: const EdgeInsets.only(top:25),
                                                                      child: blocksMotionBody( 'lepas barang'),): Container()
                                                            ],
                                                          )
                                                        : Container(),
                                      ],
                                    ),
                                  )),
                            )
                          : Container(
                              height: hgLayer * 0.12,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(width: 8),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25),
                                          child: blocksMotionProgram('kanan'),
                                        ),
                                        SizedBox(width: 8),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25),
                                          child: blocksMotionProgram('kiri'),
                                        ),
                                        SizedBox(width: 8),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25),
                                          child: blocksMotionProgram('lurus'),
                                        ),
                                        SizedBox(width: 8),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25),
                                          child: blocksMotionProgram('pb'),
                                        ),
                                        SizedBox(width: 8),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          LayoutBuilder(builder: (context, constraints) {
            lokasiX = constraints.biggest.width / 2 - 50;
            lokasiY = constraints.biggest.height / 2 - 50;

            return Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    condition == 'program2' || condition == 'program3'
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Untuk menengahkan row
                                children: [
                                  buildProgramBlock("Blok Program", () {
                                    blokChange = 'program';
                                    setState(() {});
                                    print('Blok Program');
                                  }),
                                  buildProgramBlock("Blok Kontrol", () {
                                    blokChange = 'kontrol';
                                    setState(() {});
                                    print('Blok Kontrol');
                                  }),
                                  buildProgramBlock("Blok Statement", () {
                                    blokChange = 'statement';
                                    setState(() {});
                                    print('Blok Statement');
                                  }),
                                  buildProgramBlock("Isi Kontrol", () {
                                    blokChange = 'body';
                                    setState(() {});
                                    print('Isi Kontrol');
                                  }),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    arahBebas == false
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: wdLayer * 0.5 - 50, top: 10),
                              child: Row(
                                children: [
                                  // Text('Waktu : ',
                                  //     style: TextStyle(
                                  //         fontSize: 16,
                                  //         color: Colors.white,
                                  //         fontWeight: FontWeight.bold)),
                                  // Text(
                                  //   _elapsedTime != null
                                  //       ? formatDuration(_elapsedCountDownTime)
                                  //       : '00:00:00',
                                  //   style: TextStyle(
                                  //       fontSize: 16,
                                  //       color: Colors.white,
                                  //       fontWeight: FontWeight.bold),
                                  // ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.78,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, -3), // Mengatur offset bayangan ke atas
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage('assets/background/bgGame.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.05),
                      BlendMode.darken, // Mengatur tingkat kegelapan gambar
                    ),
                  ),
                ),
              ),
            );
          }),
          shadowX != 0 && shadowY != 0
              ? shadowBlock(shadowY, shadowX)
              : Container(),
          ...dragableWidget,
          ...conditionBlokWidget,
          ...statementBlokWidget,
          ...bodyBlokWidget,
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: StreamBuilder<int>(
                stream: timerStream,
                builder: (context, snapshot) {
                  final seconds = snapshot.data ?? 0;
                  final formattedTime = formatTime(seconds);
                  return Text(
                    '$formattedTime',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 5),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.info_outline_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CustomPopup(
                            message: message,
                            buttonText: 'Oke',
                            onButtonPressed: () {
                              Navigator.pop(context);
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          dragableWidget.isNotEmpty && theLastLocation.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 5, bottom: 15),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            if (dragableWidget.isNotEmpty &&
                                theLastLocation.isNotEmpty &&
                                dataToSend.isNotEmpty &&
                                undoHistory.isNotEmpty) {
                              if (undoHistory.last == 'bawah') {
                                dataToSend.removeLast();
                              } else if (undoHistory.last == 'atas') {
                                dataToSend.removeAt(0);
                              }
                              dragableWidget.removeLast();
                              theLastLocation.removeLast();
                              undoHistory.removeLast();
                            }
                            setState(() {});
                          },
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16.0),
                          elevation: 2.0,
                          fillColor: Colors.blue,
                          child: Icon(
                            Icons.undo_outlined,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RawMaterialButton(
                          onPressed: () async {
                            if (arahBebas == false) {
                              // timer dimatikan dulu

                              print(
                                  'data to send dari yang semestinya ${mustDataToSend}');
                              print('data to send dari program ${dataToSend}');

                              List dataCopy = List.from(dataToSend);

                              dataCopy.remove('Q');

                              if (mustDataToSend.toString() ==
                                  dataCopy.toString()) {
                                List<Map<String, dynamic>> levels = await getGameLevels();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TextStory(
                                      message: message,
                                      buttonText: 'Oke',
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      height: MediaQuery.of(context).size.width,
                                      onButtonPressed: () {
                                        _stopTimer();
                                        _resetTimer();
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                                print('debug android ${indexData}');
                                print('monitor subLevel: ${subLevel}');

                                hitungSkor(
                                    waktuPenyelesaian: _secondsElapsed,
                                    waktuTerlama:
                                        levelStory[condition == 'program1'
                                                ? 2
                                                : condition == 'program2'
                                                    ? 3
                                                    : condition == 'program3'
                                                        ? 4
                                                        : 2]['isiLv']['time']
                                            ['time${int.parse(dataUser['subLevel']) - 1}']);
                                print("score updated ${subLevel}");
                                await databaseUser.updateUserByName(
                                    selectedAccount,
                                    subLevel: subLevel != '' ? subLevel : '1');
                                toListAllName();
                                getAllUser();
                                sendDataProgram('');
                                _stopTimer();
                                _resetTimer();
                              } else if (free) {
                                sendDataProgram('');
                              } else {
                                _stopTimer();
                                _resetTimer();
                                show(
                                    'yahh arah yang anda berikan kurang benar :(');
                              }
                              clearAll();
                              setState(() {});
                            }
                            //======= Timer dan penilaian

                            if (_connected) {}
                          },
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(16.0),
                          elevation: 2.0,
                          fillColor: Colors.green,
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          Container(
            height: hgLayer * 0.08,
            width: wdLayer,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Mengatur offset bayangan ke bawah
                ),
              ],
              color: Color.fromARGB(255, 185, 97, 89),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(25.0),
                bottomLeft: Radius.circular(25.0),
              ),
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                    onPressed: () {
                      if (freeProgram) {
                        changePage = menuUtama;
                      } else {
                        changePage = gameLevel;
                        getUserData(selectedAccount);
                      }
                      freeProgram = false;
                      arahBebas = false;
                      clearAll();
                      _stopTimer();
                      _resetTimer();
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white)),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'PROGRAM DRAG AND DROP',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          )
        ],
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          // floatingActionButton: FloatingActionButton(onPressed: () {
          //   // _sendMessageString('kirim data');
          //   print('rangked user ${usersRank}');
          //   printUserList(userList);
          //   printUserList(userList);
          // }),
          floatingActionButton: _showWidget2 == false
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 250),
                  child: AluminumButton(
                    click: true,
                    label: 'Play',
                    onPressed: () {
                      setState(() {
                        // ButtonAudioService.playButtonSound();
                        _showWidget = false;
                        _showWidget2 = true;
                        _controller.forward();
                      });
                    },
                  ),
                )
              : null,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: Stack(
            children: [
              changePage == menuUtama
                  ? MainMenu()
                  : changePage == menuJoypad
                      ? JoyPadWidget()
                      : changePage == menuJoypadFree
                          ? JoyPadWidgetFree()
                          : changePage == menuProgram
                              ? DragAndDropWidget(
                                  free: freeProgram,
                                  condition: jenisProgram,
                                  message: infoPetunjuk)
                              : changePage == menuContoh
                                  ? ContohDragAndDropWidget()
                                  : changePage == menuInfoPemain
                                      ? InfoPemain()
                                      : changePage == menuBluetooth
                                          ? BluetoothMenu()
                                          : changePage == gameLevel
                                              ? SubLevel()
                                              : changePage == menuRFID
                                                  ? CardPage()
                                                  : Container(),
              if (isPopupVisible)
                WaitingMessage(
                  rotate: rotateCondition,
                  onClose: _closePopup,
                ),
            ],
          )),
    );
  }

  List<DropdownMenuItem> _getDeviceItems() {
    List<DropdownMenuItem> items = [];
    if (_devicesList.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text(
          'Tidak ada device',
          style: TextStyle(
              fontSize: 12,
              color: Colors.blue[900],
              fontWeight: FontWeight.bold),
        ),
      ));
    } else {
      _devicesList.forEach((device) {
        items.add(DropdownMenuItem(
          value: device,
          child: Text(
            '  ${device.name}',
            style:
                TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
          ),
        ));
      });
    }
    return items;
  }

  void checkConnectionStatus() async {
    if (connection != null && !connection!.isConnected) {
      setState(() {
        _connected = false;
      });
    }
  }

  void _connect() async {
    if (_device == null) {
      show('No device selected');
    } else {
      if (!isConnected) {
        showConnectDialog(context);
        await BluetoothConnection.toAddress(_device?.address)
            .then((_connection) {
          print('Connected to the device');
          connection = _connection;

          setState(() {
            _connected = true;
          });

          // Start listening for incoming data
          _listenForData();
        }).catchError((error) {
          hideLoadingDialog(context);
          print('Cannot connect, exception occurred');
          print(error);
          show('Cannot connect, Try again');
        });
        hideLoadingDialog(context);
        show('Device connected');

        setState(() {
          _isButtonUnavailable = false;
          bgColor = Colors.white;
        });
        dataToSend.add('B');
        sendDataProgram('');
      }
    }
  }

  Future<void> checkAnswer(String selectedAnswer) async {
    print('jawaban joypad ${selectedAnswer}');
    selectedAnswer = selectedAnswer.replaceAll(
        RegExp(r'0+$'), ''); // Menghapus nol-nol dari akhir string
    if (cekIndex < kunjaw.length && selectedAnswer == kunjaw[cekIndex]) {
      // Jika jawaban benar
      if (cekIndex == kunjaw.length - 1) {
        // Jika ini adalah jawaban terakhir
        showAlertDialog(
            'Selamat semua jawaban anda benar, level selanjutnya telah terbuka!');

        // update database Sub level up
        hitungSkor(
            waktuPenyelesaian: _secondsElapsed,
            waktuTerlama: levelStory[0]['isiLv']['time']
                ['time${int.parse(subLevel) - 1}']);
        print("score updated ${subLevel}");
        await databaseUser.updateUserByName(selectedAccount,
            subLevel: subLevel != '' ? subLevel : '1');
        toListAllName();
        getAllUser();
        cekIndex = 0;
      } else {
        cekIndex++; // Pindah ke jawaban berikutnya
        print('jawaban benar');
      }
    } else {
      // Jika jawaban salah
      showAlertDialog('Anda salah memasukan perintah, ulangi dari awal');
      _stopTimer();
      _resetTimer();
    }
  }

  void showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Transform.rotate(
          angle: 90 * (pi / 180), // 90 derajat dalam radian
          child: TextStory(
            message: message,
            buttonText: 'Oke',
            width: MediaQuery.of(context).size.height * 0.8,
            height: MediaQuery.of(context).size.width,
            onButtonPressed: () {
              _stopTimer();
              _resetTimer();
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  // Method to disconnect bluetooth
  void _disconnect() async {
    setState(() {
      _deviceState = 0;
      bgColor = Color.fromARGB(255, 214, 211, 211);
    });

    await connection?.close();
    show('Device disconnected');

    if (connection != null && connection!.isConnected) {
      setState(() {
        _device = null;
      });
    } else {
      setState(() {
        _connected = false;
      });
    }
  }

  void sendHexData(String hexData) async {
    hexData =
        hexData.replaceAll(' ', ''); // Remove any spaces from the hex string

    // Check if the hex string has an odd length
    if (hexData.length % 2 != 0) {
      hexData = '0$hexData'; // Add a leading '0' if the length is odd
    }

    List<int> bytes = [];

    for (var i = 0; i < hexData.length; i += 2) {
      String hex = hexData.substring(
          i, i + 2); // Extract two characters from the hex string
      int value = int.parse(hex, radix: 16); // Parse the hex value

      bytes.add(value); // Add the parsed value to the byte list
    }

    Uint8List data = Uint8List.fromList(bytes);
    connection!.output.add(data);
    await connection!.output.allSent;
  }
  // void _sendMessageString(String value1) async {
  //   value1 = value1.trim();
  //   // print('value ${value1}');
  //   if (value1.isNotEmpty) {
  //     try {
  //       List<int> list = value1.codeUnits;
  //       Uint8List bytes = Uint8List.fromList(list);
  //       print(bytes);
  //       connection?.output.add(bytes);
  //       await connection?.output.allSent;
  //     } catch (e) {
  //       setState(() {});
  //     }
  //   }
  // }

  void _sendMessageString(String value1) async {
    print(value1);
    value1 = value1.trim();
    // print('value ${value1}');
    if (value1.isNotEmpty) {
      try {
        List<int> list = value1.codeUnits;
        Uint8List bytes = Uint8List.fromList(list);
        print(bytes);
        connection?.output.add(bytes);
        await connection?.output.allSent;
      } catch (e) {
        setState(() {});
      }
    }
  }

  // void _sendMessageString(String value) async {
  //   value = value.trim();
  //   if (value.isNotEmpty && connection != null) {
  //     try {
  //       List<int> list = value.codeUnits;
  //       Uint8List bytes = Uint8List.fromList(list);
  //       connection!.output.add(bytes);
  //       await connection!.output.allSent;
  //     } catch (e) {
  //       // Handle error
  //     }
  //   }
  // }

  Future<List<Map<String, dynamic>>> getGameLevels() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? gameLevelsString = prefs.getString('gameLevels');

    if (gameLevelsString != null) {
      List<dynamic> gameLevelsJson = jsonDecode(gameLevelsString);
      List<Map<String, dynamic>> gameLevels =
          List<Map<String, dynamic>>.from(gameLevelsJson);
      return gameLevels;
    } else {
      return [];
    }
  }

  void saveData(req) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> gameLevels = await getGameLevels();
    gameLevels[1]['checked'] = true;
    await prefs.setString('gameLevels', jsonEncode(gameLevels));
  }

  Future show(
    String message, {
    Duration duration: const Duration(seconds: 2),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          message,
        ),
        duration: duration,
      ),
    );
  }

  Widget shadowBlock(double thisY, thisX) {
    return Positioned(
        left: thisX,
        top: thisY,
        child: Container(
          decoration: BoxDecoration(
              color: Color.fromARGB(71, 0, 0, 0),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          width: 246,
          height: 50,
        ));
  }

  void addWidgetBody(double topYAxis, double topXAxis, String text) {
    double? xAxis;
    double? yAxis;

    xAxis = 38.761475191074965;
    yAxis = topYAxis;

    setState(() {
      bodyBlokWidget.add(Positioned(
          left: xAxis! + 71,
          top: yAxis! + 34,
          child: Container(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/body.png',
                  scale: 1.1,
                ),
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 7, left: 60),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ))
              ],
            ),
          )));
    });
    print('bodyBlockWidget : ${bodyBlokWidget}');
    locationBody.clear();
  }

  Widget blocksMotionBody(String condition) {
    return Draggable(
      child: Container(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/body.png',
              scale: 1.2,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 7, left: 60),
              child: Text(
                condition,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ))
          ],
        ),
      ),
      feedback: Container(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/body.png',
              scale: 1.2,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 7, left: 60),
              child: Text(
                condition,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ))
          ],
        ),
      ),
      childWhenDragging: Container(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/body.png',
              scale: 1.2,
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 7, left: 60),
              child: Text(
                condition,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ))
          ],
        ),
      ),
      onDraggableCanceled: (velocity, offset) async {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset globalOffset = renderBox.localToGlobal(offset);

        double yAxis = offset.dy;
        double xAxis = offset.dx;

        if (locationBody.isNotEmpty) {
          if (yAxis <= locationBody[0]['yAxis']) {
            print("Simpan di atas");

            addWidgetBody(
              locationBody[0]['yAxis'],
              locationBody[0]['xAxis'],
              condition,
            );

            if (loop != 0) {
              for (int i = 0; i < loop; i++) {
                switch (condition) {
                  case 'maju':
                    dataToSend.add('M');
                    break;
                  case 'belok kanan':
                    dataToSend.add('R');
                    break;
                  case 'belok kiri':
                    dataToSend.add('L');
                    break;
                  case 'ambil barang':
                    dataToSend.add('T');
                    break;
                  case 'lepas barang':
                    dataToSend.add('O');
                    break;
                  default:
                }
              }
            } else {
              switch (condition) {
                case 'maju':
                  dataToSend.add('M');
                  break;
                case 'belok kanan':
                  dataToSend.add('R');
                  break;
                case 'belok kiri':
                  dataToSend.add('L');
                  break;
                case 'ambil barang':
                  dataToSend.add('T');
                  break;
                case 'lepas barang':
                  dataToSend.add('O');
                  break;
                default:
              }
            }
            loop = 0;
            print('dataTosend ${dataToSend}');
          }
        }

        shadowX = 0;
        shadowY = 0;
        setState(() {});

        print(theLastLocation);
      },
      onDragUpdate: (dragDetails) {
        print(
            'Object amber dragged to X: ${dragDetails.localPosition.dx}, Y: ${dragDetails.localPosition.dy}');

        RenderBox renderBoxShadow = context.findRenderObject() as RenderBox;
        Offset globalOffsetShadow =
            renderBoxShadow.localToGlobal(dragDetails.localPosition);

        double yAxisShadow = globalOffsetShadow.dy - 55;
        double xAxisShadow = globalOffsetShadow.dx - 55;

        bool isSameValueExistsShadow = false;
        double toleranceShadow = double.maxFinite; // Toleransi maksimal
        double dxShadow = 0;
        double dyShadow = 0;

        if (theLastLocation.isNotEmpty) {
          for (Map<String, double> location in theLastLocation) {
            dxShadow = location['bottomDX']!;
            dyShadow = location['bottomDY']!;
            dxShadow = location['topDX']!;
            dyShadow = location['topDY']!;

            if ((dxShadow - xAxisShadow).abs() <= toleranceShadow &&
                (dyShadow - yAxisShadow).abs() <= toleranceShadow) {
              isSameValueExistsShadow = true;
              break;
            }
          }
        }

        if (!isSameValueExistsShadow) {
          shadowX = 0;
          shadowY = 0;
        } else if (yAxisShadow <= theLastLocation.last['topDY']!) {
          print("bayangan di atas");

          shadowX = theLastLocation.last['topDX']! + 5;
          shadowY = theLastLocation.last['topDY']! - 34;
        } else if (yAxisShadow >= theLastLocation.last['bottomDY']!) {
          print("bayangan di bawah");

          shadowX = theLastLocation.last['bottomDX']! + 5;
          shadowY = theLastLocation.last['bottomDY']! + 25;
        }
        setState(() {});
      },
    );
  }

  void addWidgetStatement(double topYAxis, double topXAxis, String text) {
    double? xAxis;
    double? yAxis;

    xAxis = 38.761475191074965;
    yAxis = topYAxis;

    setState(() {
      statementBlokWidget.add(Positioned(
          left: xAxis! + 180,
          top: yAxis! + 6,
          child: Container(
              height: 20,
              width: 130,
              color: Colors.amber,
              child: Center(child: Text(text)))));
    });
    locationStatement.clear();
  }

  Widget blocksMotionStatement(String condition) {
    return Draggable(
      child: Container(
        height: 20,
        width: 130,
        decoration: BoxDecoration(
          color: Colors.amber,
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(255, 82, 82, 82),
              blurRadius: 1, // Ukuran bayangan
              offset: Offset(0, 2), // Posisi bayangan (x, y)
            ),
          ],
          border: Border.all(
            color: Colors.black, // Warna garis pinggir
            width: 1, // Lebar garis pinggir
          ),
        ),
        child: Center(child: Text(condition)),
      ),
      feedback: Container(
          height: 20,
          width: 130,
          color: Colors.amber,
          child: Center(child: Text(condition))),
      childWhenDragging: Container(
          height: 20,
          width: 130,
          color: Colors.amber,
          child: Center(child: Text(condition))),
      onDraggableCanceled: (velocity, offset) async {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset globalOffset = renderBox.localToGlobal(offset);

        double yAxis = offset.dy;
        double xAxis = offset.dx;

        if (locationStatement.isNotEmpty) {
          if (yAxis <= locationStatement[0]['yAxis']) {
            print("Simpan di atas");

            addWidgetStatement(
              locationStatement[0]['yAxis'],
              locationStatement[0]['xAxis'],
              condition,
            );
          }
        }

        shadowX = 0;
        shadowY = 0;
        setState(() {});
        switch (condition) {
          case "ada persimpangan":
            dataToSend.add('P');
            break;
          case "ada benda":
            dataToSend.add('B');
            break;
          case "2 kali":
            loop = 2;
            break;
          case "3 kali":
            loop = 3;
            break;
          case "stop":
            print("Menghentikan permainan...");
            break;
          default:
            print("Aksi tidak dikenali");
        }

        print(theLastLocation);
      },
      onDragUpdate: (dragDetails) {
        print(
            'Object amber dragged to X: ${dragDetails.localPosition.dx}, Y: ${dragDetails.localPosition.dy}');

        RenderBox renderBoxShadow = context.findRenderObject() as RenderBox;
        Offset globalOffsetShadow =
            renderBoxShadow.localToGlobal(dragDetails.localPosition);

        double yAxisShadow = globalOffsetShadow.dy - 55;
        double xAxisShadow = globalOffsetShadow.dx - 55;

        bool isSameValueExistsShadow = false;
        double toleranceShadow = double.maxFinite; // Toleransi maksimal
        double dxShadow = 0;
        double dyShadow = 0;

        if (theLastLocation.isNotEmpty) {
          for (Map<String, double> location in theLastLocation) {
            dxShadow = location['bottomDX']!;
            dyShadow = location['bottomDY']!;
            dxShadow = location['topDX']!;
            dyShadow = location['topDY']!;

            if ((dxShadow - xAxisShadow).abs() <= toleranceShadow &&
                (dyShadow - yAxisShadow).abs() <= toleranceShadow) {
              isSameValueExistsShadow = true;
              break;
            }
          }
        }

        if (!isSameValueExistsShadow) {
          shadowX = 0;
          shadowY = 0;
        } else if (yAxisShadow <= theLastLocation.last['topDY']!) {
          print("bayangan di atas");

          shadowX = theLastLocation.last['topDX']! + 5;
          shadowY = theLastLocation.last['topDY']! - 34;
        } else if (yAxisShadow >= theLastLocation.last['bottomDY']!) {
          print("bayangan di bawah");

          shadowX = theLastLocation.last['bottomDX']! + 5;
          shadowY = theLastLocation.last['bottomDY']! + 25;
        }
        setState(() {});
      },
    );
  }

  void addWidgetDragable(double topYAxis, double topXAxis, double bottomYAxis,
      double bottomXAxis, String condition, String position) {
    double? xAxis;
    double? yAxis;

    xAxis = 38.761475191074965;
    yAxis = topYAxis;

    if (blokHistory.isNotEmpty) {
      print(blokHistory.last);
      if (blokHistory.last == 'kontrol') {
        bottomYAxis += 44.5;
        xAxis += 1;
        if (position == 'top') {
          theLastLocation.add({
            'bottomDX': xAxis,
            'bottomDY': bottomYAxis,
            // jika widget di simpan di atas, nilai top yang di ganti
            'topDX': xAxis,
            'topDY': yAxis,
          });
        } else if (position == 'bottom') {
          xAxis = xAxis;
          yAxis = bottomYAxis;
          theLastLocation.add({
            // jika widget di simpan di bawag, nilai bottom yang di ganti
            'bottomDX': xAxis,
            'bottomDY': yAxis,
            'topDX': xAxis,
            'topDY': topYAxis,
          });
        } else if (position == 'awal') {
          xAxis = xAxis;
          yAxis = topYAxis;
          theLastLocation.add({
            // jika widget di simpan di bawag, nilai bottom yang di ganti
            'bottomDX': xAxis,
            'bottomDY': topYAxis,
            'topDX': xAxis,
            'topDY': topYAxis,
          });
        }
      } else {
        if (position == 'top') {
          theLastLocation.add({
            'bottomDX': xAxis,
            'bottomDY': bottomYAxis,
            // jika widget di simpan di atas, nilai top yang di ganti
            'topDX': xAxis,
            'topDY': yAxis,
          });
        } else if (position == 'bottom') {
          xAxis = xAxis;
          yAxis = bottomYAxis;
          theLastLocation.add({
            // jika widget di simpan di bawag, nilai bottom yang di ganti
            'bottomDX': xAxis,
            'bottomDY': yAxis,
            'topDX': xAxis,
            'topDY': topYAxis,
          });
        } else if (position == 'awal') {
          xAxis = xAxis;
          yAxis = topYAxis;
          theLastLocation.add({
            // jika widget di simpan di bawag, nilai bottom yang di ganti
            'bottomDX': xAxis,
            'bottomDY': topYAxis,
            'topDX': xAxis,
            'topDY': topYAxis,
          });
        }
      }
    } else {
      if (position == 'top') {
        theLastLocation.add({
          'bottomDX': xAxis,
          'bottomDY': bottomYAxis,
          // jika widget di simpan di atas, nilai top yang di ganti
          'topDX': xAxis,
          'topDY': yAxis,
        });
      } else if (position == 'bottom') {
        xAxis = xAxis;
        yAxis = bottomYAxis;
        theLastLocation.add({
          // jika widget di simpan di bawag, nilai bottom yang di ganti
          'bottomDX': xAxis,
          'bottomDY': yAxis,
          'topDX': xAxis,
          'topDY': topYAxis,
        });
      } else if (position == 'awal') {
        xAxis = xAxis;
        yAxis = topYAxis;
        theLastLocation.add({
          // jika widget di simpan di bawag, nilai bottom yang di ganti
          'bottomDX': xAxis,
          'bottomDY': topYAxis,
          'topDX': xAxis,
          'topDY': topYAxis,
        });
      }
    }

    setState(() {
      if (dragableWidget.length <= 20) {
        print(dragableWidget.length);
        blokHistory.add('program');
        print(blokHistory);
        dragableWidget.add(
          Positioned(
            left: xAxis,
            top: yAxis,
            child: Container(
              child: Stack(
                children: [
                  Image.asset(
                    condition == 'kanan'
                        ? 'assets/images/kanan.png'
                        : condition == 'kiri'
                            ? 'assets/images/kiri.png'
                            : condition == 'lurus'
                                ? 'assets/images/lurus.png'
                                : condition == 'pb'
                                    ? 'assets/images/pb.png'
                                    : 'assets/images/belok kanan.png',
                    scale: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  Widget blocksMotionProgram(String condition) {
    return Draggable(
      child: Container(
        child: Image.asset(
          condition == 'kanan'
              ? 'assets/images/kanan.png'
              : condition == 'kiri'
                  ? 'assets/images/kiri.png'
                  : condition == 'lurus'
                      ? 'assets/images/lurus.png'
                      : condition == 'pb'
                          ? 'assets/images/pb.png'
                          : 'assets/images/belok kanan.png',
          scale: 1.2,
        ),
      ),
      feedback: Container(
        color: Colors.transparent,
        child: Image.asset(
          condition == 'kanan'
              ? 'assets/images/kanan.png'
              : condition == 'kiri'
                  ? 'assets/images/kiri.png'
                  : condition == 'lurus'
                      ? 'assets/images/lurus.png'
                      : condition == 'pb'
                          ? 'assets/images/pb.png'
                          : 'assets/images/belok kanan.png',
          scale: 1.2,
        ),
      ),
      childWhenDragging: Container(
        color: Colors.transparent,
        child: Image.asset(
          condition == 'kanan'
              ? 'assets/images/kanan.png'
              : condition == 'kiri'
                  ? 'assets/images/kiri.png'
                  : condition == 'lurus'
                      ? 'assets/images/lurus.png'
                      : condition == 'pb'
                          ? 'assets/images/pb.png'
                          : 'assets/images/belok kanan.png',
          scale: 1,
        ),
      ),
      onDraggableCanceled: (velocity, offset) async {
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset globalOffset = renderBox.localToGlobal(offset);

        double yAxis = offset.dy;
        double xAxis = offset.dx;

        if (yAxis >= 250) {
          if (arahBebas == false) {
            if (dragableWidget.isEmpty) {
              // if (_elapsedTime == Duration.zero) {
              //   print('waktu debug : mulai waktu');
              //   _resetTimer();
              //   startStopTimer();
              //   // _startCountDown(await dbHelper.getMaxTimer(indexData));
              //   _startCountDown(10);
              // }
            }
          }

          if (dragableWidget.length <= 20) {
            List<Map<String, double>> lastLocationCopy = [...theLastLocation];

            for (Map<String, double> location in lastLocationCopy) {
              print(
                  'cek kondisi awal position : ${location['position']} topDX : ${location['topDX']}, topDY : ${location['topDY']}, bottomDX : ${location['bottomDX']}, bottomDY : ${location['bottomDY']}, ');

              double toplocdX = theLastLocation.last['topDX']!;
              double toplocdY = theLastLocation.last['topDY']!;
              double bottomlocdX = theLastLocation.last['bottomDX']!;
              double bottomlocdY = theLastLocation.last['bottomDY']!;

              if (theLastLocation.length <= 1) {
                if (theLastLocation.indexOf(location) == 0) {
                  double locdX = location['topDX']!;
                  double locdY = location['topDY']!;

                  if (yAxis <= locdY) {
                    print("Simpan di atas");
                    undoHistory.add('atas');

                    double topyAxis = locdY - 50;
                    double topxAxis = locdX;
                    addWidgetDragable(
                        topyAxis,
                        topxAxis,
                        bottomlocdY.toDouble(),
                        bottomlocdX.toDouble(),
                        condition,
                        'top');

                    switch (condition) {
                      case 'lurus':
                        dataToSend.insert(0, 'M');
                        break;
                      case 'kanan':
                        dataToSend.insert(0, 'R');
                        break;
                      case 'kiri':
                        dataToSend.insert(0, 'L');
                        break;
                      case 'pb':
                        dataToSend.insert(0, 'Q');
                        break;
                      default:
                    }
                  } else {
                    print("Simpan di bawah");
                    undoHistory.add('bawah');

                    double bottomyAxis = locdY + 48;
                    double bottomxAxis = locdX;

                    addWidgetDragable(toplocdY.toDouble(), toplocdX.toDouble(),
                        bottomyAxis, bottomxAxis, condition, 'bottom');

                    switch (condition) {
                      case 'lurus':
                        dataToSend.add('M');
                        break;
                      case 'kanan':
                        dataToSend.add('R');
                        break;
                      case 'kiri':
                        dataToSend.add('L');
                        break;
                      case 'pb':
                        dataToSend.add('Q');
                        break;
                      default:
                    }
                  }
                }
              } else {
                if (yAxis <= toplocdY && location == theLastLocation.last) {
                  print("Simpan di atas");
                  undoHistory.add('atas');

                  double topyAxis = toplocdY - 50;
                  double topxAxis = toplocdX;

                  addWidgetDragable(topyAxis, topxAxis, bottomlocdY.toDouble(),
                      bottomlocdX.toDouble(), condition, 'top');

                  switch (condition) {
                    case 'lurus':
                      dataToSend.insert(0, 'M');
                      break;
                    case 'kanan':
                      dataToSend.insert(0, 'R');
                      break;
                    case 'kiri':
                      dataToSend.insert(0, 'L');
                      break;
                    case 'pb':
                      dataToSend.insert(0, 'Q');
                      break;
                    default:
                  }

                  print('masukan widget');
                } else if (yAxis >= bottomlocdY &&
                    location == theLastLocation.last) {
                  print("Simpan di bawah");
                  undoHistory.add('bawah');

                  double bottomyAxis = bottomlocdY + 48;
                  double bottomxAxis = bottomlocdX;

                  addWidgetDragable(toplocdY.toDouble(), toplocdX.toDouble(),
                      bottomyAxis, bottomxAxis, condition, 'bottom');

                  switch (condition) {
                    case 'lurus':
                      dataToSend.add('M');
                      break;
                    case 'kanan':
                      dataToSend.add('R');
                      break;
                    case 'kiri':
                      dataToSend.add('L');
                      break;
                    case 'pb':
                      dataToSend.add('Q');
                      break;
                    default:
                  }
                  print('masukan widget');
                }
              }
            }

            if (dragableWidget.isEmpty && theLastLocation.isEmpty) {
              undoHistory.add('bawah');
              addWidgetDragable(yAxis, xAxis, yAxis, xAxis, condition, 'awal');
              print('widget pertama tersimpan ${yAxis} ${xAxis}');

              switch (condition) {
                case 'lurus':
                  dataToSend.add('M');
                  break;
                case 'kanan':
                  dataToSend.add('R');
                  break;
                case 'kiri':
                  dataToSend.add('L');
                  break;
                case 'pb':
                  dataToSend.add('Q');
                  break;
                default:
              }
            }
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PopupDialog(
                  message: 'Block sudah penuh',
                  txtButton: 'OKE',
                );
              },
            );
          }
        }

        shadowX = 0;
        shadowY = 0;
        setState(() {});

        print(theLastLocation);
      },
      onDragUpdate: (dragDetails) {
        print(
            'Object amber dragged to X: ${dragDetails.localPosition.dx}, Y: ${dragDetails.localPosition.dy}');

        RenderBox renderBoxShadow = context.findRenderObject() as RenderBox;
        Offset globalOffsetShadow =
            renderBoxShadow.localToGlobal(dragDetails.localPosition);

        double yAxisShadow = globalOffsetShadow.dy - 55;
        double xAxisShadow = globalOffsetShadow.dx - 55;

        bool isSameValueExistsShadow = false;
        double toleranceShadow = double.maxFinite; // Toleransi maksimal
        double dxShadow = 0;
        double dyShadow = 0;

        if (theLastLocation.isNotEmpty) {
          for (Map<String, double> location in theLastLocation) {
            dxShadow = location['bottomDX']!;
            dyShadow = location['bottomDY']!;
            dxShadow = location['topDX']!;
            dyShadow = location['topDY']!;

            if ((dxShadow - xAxisShadow).abs() <= toleranceShadow &&
                (dyShadow - yAxisShadow).abs() <= toleranceShadow) {
              isSameValueExistsShadow = true;
              break;
            }
          }
        }

        if (!isSameValueExistsShadow) {
          shadowX = 0;
          shadowY = 0;
        } else if (yAxisShadow <= theLastLocation.last['topDY']!) {
          print("bayangan di atas");

          shadowX = theLastLocation.last['topDX']! + 5;
          shadowY = theLastLocation.last['topDY']! - 34;
        } else if (yAxisShadow >= theLastLocation.last['bottomDY']!) {
          print("bayangan di bawah");

          shadowX = theLastLocation.last['bottomDX']! + 5;
          shadowY = theLastLocation.last['bottomDY']! + 25;
        }
        setState(() {});
      },
    );
  }

  void addWidgetDragableFor(
      double topYAxis,
      double topXAxis,
      double bottomYAxis,
      double bottomXAxis,
      String condition,
      String position,
      String blok) {
    double? xAxis;
    double? yAxis;

    if (blokHistory.isNotEmpty) {
      if (blokHistory.last == 'program') {
        if (position == 'top') {
          xAxis = 46.761475191074965;
          yAxis = topYAxis;
          theLastLocation.add({
            'bottomDX': bottomXAxis,
            'bottomDY': bottomYAxis,
            // jika widget di simpan di atas, nilai top yang di ganti
            'topDX': xAxis,
            'topDY': yAxis,
          });
        } else if (position == 'bottom') {
          xAxis = 46.761475191074965;
          yAxis = bottomYAxis - 43;
          theLastLocation.add({
            // jika widget di simpan di bawag, nilai bottom yang di ganti
            'bottomDX': xAxis,
            'bottomDY': yAxis,
            'topDX': topXAxis,
            'topDY': topYAxis,
          });
        } else if (position == 'awal') {
          xAxis = 46.761475191074965;
          yAxis = topYAxis;
          theLastLocation.add({
            // jika widget di simpan di bawag, nilai bottom yang di ganti
            'bottomDX': topXAxis,
            'bottomDY': topYAxis,
            'topDX': 46.761475191074965,
            'topDY': topYAxis,
          });
        }
      } else {
        if (position == 'top') {
          xAxis = 46.761475191074965;
          yAxis = topYAxis;
          theLastLocation.add({
            'bottomDX': bottomXAxis,
            'bottomDY': bottomYAxis,
            // jika widget di simpan di atas, nilai top yang di ganti
            'topDX': xAxis,
            'topDY': yAxis,
          });
        } else if (position == 'bottom') {
          xAxis = 46.761475191074965;
          yAxis = bottomYAxis;
          theLastLocation.add({
            // jika widget di simpan di bawag, nilai bottom yang di ganti
            'bottomDX': xAxis,
            'bottomDY': yAxis,
            'topDX': topXAxis,
            'topDY': topYAxis,
          });
        } else if (position == 'awal') {
          xAxis = 46.761475191074965;
          yAxis = topYAxis;
          theLastLocation.add({
            // jika widget di simpan di bawag, nilai bottom yang di ganti
            'bottomDX': topXAxis,
            'bottomDY': topYAxis,
            'topDX': 46.761475191074965,
            'topDY': topYAxis,
          });
        }
      }
    } else {
      if (position == 'top') {
        xAxis = 46.761475191074965;
        yAxis = topYAxis;
        theLastLocation.add({
          'bottomDX': bottomXAxis,
          'bottomDY': bottomYAxis,
          // jika widget di simpan di atas, nilai top yang di ganti
          'topDX': xAxis,
          'topDY': yAxis,
        });
      } else if (position == 'bottom') {
        xAxis = 46.761475191074965;
        yAxis = bottomYAxis;
        theLastLocation.add({
          // jika widget di simpan di bawag, nilai bottom yang di ganti
          'bottomDX': xAxis,
          'bottomDY': yAxis,
          'topDX': topXAxis,
          'topDY': topYAxis,
        });
      } else if (position == 'awal') {
        xAxis = 46.761475191074965;
        yAxis = topYAxis;
        theLastLocation.add({
          // jika widget di simpan di bawag, nilai bottom yang di ganti
          'bottomDX': topXAxis,
          'bottomDY': topYAxis,
          'topDX': 46.761475191074965,
          'topDY': topYAxis,
        });
      }
    }

    setState(() {
      if (dragableWidget.length <= 20) {
        Map<String, dynamic> newData = {
          'yAxis': yAxis,
          'xAxis': xAxis, // Menyisakan nilai 'cond' dikosongkan
        };

        locationStatement.add(newData);
        locationBody.add(newData);
        flexText.add(true);
        int indexWidget = flexText.length - 1;

        print(dragableWidget.length);
        blokHistory.add('kontrol');
        dragableWidget.add(
          Positioned(
            left: xAxis,
            top: yAxis,
            child: Container(
              child: Stack(
                children: [
                  Image.asset(
                    condition == 'if'
                        ? 'assets/images/IFBLOK.png'
                        : condition == 'for'
                            ? 'assets/images/FORBLOK.png'
                            : 'assets/images/IFBLOK.png',
                    scale: 1.1,
                  ),

                  // DropdownButton<String>(
                  //   value: newData['cond'],
                  //   onChanged: (newValue) {
                  //     setState(() {
                  //       newData['cond'] = newValue!;
                  //     });
                  //   },
                  //   items: [
                  //     DropdownMenuItem(value: 'if', child: Text('If Condition')),
                  //     DropdownMenuItem(value: 'for', child: Text('For Loop')),
                  //     DropdownMenuItem(value: 'other', child: Text('Other Condition')),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        );
        // conditionBlokWidget.add(
        //   Positioned(
        //     left: xAxis! + 20,
        //     top: yAxis,
        //     child: Container(
        //       child: Stack(
        //         children: [
        //           Text('Kondisi')
        //         ],
        //       ),
        //     ),
        //   ),
        // );
      }
    });
    print('${theLastLocation.last}');
  }

  void changeWidget(
      double xAxis, double yAxis, String condition, int indexWidget) {
    print('indexWidget terganti');
    flexText[indexWidget] = !flexText[indexWidget];
    dragableWidget[indexWidget] = Positioned(
      left: xAxis,
      top: yAxis,
      child: Container(
        child: Stack(
          children: [
            Image.asset(
              condition == 'if'
                  ? 'assets/images/IFBLOK.png'
                  : condition == 'for'
                      ? 'assets/images/FORBLOK.png'
                      : 'assets/images/IFBLOK.png',
              scale: 1.1,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    print('indexWidget : ${indexWidget}');
                    if (indexWidget >= 0 &&
                        indexWidget < dragableWidget.length) {
                      changeWidget(xAxis, yAxis, condition, indexWidget);
                    }
                  });
                },
                child: Text(flexText[indexWidget].toString()))
            // DropdownButton<String>(
            //   value: newData['cond'],
            //   onChanged: (newValue) {
            //     setState(() {
            //       newData['cond'] = newValue!;
            //     });
            //   },
            //   items: [
            //     DropdownMenuItem(value: 'if', child: Text('If Condition')),
            //     DropdownMenuItem(value: 'for', child: Text('For Loop')),
            //     DropdownMenuItem(value: 'other', child: Text('Other Condition')),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget blocksMotionKontrol(String condition) {
    return Draggable(
      child: Container(
        child: Image.asset(
          condition == 'if'
              ? 'assets/images/IFBLOK.png'
              : condition == 'for'
                  ? 'assets/images/FORBLOK.png'
                  : 'assets/images/IFBLOK.png',
          scale: 2,
        ),
      ),
      feedback: Container(
        color: Colors.transparent,
        child: Image.asset(
          condition == 'if'
              ? 'assets/images/IFBLOK.png'
              : condition == 'for'
                  ? 'assets/images/FORBLOK.png'
                  : 'assets/images/IFBLOK.png',
          scale: 1.1,
        ),
      ),
      childWhenDragging: Container(
        color: Colors.transparent,
        child: Image.asset(
          condition == 'if'
              ? 'assets/images/IFBLOK.png'
              : condition == 'for'
                  ? 'assets/images/FORBLOK.png'
                  : 'assets/images/IFBLOK.png',
          scale: 2,
        ),
      ),
      onDraggableCanceled: (velocity, offset) async {
        print('blok kontrol');
        RenderBox renderBox = context.findRenderObject() as RenderBox;
        Offset globalOffset = renderBox.localToGlobal(offset);

        double yAxis = offset.dy;
        double xAxis = 46.761475191074965;

        if (yAxis >= 250) {
          if (arahBebas == false) {
            if (dragableWidget.isEmpty) {
              // if (_elapsedTime == Duration.zero) {
              //   print('waktu debug : mulai waktu');
              //   _resetTimer();
              //   startStopTimer();
              //   // _startCountDown(await dbHelper.getMaxTimer(indexData));
              // }
            }
          }
          // ALGORITMA PENYIMPANAN BLOK
          if (dragableWidget.length <= 20) {
            List<Map<String, double>> lastLocationCopy = [...theLastLocation];

            for (Map<String, double> location in lastLocationCopy) {
              print(
                  'cek kondisi awal position : ${location['position']} topDX : ${location['topDX']}, topDY : ${location['topDY']}, bottomDX : ${location['bottomDX']}, bottomDY : ${location['bottomDY']}, ');

              double toplocdX = theLastLocation.last['topDX']!;
              double toplocdY = theLastLocation.last['topDY']!;
              double bottomlocdX = theLastLocation.last['bottomDX']!;
              double bottomlocdY = theLastLocation.last['bottomDY']!;

              if (theLastLocation.length <= 1) {
                if (theLastLocation.indexOf(location) == 0) {
                  double locdX = location['topDX']!;
                  double locdY = location['topDY']!;

                  if (yAxis <= locdY) {
                    print("Simpan di atas");
                    undoHistory.add('atas');

                    double topyAxis = locdY - 91.5;
                    double topxAxis = 46.761475191074965;
                    addWidgetDragableFor(
                        topyAxis,
                        topxAxis,
                        bottomlocdY.toDouble(),
                        bottomlocdX.toDouble(),
                        condition,
                        'top',
                        'kontrol');

                    switch (condition) {
                      case 'if':
                        dataToSend.insert(0, 'I');
                        break;
                      case 'for':
                        dataToSend.insert(0, 'F');
                        break;
                      default:
                    }
                  } else {
                    print("Simpan di bawah");
                    undoHistory.add('bawah');

                    double bottomyAxis = locdY + 91.5;
                    double bottomxAxis = 46.761475191074965;

                    addWidgetDragableFor(
                        toplocdY.toDouble(),
                        toplocdX.toDouble(),
                        bottomyAxis,
                        bottomxAxis,
                        condition,
                        'bottom',
                        'kontrol');

                    switch (condition) {
                      case 'if':
                        dataToSend.add('I');
                        break;
                      case 'for':
                        dataToSend.add('F');
                        break;
                      default:
                    }
                  }
                }
              } else {
                if (yAxis <= toplocdY && location == theLastLocation.last) {
                  print("Simpan di atas");
                  undoHistory.add('atas');

                  double topyAxis = toplocdY - 91.5;
                  double topxAxis = 46.761475191074965;

                  print('top x axis ${topxAxis}');

                  addWidgetDragableFor(
                      topyAxis,
                      topxAxis,
                      bottomlocdY.toDouble(),
                      bottomlocdX.toDouble(),
                      condition,
                      'top',
                      'kontrol');

                  switch (condition) {
                    case 'if':
                      dataToSend.insert(0, 'I');
                      break;
                    case 'for':
                      dataToSend.insert(0, 'F');
                      break;
                    default:
                  }

                  print('masukan widget');
                } else if (yAxis >= bottomlocdY &&
                    location == theLastLocation.last) {
                  print("Simpan di bawah");
                  undoHistory.add('bawah');

                  double bottomyAxis = bottomlocdY + 91.5;
                  double bottomxAxis = 46.761475191074965;

                  addWidgetDragableFor(toplocdY.toDouble(), toplocdX.toDouble(),
                      bottomyAxis, bottomxAxis, condition, 'bottom', 'kontrol');

                  switch (condition) {
                    case 'if':
                      dataToSend.add('I');
                      break;
                    case 'for':
                      dataToSend.add('F');
                      break;
                    default:
                  }
                  print('masukan widget');
                }
              }
            }

            if (dragableWidget.isEmpty && theLastLocation.isEmpty) {
              undoHistory.add('bawah');
              addWidgetDragableFor(
                  yAxis, xAxis, yAxis, xAxis, condition, 'awal', 'kontrol');
              print('widget pertama tersimpan ${yAxis} ${xAxis}');

              switch (condition) {
                case 'if':
                  dataToSend.add('I');
                  break;
                case 'for':
                  dataToSend.add('F');
                  break;
                default:
              }
            }
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return PopupDialog(
                  message: 'Block sudah penuh',
                  txtButton: 'OKE',
                );
              },
            );
          }
        }

        shadowX = 0;
        shadowY = 0;
        setState(() {});

        print(theLastLocation);
      },
      onDragUpdate: (dragDetails) {
        print(
            'Object amber dragged to X: ${dragDetails.localPosition.dx}, Y: ${dragDetails.localPosition.dy}');

        RenderBox renderBoxShadow = context.findRenderObject() as RenderBox;
        Offset globalOffsetShadow =
            renderBoxShadow.localToGlobal(dragDetails.localPosition);

        double yAxisShadow = globalOffsetShadow.dy - 55;
        double xAxisShadow = globalOffsetShadow.dx - 55;

        bool isSameValueExistsShadow = false;
        double toleranceShadow = double.maxFinite; // Toleransi maksimal
        double dxShadow = 0;
        double dyShadow = 0;

        if (theLastLocation.isNotEmpty) {
          for (Map<String, double> location in theLastLocation) {
            dxShadow = location['bottomDX']!;
            dyShadow = location['bottomDY']!;
            dxShadow = location['topDX']!;
            dyShadow = location['topDY']!;

            if ((dxShadow - xAxisShadow).abs() <= toleranceShadow &&
                (dyShadow - yAxisShadow).abs() <= toleranceShadow) {
              isSameValueExistsShadow = true;
              break;
            }
          }
        }

        if (!isSameValueExistsShadow) {
          shadowX = 0;
          shadowY = 0;
        } else if (yAxisShadow <= theLastLocation.last['topDY']!) {
          print("bayangan di atas");

          shadowX = theLastLocation.last['topDX']! + 5;
          shadowY = theLastLocation.last['topDY']! - 34;
        } else if (yAxisShadow >= theLastLocation.last['bottomDY']!) {
          print("bayangan di bawah");

          shadowX = theLastLocation.last['bottomDX']! + 5;
          shadowY = theLastLocation.last['bottomDY']! + 91.5;
        }
        setState(() {});
      },
    );
  }
}

/*

penambahan list blokhistory untuk memasukan history dari jenis blok yang dimasukan untuk menyesuaikan
nilai Y terakhir, yang digunakan untuk menyimpan blok selanjutnya sesuai dengan jenis blok yang
akan disimpan

lv 1 : Joypad
  - 
  -
  -
  -
lv 2 : kartu
  -
  -
  -
  -
lv 3 : blok program tanpa while
  -
  -
  -
  -
lv 4 : blok program dengan while dan if 
  -
  -
  -
  -
lv 5 :
  -
  -
  -
  -
  -
  -
*/

import 'dart:async';

import 'package:flutter/material.dart';

import '../utillitas/database/database_user.dart';
import '../widgets/leaderBoard.dart';

String proses = 'Sending';

int pengulangan = 0;

bool pengiriman = false;

String _messageBuffer = '';

bool isDisconnecting = false;
List textData = [];

String? nameDirection;

// To track whether the device is still connected to Bluetooth

bool? send;

String changePage = 'MAIN';
String buttonPressed = '';
String arrowPressed = '';
bool restarOnTap = false;
bool okOnTap = false;
double joystickX = 0.0;
double joystickY = 0.0;
String dataYangdiIsi = '';
String buttonMaju = 'W0000000000000000000';
String buttonMundur = 'U0000000000000000000';
String buttonKanan = 'D0000000000000000000';
String buttonKiri = 'A0000000000000000000';
String buttonY = 'Z0000000000000000000';
String buttonX = 'X0000000000000000000';
String buttonA = 'C0000000000000000000';
String buttonB = 'V0000000000000000000';
String diam = 'J0000000000000000000';
String buttonMajuFree = '80000000000000000000';
String buttonMundurFree = '50000000000000000000';
String buttonKananFree = '40000000000000000000';
String buttonKiriFree = '60000000000000000000';
String buttonYFree = '70000000000000000000';
String buttonXFree = '90000000000000000000';
String buttonAFree = '10000000000000000000';
String buttonBFree = '30000000000000000000';
String diamFree = 'J0000000000000000000';
bool majuClick = false;
bool kiriClick = false;
bool kananClick = false;
bool mundurClick = false;
bool arahBebas = false;
bool blokState = true;
String? selectedValue;
bool rotateCondition = false;
bool freeProgram = false;
// Route Menu
String menuJoypadFree = 'JOYPAD';
String menuJoypad = 'JOYPADLV';
String menuProgram = 'PROGRAM';
String menuUtama = 'MAIN';
String menuBluetooth = 'BLUE';
String menuLevel = 'LEVEL';
String menuContoh = 'CONTOH';
String menuInfo = 'INFO';
String menuInfoPemain = 'INFOPEMAIN';
String gameLevel = 'GAMELEVEL';
String menuRFID = 'RFID';

String combineReceived = '';

// Drag And Drop
// List<Map<String, dynamic>> dragableWidget = [];
List<Widget> dragableWidget = [];
List undoHistory = [];
List dataToSend = [];
double lokasiX = 0;
double lokasiY = 0;
List<Map<String, double>> theLastLocation = [];
double shadowY = 0;
double shadowX = 0;
bool bluetoothCond = false;
String receivedData = '';
bool isListening = false;
bool listeningData = true;

int indexData = 0;
String mustDataToSend = '';
int inputNumber = 0;
List answerJoypad = [];

late Stopwatch stopwatch = Stopwatch();
Timer? timer;
Duration elapsedTime = Duration.zero;
Duration elapsedCountDownTime = Duration(seconds: 0);
bool isRunning = false;
bool isPopupVisible = false;
List locationBlokKontrol = [];
List<Map<String, dynamic>> locationStatement = [];
List<Map<String, dynamic>> locationBody = [];
List<bool> flexText = [];
List accountId = [];
List<String> nameUsers = [];
List<User> userList = [];
List<LeaderboardUser> usersRank = [];
String subLevel = '';
bool levelTwo = false;
bool isFirstG = false;
String catchData = '';

String selectedAccount = '';
String desiredStory = '';
int levelSebelumnya = 1;
String levelDilihat = '1';
int subLevelDipilih = 1;
int indexButton = 0;
int cekIndex = 0;
String jenisProgram = 'program1';
int loop = 0;

Map<String, dynamic> dataUser = {};

List kunjaw = [];
String infoPetunjuk = '';



/*
 dataUser = {
        'userName': users[index].name,
        'lastLevel': users[index].lastLevel,
        'subLevel': users[index].subLevel,
        'score': users[index].score,
      };
*/
// /*

// note* masukan kondisi dragablewidget ke pengkondisian block 
// dimana dragable widget rubah menjadi listMap dan buat field 
// baru berupa kondisi maju/mundur/kiri/kanan lalu kondisi tersebut
// di cek pada switchCase dan pada saat tombol done di tekan

// */

// import 'dart:async';

// import 'package:flutter/rendering.dart';
// import 'dart:math';

// import 'package:kirro/menu/game_page/dragAndDrop/cobain.dart';
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

// class Joypad extends StatefulWidget {
//   @override
//   _JoypadState createState() => _JoypadState();
// }

// class _JoypadState extends State<Joypad> {
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

//   String changePage = 'joypad';
//   String buttonPressed = '';
//   String arrowPressed = '';
//   bool restarOnTap = false;
//   bool okOnTap = false;
//   double joystickX = 0.0;
//   double joystickY = 0.0;
//   List<Widget> dragableWidget = [];
//   double lokasiX = 0;
//   double lokasiY = 0;
//   List<Map<String, double>> theLastLocation = [];
//   double shadowY = 0;
//   double shadowX = 0;
//   String dataYangdiIsi = '';
//   String buttonMaju = 'WXXXXXXXXXXXXXXXXXXX';
//   String buttonMundur = 'SXXXXXXXXXXXXXXXXXXX';
//   String buttonKanan = 'DXXXXXXXXXXXXXXXXXXX';
//   String buttonKiri = 'AXXXXXXXXXXXXXXXXXXX';
//   String diam = 'JXXXXXXXXXXXXXXXXXXX';
//   String? buttonX;
//   String? buttonY;
//   String? buttonB;
//   String? buttonA;
//   bool majuClick = false;
//   bool kiriClick = false;
//   bool kananClick = false;
//   bool mundurClick = false;
//   String? selectedValue;



//   @override
//   void initState() {
//     super.initState();

//     // Get current state
//     FlutterBluetoothSerial.instance.state.then((state) {
//       setState(() {
//         _bluetoothState = state;
//       });
//     });

//     _deviceState = 0; // neutral

//     // If the bluetooth of the device is not enabled,
//     // then request permission to turn on bluetooth
//     // as the app starts up
//     enableBluetooth();

//     // Listen for further state changes
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
//     // Avoid memory leak and disconnect
//     if (isConnected) {
//       isDisconnecting = true;
//       connection?.dispose();
//       var lateconnection = null;
//     }

//     // Hentikan penerimaan data dari serial
//     // _streamSubscription.cancel();

//     super.dispose();
//   }

//   Future<bool> enableBluetooth() async {
//     // Retrieving the current Bluetooth state
//     _bluetoothState = await FlutterBluetoothSerial.instance.state;

//     // If the bluetooth is off, then turn it on first
//     // and then retrieve the devices that are paired.
//     if (_bluetoothState == BluetoothState.STATE_OFF) {
//       await FlutterBluetoothSerial.instance.requestEnable();
//       await getPairedDevices();
//       return true;
//     } else {
//       await getPairedDevices();
//     }
//     return false;
//   }

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

//   Future<void> sendData(String data) async {
//     if (_connected) {
//       print('data terkirim ${data}');
//       _sendMessageString(data);
//     } else {
//       print('belum tersambung');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double wdLayer = MediaQuery.of(context).size.width;
//     double hgLayer =
//         MediaQuery.of(context).size.height + MediaQuery.of(context).padding.top;

    

    



//     return Scaffold(
//         floatingActionButton: 
//         body: 
//   }

  
// }

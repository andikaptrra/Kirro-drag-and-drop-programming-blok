// import 'dart:collection';
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
// import 'package:ndialog/ndialog.dart';

// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xls;
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';

// class bluetoothApp extends StatefulWidget {
//   List dataToSend;

//   bluetoothApp({
//     super.key,
//     required this.dataToSend,
//   });

//   @override
//   State<bluetoothApp> createState() => _bluetoothAppState();
// }

// class _Message {
//   int whom;
//   String text;

//   _Message(this.whom, this.text);
// }

// class _bluetoothAppState extends State<bluetoothApp> {
//   // Initializing the Bluetooth connection state to be unknown
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

//   List<_Message> messages = List<_Message>.empty(growable: true);

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

//   // Request Bluetooth permission from the user
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

//   Future<void> sendDataProgram() async {
//     showLoadingDialog(context);

//     List dataReady = widget.dataToSend;
//     bool containsG = dataReady.contains('G');
//     !containsG ? dataReady.add('G') : null;

//     if (dataReady.length <= 19) {
//       int maxInd = 19 - dataReady.length;
//       for (var i = 0; i < maxInd; i++) {
//         dataReady.add('X');
//       }
//     }

//     dataReady.add('G');

//     // MULAU PROSES PENGGABUNGAN LIST DAN MENGIRIM DATA
//     String _puzzleSend = dataReady.join();
//     print('ini data yang di kirim : ${_puzzleSend}');
//     // menggunakan String

//     _sendMessageString(_puzzleSend);

//     // menggunakan Hex
//     // _sendMessageHex(_puzzleSend);

//     // for (var data in dataReady) {
//     // await Future.delayed(Duration(milliseconds: 500), () {
//     // _sendMessageHex(data);
//     // });
//     // }
//     // MENGIRIM KODE GOGO
//     // _sendMessageString('G');
//     // _sendMessageHex('G');
//     // hideLoadingDialog(context);
//     print('ini data panjang : ${dataReady.length}');
//     dataReady.removeWhere((element) => element == 'G');
//     dataReady.removeWhere((element) => element == 'X');
//     print('ini data ready dari page bluetooth dikembalikan : ${dataReady}');

//     Timer(Duration(seconds: 2), () {
//       hideLoadingDialog(context);
//       Navigator.pop(context);
//     });
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

//   void hideLoadingDialog(BuildContext context) {
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double wdLayer = MediaQuery.of(context).size.width;
//     double hgLayer =
//         MediaQuery.of(context).size.height + MediaQuery.of(context).padding.top;

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(onPressed: () {
//         sendDataProgram();
//       }),
//       backgroundColor: bgColor,
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         elevation: 0,
//         title: Text('Bluetooth Send'),
//         leading: IconButton(
//             onPressed: () async {
//               // back button
//               Navigator.pop(context);
//             },
//             icon: Icon(Icons.arrow_back_ios_new_rounded)),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Container(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 250,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStateProperty.resolveWith((states) {
//                           return _connected ? Colors.blue : Colors.grey;
//                         }),
//                       ),
//                       onPressed: () {
//                         if (_connected) {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: Text('You want to send the data?'),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                       sendDataProgram();
//                                       // showLoadingDialog(context);
//                                       // showLoadingDialog(
//                                       //     context); // Show loading dialog
//                                       // sendDataProgram().then((_) {
//                                       //   hideLoadingDialog(
//                                       //       context); // Hide loading dialog after sending data
//                                       // });
//                                     },
//                                     child: Text('YES'),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Text('NO'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         }
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           "SEND DATA",
//                           style: TextStyle(fontSize: 18, color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 50,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       width: wdLayer * 0.9,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.all(Radius.circular(20)),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Container(
//                 height: 210,
//                 width: wdLayer,
//                 decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.grey,
//                           spreadRadius: 1.5,
//                           blurRadius: 5,
//                           offset: Offset.zero)
//                     ],
//                     color: Colors.blue,
//                     borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(25),
//                         bottomRight: Radius.circular(25))),
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           width: wdLayer * 0.9,
//                           height: 50,
//                           decoration: BoxDecoration(
//                               boxShadow: const [
//                                 BoxShadow(
//                                     color: Colors.white,
//                                     spreadRadius: 0.5,
//                                     blurRadius: 1)
//                               ],
//                               color: Colors.blue[700],
//                               borderRadius: BorderRadius.circular(10)),
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 10, right: 10),
//                             child: Row(
//                               children: [
//                                 const Expanded(
//                                     child: Text(
//                                   'Enable Bluetooth',
//                                   style: TextStyle(
//                                       fontSize: 16, color: Colors.white),
//                                 )),
//                                 Switch(
//                                   value: _bluetoothState.isEnabled,
//                                   onChanged: (bool value) {
//                                     // Do the request and update with the true value then
//                                     future() async {
//                                       // async lambda seems to not working
//                                       if (value)
//                                         await _bluetooth.requestEnable();
//                                       else {
//                                         await _bluetooth.requestDisable();
//                                       }
//                                     }

//                                     future().then((_) {
//                                       setState(() {});
//                                     });
//                                   },
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       Container(
//                         width: wdLayer * 0.9,
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(20)),
//                             color: Colors.white),
//                         child: Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(10.0),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   DropdownButton(
//                                     underline: SizedBox(),
//                                     items: _getDeviceItems(),
//                                     onChanged: (value) =>
//                                         setState(() => _device = value!),
//                                     value: _devicesList.isNotEmpty
//                                         ? _device
//                                         : null,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(bottom: 5),
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   primary: Colors.blue,
//                                   elevation: 2,
//                                 ),
//                                 onPressed: _isButtonUnavailable
//                                     ? null
//                                     : _connected
//                                         ? _disconnect
//                                         : _connect,
//                                 child:
//                                     Text(_connected ? 'Disconnect' : 'Connect'),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // Create the List of devices to be shown in Dropdown Menu
//   List<DropdownMenuItem> _getDeviceItems() {
//     List<DropdownMenuItem> items = [];
//     if (_devicesList.isEmpty) {
//       items.add(DropdownMenuItem(
//         child: Text(
//           'NO DEVICE',
//           style:
//               TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
//           // style: TextStyle(
//           //   color: Colors.white,
//           // )
//         ),
//       ));
//     } else {
//       _devicesList.forEach((device) {
//         items.add(DropdownMenuItem(
//           value: device,
//           child: Text(
//             device.name.toString(),
//             style:
//                 TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
//           ),
//         ));
//       });
//     }
//     return items;
//   }

//   void _connect() async {
//     if (_device == null) {
//       show('No device selected');
//     } else {
//       if (!isConnected) {
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
//           print('Cannot connect, exception occurred');
//           print(error);
//           show('Cannot connect, Try again');
//         });
//         show('Device connected');

//         setState(() {
//           _isButtonUnavailable = false;
//           bgColor = Colors.white;
//         });
//       }
//     }
//   }

//   // Method to disconnect bluetooth
//   void _disconnect() async {
//     setState(() {
//       _isButtonUnavailable = true;
//       _deviceState = 0;
//       bgColor = Color.fromARGB(255, 214, 211, 211);
//     });

//     await connection?.close();
//     show('Device disconnected');
//     if (connection!.isConnected) {
//       setState(() {
//         _connected = false;
//         _isButtonUnavailable = false;
//       });
//     }
//   }

//   void _sendMessageHex(String hexData) async {
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
//     print('Data yang telah di olah _sendMessageHex : ${data}');
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
//         print('data yang telah di olah _sendMessageString : {bytes}');
//         connection?.output.add(bytes);
//         await connection?.output.allSent;
//       } catch (e) {
//         setState(() {});
//       }
//     }
//   }

//   void _onDataReceived(Uint8List data) {
//     print('_onDataReceived running...');
//     // Allocate buffer for parsed data
//     int backspacesCounter = 0;
//     data.forEach((byte) {
//       if (byte == 8 || byte == 127) {
//         backspacesCounter++;
//       }
//     });
//     Uint8List buffer = Uint8List(data.length - backspacesCounter);
//     int bufferIndex = buffer.length;

//     // Apply backspace control character
//     backspacesCounter = 0;
//     for (int i = data.length - 1; i >= 0; i--) {
//       if (data[i] == 8 || data[i] == 127) {
//         backspacesCounter++;
//       } else {
//         if (backspacesCounter > 0) {
//           backspacesCounter--;
//         } else {
//           buffer[--bufferIndex] = data[i];
//         }
//       }
//     }

//     // Create message if there is new line character
//     String dataString = String.fromCharCodes(buffer);
//     int index = buffer.indexOf(13);
//     if (~index != 0) {
//       setState(() {
//         messages.add(
//           _Message(
//             1,
//             backspacesCounter > 0
//                 ? _messageBuffer.substring(
//                     0, _messageBuffer.length - backspacesCounter)
//                 : _messageBuffer + dataString.substring(0, index),
//           ),
//         );
//         _messageBuffer = dataString.substring(index);
//       });
//     } else {
//       _messageBuffer = (backspacesCounter > 0
//           ? _messageBuffer.substring(
//               0, _messageBuffer.length - backspacesCounter)
//           : _messageBuffer + dataString);
//     }
//   }

//   // Method to send message,
//   // for turning the Bluetooth device off
//   void _sendOffMessageToBluetooth() async {
//     Uint8List bytes = Uint8List(2);
//     connection?.output.add(bytes);
//     await connection?.output.allSent;
//     show('Device Turned Off');
//     setState(() {
//       _deviceState = -1; // device off
//     });
//   }

//   // Method to show a Snackbar,
//   // taking message as the text
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
// }

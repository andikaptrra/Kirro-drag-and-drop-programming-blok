// import 'package:flutter/material.dart';

// import '../function/timer.dart';
// import '../global_Variabel/variabel.dart';
// import '../utillitas/math/scorer.dart';

// class BlocksMotionWidget extends StatefulWidget {
//   final String condition;

//   BlocksMotionWidget({required this.condition});

//   @override
//   _BlocksMotionWidgetState createState() => _BlocksMotionWidgetState();
// }

// class _BlocksMotionWidgetState extends State<BlocksMotionWidget> {
//   double shadowX = 0;
//   double shadowY = 0;
//   List<Map<String, double>> theLastLocation = [];

//   @override
//   Widget build(BuildContext context) {
//     return Draggable(
//       child: Container(
//         child: Image.asset(
//           widget.condition == 'kanan'
//               ? 'assets/images/kanan.png'
//               : widget.condition == 'kiri'
//                   ? 'assets/images/kiri.png'
//                   : widget.condition == 'lurus'
//                       ? 'assets/images/lurus.png'
//                       : 'assets/images/belok kanan.png',
//           scale: 1.5,
//         ),
//       ),
//       feedback: Container(
//         color: Colors.transparent,
//         child: Image.asset(
//           widget.condition == 'kanan'
//               ? 'assets/images/kanan.png'
//               : widget.condition == 'kiri'
//                   ? 'assets/images/kiri.png'
//                   : widget.condition == 'lurus'
//                       ? 'assets/images/lurus.png'
//                       : 'assets/images/belok kanan.png',
//           scale: 1.5,
//         ),
//       ),
//       childWhenDragging: Container(
//         color: Colors.transparent,
//         child: Image.asset(
//           widget.condition == 'kanan'
//               ? 'assets/images/kanan.png'
//               : widget.condition == 'kiri'
//                   ? 'assets/images/kiri.png'
//                   : widget.condition == 'lurus'
//                       ? 'assets/images/lurus.png'
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
//               if (elapsedTime == Duration.zero) {
//                 print('waktu debug : mulai waktu');
//                 TimerHelper.resetTimer(() {
//                   setState(() {});
//                 });
//               }
//               TimerHelper.startTimer(() {
//                 setState(() {});
//               });

//               TimerHelper.startCountDown(
//                 context,
//                 await dbHelper.getMaxTimer(indexData),
//                 int.parse(menuLevel),
//               );
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
//         // Salin dan kustomisasi bagian onDragUpdate
//       },
//     );
//   }
// }

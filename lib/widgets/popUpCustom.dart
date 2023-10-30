import 'package:flutter/material.dart';
import 'package:kirro/widgets/button.dart';

import '../global_Variabel/variabel.dart';

class CustomPopup extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  CustomPopup({
    required this.message,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: Container(
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  primary: Colors.amber,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    buttonText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
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
}

class TextStory extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final double height;
  final double width;

  TextStory(
      {required this.message,
      required this.buttonText,
      required this.onButtonPressed,
      required this.height,
      required this.width});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      content: Stack(
        children: [
          Align(
            alignment: Alignment.center,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(
                      message,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        primary: Colors.amber,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          buttonText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaitingMessage extends StatelessWidget {
  final VoidCallback onClose;
  final bool rotate;

  WaitingMessage({required this.onClose, required this.rotate});

  @override
  Widget build(BuildContext context) {
    if (receivedData == 'done') {
      // Jika receivedData adalah 'done', tutup popup tanpa menampilkan tombol
      Future.delayed(Duration.zero, () {
        onClose();
      });
      return Container(); // Return an empty container
    }

    return GestureDetector(
        onTap: () {}, // Prevent taps from propagating
        child: rotate == false
            ? Container(
                color: Colors.black.withOpacity(0.3),
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(20),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        receivedData == 'done'
                            ? 'Robot telah sampai'
                            : 'Robot Sedang bergerak...',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            : Container(
                color: Colors.black.withOpacity(0.3),
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: 90 * (3.14159265359 / 180), // 90 derajat dalam radian
                  child: Container(
                    padding: EdgeInsets.all(20),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          receivedData == 'done'
                              ? 'Robot telah sampai'
                              : 'Robot Sedang bergerak...',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ));
  }
}

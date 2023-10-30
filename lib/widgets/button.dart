import 'package:flutter/material.dart';

String blokChange = 'program';

Widget buildProgramBlock(String text, VoidCallback onTap) {
  return Padding(
    padding: const EdgeInsets.only(left: 10),
    child: InkWell(
      onTap: onTap,
      splashColor: Colors.amber.withOpacity(0.5), // Warna efek splash
      borderRadius: BorderRadius.circular(5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class AluminumButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool click;

  AluminumButton({
    required this.label,
    required this.onPressed,
    required this.click,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      height: 60.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        gradient: LinearGradient(
          colors: click ? [Color.fromARGB(155, 255, 78, 81), Color(0xFFF9D423)] : [Color.fromARGB(94, 134, 95, 95), Color.fromARGB(115, 100, 99, 92)],
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LevelButton extends StatefulWidget {
  final String levelText;
  final VoidCallback onTap;
  final bool levelOpen;

  const LevelButton({
    required this.levelText,
    required this.onTap,
    this.levelOpen = true, // Default value is true
  });

  @override
  State<LevelButton> createState() => _LevelButtonState();
}

class _LevelButtonState extends State<LevelButton> {
  bool _isPressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Transform.scale(
        scale: _isPressed ? 0.95 : 1.0,
        child: Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              colors: widget.levelOpen
                  ? [Color(0xFFFF4E50), Color(0xFFF9D423)]
                  : [
                      Color.fromARGB(127, 119, 117, 117),
                      Color.fromARGB(125, 145, 138, 104),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Rintangan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.levelText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

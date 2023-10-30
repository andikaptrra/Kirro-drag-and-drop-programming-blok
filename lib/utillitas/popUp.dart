import 'package:flutter/material.dart';



class PopupDialog extends StatelessWidget {
  final String message;
  final String txtButton;

  PopupDialog({required this.message, required this.txtButton});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(txtButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

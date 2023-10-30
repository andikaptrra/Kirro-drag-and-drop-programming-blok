import 'package:flutter/material.dart';

class LoadingIndicatorOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    print('loading terpanggil');
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.5),
            alignment: Alignment.center,
            child: CircularProgressIndicator(), // Ganti ini dengan widget loading spinner yang sesuai
          ),
        );
      },
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

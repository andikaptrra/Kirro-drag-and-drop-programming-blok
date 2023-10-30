import 'package:flutter/material.dart';

class WidgetHelper {
  static void addWidgetDragable(
    BuildContext context,
    List<Map<String, double>> theLastLocation,
    List<Widget> dragableWidget,
    double topYAxis,
    double topXAxis,
    double bottomYAxis,
    double bottomXAxis,
    String condition,
    String position,
    void Function(void Function()) setState,
  ) {
    double? xAxis;
    double? yAxis;

    if (position == 'top') {
      xAxis = topXAxis;
      yAxis = topYAxis;
      theLastLocation.add({
        'bottomDX': bottomXAxis,
        'bottomDY': bottomYAxis,
        'topDX': xAxis,
        'topDY': yAxis,
      });
    } else if (position == 'bottom') {
      xAxis = bottomXAxis;
      yAxis = bottomYAxis;
      theLastLocation.add({
        'bottomDX': xAxis,
        'bottomDY': yAxis,
        'topDX': topXAxis,
        'topDY': topYAxis,
      });
    } else if (position == 'awal') {
      xAxis = topXAxis;
      yAxis = topYAxis;
      theLastLocation.add({
        'bottomDX': topXAxis,
        'bottomDY': topYAxis,
        'topDX': topXAxis,
        'topDY': topYAxis,
      });
    }

    setState(() {
      if (dragableWidget.length <= 7) {
        print(dragableWidget.length);
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
                        : 'assets/images/belok kanan.png',
                    scale: 1.1,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
    print('${theLastLocation.last}');
  }
}

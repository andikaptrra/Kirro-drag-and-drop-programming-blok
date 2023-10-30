import 'package:flutter/material.dart';

class CreateProgram extends StatefulWidget {
  @override
  _CreateProgramState createState() => _CreateProgramState();
}

class _CreateProgramState extends State<CreateProgram> {
  List<Widget> _containers = [];
  List<Offset> _positions = [];
  List<Color> _colors = [Colors.red, Colors.blue, Colors.green]; // List of colors
  Offset? _lastDropPosition;

  @override
  void initState() {
    super.initState();
    _spawnContainer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drag and Drop Container'),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _containers,
            ),
          ),
          if (_lastDropPosition != null)
            Positioned(
              left: _lastDropPosition!.dx,
              top: _lastDropPosition!.dy,
              child: DragTarget<Offset>(
                onAccept: (offset) {
                  setState(() {
                    _lastDropPosition = offset;
                    _spawnContainer();
                  });
                },
                builder: (context, candidates, rejects) {
                  return Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContainer(int index) {
    return Draggable(
      data: _positions[index],
      child: Container(
        width: 100,
        height: 100,
        color: _colors[index],
        margin: EdgeInsets.only(right: 20),
      ),
      feedback: Container(
        width: 100,
        height: 100,
        color: _colors[index].withOpacity(0.5),
        margin: EdgeInsets.only(right: 20),
      ),
      onDraggableCanceled: (velocity, offset) {
        setState(() {
          _positions[index] = offset;
          print('Container ${index + 1} position: $offset');
        });
      },
    );
  }

  void _spawnContainer() {
    for (int i = 0; i < _colors.length; i++) {
      final newIndex = _containers.length;
      _positions.add(Offset(0, 0));
      _containers.add(_buildContainer(newIndex));
    }
  }
}
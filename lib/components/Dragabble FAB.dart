import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DraggableFab extends StatelessWidget {
  final IconData icon;
  final Future<Null> Function() onPressed;
  const DraggableFab({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Consumer<FabPosition>(
        builder: (context, fabPosition, child) {
          return Positioned(
            left: fabPosition.position.dx,
            top: fabPosition.position.dy,
            child: Draggable(
              feedback: FloatingActionButton(
                onPressed: onPressed,
                child: Icon(icon),
              ),
              childWhenDragging: Container(),
              onDraggableCanceled: (velocity, offset) {
                fabPosition.position = offset;
              },
              child: FloatingActionButton(
                onPressed: onPressed,
                child: Icon(icon),
              ),
            ),
          );
        },
      ),
    ]);
  }
}

class FabPosition with ChangeNotifier {
  double screenHeight = WidgetsBinding.instance.window.physicalSize.height / WidgetsBinding.instance.window.devicePixelRatio;
  double screenWidth = WidgetsBinding.instance.window.physicalSize.width / WidgetsBinding.instance.window.devicePixelRatio;

  Offset _position = Offset(50.0, (WidgetsBinding.instance.window.physicalSize.height / WidgetsBinding.instance.window.devicePixelRatio) - 60);

  Offset get position => _position;

  set position(Offset newPosition) {
    _position = newPosition;
    notifyListeners();
  }

  // void setBottomRight(BuildContext context) {
  //   final RenderBox renderBox = context.findRenderObject() as RenderBox;
  //   _position = Offset(
  //     50.0,
  //     // renderBox.size.width - 56.0, // Subtract the width of the FAB to align it properly
  //     renderBox.size.height - 60.0, // Subtract the height of the FAB to align it properly
  //   );
  //   notifyListeners();
  // }
}

/// paste in the instate()
// WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<FabPosition>(context, listen: false).setBottomRight(context);
//     });

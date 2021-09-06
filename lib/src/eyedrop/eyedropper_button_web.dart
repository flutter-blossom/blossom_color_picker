import 'package:flutter/material.dart';
import 'dart:js' as js;

import 'eye_dropper_layer.dart';

/// an eyeDropper standalone button
/// in browser the eyedrop feature is enabled only with canvasKit renderer
class EyedropperButton extends StatelessWidget {
  /// customisable icon ( default : [Icons.colorize] )
  final IconData icon;

  /// icon color, default : [Colors.blueGrey]
  final Color iconColor;
  final Color? backgroundColor;

  /// color selection callback
  final ValueChanged<Color> onColor;
  final void Function() onActivate;

  /// verify if the button is in a CanvasKit context
  bool get eyedropEnabled => js.context['flutterCanvasKit'] != null;

  EyedropperButton({
    required this.onColor,
    required this.onActivate,
    this.icon = Icons.colorize,
    this.backgroundColor,
    this.iconColor = Colors.blueGrey,
    Key? key,
  }) : super(key: key);

  bool isActive = false;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
        child: InkWell(
          onTap: () {
            if (!isActive) {
              onActivate();
              _onEyeDropperRequest(context);
            }
            isActive = !isActive;
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(25),
              color: backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
          ),
        ),
      );

  void _onEyeDropperRequest(BuildContext context) {
    try {
      EyeDrop.of(context).capture(context, onColor);
    } catch (err) {
      throw Exception('EyeDrop capture error : $err');
    }
  }
}

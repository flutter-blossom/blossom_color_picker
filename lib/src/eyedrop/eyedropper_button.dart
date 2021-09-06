import 'package:flutter/material.dart';

import 'eye_dropper_layer.dart';

/// an eyeDropper standalone button
class EyedropperButton extends StatelessWidget {
  final IconData icon;

  /// icon color, default : [Colors.blueGrey]
  final Color iconColor;
  final Color? backgroundColor;

  /// color selection callback
  final ValueChanged<Color> onColor;
  final void Function() onActivate;

  const EyedropperButton({
    required this.onColor,
    required this.onActivate,
    this.icon = Icons.colorize,
    this.backgroundColor,
    this.iconColor = Colors.blueGrey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
        child: InkWell(
          onTap: () {
            if (!EyeDrop.of(context).isActive) {
              onActivate();
              _onEyeDropperRequest(context);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.15),
              ),
              borderRadius: BorderRadius.circular(25),
              color: backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Icon(
                icon,
                color: iconColor,
                size: 16,
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

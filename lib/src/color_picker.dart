import 'package:flutter/material.dart';
import '../blossom_color_picker.dart';

class ColorPicker extends StatefulWidget {
  ColorPicker(
      {Key? key,
      required this.onColor,
      this.eyeDropIcon,
      this.eyeDropColor,
      this.hexBackgroundColor,
      this.colorIndicatorSize = 22.0})
      : super(key: key);
  final void Function(Color color) onColor;
  final IconData? eyeDropIcon;
  final Color? eyeDropColor;
  final Color? hexBackgroundColor;
  final double colorIndicatorSize;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  double opacity = 1.0;
  Color _preColor = Colors.transparent;
  HSVColor color = HSVColor.fromColor(Colors.blue);
  void onChanged(HSVColor color) {
    this.color = color;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          WheelPicker(
            color: color,
            onChanged: (value) => super.setState(
              () => onChanged(value),
            ),
            onEnd: () {
              _preColor = color.toColor();
              widget.onColor(color.toColor());
            },
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: widget.colorIndicatorSize / 2,
                      height: widget.colorIndicatorSize,
                      decoration: BoxDecoration(
                        color: _preColor,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
                      ),
                    ),
                    Container(
                      width: widget.colorIndicatorSize / 2,
                      height: widget.colorIndicatorSize,
                      decoration: BoxDecoration(
                        color: color.toColor(),
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
                      ),
                    ),
                  ],
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: HexPicker(
                    backgroundColor: widget.hexBackgroundColor,
                    color: color.toColor().withOpacity(opacity),
                    onChanged: (v) =>
                        super.setState(() => onChanged(HSVColor.fromColor(v))),
                  ),
                ),
                EyedropperButton(
                  icon: widget.eyeDropIcon ?? Icons.colorize,
                  iconColor: widget.eyeDropColor ?? Colors.blue,
                  onColor: (v) {
                    _preColor = color.toColor();
                    super.setState(
                      () {
                        _preColor = v;
                        onChanged(HSVColor.fromColor(v));
                      },
                    );
                    widget.onColor(color.toColor());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

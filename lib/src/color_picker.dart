import 'package:flutter/material.dart';
import '../blossom_color_picker.dart';

class ColorPicker extends StatefulWidget {
  ColorPicker(
      {Key? key,
      required this.color,
      required this.onColor,
      this.onEyeDrop,
      this.eyeDropIcon,
      this.eyeDropColor,
      this.eyeDropBackgroundColor,
      this.hexBackgroundColor,
      this.colorIndicatorSize = 22.0})
      : super(key: key);
  final Color color;
  final void Function(Color color) onColor;
  final void Function()? onEyeDrop;
  final IconData? eyeDropIcon;
  final Color? eyeDropColor;
  final Color? eyeDropBackgroundColor;
  final Color? hexBackgroundColor;
  final double colorIndicatorSize;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  double opacity = 1.0;
  Color? _preColor;
  HSVColor? color;
  void onChanged(HSVColor color) {
    this.color = color;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: WheelPicker(
            color: color ?? HSVColor.fromColor(widget.color),
            onChanged: (value) => super.setState(
              () => onChanged(value),
            ),
            onEnd: () {
              _preColor = color?.toColor() ?? widget.color;
              widget.onColor(color?.toColor() ?? widget.color);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.4),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: widget.colorIndicatorSize / 2,
                      height: widget.colorIndicatorSize,
                      decoration: BoxDecoration(
                        color: _preColor ?? widget.color,
                        borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
                      ),
                    ),
                    Container(
                      width: widget.colorIndicatorSize / 2,
                      height: widget.colorIndicatorSize,
                      decoration: BoxDecoration(
                        color: color?.toColor() ?? widget.color,
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(50)),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                child: HexPicker(
                  backgroundColor: widget.hexBackgroundColor,
                  color: (color?.toColor() ?? widget.color).withOpacity(opacity),
                  onChanged: (v) =>
                      super.setState(() => onChanged(HSVColor.fromColor(v))),
                ),
              ),
              EyedropperButton(
                icon: widget.eyeDropIcon ?? Icons.colorize,
                iconColor: widget.eyeDropColor ?? Colors.blue,
                backgroundColor: widget.eyeDropBackgroundColor,
                onActivate: () {
                  widget.onEyeDrop?.call();
                },
                onColor: (v) {
                  _preColor = color?.toColor() ?? widget.color;
                  super.setState(
                    () {
                      _preColor = v;
                      onChanged(HSVColor.fromColor(v));
                    },
                  );
                  widget.onColor(color?.toColor() ?? widget.color);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

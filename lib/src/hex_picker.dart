import 'package:flutter/material.dart';

/// Textfield for entering the Hex color code (RRGGBB)
class HexPicker extends StatefulWidget {
  HexPicker({
    required this.color,
    required this.onChanged,
    this.backgroundColor,
    this.textField,
    Key? key,
  })  : _controller = TextEditingController(
          text: _Hex.colorToString(color).toUpperCase(),
        ),
        super(key: key);

  final Color color;
  final ValueChanged<Color> onChanged;
  final TextEditingController _controller;
  final Widget Function(String text)? textField;
  final Color? backgroundColor;

  @override
  _HexPickerState createState() => _HexPickerState();
}

class _HexPickerState extends State<HexPicker> {
  void textOnSubmitted(String value) => widget.onChanged(
        textOnChenged(value),
      );
  Color textOnChenged(String text) {
    final String? hex = _Hex.textSubString(text);
    if (hex == null) return widget.color;

    try {
      return _Hex.intToColor(_Hex.stringToInt(hex));
    } catch (_) {
      return widget.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Text
        Padding(
          padding: const EdgeInsets.only(left: 4, top: 2),
          child: Text(
            '#',
            style: Theme.of(context).textTheme.headline6?.copyWith(
                fontSize: 18,
                color: widget.backgroundColor ?? Colors.grey.withOpacity(0.8)),
          ),
        ),

        // TextField
        Container(
          width: 70,
          height: 25,
          decoration: BoxDecoration(
            color:
                widget.backgroundColor?.withOpacity(0.2) ?? Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: widget.textField?.call(widget._controller.text) ??
                  TextField(
                    style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 18),
                    controller: widget._controller,
                    onSubmitted: textOnSubmitted,
                    decoration: const InputDecoration.collapsed(hintText: 'hex code'),
                  ),
            ),
          ),
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }
}

class _Hex {
  // Hex Number To Color
  static Color intToColor(int hexNumber) => Color.fromARGB(
        255,
        (hexNumber >> 16) & 0xFF,
        (hexNumber >> 8) & 0xFF,
        (hexNumber >> 0) & 0xFF,
      );

  // String To Hex Number
  static int stringToInt(String hex) => int.parse(hex, radix: 16);

  // String To Color
  static String colorToString(Color color) =>
      _colorToString(
        color.red.toRadixString(16),
      ) +
      _colorToString(
        color.green.toRadixString(16),
      ) +
      _colorToString(
        color.blue.toRadixString(16),
      );
  static String _colorToString(String text) => text.length == 1 ? '0$text' : text;

  // Subste
  static String? textSubString(String? text) {
    if (text == null) return null;

    if (text.length < 6) return null;

    if (text.length == 6) return text;

    return text.substring(text.length - 6, 6);
  }
}

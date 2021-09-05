# blossom_color_picker

A color picker combining [flutter_hsvcolor_picker](https://github.com/fluttercandies/flutter_hsvcolor_picker) by [fluttercandies](https://github.com/fluttercandies) and [cyclop](https://github.com/rxlabz/cyclop) by [rxlabz](https://github.com/rxlabz).
Made for (Flutter Blossom)(https://github.com/flutter-blossom/flutter_blossom).

## Getting Started

```dart
import 'package:blossom_color_picker/blossom_color_picker.dart';

// for colorPicker
ColorPicker(
  onColor: onChanged,
),

// for opacity slider

OpacitySlider(
  opacity: opacity,
  selectedColor: color,
  onChange: (o) {
    setState(() {
      opacity = o;
    });
  },
),

```

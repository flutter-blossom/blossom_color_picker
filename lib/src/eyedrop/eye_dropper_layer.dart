import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import '../utils.dart';
import 'eye_dropper_overlay.dart';

final captureKey = GlobalKey();

class _EyeDropperModel {
  /// based on PointerEvent.kind
  bool touchable = false;

  OverlayEntry? eyeOverlayEntry;

  img.Image? snapshot;

  Offset cursorPosition = screenSize.center(Offset.zero);

  Color hoverColor = Colors.black;

  List<Color> hoverColors = [];

  Color selectedColor = Colors.black;

  ValueChanged<Color>? onColorSelected;

  _EyeDropperModel();
}

class EyeDrop extends InheritedWidget {
  static _EyeDropperModel data = _EyeDropperModel();

  EyeDrop({required Widget child, void Function()? onEscape})
      : super(
          child: RepaintBoundary(
            key: captureKey,
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              autofocus: true,
              onKey: (e) {
                if (data.eyeOverlayEntry != null &&
                    e.logicalKey == LogicalKeyboardKey.escape) {
                  data.eyeOverlayEntry!.remove();
                  data.eyeOverlayEntry = null;
                  data.onColorSelected = null;
                  onEscape?.call();
                }
              },
              child: Listener(
                onPointerMove: (details) => _onHover(
                  details.position,
                  details.kind == PointerDeviceKind.touch,
                ),
                // ignore: deprecated_member_use
                onPointerHover: (details) => _onHover(
                  details.position,
                  details.kind == PointerDeviceKind.touch,
                ),
                onPointerUp: (details) => _onPointerUp(details.position),
                child: child,
              ),
            ),
          ),
        );

  static EyeDrop of(BuildContext context) {
    final eyeDrop = context.dependOnInheritedWidgetOfExactType<EyeDrop>();
    if (eyeDrop == null) {
      throw Exception(
          'No EyeDrop found. You must wrap your application within an EyeDrop widget.');
    }
    return eyeDrop;
  }

  static void _onPointerUp(Offset position) {
    _onHover(position, data.touchable);
    if (data.onColorSelected != null) {
      data.onColorSelected!(data.hoverColors[12]);
    }

    if (data.eyeOverlayEntry != null) {
      try {
        data.eyeOverlayEntry!.remove();
        data.eyeOverlayEntry = null;
        data.onColorSelected = null;
      } catch (err) {
        debugPrint('ERROR !!! _onPointerUp $err');
      }
    }
  }

  static void _onHover(Offset offset, bool touchable) {
    if (data.eyeOverlayEntry != null) data.eyeOverlayEntry!.markNeedsBuild();

    data.cursorPosition = offset;

    data.touchable = touchable;

    if (data.snapshot != null) {
      data.hoverColor = getPixelColor(data.snapshot!, offset - Offset(2, 47));
      data.hoverColors = getPixelColors(data.snapshot!, offset - Offset(2, 47));
    }
  }

  void capture(BuildContext context, ValueChanged<Color> onColorSelected) async {
    final renderer =
        captureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (renderer == null) return;

    data.onColorSelected = onColorSelected;

    data.snapshot = await repaintBoundaryToImage(renderer);

    if (data.snapshot == null) return;

    /* FIXME(rxlabz) */
    data.eyeOverlayEntry = OverlayEntry(
      builder: (_) => EyeDropOverlay(
        touchable: data.touchable,
        colors: data.hoverColors,
        cursorPosition: data.cursorPosition,
      ),
    );
    Overlay.of(context)?.insert(data.eyeOverlayEntry!);
  }

  @override
  bool updateShouldNotify(EyeDrop oldWidget) {
    return true;
  }
}

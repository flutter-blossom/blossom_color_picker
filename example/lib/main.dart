import 'package:blossom_color_picker/blossom_color_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double opacity = 1.0;
  Color color = Colors.blue;
  void onChanged(Color color) {
    setState(() {
      this.color = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return EyeDrop(
        child: Material(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: CircleAvatar(
              backgroundColor: color.withOpacity(opacity),
            ),
          ),
          Divider(),
          ColorPicker(
            color: Colors.blue,
            onColor: onChanged,
          ),
          OpacitySlider(
            opacity: opacity,
            selectedColor: color,
            onChange: (o) {
              setState(() {
                opacity = o;
              });
            },
          )
        ],
      ),
    ));
  }
}

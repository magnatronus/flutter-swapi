import 'package:flutter/material.dart';
import 'package:swapi/app.dart';

/// Run the app
void main() => runApp(new MyApp());

// Generate a material app
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'SWAPI Demo',
      home: SwApiHome()
    );
  }

}


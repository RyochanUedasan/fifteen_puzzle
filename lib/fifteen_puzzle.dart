import 'package:flutter/material.dart';

import 'play.dart';

class FifteenPuzzle extends StatelessWidget {
  const FifteenPuzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '15 Puzzle',
      theme: ThemeData(primarySwatch: Colors.grey),
      home: const Play(),
    );
  }
}

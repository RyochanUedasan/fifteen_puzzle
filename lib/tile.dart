import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  const Tile({Key? key, required this.number}) : super(key: key);

  final int number;

  bool get whitespace => number == 0;

  @override
  Widget build(BuildContext context) {
    if (whitespace) {
      return Container();
    }

    return Text(
      "$number",
      style: Theme.of(context)
          .textTheme
          .headlineMedium!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }
}

import 'package:flutter/material.dart';

import 'tile.dart';

class Cell extends StatelessWidget {
  const Cell({Key? key, required this.tile, required this.onTap})
      : super(key: key);

  final Tile tile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.0),
        ),
        alignment: Alignment.center,
        child: tile,
      ),
    );
  }
}

import 'package:collection/collection.dart';
import 'package:fifteen_puzzle/position.dart';
import 'package:flutter/material.dart';

import 'cell.dart';
import 'tile.dart';

class Grid extends StatelessWidget {
  const Grid({
    Key? key,
    required this.width,
    required this.gridSize,
    required this.tiles,
    required this.onTileMoved,
  }) : super(key: key);

  final double width;
  final int gridSize;
  final List<Tile> tiles;
  final void Function(int, int) onTileMoved;

  Tile getTile(Position p) {
    return tiles[p.index];
  }

  void onTap(Position p) {
    final swappablePosition = p.neighbours
        .firstWhereOrNull((p) => p.withinFrame && getTile(p).whitespace);
    if (swappablePosition == null) {
      return;
    }
    onTileMoved(p.index, swappablePosition.index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: width,
      width: width,
      child: Column(
        children: List.generate(gridSize, (i) => i)
            .map(
              (y) => Expanded(
                child: Row(
                  children: List.generate(gridSize, (i) => i).map((x) {
                    final position = Position(x, y, gridSize);
                    return Expanded(
                      child: Cell(
                        tile: getTile(position),
                        onTap: () => onTap(position),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

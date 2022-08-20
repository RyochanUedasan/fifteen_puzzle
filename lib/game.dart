import 'dart:math';

import 'package:collection/collection.dart';
import 'playtime_counter.dart';
import 'tile.dart';

class Game {
  static const availableGridSizes = [3, 4];
  final int gridSize;
  final int? seed;
  final List<Tile> tiles;
  final PlaytimeCounter playtimeCounter;

  int moveCount = 0;

  Game({this.gridSize = 4, this.seed = 5555})
      : tiles = generateShuffledTiles(gridSize, seed),
        playtimeCounter = PlaytimeCounter();

  static List<Tile> generateShuffledTiles(int gridSize, int? seed) {
    final tiles = List.generate(gridSize * gridSize, (i) => Tile(number: i));
    tiles.shuffle(Random(seed));
    return tiles;
  }

  bool firstMove() {
    return moveCount == 0;
  }

  void startCountingPlaytime() {
    playtimeCounter.start();
  }

  void stopCountingPlaytime() {
    playtimeCounter.stop();
  }

  /// Returns playtime formatted in `mm:ss`.
  String playtime() {
    return playtimeCounter
        .duration()
        .toString()
        .split(".")
        .first
        .split(":")
        .sublist(1)
        .join(":");
  }

  void incrementMoveCount() {
    moveCount++;
  }

  void swap(int from, int to) {
    final tmp = tiles[from];
    tiles[from] = tiles[to];
    tiles[to] = tmp;
  }

  bool completed() {
    List<int> target;
    if (tiles.first.whitespace) {
      target = tiles.map((t) => t.number).toList().sublist(1);
    } else if (tiles.last.whitespace) {
      target = tiles.map((t) => t.number).toList().sublist(0, tiles.length - 1);
    } else {
      return false;
    }
    return target.isSorted((a, b) => a.compareTo(b));
  }
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import 'grid.dart';
import 'tile.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final gridSize = 4;
  late int moveCount;
  late List<Tile> tiles;
  late List<int> answer;
  late List<int> answer2;

  void initialize() {
    moveCount = 0;
    tiles = generateShuffledTiles();
    answer = List.generate(gridSize * gridSize, (i) => i);
    answer2 = answer.sublist(1);
    answer2.add(0);
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  List<Tile> generateShuffledTiles() {
    final tiles = List.generate(gridSize * gridSize, (i) => Tile(number: i));
    tiles.shuffle();
    return tiles;
  }

  bool completed() {
    if (tiles.first.whitespace) {
      return zip([tiles.map((t) => t.number), answer])
          .every((l) => l[0] == l[1]);
    }
    if (tiles.last.whitespace) {
      return zip([tiles.map((t) => t.number), answer2])
          .every((l) => l[0] == l[1]);
    }
    return false;
  }

  void onTileMoved(int from, int to) {
    final tmp = tiles[from];
    tiles[from] = tiles[to];
    tiles[to] = tmp;
    setState(() {
      moveCount++;
    });
    if (completed()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Completed!"),
          content: Text("Your score is: $moveCount"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back'),
            ),
          ],
        ),
      );
    }
  }

  Widget scoreBoard() {
    return Center(
      child: Text(
        "Score: $moveCount",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('15 Puzzle')),
      body: Column(
        children: [
          const SizedBox(height: 32),
          scoreBoard(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Builder(builder: (context) {
                  final mediaQuerySize = MediaQuery.of(context).size;
                  return Grid(
                    width: math.min(
                      mediaQuerySize.height,
                      mediaQuerySize.width,
                    ),
                    gridSize: gridSize,
                    tiles: tiles,
                    onTileMoved: onTileMoved,
                  );
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  initialize();
                });
              },
              child: Text(
                "Reset",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:url_launcher/url_launcher.dart';

import 'grid.dart';
import 'tile.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int gridSize = 4;
  late int moveCount;
  late List<Tile> tiles;
  late List<int> answer;
  late List<int> answer2;

  void initialize({int? gSize}) {
    if (gSize != null) gridSize = gSize;
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
          content: Text("Your moves: $moveCount"),
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
        "Moves: $moveCount",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton(
          value: gridSize,
          focusColor: Colors.transparent,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
          onChanged: (int? newValue) {
            setState(() {
              initialize(gSize: newValue!);
            });
          },
          items: [3, 4]
              .map(
                (i) => DropdownMenuItem<int>(
                  value: i,
                  child: Text("${i * i - 1} Puzzle"),
                ),
              )
              .toList(),
        ),
      ),
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
      bottomSheet: kIsWeb
          ? Container(
              height: 32,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Built with Flutter. ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'GitHub',
                      style: const TextStyle(color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(
                            Uri.parse(
                              "https://github.com/RyochanUedasan/fifteen_puzzle",
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

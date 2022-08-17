import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'grid.dart';
import 'game.dart';

class Play extends StatefulWidget {
  const Play({Key? key}) : super(key: key);

  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  late Game game;

  @override
  void initState() {
    super.initState();
    game = Game();
  }

  void onTileMoved(int from, int to) {
    game.swap(from, to);
    setState(() {
      game.incrementMoveCount();
    });
    if (game.completed()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Completed!"),
          content: Text("Your moves: ${game.moveCount}"),
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
        "Moves: ${game.moveCount}",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: DropdownButton(
          value: game.gridSize,
          focusColor: Colors.transparent,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold),
          onChanged: (int? newValue) {
            setState(() {
              game = Game(gridSize: newValue!);
            });
          },
          items: Game.availableGridSizes
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
                    gridSize: game.gridSize,
                    tiles: game.tiles,
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
                  game = Game();
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

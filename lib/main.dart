import 'package:flutter/material.dart';
import 'dart:async';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Card Game',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const MemoryCardGame(),
    );
  }
}

class MemoryCardGame extends StatefulWidget {
  const MemoryCardGame({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MemoryCardGameState createState() => _MemoryCardGameState();
}

class _MemoryCardGameState extends State<MemoryCardGame> {
  late List<int> cardNumbers;
  late List<bool> cardFlips;
  late int previousIndex;
  late int moves;
  late bool gameComplete;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    cardNumbers = List.generate(8, (index) => index + 1)..addAll(List.generate(8, (index) => index + 1));
    cardNumbers.shuffle();
    cardFlips = List.filled(16,false);
    previousIndex = -1;
    moves = 0;
    gameComplete = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Card Game'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
        ),
        itemBuilder: (context, index) => buildCard(index),
        itemCount: 16,
      ),
      bottomNavigationBar: BottomAppBar(color: Colors.teal,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Moves: $moves',
          style: const TextStyle(fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            startNewGame();
          });
        },
        child: const Icon(Icons.replay_circle_filled),
      ),
    );
  }

  Widget buildCard(int index) {
    return GestureDetector(
      onTap: () {
        if (!gameComplete && !cardFlips[index]) {
          handleCardTap(index);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: cardFlips[index] ? Colors.teal: Colors.grey[500],
          borderRadius: BorderRadius.circular(10.0),),
        child: Center(
          child: cardFlips[index]
              ? Text(
            '${cardNumbers[index]}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 25.0,
            ),
          )
              : null,
        ),
      ),
    );
  }

  void handleCardTap(int index) {
    setState(() {
      cardFlips[index] = true;

      if (previousIndex == -1) {
        previousIndex = index;
      } else {
        if (cardNumbers[previousIndex] != cardNumbers[index]) {
          Timer(const Duration(seconds: 1), () {
            setState(() {
              cardFlips[previousIndex] = false;
              cardFlips[index] = false;
              previousIndex = -1;
              moves++;
            });
          });
        } else {

          if (!cardFlips.contains(false)) {
            gameComplete = true;
            showGameCompleteDialog();
          }
          previousIndex = -1;
          moves++;
        }
      }
    });
  }

  void showGameCompleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!',
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          content: Text('You completed the game in $moves moves.',),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  startNewGame();
                });
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }
}

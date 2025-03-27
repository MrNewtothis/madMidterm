import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PictureEasyMode extends StatefulWidget {
  final int pictureIndex3;

  PictureEasyMode(this.pictureIndex3);

  @override
  _PictureEasyModeState createState() => _PictureEasyModeState();
}

class _PictureEasyModeState extends State<PictureEasyMode> {
  late SharedPreferences sharedPreferences;
  late List<int> puzzle;
  late List<bool> tileInPosition;
  late int moves;
  late bool isCompleted;
  late Timer timer;
  int secondsElapsed = 0;
  late AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    initPuzzle();
    audioPlayer = AudioPlayer();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    timer.cancel();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });
  }

  void initPuzzle() {
    puzzle = List.generate(9, (index) => index);
    // Predefined number of random moves
    for (int i = 0; i < 25; i++) {
      int emptyIndex = puzzle.indexOf(8);
      List<int> possibleMoves = [];
      if (emptyIndex % 3 != 0) possibleMoves.add(emptyIndex - 1); // Left
      if ((emptyIndex + 1) % 3 != 0) possibleMoves.add(emptyIndex + 1); // Right
      if (emptyIndex - 3 >= 0) possibleMoves.add(emptyIndex - 3); // Up
      if (emptyIndex + 3 < 9) possibleMoves.add(emptyIndex + 3); // Down
      int randomMove = possibleMoves[Random().nextInt(possibleMoves.length)];
      swapTiles(emptyIndex, randomMove);
    }
    moves = 0;
    isCompleted = false;
    tileInPosition = List.filled(9, false); // Initialized all tiles to false
    updateTileInPosition();
  }

  Future<void> completePuzzle() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var bestScoreKey2 = '_easypic${widget.pictureIndex3}BestScore';
    if (!sharedPreferences.containsKey(bestScoreKey2) ||
        moves < sharedPreferences.getInt(bestScoreKey2)!) {
      await sharedPreferences.setInt(bestScoreKey2, moves);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        title: Text(
          'Moves: $moves',
          style: const TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            showExitConfirmation();
          },
        ),
      ),
      body: Stack(
        children: [
          RepaintBoundary(
            key: const Key('backgroundBlur'),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                  sigmaX: 25.2, sigmaY: 25.2, tileMode: TileMode.decal),
              child: Image.asset(
                'assets/easy/${widget.pictureIndex3}/original.jpg',
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    showFullSizeImage();
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/easy/${widget.pictureIndex3}/original.jpg',
                      height: 80,
                      width: 80,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Gap(10),
                Text(
                  'Tiles in position: ${tileInPosition.where((element) => element).length}',
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const Gap(50),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 320,
                    width: 320,
                    color: Colors.black.withOpacity(0.5),
                    child: GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5, // cross axis spacing
                        mainAxisSpacing: 5, // main axis spacing
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (!isCompleted) {
                              setState(() {
                                moveTile(index);
                              });
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    tileInPosition[index] ? Colors.green : null,
                              ),
                              child: puzzle[index] == 8
                                  ? Container()
                                  : Image.asset(
                                      'assets/easy/${widget.pictureIndex3}/${puzzle[index] + 1}.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.timer, color: Colors.white),
                          const Gap(5),
                          Text(
                            '${formatTime(secondsElapsed)}',
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const Gap(20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.restart_alt),
                        onPressed: () {
                          showRestartConfirmation();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void moveTile(int index) {
    if (puzzle[index] == 8) return;

    int emptyIndex = puzzle.indexOf(8);
    List<int> possibleMoves = [];
    if (emptyIndex % 3 != 0) possibleMoves.add(emptyIndex - 1); // Left
    if ((emptyIndex + 1) % 3 != 0) possibleMoves.add(emptyIndex + 1); // Right
    if (emptyIndex - 3 >= 0) possibleMoves.add(emptyIndex - 3); // Up
    if (emptyIndex + 3 < 9) possibleMoves.add(emptyIndex + 3); // Down

    if (!possibleMoves.contains(index)) {
      playAudio('assets/Not Movable.wav');
      return;
    }

    playAudio('assets/Tile Move.wav');

    swapTiles(index, emptyIndex);
    updateTileInPosition();

    if (!isSolved()) {
      moves++;
    } else {
      isCompleted = true;
      completePuzzle();
    }
  }

  Future<void> playAudio(String assetPath) async {
    final player = AudioPlayer();
    try {
      await player.setAsset(assetPath);
      await player.play();
    } catch (e) {
      print('Error playing audio: $e');
    } finally {
      await player.dispose();
    }
  }

  void swapTiles(int index1, int index2) {
    int temp = puzzle[index1];
    puzzle[index1] = puzzle[index2];
    puzzle[index2] = temp;
  }

  bool isSolved() {
    for (int i = 0; i < 9; i++) {
      if (puzzle[i] != i) {
        return false;
      }
    }
    return true;
  }

  void updateTileInPosition() {
    bool allTilesInPosition = true;
    for (int i = 0; i < 9; i++) {
      if (puzzle[i] != i) {
        allTilesInPosition = false;
      }
      if (puzzle[i] == i) {
        tileInPosition[i] = true;
      } else {
        tileInPosition[i] = false;
      }
    }
    if (allTilesInPosition) {
      showSuccessDialog();
    }
  }

  void showSuccessDialog() async {
    showFullSizeImage();
    audioPlayer.setAsset('assets/Choir Harp Bless.wav');
    await audioPlayer.play();
    final int currentTime = secondsElapsed;
    timer.cancel();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Congratulations!"),
          content:
              Text("You solved the puzzle!\nTime: ${formatTime(currentTime)}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Quit"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                initPuzzle(); // Restart the puzzle
                resetTimer(); // Reset the timer
                await audioPlayer.setAsset('assets/Shuffle-Reset.wav');
                await audioPlayer.play();
              },
              child: const Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  void resetTimer() {
    timer.cancel(); // Cancel the current timer
    secondsElapsed = 0; // Reset the seconds elapsed
    startTimer(); // Start a new timer
  }

  void showRestartConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Restart Puzzle"),
          content: const Text("Are you sure you want to restart the puzzle?"),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                initPuzzle(); // Restart the puzzle
                resetTimer(); // Reset the timer
                await audioPlayer.setAsset('assets/Shuffle-Reset.wav');
                await audioPlayer.play();
              },
              child: const Text("Restart"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Resume"),
            ),
          ],
        );
      },
    );
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void showFullSizeImage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog when tapped
            },
            child: SizedBox(
              height: 350,
              width: 350,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(20), // Set the border radius
                child: Image(
                  image: AssetImage(
                    'assets/easy/${widget.pictureIndex3}/original.jpg',
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showExitConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Exit Puzzle"),
          content: const Text("Are you sure you want to exit?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // exit
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}

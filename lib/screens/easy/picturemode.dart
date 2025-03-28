import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'choosepic_easy.dart';

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

  // Function to initialize and shuffle the puzzle
  void initPuzzle() {
    // Create a list of numbers from 0 to 8, representing puzzle tiles.
    // Each number corresponds to a piece of the puzzle.
    puzzle = List.generate(9, (index) => index);

    // Shuffle the puzzle using a predefined number of random moves.
    // This ensures the puzzle starts in a solvable, shuffled state.
    for (int i = 0; i < 25; i++) {
      // Find the index of the empty tile (represented by the number 8).
      int emptyIndex = puzzle.indexOf(8);

      // Create a list to store possible moves (tiles that can be swapped with the empty space).
      List<int> possibleMoves = [];

      // If the empty tile is not in the first column, it can move left.
      if (emptyIndex % 3 != 0) possibleMoves.add(emptyIndex - 1); // Left

      // If the empty tile is not in the last column, it can move right.
      if ((emptyIndex + 1) % 3 != 0) possibleMoves.add(emptyIndex + 1); // Right

      // If the empty tile is not in the first row, it can move up.
      if (emptyIndex - 3 >= 0) possibleMoves.add(emptyIndex - 3); // Up

      // If the empty tile is not in the last row, it can move down.
      if (emptyIndex + 3 < 9) possibleMoves.add(emptyIndex + 3); // Down

      // Select a random tile from the possible moves to swap with the empty tile.
      int randomMove = possibleMoves[Random().nextInt(possibleMoves.length)];

      // Swap the empty tile with the selected tile to create a shuffled puzzle.
      swapTiles(emptyIndex, randomMove);
    }

    // Reset the move counter to 0 because the game is starting fresh.
    moves = 0;

    // Mark the puzzle as incomplete since it was just shuffled.
    isCompleted = false;

    // Create a list to track whether each tile is in its correct position.
    // Initially, all tiles are marked as incorrect (false).
    tileInPosition = List.filled(9, false);

    // Update the `tileInPosition` list to check which tiles are in the correct spot.
    updateTileInPosition();
  }

  // Function to save the best score for the completed puzzle
  Future<void> completePuzzle() async {
    // Access shared preferences to store game data
    sharedPreferences = await SharedPreferences.getInstance();

    // Generate a unique key for storing the best score of the current puzzle image
    var bestScoreKey2 = '_easypic${widget.pictureIndex3}BestScore';

    // If there is no saved score OR the current move count is lower, update the best score
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
    if (puzzle[index] == 8)
      return; // If the tapped tile is the empty space, do nothing

    int emptyIndex =
        puzzle.indexOf(8); // Find the current position of the empty tile

    List<int> possibleMoves = []; // List to store valid moves
    if (emptyIndex % 3 != 0) possibleMoves.add(emptyIndex - 1); // Left move
    if ((emptyIndex + 1) % 3 != 0)
      possibleMoves.add(emptyIndex + 1); // Right move
    if (emptyIndex - 3 >= 0) possibleMoves.add(emptyIndex - 3); // Up move
    if (emptyIndex + 3 < 9) possibleMoves.add(emptyIndex + 3); // Down move

    if (!possibleMoves.contains(index)) {
      // Check if the selected tile can move
      playAudio('assets/Not Movable.wav'); // Play "not movable" sound
      return; // Exit the function if the move is invalid
    }

    playAudio('assets/Tile Move.wav'); // Play tile move sound effect

    swapTiles(index, emptyIndex); // Swap the tapped tile with the empty tile
    updateTileInPosition(); // Update the tile positions

    if (!isSolved()) {
      // Check if the puzzle is solved
      moves++; // Increase move count if not yet solved
    } else {
      isCompleted = true; // Mark puzzle as completed
      completePuzzle(); // Save best score if applicable
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
    int temp =
        puzzle[index1]; // Store the first tile value in a temporary variable.
    puzzle[index1] = puzzle[
        index2]; // Swap: Assign the second tile's value to the first tile.
    puzzle[index2] =
        temp; // Swap: Assign the original first tile's value to the second tile.
  } // This function swaps two tiles in the puzzle.

  bool isSolved() {
    for (int i = 0; i < 9; i++) {
      // Loop through all tiles (0 to 8).
      if (puzzle[i] != i) {
        // If any tile is not in its correct position...
        return false; // The puzzle is not solved.
      }
    }
    return true; // If all tiles are in the correct order, the puzzle is solved.
  } // This function checks if all tiles are in their correct positions.

  void updateTileInPosition() {
    bool allTilesInPosition =
        true; // Assume all tiles are in position by default.

    for (int i = 0; i < 9; i++) {
      // Loop through all 9 tiles.
      if (puzzle[i] != i) {
        // If a tile is not in its correct position...
        allTilesInPosition =
            false; // Mark that not all tiles are correctly placed.
      }

      if (puzzle[i] == i) {
        // If the tile is in its correct position...
        tileInPosition[i] = true; // Mark this tile as correctly placed.
      } else {
        tileInPosition[i] = false; // Otherwise, mark it as misplaced.
      }
    }

    if (allTilesInPosition) {
      // If all tiles are in the correct position...
      showSuccessDialog(); // Display the success message.
    }
  } // This function checks if each tile is correctly placed and updates the status.

  void showSuccessDialog() async {
    showFullSizeImage(); // Show the full image of the completed puzzle.

    audioPlayer
        .setAsset('assets/Choir Harp Bless.wav'); // Load the success sound.
    await audioPlayer.play(); // Play the success sound.

    final int currentTime = secondsElapsed; // Store the elapsed time.
    timer.cancel(); // Stop the timer since the puzzle is completed.

    showDialog(
      // Show a popup dialog to congratulate the player.
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // Create an alert dialog.
          title: const Text(
              "Congratulations!"), // Display a congratulatory message.
          content: Text(
              "You solved the puzzle!\nTime: ${formatTime(currentTime)}"), // Show the completion time.
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog when "Quit" is pressed.
              },
              child: const Text("Quit"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog.
                initPuzzle(); // Restart the puzzle.
                resetTimer(); // Reset the timer.
                await audioPlayer.setAsset(
                    'assets/Shuffle-Reset.wav'); // Load the shuffle/reset sound.
                await audioPlayer.play(); // Play the shuffle/reset sound.
              },
              child: const Text("Restart"), // Button to restart the game.
            ),
          ],
        );
      },
    );
  } // This function shows a success message, plays a sound, and offers restart options.

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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChoosePicEasyScreen(),
                ));
                setState(() {});
                // Navigator.of(context).pop(); // Close the dialog
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

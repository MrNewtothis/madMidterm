import 'package:flutter/material.dart';
import 'package:mtr_puzzle/screens/easy/picturemode.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This screen allows the user to choose a picture to play a puzzle game.
class ChoosePicEasyScreen extends StatefulWidget {
  ChoosePicEasyScreen();

  @override
  _ChoosePicEasyScreenState createState() => _ChoosePicEasyScreenState();
}

class _ChoosePicEasyScreenState extends State<ChoosePicEasyScreen> {
  late SharedPreferences
      sharedPreferences3; // This will store game data (best scores).
  List<int> bestScores3 = [
    -1,
    -1,
    -1,
    -1
  ]; // Stores best scores for each of the 4 puzzles.
  int hoverIndex = -1; // Keeps track of which image is being hovered over.

  @override
  void initState() {
    super.initState();
    fetchBestScoresEasy(); // Load best scores when the screen opens.
  }

  // Fetches and updates the best scores from local storage.
  Future<void> fetchBestScoresEasy() async {
    sharedPreferences3 =
        await SharedPreferences.getInstance(); // Access stored game data.
    List<int> newBestScores3 = [];

    // Loop through 4 images to retrieve their best scores.
    for (int i = 0; i < 4; i++) {
      var bestScoreKey3 =
          '_easypic${i + 1}BestScore'; // Unique key for each picture's best score.

      // Check if a score exists, otherwise use -1 (meaning no score).
      if (sharedPreferences3.containsKey(bestScoreKey3)) {
        newBestScores3.add(sharedPreferences3.getInt(bestScoreKey3)!);
      } else {
        newBestScores3.add(-1);
      }
    }

    setState(() {
      bestScores3 = newBestScores3; // Update the UI with fetched scores.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Select a picture'), // Title at the top of the screen.
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50), // Adds space around the grid.
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Display 2 images per row.
            crossAxisSpacing: 20.0, // Space between columns.
            mainAxisSpacing: 20.0, // Space between rows.
          ),
          itemCount: 4, // There are 4 puzzle images.
          itemBuilder: (context, index) {
            int pictureIndex3 = index + 1; // Picture numbers are 1 to 4.
            return MouseRegion(
              onEnter: (_) {
                setState(() {
                  hoverIndex =
                      index; // Detects when the user hovers over an image.
                });
              },
              onExit: (_) {
                setState(() {
                  hoverIndex =
                      -1; // Detects when the user moves the mouse away.
                });
              },
              child: GestureDetector(
                onTap: () => navigateToPictureModeEasy(
                    pictureIndex3), // When clicked, start the puzzle.
                child: Stack(
                  // Allows layering of widgets (image, text, hover effect).
                  children: [
                    // Displays the puzzle image.
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          16.0), // Makes the corners rounded.
                      child: Image.asset(
                          'assets/easy/$pictureIndex3/original.jpg'), // Load image from assets.
                    ),
                    // Shows the best move score overlayed on the image.
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          color: Colors
                              .black38, // Dark transparent background for text.
                          child: Text(
                            'Best Move: ${bestScores3[index] == -1 ? '-' : bestScores3[index]}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25), // White text with size 25.
                          ),
                        ),
                      ),
                    ),
                    // Shows a darker overlay when hovered over.
                    if (hoverIndex == index)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black
                              .withOpacity(0.5), // Darkens when hovered over.
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Navigates to the puzzle screen when an image is clicked.
  void navigateToPictureModeEasy(int pictureIndex3) {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) =>
          PictureEasyMode(pictureIndex3), // Opens the puzzle screen.
    ))
        .then((moves) {
      // Waits for the puzzle screen to return the number of moves used.
      if (moves != null) {
        var bestScoreKey3 = '_easypic$pictureIndex3' +
            'BestScore'; // Get the key for this picture's best score.

        // If there's no existing best score or the new score is better, save it.
        if (!sharedPreferences3.containsKey(bestScoreKey3) ||
            moves < sharedPreferences3.getInt(bestScoreKey3)!) {
          sharedPreferences3.setInt(
              bestScoreKey3, moves); // Save the new best score.
          fetchBestScoresEasy(); // Update the displayed scores.
        }
      }
    });
  }
}

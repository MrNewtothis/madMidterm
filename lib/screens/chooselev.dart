import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mtr_puzzle/screens/easy/choosepic_easy.dart';
import 'package:mtr_puzzle/screens/hard/choosepic_hard.dart';
import 'package:mtr_puzzle/screens/medium/choosepic_medium.dart';

// This screen allows the user to choose a difficulty level for the puzzle game.
class ChooseLevelScreen extends StatefulWidget {
  final bool isMuted; // Stores whether the game audio is muted or not.
  final VoidCallback toggleMute; // Function to toggle the mute state.

  const ChooseLevelScreen(
      {Key? key, required this.isMuted, required this.toggleMute})
      : super(key: key);

  @override
  _ChooseLevelScreenState createState() => _ChooseLevelScreenState();
}

class _ChooseLevelScreenState extends State<ChooseLevelScreen> {
  bool isHoveredEasy =
      false; // Tracks whether the mouse is hovering over the Easy button.
  bool isHoveredMedium = false; // Tracks hover state for the Medium button.
  bool isHoveredHard = false; // Tracks hover state for the Hard button.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Makes the app bar background transparent.
        elevation: 0.0, // Removes shadow from the app bar.
        title: const Text('Select a level'), // Title text for the screen.
        centerTitle: true, // Centers the title.
        actions: [
          IconButton(
            onPressed: widget
                .toggleMute, // Calls the function to mute/unmute the audio.
            icon: Icon(widget.isMuted ? Icons.volume_off : Icons.volume_up),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image for the screen.
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/image1.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Easy level button with hover effect.
                buildLevelButton(
                    'EASY', '9 Tiles', Colors.blueAccent, isHoveredEasy, () {
                  setState(() => isHoveredEasy = true);
                }, () {
                  setState(() => isHoveredEasy = false);
                }, easybtn),
                const Gap(15),
                // Medium level button with hover effect.
                buildLevelButton(
                    'MEDIUM', '16 Tiles', Colors.orange, isHoveredMedium, () {
                  setState(() => isHoveredMedium = true);
                }, () {
                  setState(() => isHoveredMedium = false);
                }, mediumbtn),
                const Gap(15),
                // Hard level button with hover effect.
                buildLevelButton('HARD', '25 Tiles', Colors.red, isHoveredHard,
                    () {
                  setState(() => isHoveredHard = true);
                }, () {
                  setState(() => isHoveredHard = false);
                }, hardbtn),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create level buttons with hover effect.
  Widget buildLevelButton(
      String label,
      String subtext,
      Color color,
      bool isHovered,
      VoidCallback onEnter,
      VoidCallback onExit,
      VoidCallback onPressed) {
    return MouseRegion(
      onEnter: (_) => onEnter(), // Changes hover state when mouse enters.
      onExit: (_) => onExit(), // Changes hover state when mouse exits.
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: isHovered ? 320 : 300, // Slightly enlarges button when hovered.
        height: isHovered ? 110 : 100,
        child: ElevatedButton(
          onPressed:
              onPressed, // Calls the function to navigate to the chosen level.
          style: ElevatedButton.styleFrom(
            backgroundColor: color, // Sets the button color.
            foregroundColor: Colors.white, // Sets text color.
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(10.0), // Rounds button corners.
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 23.0,
                  color: Colors.white,
                ),
              ),
              const Gap(5),
              Text(
                subtext,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 17.0,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Navigates to the Easy level screen.
  void easybtn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ChoosePicEasyScreen(),
      ),
    );
  }

  // Navigates to the Medium level screen.
  void mediumbtn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ChoosePicMediumScreen(),
      ),
    );
  }

  // Navigates to the Hard level screen.
  void hardbtn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ChoosePicHardScreen(),
      ),
    );
  }
}

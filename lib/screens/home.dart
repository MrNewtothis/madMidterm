import 'package:flutter/material.dart';
import 'package:mtr_puzzle/screens/about.dart'; // Importing the About Screen
import 'package:mtr_puzzle/screens/chooselev.dart'; // Importing the Choose Level Screen
import 'package:shared_preferences/shared_preferences.dart'; // Used to store best score locally
import 'package:just_audio/just_audio.dart'; // Library for playing audio files

// The main game screen of the Pindot Puzzler Game
class PuzzleGame extends StatefulWidget {
  const PuzzleGame({Key? key}) : super(key: key);

  @override
  State<PuzzleGame> createState() => _PuzzleAppState();
}

// State class to manage the UI and functionality of the game
class _PuzzleAppState extends State<PuzzleGame> {
  late int bestScore =
      -1; // Variable to store the best score, initialized to -1
  late AudioPlayer audioPlayer; // Audio player instance for background music
  bool isMuted = false; // Flag to check if the sound is muted
  bool audioLoaded =
      false; // Flag to check if audio has been successfully loaded
  bool isHovered = false; // Flag to check if the play button is being hovered

  @override
  void initState() {
    super.initState();
    loadBestScore(); // Load best score from local storage
    initAudioPlayer(); // Initialize the audio player
  }

  // Load the best score stored in local storage
  Future<void> loadBestScore() async {
    SharedPreferences sp =
        await SharedPreferences.getInstance(); // Get SharedPreferences instance
    setState(() {
      bestScore = sp.getInt('bestScore') ??
          -1; // Retrieve best score, or set to -1 if not found
    });
  }

  // Initialize the audio player and load background music
  Future<void> initAudioPlayer() async {
    audioPlayer = AudioPlayer(); // Create a new AudioPlayer instance
    try {
      await audioPlayer.setAsset('Home.mp3'); // Load the audio file from assets
      await audioPlayer
          .setLoopMode(LoopMode.one); // Set the music to loop continuously
      setState(() {
        audioLoaded = true; // Mark audio as successfully loaded
      });
    } catch (error) {
      print(
          'Error loading audio: $error'); // Print an error message if the audio fails to load
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // Allows content to extend behind the app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Makes the app bar transparent
        elevation: 0.0, // Removes shadow from the app bar
        title: const Text(
          'PINDOT PUZZLER GAME', // Title displayed at the top
        ),
        centerTitle: true, // Centers the title in the app bar
        actions: [
          IconButton(
            onPressed:
                navigateToAboutScreen, // Navigate to About screen when clicked
            icon: const Icon(Icons.help_outline_outlined), // Help icon button
          ),
          IconButton(
            onPressed: toggleMute, // Toggle mute when clicked
            icon: Icon(isMuted
                ? Icons.volume_off
                : Icons.volume_up), // Mute/Unmute icon
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background Image for the game screen
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                    'assets/images/image1.jpg'), // Set background image
                fit: BoxFit.cover, // Cover entire screen with the image
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2), // Darken the image slightly
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          SafeArea(
            child: GestureDetector(
              onTap: playAudio, // Play audio when the screen is tapped
              onTapCancel: stopAudio, // Stop audio if tap is canceled
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/icon.png', // Game logo
                      height: 350,
                      width: 400,
                    ),
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          isHovered = true; // When mouse hovers over the button
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          isHovered = false; // When mouse leaves the button
                        });
                      },
                      child: AnimatedContainer(
                        duration:
                            Duration(milliseconds: 100), // Animation duration
                        width:
                            isHovered ? 220 : 200, // Increase size when hovered
                        height: isHovered ? 70 : 60,
                        child: ElevatedButton(
                          onPressed:
                              chooseLevelScreen, // Navigate to level selection screen
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent, // Button color
                            foregroundColor: Colors.white, // Text color
                            elevation: 5, // Button shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Rounded corners
                            ),
                          ),
                          child: const SizedBox(
                            width: 200,
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow), // Play icon
                                SizedBox(
                                    width: 8), // Spacing between icon and text
                                Text(
                                  'PLAY', // Button text
                                  style: TextStyle(
                                    fontFamily: 'Manrope', // Custom font
                                    fontSize: 20.0, // Font size
                                    color: Colors.white, // Text color
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    audioPlayer
        .dispose(); // Dispose of the audio player when the screen is closed
    super.dispose();
  }

  // Navigate to level selection screen
  void chooseLevelScreen() {
    playAudio(); // Play click sound
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ChooseLevelScreen(
          isMuted: isMuted,
          toggleMute: toggleMute,
        ),
      ),
    );
  }

  // Navigate to the About screen
  void navigateToAboutScreen() {
    playAudio(); // Play click sound
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => AboutScreen(
          isMuted: isMuted,
          toggleMute: toggleMute,
        ),
      ),
    );
  }

  // Play audio if it's not muted
  void playAudio() async {
    if (!audioLoaded) {
      await initAudioPlayer(); // Load audio if not already loaded
    }
    try {
      await audioPlayer.play(); // Play the audio file
    } catch (e) {
      print('Error playing audio: $e'); // Print an error message if audio fails
    }
  }

  // Stop playing audio
  void stopAudio() {
    audioPlayer.stop();
  }

  // Toggle mute functionality
  void toggleMute() {
    setState(() {
      isMuted = !isMuted; // Change mute status
      audioPlayer.setVolume(isMuted ? 0 : 1); // Set volume accordingly
    });
  }
}

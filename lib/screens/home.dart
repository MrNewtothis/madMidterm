import 'package:flutter/material.dart';
import 'package:mtr_puzzle/screens/about.dart';
import 'package:mtr_puzzle/screens/chooselev.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:just_audio/just_audio.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({Key? key}) : super(key: key);

  @override
  State<PuzzleGame> createState() => _PuzzleAppState();
}

class _PuzzleAppState extends State<PuzzleGame> {
  late int bestScore = -1;
  late AudioPlayer audioPlayer;
  bool isMuted = false;
  bool audioLoaded = false;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    loadBestScore();
    initAudioPlayer();
  }

  Future<void> loadBestScore() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      bestScore = sp.getInt('bestScore') ?? -1;
    });
  }

  Future<void> initAudioPlayer() async {
    audioPlayer = AudioPlayer();
    try {
      await audioPlayer.setAsset('Home.mp3');
      await audioPlayer.setLoopMode(LoopMode.one);
      setState(() {
        audioLoaded = true;
      });
    } catch (error) {
      print('Error loading audio: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text(
          'PINDOT PUZZLER GAME',
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: navigateToAboutScreen,
            icon: const Icon(Icons.help_outline_outlined),
          ),
          IconButton(
            onPressed: toggleMute,
            icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/image1.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.dstATop,
                ),
              ),
            ),
          ),
          SafeArea(
            child: GestureDetector(
              onTap: playAudio,
              onTapCancel: stopAudio,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/icon.png',
                      height: 350,
                      width: 400,
                    ),
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          isHovered = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          isHovered = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        width: isHovered ? 220 : 200,
                        height: isHovered ? 70 : 60,
                        child: ElevatedButton(
                          onPressed: chooseLevelScreen,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const SizedBox(
                            width: 200,
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_arrow),
                                const SizedBox(width: 8),
                                Text(
                                  'PLAY',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 20.0,
                                    color: Colors.white,
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
    audioPlayer.dispose();
    super.dispose();
  }

  void chooseLevelScreen() {
    playAudio();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ChooseLevelScreen(
          isMuted: isMuted,
          toggleMute: toggleMute,
        ),
      ),
    );
  }

  void navigateToAboutScreen() {
    playAudio();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => AboutScreen(
          isMuted: isMuted,
          toggleMute: toggleMute,
        ),
      ),
    );
  }

  void playAudio() async {
    if (!audioLoaded) {
      await initAudioPlayer();
    }
    try {
      await audioPlayer.play();
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  void stopAudio() {
    audioPlayer.stop();
  }

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
      audioPlayer.setVolume(isMuted ? 0 : 1);
    });
  }
}

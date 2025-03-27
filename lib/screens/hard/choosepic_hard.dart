import 'package:flutter/material.dart';
import 'package:mtr_puzzle/screens/hard/picturemode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChoosePicHardScreen extends StatefulWidget {
  ChoosePicHardScreen();

  @override
  _ChoosePicHardScreenState createState() => _ChoosePicHardScreenState();
}

class _ChoosePicHardScreenState extends State<ChoosePicHardScreen> {
  late SharedPreferences sharedPreferences1;
  List<int> bestScores1 = [-1, -1, -1, -1];
  int hoverIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchBestScoresHard();
  }

  Future<void> fetchBestScoresHard() async {
    sharedPreferences1 = await SharedPreferences.getInstance();
    List<int> newBestScores1 = [];
    for (int i = 0; i < 4; i++) {
      var bestScoreKey1 = '_hardpic${i + 1}BestScore';
      if (sharedPreferences1.containsKey(bestScoreKey1)) {
        newBestScores1.add(sharedPreferences1.getInt(bestScoreKey1)!);
      } else {
        newBestScores1.add(-1);
      }
    }
    setState(() {
      bestScores1 = newBestScores1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a picture'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20.0,
            mainAxisSpacing: 20.0,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            int pictureIndex1 = index + 1;
            return MouseRegion(
              onEnter: (_) {
                setState(() {
                  hoverIndex = index;
                });
              },
              onExit: (_) {
                setState(() {
                  hoverIndex = -1;
                });
              },
              child: GestureDetector(
                onTap: () => navigateToPictureModeHard(pictureIndex1),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                          'assets/hard/$pictureIndex1/original.jpg'),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          color: Colors.black38,
                          child: Text(
                            'Best score: ${bestScores1[index] == -1 ? '-' : bestScores1[index]}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 25),
                          ),
                        ),
                      ),
                    ),
                    if (hoverIndex == index)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
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

  void navigateToPictureModeHard(int pictureIndex1) {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => PictureHardMode(pictureIndex1),
    ))
        .then((moves) {
      if (moves != null) {
        var bestScoreKey1 = '_hardpic$pictureIndex1' + 'BestScore';
        if (!sharedPreferences1.containsKey(bestScoreKey1) ||
            moves < sharedPreferences1.getInt(bestScoreKey1)!) {
          sharedPreferences1.setInt(bestScoreKey1, moves);
          fetchBestScoresHard();
        }
      }
    });
  }
}

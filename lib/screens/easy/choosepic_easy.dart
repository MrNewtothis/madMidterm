import 'package:flutter/material.dart';
import 'package:mtr_puzzle/screens/easy/picturemode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChoosePicEasyScreen extends StatefulWidget {
  ChoosePicEasyScreen();

  @override
  _ChoosePicEasyScreenState createState() => _ChoosePicEasyScreenState();
}

class _ChoosePicEasyScreenState extends State<ChoosePicEasyScreen> {
  late SharedPreferences sharedPreferences3;
  List<int> bestScores3 = [-1, -1, -1, -1];
  int hoverIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchBestScoresEasy();
  }

  Future<void> fetchBestScoresEasy() async {
    sharedPreferences3 = await SharedPreferences.getInstance();
    List<int> newBestScores3 = [];
    for (int i = 0; i < 4; i++) {
      var bestScoreKey3 = '_easypic${i + 1}BestScore';
      if (sharedPreferences3.containsKey(bestScoreKey3)) {
        newBestScores3.add(sharedPreferences3.getInt(bestScoreKey3)!);
      } else {
        newBestScores3.add(-1);
      }
    }
    setState(() {
      bestScores3 = newBestScores3;
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
            int pictureIndex3 = index + 1;
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
                onTap: () => navigateToPictureModeEasy(pictureIndex3),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                          'assets/easy/$pictureIndex3/original.jpg'),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          color: Colors.black38,
                          child: Text(
                            'Best Move: ${bestScores3[index] == -1 ? '-' : bestScores3[index]}',
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

  void navigateToPictureModeEasy(int pictureIndex3) {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => PictureEasyMode(pictureIndex3),
    ))
        .then((moves) {
      if (moves != null) {
        var bestScoreKey3 = '_easypic$pictureIndex3' + 'BestScore';
        if (!sharedPreferences3.containsKey(bestScoreKey3) ||
            moves < sharedPreferences3.getInt(bestScoreKey3)!) {
          sharedPreferences3.setInt(bestScoreKey3, moves);
          fetchBestScoresEasy();
        }
      }
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtr_puzzle/screens/medium/picturemode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChoosePicMediumScreen extends StatefulWidget {
  ChoosePicMediumScreen();

  @override
  _ChoosePicMediumScreenState createState() => _ChoosePicMediumScreenState();
}

class _ChoosePicMediumScreenState extends State<ChoosePicMediumScreen> {
  late SharedPreferences sharedPreferences2;
  List<int> bestScores2 = [-1, -1, -1, -1];
  int hoverIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchBestScoresMedium();
  }

  Future<void> fetchBestScoresMedium() async {
    sharedPreferences2 = await SharedPreferences.getInstance();
    List<int> newBestScores2 = [];
    for (int i = 0; i < 4; i++) {
      var bestScoreKey2 = '_mediumpic${i + 1}BestScore';
      if (sharedPreferences2.containsKey(bestScoreKey2)) {
        newBestScores2.add(sharedPreferences2.getInt(bestScoreKey2)!);
      } else {
        newBestScores2.add(-1);
      }
    }
    setState(() {
      bestScores2 = newBestScores2;
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
            int pictureIndex2 = index + 1;
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
                onTap: () => navigateToPictureModeMedium(pictureIndex2),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                          'assets/medium/$pictureIndex2/original.jpg'),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Container(
                          color: Colors.black38,
                          child: Text(
                            'Best score: ${bestScores2[index] == -1 ? '-' : bestScores2[index]}',
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

  void navigateToPictureModeMedium(int pictureIndex2) {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => PictureMediumMode(pictureIndex2),
    ))
        .then((moves) {
      if (moves != null) {
        var bestScoreKey2 = '_mediumpic$pictureIndex2' + 'BestScore';
        if (!sharedPreferences2.containsKey(bestScoreKey2) ||
            moves < sharedPreferences2.getInt(bestScoreKey2)!) {
          sharedPreferences2.setInt(bestScoreKey2, moves);
          fetchBestScoresMedium();
        }
      }
    });
  }
}

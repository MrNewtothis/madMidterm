import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mtr_puzzle/screens/easy/choosepic_easy.dart';
import 'package:mtr_puzzle/screens/hard/choosepic_hard.dart';
import 'package:mtr_puzzle/screens/medium/choosepic_medium.dart';

class ChooseLevelScreen extends StatefulWidget {
  final bool isMuted;
  final VoidCallback toggleMute;

  const ChooseLevelScreen(
      {Key? key, required this.isMuted, required this.toggleMute})
      : super(key: key);

  @override
  _ChooseLevelScreenState createState() => _ChooseLevelScreenState();
}

class _ChooseLevelScreenState extends State<ChooseLevelScreen> {
  bool isHoveredEasy = false;
  bool isHoveredMedium = false;
  bool isHoveredHard = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('Select a level'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.toggleMute,
            icon: Icon(widget.isMuted ? Icons.volume_off : Icons.volume_up),
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
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isHoveredEasy = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHoveredEasy = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: isHoveredEasy ? 320 : 300,
                    height: isHoveredEasy ? 110 : 100,
                    child: ElevatedButton(
                      onPressed: easybtn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'EASY',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 23.0,
                              color: Colors.white,
                            ),
                          ),
                          Gap(5),
                          Text(
                            '9 Tiles',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 17.0,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(15),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isHoveredMedium = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHoveredMedium = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: isHoveredMedium ? 320 : 300,
                    height: isHoveredMedium ? 110 : 100,
                    child: ElevatedButton(
                      onPressed: mediumbtn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'MEDIUM',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 23.0,
                              color: Colors.white,
                            ),
                          ),
                          Gap(5),
                          Text(
                            '16 Tiles',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 17.0,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(15),
                MouseRegion(
                  onEnter: (_) {
                    setState(() {
                      isHoveredHard = true;
                    });
                  },
                  onExit: (_) {
                    setState(() {
                      isHoveredHard = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: isHoveredHard ? 320 : 300,
                    height: isHoveredHard ? 110 : 100,
                    child: ElevatedButton(
                      onPressed: hardbtn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'HARD',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 23.0,
                              color: Colors.white,
                            ),
                          ),
                          Gap(5),
                          Text(
                            '25 Tiles',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 17.0,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void easybtn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ChoosePicEasyScreen(),
      ),
    );
  }

  void mediumbtn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ChoosePicMediumScreen(),
      ),
    );
  }

  void hardbtn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => ChoosePicHardScreen(),
      ),
    );
  }
}

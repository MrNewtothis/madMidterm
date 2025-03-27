import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AboutScreen extends StatefulWidget {
  final bool isMuted;
  final VoidCallback toggleMute;

  const AboutScreen({Key? key, required this.isMuted, required this.toggleMute})
      : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  final style1 = const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  final style2 = const TextStyle(fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: const Text('ABOUT PINDOT PUZZLER'),
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
          SafeArea(
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        const Gap(5),
                        Image.asset(
                          'assets/images/icon.png',
                          height: 150,
                          width: 150,
                        ),
                        const Gap(5),
                        Text(
                          'About Pindot Puzzler:',
                          style: style1,
                        ),
                        const Gap(2),
                        Text(
                          'Pindot Puzzler is the ultimate sliding picture game with a Filipino twist! Get ready to embark on an exciting journey through'
                          'Filipino culture, landscapes, and traditions, all while challenging your puzzle-solving skills.',
                          style: style2,
                        ),
                        const Gap(10),
                        Text(
                          'Our Mission:',
                          style: style1,
                        ),
                        const Gap(2),
                        Text(
                          'At Pindot Puzzler, our mission is to celebrate the rich culture of Filipino heritage through engaging gameplay. '
                          'We aim to provide players with a unique and entertaining experience that not only entertains but also educates'
                          'them about the beauty and diversity of the Philippines.',
                          style: style2,
                        ),
                        const Gap(10),
                        Text(
                          'Features:',
                          style: style1,
                        ),
                        const Gap(2),
                        Text(
                          'Filipino Theme: Immerse yourself in stunning images and artwork inspired by the vibrant culture and landscapes of the Philippines. '
                          'Challenging Puzzles: Test your brainpower with a variety of sliding picture puzzles that range from easy to challenging.'
                          'Each puzzle is carefully crafted to provide a satisfying gameplay experience.'
                          'Educational Content: Learn interesting facts and trivia about Filipino history, landmarks, festivals, and more as you progress through the game.'
                          'Expand your knowledge while having fun!'
                          'Intuitive Controls: Enjoy smooth and intuitive controls that make sliding and rearranging puzzle pieces a breeze.'
                          "Whether you're a novice or a puzzle pro, Pindot Puzzler is easy to pick up and play.",
                          style: style2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

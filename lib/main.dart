import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(MaterialApp(home: MainPage()));
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  TextEditingController playerAController = TextEditingController();
  TextEditingController playerBController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blueAccent,
              width: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Player B Name", style: TextStyle(color: Colors.white, fontSize: 20)),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: playerBController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.redAccent,
              width: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Player A Name", style: TextStyle(color: Colors.white, fontSize: 20)),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextField(
                        controller: playerAController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Enter name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GamePage(
                              playerA: playerAController.text,
                              playerB: playerBController.text,
                            ),
                          ),
                        );
                      },
                      child: Text("Start Game"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  final String playerA;
  final String playerB;

  const GamePage({super.key, required this.playerA, required this.playerB});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  double blueCardHeight = 0;
  double redCardHeight = 0;

  int playerAscore = 0;
  int playerBscore = 0;

  bool initialized = false;

  late AudioPlayer bgPlayer;
  final AudioPlayer tapPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    bgPlayer = AudioPlayer();
    bgPlayer.setReleaseMode(ReleaseMode.loop);
    bgPlayer.play(AssetSource('sound/bg_music.mp3'));
  }

  void playTapSound() {
    tapPlayer.play(AssetSource('sound/tap.wav'));
  }

  @override
  void dispose() {
    bgPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double winningHeight = screenHeight * 0.9;

    if (!initialized) {
      blueCardHeight = screenHeight / 2;
      redCardHeight = screenHeight / 2;
      initialized = true;
    }

    return Scaffold(
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {
              playTapSound();
              setState(() {
                if (blueCardHeight + 30 <= screenHeight) {
                  blueCardHeight += 30;
                  redCardHeight -= 30;
                  playerBscore += 10;
                }
              });

              if (blueCardHeight >= winningHeight) {
                bgPlayer.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      score: playerBscore,
                      playerName: widget.playerB,
                      winColor: Colors.blueAccent,
                    ),
                  ),
                );
              }
            },
            padding: EdgeInsets.zero,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              color: Colors.blueAccent,
              height: blueCardHeight,
              width: double.infinity,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.playerB,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Text(
                    playerBscore.toString(),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              playTapSound();
              setState(() {
                if (redCardHeight + 30 <= screenHeight) {
                  redCardHeight += 30;
                  blueCardHeight -= 30;
                  playerAscore += 10;
                }
              });

              if (redCardHeight >= winningHeight) {
                bgPlayer.stop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(
                      score: playerAscore,
                      playerName: widget.playerA,
                      winColor: Colors.redAccent,
                    ),
                  ),
                );
              }
            },
            padding: EdgeInsets.zero,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              color: Colors.redAccent,
              height: redCardHeight,
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.playerA,
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Text(
                    playerAscore.toString(),
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final String playerName;
  final Color winColor;

  const ResultPage({
    super.key,
    required this.score,
    required this.playerName,
    required this.winColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: winColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "🎉 $playerName WON! 🎉",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Score: $score 😊",
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: Text("Restart Game", style: TextStyle(color: Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}

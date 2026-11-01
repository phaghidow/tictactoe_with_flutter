import 'package:flutter/material.dart';
import 'game_screen.dart';

class ChooseStartingScreen extends StatelessWidget {
  const ChooseStartingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qui commence ?')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // L'utilisateur commence
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const GameScreen(
                          isSinglePlayer: true,
                          userStarts: true,
                        ),
                  ),
                );
              },
              child: const Text('Vous commencez'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // L'IA commence
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => const GameScreen(
                          isSinglePlayer: true,
                          userStarts: false,
                        ),
                  ),
                );
              },
              child: const Text('L\'IA commence'),
            ),
          ],
        ),
      ),
    );
  }
}

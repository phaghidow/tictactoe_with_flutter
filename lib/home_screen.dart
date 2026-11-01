import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'choose_starting_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic-Tac-Toe')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenue dans Tic-Tac-Toe !',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Mode 2 Joueurs
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GameScreen(isSinglePlayer: false),
                  ),
                );
              },
              child: const Text('Mode 2 Joueurs'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Mode 1 Joueur : redirige vers l'écran pour choisir qui commence
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChooseStartingScreen(),
                  ),
                );
              },
              child: const Text('Mode 1 Joueur (contre l\'IA)'),
            ),
          ],
        ),
      ),
    );
  }
}

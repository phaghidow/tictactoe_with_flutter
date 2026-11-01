import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TicTacToeHomePage(),
    );
  }
}

class TicTacToeHomePage extends StatelessWidget {
  const TicTacToeHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
      ),
      body: const Center(
        child: GameBoard(),
      ),
    );
  }
}

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  GameBoardState createState() => GameBoardState();
}

class GameBoardState extends State<GameBoard> {
  // Liste pour stocker l'état des cases (vide, X ou O)
  List<String> board = List.filled(9, '');

  // Variable pour suivre le tour du joueur (X commence)
  bool isXTurn = true;

  // Fonction pour gérer le clic sur une case
  void onCellTapped(int index) {
    if (board[index].isEmpty) {
      setState(() {
        board[index] = isXTurn ? 'X' : 'O';
        isXTurn = !isXTurn; // Changer de tour
      });

      // Vérifier s'il y a un gagnant
      checkWinner();
    }
  }

  // Fonction pour vérifier s'il y a un gagnant
  void checkWinner() {
    // Liste des combinaisons gagnantes
    final winningCombinations = [
      [0, 1, 2], // Ligne 1
      [3, 4, 5], // Ligne 2
      [6, 7, 8], // Ligne 3
      [0, 3, 6], // Colonne 1
      [1, 4, 7], // Colonne 2
      [2, 5, 8], // Colonne 3
      [0, 4, 8], // Diagonale 1
      [2, 4, 6], // Diagonale 2
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]].isNotEmpty &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[1]] == board[combination[2]]) {
        // Afficher un message de victoire
        showWinnerDialog(board[combination[0]]);
        return;
      }
    }

    // Vérifier s'il y a un match nul
    if (!board.contains('')) {
      showDrawDialog();
    }
  }

  // Fonction pour afficher un message de victoire
  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Félicitations !'),
          content: Text('Le joueur $winner a gagné !'),
          actions: [
            TextButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: const Text('Rejouer'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher un message de match nul
  void showDrawDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Match nul !'),
          content: const Text('Aucun joueur n\'a gagné.'),
          actions: [
            TextButton(
              onPressed: () {
                resetGame();
                Navigator.of(context).pop();
              },
              child: const Text('Rejouer'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour réinitialiser le jeu
  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isXTurn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 colonnes
      ),
      itemCount: 9, // 3x3 = 9 cases
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onCellTapped(index),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Center(
              child: Text(
                board[index],
                style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}
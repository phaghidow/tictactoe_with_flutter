import 'package:flutter/material.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  final bool isSinglePlayer; // true pour le mode 1 joueur, false pour 2 joueurs
  final bool userStarts;     // true si l'utilisateur commence, false si l'IA commence

  const GameScreen({super.key, required this.isSinglePlayer, this.userStarts = true});

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, '');
  bool isXTurn = true;
  List<int> winningCells = [];

  @override
  void initState() {
    super.initState();
    // En mode 1 joueur, si l'utilisateur ne commence pas, l'IA joue en premier.
    if (widget.isSinglePlayer) {
      isXTurn = widget.userStarts;
      if (!widget.userStarts) {
        Future.delayed(const Duration(milliseconds: 500), () {
          aiMove();
        });
      }
    }
  }

  // Gérer le tap sur une case
  void onCellTapped(int index) {
    // En mode 1 joueur, le joueur ne peut jouer que s'il est en tour (ici, 'X')
    if (widget.isSinglePlayer && !isXTurn) return;

    if (board[index].isEmpty && winningCells.isEmpty) {
      setState(() {
        board[index] = isXTurn ? 'X' : 'O';
        isXTurn = !isXTurn;
      });
      checkWinner();

      // En mode 1 joueur, après le coup du joueur, lancer le coup de l'IA
      if (widget.isSinglePlayer && !isXTurn && winningCells.isEmpty && board.contains('')) {
        Future.delayed(const Duration(milliseconds: 500), () {
          aiMove();
        });
      }
    }
  }

  // Coup de l'IA utilisant l'algorithme Minimax (version intelligente)
  void aiMove() {
    if (winningCells.isNotEmpty) return;

    int bestScore = -1000;
    int bestMove = -1;
    for (int i = 0; i < board.length; i++) {
      if (board[i].isEmpty) {
        board[i] = 'O';
        int score = minimax(board, false);
        board[i] = '';
        if (score > bestScore) {
          bestScore = score;
          bestMove = i;
        }
      }
    }
    if (bestMove != -1) {
      setState(() {
        board[bestMove] = 'O';
        isXTurn = true; // Retour au tour du joueur
      });
      checkWinner();
    }
  }

  int minimax(List<String> boardState, bool isMaximizing) {
    if (_isWinner(boardState, 'O')) return 10;
    if (_isWinner(boardState, 'X')) return -10;
    if (!boardState.contains('')) return 0; // Match nul

    int bestScore = isMaximizing ? -1000 : 1000;
    for (int i = 0; i < boardState.length; i++) {
      if (boardState[i].isEmpty) {
        boardState[i] = isMaximizing ? 'O' : 'X';
        int score = minimax(boardState, !isMaximizing);
        boardState[i] = '';
        if (isMaximizing) {
          bestScore = max(bestScore, score);
        } else {
          bestScore = min(bestScore, score);
        }
      }
    }
    return bestScore;
  }

  bool _isWinner(List<String> boardState, String player) {
    const winningCombinations = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];
    for (var combination in winningCombinations) {
      if (boardState[combination[0]] == player &&
          boardState[combination[1]] == player &&
          boardState[combination[2]] == player) {
        return true;
      }
    }
    return false;
  }

  void checkWinner() {
    const winningCombinations = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var combination in winningCombinations) {
      if (board[combination[0]].isNotEmpty &&
          board[combination[0]] == board[combination[1]] &&
          board[combination[1]] == board[combination[2]]) {
        setState(() {
          winningCells = combination;
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          showWinnerDialog(board[combination[0]]);
        });
        return;
      }
    }

    if (!board.contains('')) {
      showDrawDialog();
    }
  }

  void showWinnerDialog(String winner) {
    String message;
    if (widget.isSinglePlayer) {
      message = winner == 'X'
          ? 'Bravo ! Vous avez gagné !'
          : 'Dommage, l\'IA a gagné !';
    } else {
      message = 'Le joueur $winner a gagné !';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Félicitations !'),
          content: Text(message),
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

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      winningCells = [];
      // Réinitialiser le tour selon l'option choisie :
      isXTurn = widget.isSinglePlayer ? widget.userStarts : true;
      // Si l'IA doit commencer, on lance son coup
      if (widget.isSinglePlayer && !widget.userStarts) {
        Future.delayed(const Duration(milliseconds: 500), () {
          aiMove();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: resetGame,
            tooltip: 'Réinitialiser',
          ),
        ],
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onCellTapped(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: winningCells.contains(index)
                    ? Colors.greenAccent
                    : Colors.white,
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  board[index],
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

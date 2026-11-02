import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'app_theme.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.isSinglePlayer,
    this.userStarts = true,
  });

  final bool isSinglePlayer;
  final bool userStarts;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const _winningCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  List<String> board = List<String>.filled(9, '');
  List<int> winningCells = [];
  bool isXTurn = true;
  bool _aiThinking = false;
  bool _gameFinished = false;
  int _roundId = 0;

  @override
  void initState() {
    super.initState();
    isXTurn = widget.userStarts;
    if (widget.isSinglePlayer && !widget.userStarts) {
      _scheduleAiMove();
    }
  }

  void _onCellTapped(int index) {
    if (_gameFinished || _aiThinking || board[index].isNotEmpty) return;
    if (widget.isSinglePlayer && !isXTurn) return;

    final symbol = isXTurn ? 'X' : 'O';
    setState(() {
      board[index] = symbol;
      isXTurn = !isXTurn;
    });

    _finishTurn(symbol);
  }

  void _finishTurn(String symbol) {
    List<int>? winningCombination;
    for (final combination in _winningCombinations) {
      if (combination.every((index) => board[index] == symbol)) {
        winningCombination = combination;
        break;
      }
    }

    final cellsToHighlight = winningCombination;
    if (cellsToHighlight != null) {
      setState(() {
        winningCells = cellsToHighlight;
        _gameFinished = true;
      });
      _showResultDialog(winner: symbol);
      return;
    }

    if (!board.contains('')) {
      setState(() => _gameFinished = true);
      _showResultDialog();
      return;
    }

    if (widget.isSinglePlayer && !isXTurn) {
      _scheduleAiMove();
    }
  }

  void _scheduleAiMove() {
    if (_aiThinking || _gameFinished) return;

    _aiThinking = true;
    final roundId = _roundId;
    Future<void>.delayed(const Duration(milliseconds: 450), () {
      if (!mounted || roundId != _roundId) return;
      _aiThinking = false;
      if (isXTurn || _gameFinished) return;
      _makeAiMove();
    });
  }

  void _makeAiMove() {
    var bestScore = -1000;
    var bestMove = -1;

    for (var index = 0; index < board.length; index++) {
      if (board[index].isNotEmpty) continue;

      board[index] = 'O';
      final score = _minimax(isMaximizing: false);
      board[index] = '';
      if (score > bestScore) {
        bestScore = score;
        bestMove = index;
      }
    }

    if (bestMove == -1) return;

    setState(() {
      board[bestMove] = 'O';
      isXTurn = true;
    });
    _finishTurn('O');
  }

  int _minimax({required bool isMaximizing}) {
    if (_hasWinner('O')) return 10;
    if (_hasWinner('X')) return -10;
    if (!board.contains('')) return 0;

    var bestScore = isMaximizing ? -1000 : 1000;
    for (var index = 0; index < board.length; index++) {
      if (board[index].isNotEmpty) continue;

      board[index] = isMaximizing ? 'O' : 'X';
      final score = _minimax(isMaximizing: !isMaximizing);
      board[index] = '';
      bestScore =
          isMaximizing
              ? math.max(bestScore, score)
              : math.min(bestScore, score);
    }
    return bestScore;
  }

  bool _hasWinner(String symbol) {
    return _winningCombinations.any(
      (combination) => combination.every((index) => board[index] == symbol),
    );
  }

  void _showResultDialog({String? winner}) {
    final roundId = _roundId;
    Future<void>.delayed(const Duration(milliseconds: 350), () {
      if (!mounted || roundId != _roundId) return;

      final title =
          winner == null
              ? "It's a draw!"
              : widget.isSinglePlayer
              ? winner == 'X'
                  ? 'You win!'
                  : 'The bot wins!'
              : 'Player $winner wins!';
      final subtitle =
          winner == null
              ? 'A perfect match. Fancy a rematch?'
              : winner == 'X'
              ? 'That was a brilliant move.'
              : 'Ready to give it another go?';

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder:
            (dialogContext) => AlertDialog(
              backgroundColor: GameColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              contentPadding: const EdgeInsets.fromLTRB(26, 28, 26, 12),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: (winner == 'O'
                              ? GameColors.coral
                              : GameColors.mint)
                          .withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      winner == null
                          ? Icons.handshake_rounded
                          : Icons.celebration_rounded,
                      color: winner == 'O' ? GameColors.coral : GameColors.mint,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 17),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: GameColors.muted),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.fromLTRB(22, 8, 22, 22),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    key: const ValueKey('play-again'),
                    onPressed: () {
                      _resetGame();
                      Navigator.of(dialogContext).pop();
                    },
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('Play again'),
                  ),
                ),
              ],
            ),
      );
    });
  }

  void _resetGame() {
    _roundId++;
    setState(() {
      board = List<String>.filled(9, '');
      winningCells = [];
      _gameFinished = false;
      _aiThinking = false;
      isXTurn = widget.userStarts;
    });

    if (widget.isSinglePlayer && !widget.userStarts) {
      _scheduleAiMove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 700;
              final gap = compact ? 11.0 : 16.0;

              return Padding(
                padding: EdgeInsets.fromLTRB(22, compact ? 8 : 12, 22, 12),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      children: [
                        _GameHeader(
                          onBack: () => Navigator.of(context).maybePop(),
                          onReset: _resetGame,
                        ),
                        SizedBox(height: gap),
                        _TurnStatus(
                          title: _statusTitle,
                          subtitle: _statusSubtitle,
                          isThinking: _aiThinking,
                        ),
                        SizedBox(height: gap),
                        _PlayerRow(
                          isXActive: isXTurn && !_gameFinished,
                          isOActive: !isXTurn && !_gameFinished,
                          isSinglePlayer: widget.isSinglePlayer,
                        ),
                        SizedBox(height: gap),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (context, boardConstraints) {
                              final side = math.min(
                                boardConstraints.maxWidth,
                                boardConstraints.maxHeight,
                              );
                              return Center(
                                child: SizedBox.square(
                                  dimension: side,
                                  child: _GameBoard(
                                    board: board,
                                    winningCells: winningCells,
                                    onCellTapped: _onCellTapped,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: compact ? 5 : 10),
                        const _GameFooter(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String get _statusTitle {
    if (_gameFinished) {
      if (winningCells.isEmpty) return "It's a draw!";
      final winner = board[winningCells.first];
      if (widget.isSinglePlayer) {
        return winner == 'X' ? 'You win!' : 'Bot wins!';
      }
      return 'Player $winner wins!';
    }
    if (_aiThinking) return 'Bot is thinking...';
    if (widget.isSinglePlayer) return isXTurn ? 'Your turn!' : "Bot's turn!";
    return isXTurn ? "Player X's turn" : "Player O's turn";
  }

  String get _statusSubtitle {
    if (_gameFinished) return 'Nice game. Play another round?';
    if (_aiThinking) return 'Hmm... what should I play?';
    if (widget.isSinglePlayer) {
      return isXTurn ? 'You are X. Make it count.' : 'You are X. Hang tight.';
    }
    return 'A little focus goes a long way.';
  }
}

class _GameHeader extends StatelessWidget {
  const _GameHeader({required this.onBack, required this.onReset});

  final VoidCallback onBack;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderIconButton(
          icon: Icons.arrow_back_rounded,
          tooltip: 'Back to menu',
          onPressed: onBack,
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              'TIC TAC TOE',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
            Text(
              'MAKE YOUR MOVE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: GameColors.muted,
                fontSize: 8,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const Spacer(),
        _HeaderIconButton(
          icon: Icons.refresh_rounded,
          tooltip: 'New game',
          onPressed: onReset,
        ),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GameColors.surface.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: Icon(icon, color: GameColors.ink),
      ),
    );
  }
}

class _TurnStatus extends StatelessWidget {
  const _TurnStatus({
    required this.title,
    required this.subtitle,
    required this.isThinking,
  });

  final String title;
  final String subtitle;
  final bool isThinking;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isThinking) ...[
              const SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: GameColors.coral,
                ),
              ),
              const SizedBox(width: 8),
            ] else ...[
              const Icon(
                Icons.auto_awesome_rounded,
                color: GameColors.yellow,
                size: 19,
              ),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: GameColors.muted),
        ),
      ],
    );
  }
}

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    required this.isXActive,
    required this.isOActive,
    required this.isSinglePlayer,
  });

  final bool isXActive;
  final bool isOActive;
  final bool isSinglePlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PlayerCard(
            symbol: 'X',
            label: isSinglePlayer ? 'YOU' : 'PLAYER 1',
            color: GameColors.violet,
            isActive: isXActive,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _PlayerCard(
            symbol: 'O',
            label: isSinglePlayer ? 'PIXEL BOT' : 'PLAYER 2',
            color: GameColors.coral,
            isActive: isOActive,
          ),
        ),
      ],
    );
  }
}

class _PlayerCard extends StatelessWidget {
  const _PlayerCard({
    required this.symbol,
    required this.label,
    required this.color,
    required this.isActive,
  });

  final String symbol;
  final String label;
  final Color color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? color.withValues(alpha: 0.12) : GameColors.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: isActive ? color.withValues(alpha: 0.45) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isActive ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(
              child: Text(
                symbol,
                style: TextStyle(
                  color: color,
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: isActive ? color : GameColors.muted,
                fontWeight: FontWeight.w900,
                fontSize: 10,
                letterSpacing: 0.35,
              ),
            ),
          ),
          if (isActive)
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
        ],
      ),
    );
  }
}

class _GameBoard extends StatelessWidget {
  const _GameBoard({
    required this.board,
    required this.winningCells,
    required this.onCellTapped,
  });

  final List<String> board;
  final List<int> winningCells;
  final ValueChanged<int> onCellTapped;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(4),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 11,
        mainAxisSpacing: 11,
      ),
      itemCount: board.length,
      itemBuilder: (context, index) {
        final symbol = board[index];
        final isWinningCell = winningCells.contains(index);
        final symbolColor =
            symbol == 'X' ? GameColors.violet : GameColors.coral;
        final tileColor =
            isWinningCell
                ? GameColors.mint
                : symbol.isEmpty
                ? GameColors.surface.withValues(alpha: 0.94)
                : symbolColor.withValues(alpha: 0.09);

        return Semantics(
          label:
              symbol.isEmpty
                  ? 'Empty square ${index + 1}'
                  : 'Square ${index + 1}, $symbol',
          button: true,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              key: ValueKey('board-cell-$index'),
              onTap: () => onCellTapped(index),
              borderRadius: BorderRadius.circular(22),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                decoration: BoxDecoration(
                  color: tileColor,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color:
                        isWinningCell
                            ? GameColors.mint
                            : symbol.isEmpty
                            ? GameColors.violet.withValues(alpha: 0.07)
                            : symbolColor.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: GameColors.ink.withValues(alpha: 0.055),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder:
                        (child, animation) =>
                            ScaleTransition(scale: animation, child: child),
                    child:
                        symbol.isEmpty
                            ? Icon(
                              Icons.add_rounded,
                              key: const ValueKey('empty'),
                              color: GameColors.muted.withValues(alpha: 0.12),
                              size: 30,
                            )
                            : Text(
                              symbol,
                              key: ValueKey(symbol),
                              style: TextStyle(
                                color:
                                    isWinningCell ? Colors.white : symbolColor,
                                fontSize: 56,
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GameFooter extends StatelessWidget {
  const _GameFooter();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.tips_and_updates_rounded,
          color: GameColors.yellow,
          size: 16,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'THINK AHEAD. HAVE FUN.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: GameColors.muted,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

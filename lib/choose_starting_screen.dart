import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'game_screen.dart';

class ChooseStartingScreen extends StatelessWidget {
  const ChooseStartingScreen({super.key});

  void _startGame(BuildContext context, {required bool userStarts}) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder:
            (_) => GameScreen(isSinglePlayer: true, userStarts: userStarts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, _) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TopBar(onBack: () => Navigator.of(context).pop()),
                        const SizedBox(height: 40),
                        Text(
                          'YOUR TURN,\nYOUR RULES',
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(
                            color: GameColors.violet,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Who gets the\nfirst move?',
                          style: Theme.of(
                            context,
                          ).textTheme.displaySmall?.copyWith(
                            fontSize: 42,
                            height: 1.02,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.7,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Choose your starting spot. The bot takes the other.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: GameColors.muted, height: 1.4),
                        ),
                        const SizedBox(height: 30),
                        _StartingChoice(
                          key: const ValueKey('start-player'),
                          symbol: 'X',
                          icon: Icons.person_rounded,
                          color: GameColors.violet,
                          tag: 'YOU GO FIRST',
                          title: 'Make the opening move',
                          onTap: () => _startGame(context, userStarts: true),
                        ),
                        const SizedBox(height: 14),
                        _StartingChoice(
                          key: const ValueKey('start-bot'),
                          symbol: 'O',
                          icon: Icons.smart_toy_rounded,
                          color: GameColors.coral,
                          tag: 'LET THE BOT START',
                          title: 'See what it comes up with',
                          onTap: () => _startGame(context, userStarts: false),
                        ),
                        const SizedBox(height: 28),
                        const _BotTip(),
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
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RoundIconButton(
          icon: Icons.arrow_back_rounded,
          tooltip: 'Back',
          onPressed: onBack,
        ),
        const Spacer(),
        DecoratedBox(
          decoration: BoxDecoration(
            color: GameColors.surface.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              'SOLO MODE',
              style: TextStyle(
                color: GameColors.ink,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StartingChoice extends StatelessWidget {
  const _StartingChoice({
    required this.symbol,
    required this.icon,
    required this.color,
    required this.tag,
    required this.title,
    required this.onTap,
    super.key,
  });

  final String symbol;
  final IconData icon;
  final Color color;
  final String tag;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: GameColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: color.withValues(alpha: 0.16)),
            boxShadow: [
              BoxShadow(
                color: GameColors.ink.withValues(alpha: 0.045),
                blurRadius: 18,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: Center(
                  child: Text(
                    symbol,
                    style: TextStyle(
                      color: color,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 14, color: color),
                        const SizedBox(width: 5),
                        Text(
                          tag,
                          style: TextStyle(
                            color: color,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_rounded,
                color: GameColors.muted,
                size: 21,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BotTip extends StatelessWidget {
  const _BotTip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GameColors.violet.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(19),
      ),
      child: const Row(
        children: [
          Icon(Icons.tips_and_updates_rounded, color: GameColors.violet),
          SizedBox(width: 11),
          Expanded(
            child: Text(
              'The computer plays as O. It is clever, but you have got this.',
              style: TextStyle(
                color: GameColors.ink,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
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
      color: GameColors.surface.withValues(alpha: 0.88),
      shape: const CircleBorder(),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: GameColors.ink),
        tooltip: tooltip,
      ),
    );
  }
}

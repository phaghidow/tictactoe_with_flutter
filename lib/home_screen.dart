import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'choose_starting_screen.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openGame(BuildContext context, {required bool singlePlayer}) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder:
            (_) =>
                singlePlayer
                    ? const ChooseStartingScreen()
                    : const GameScreen(isSinglePlayer: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _HomeHeader(),
                        const SizedBox(height: 34),
                        const _Intro(),
                        const SizedBox(height: 28),
                        _ModeCard(
                          key: const ValueKey('mode-two-player'),
                          icon: Icons.people_alt_rounded,
                          iconColor: GameColors.violet,
                          tag: 'THE CLASSIC',
                          title: 'Two players',
                          subtitle: 'Pass the phone. Settle the score.',
                          onTap: () => _openGame(context, singlePlayer: false),
                        ),
                        const SizedBox(height: 14),
                        _ModeCard(
                          key: const ValueKey('mode-single-player'),
                          icon: Icons.smart_toy_rounded,
                          iconColor: GameColors.coral,
                          tag: 'BRAIN VS. BOT',
                          title: 'Play the computer',
                          subtitle: 'A clever little bot is waiting.',
                          onTap: () => _openGame(context, singlePlayer: true),
                        ),
                        const SizedBox(height: 24),
                        const _HomeFooter(),
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

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [GameColors.violet, GameColors.violetDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: GameColors.violet.withValues(alpha: 0.24),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(
                Icons.grid_3x3_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIC TAC TOE',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.1,
                  ),
                ),
                Text(
                  'THE TINY ARCADE',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: GameColors.muted,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.25,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (constraints.maxWidth >= 350) const _PlayerCounter(),
          ],
        );
      },
    );
  }
}

class _PlayerCounter extends StatelessWidget {
  const _PlayerCounter();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: GameColors.surface.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GameColors.violet.withValues(alpha: 0.1)),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 11, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, color: GameColors.yellow, size: 17),
            SizedBox(width: 4),
            Text(
              'READY',
              style: TextStyle(
                color: GameColors.ink,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
      fontSize: 42,
      height: 1.02,
      fontWeight: FontWeight.w900,
      letterSpacing: -1.8,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: GameColors.yellow.withValues(alpha: 0.24),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFFD58C13),
                  size: 15,
                ),
                SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'A LITTLE FRIENDLY COMPETITION',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: GameColors.ink,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Ready, player one?', style: titleStyle),
        const SizedBox(height: 10),
        Text(
          'Pick your opponent. Bring your best moves.',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: GameColors.muted, height: 1.4),
        ),
      ],
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.iconColor,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color iconColor;
  final String tag;
  final String title;
  final String subtitle;
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
            border: Border.all(color: iconColor.withValues(alpha: 0.15)),
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
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.11),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tag,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: GameColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: iconColor, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeFooter extends StatelessWidget {
  const _HomeFooter();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_rounded, color: GameColors.coral, size: 14),
          const SizedBox(width: 6),
          Text(
            'MADE FOR QUICK FUN',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: GameColors.muted,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

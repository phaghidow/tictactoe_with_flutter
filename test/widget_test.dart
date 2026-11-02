import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tictactoe/main.dart';

void main() {
  testWidgets('home screen offers both game modes', (tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    expect(find.text('Ready, player one?'), findsOneWidget);
    expect(find.text('Two players'), findsOneWidget);
    expect(find.text('Play the computer'), findsOneWidget);
  });

  testWidgets('home and game screens fit a narrow phone display', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const TicTacToeApp());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const ValueKey('mode-two-player')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('two-player mode alternates turns and declares a winner', (
    tester,
  ) async {
    await tester.pumpWidget(const TicTacToeApp());
    await tester.tap(find.byKey(const ValueKey('mode-two-player')));
    await tester.pumpAndSettle();

    expect(find.text("Player X's turn"), findsOneWidget);

    for (final index in [0, 3, 1, 4, 2]) {
      await tester.tap(find.byKey(ValueKey('board-cell-$index')));
      await tester.pumpAndSettle();
    }

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Player X wins!'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('play-again')));
    await tester.pumpAndSettle();
    expect(find.text("Player X's turn"), findsOneWidget);
    expect(
      find.descendant(of: find.byType(GridView), matching: find.text('X')),
      findsNothing,
    );
    expect(
      find.descendant(of: find.byType(GridView), matching: find.text('O')),
      findsNothing,
    );
  });

  testWidgets('single-player mode plays the computer response', (tester) async {
    await tester.pumpWidget(const TicTacToeApp());
    await tester.tap(find.byKey(const ValueKey('mode-single-player')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('start-player')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('board-cell-4')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('board-cell-4')),
        matching: find.text('X'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: find.byType(GridView), matching: find.text('O')),
      findsOneWidget,
    );
    expect(find.text('Your turn!'), findsOneWidget);
  });

  testWidgets('reset cancels a pending computer move', (tester) async {
    await tester.pumpWidget(const TicTacToeApp());
    await tester.tap(find.byKey(const ValueKey('mode-single-player')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('start-player')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('board-cell-4')));
    await tester.pump();
    await tester.tap(find.byTooltip('New game'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.text('Your turn!'), findsOneWidget);
    expect(
      find.descendant(of: find.byType(GridView), matching: find.text('X')),
      findsNothing,
    );
    expect(
      find.descendant(of: find.byType(GridView), matching: find.text('O')),
      findsNothing,
    );
  });
}

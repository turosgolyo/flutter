import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/timer_provider.dart';
import '../widgets/sudoku_grid.dart';
import '../widgets/number_pad.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final timerProvider = context.watch<TimerProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sudoku - ${gameProvider.currentDifficulty.name.toUpperCase()}',
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                timerProvider.formattedTime,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: const SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(child: Center(child: SudokuGrid())),
            NumberPad(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

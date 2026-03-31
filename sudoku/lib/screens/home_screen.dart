import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/timer_provider.dart';
import '../models/difficulty.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startGame(BuildContext context, Difficulty difficulty) {
    context.read<GameProvider>().startNewGame(difficulty);
    context.read<TimerProvider>().startTimer();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sudoku Főmenü')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sudoku',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () => _startGame(context, Difficulty.easy),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              child: const Text('Könnyű', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startGame(context, Difficulty.medium),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              child: const Text('Közepes', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _startGame(context, Difficulty.hard),
              style: ElevatedButton.styleFrom(minimumSize: const Size(200, 50)),
              child: const Text('Nehéz', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

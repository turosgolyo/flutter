import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/timer_provider.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({super.key});

  void _checkWin(BuildContext context, GameProvider gameProvider) {
    if (gameProvider.isGameWon) {
      context.read<TimerProvider>().stopTimer();
      final String time = context.read<TimerProvider>().formattedTime;

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Gratulálok, nyertél!'),
          content: Text('Sikeresen megoldottad a feladványt.\nIdő: $time'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Back to main screen
              },
              child: const Text('Vissza a főmenübe'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        alignment: WrapAlignment.center,
        children: [
          ...List.generate(9, (index) {
            int number = index + 1;
            bool isComplete = gameProvider.isNumberComplete(number);

            return ElevatedButton(
              onPressed: isComplete
                  ? null
                  : () {
                      gameProvider.inputNumber(number);
                      _checkWin(context, gameProvider);
                    },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(18),
              ),
              child: Text('$number', style: const TextStyle(fontSize: 24)),
            );
          }),
          ElevatedButton(
            onPressed: () => gameProvider.inputNumber(0), // 0 means delete
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(18),
              backgroundColor: Colors.red.shade100,
              foregroundColor: Colors.red.shade900,
            ),
            child: const Icon(Icons.backspace, size: 28),
          ),
        ],
      ),
    );
  }
}

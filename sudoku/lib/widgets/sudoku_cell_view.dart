import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class SudokuCellView extends StatelessWidget {
  final int row;
  final int col;

  const SudokuCellView({super.key, required this.row, required this.col});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();
    final cell = gameProvider.board[row][col];

    final isSelected =
        gameProvider.selectedRow == row && gameProvider.selectedCol == col;

    bool isSameValue = false;
    if (gameProvider.selectedRow != null && gameProvider.selectedCol != null) {
      final selectedCellValue = gameProvider
          .board[gameProvider.selectedRow!][gameProvider.selectedCol!]
          .value;
      if (selectedCellValue != 0 && selectedCellValue == cell.value) {
        isSameValue = true;
      }
    }

    Color cellColor = Colors.white;
    if (isSelected) {
      cellColor = Colors.blue.shade300;
    } else if (isSameValue) {
      cellColor = Colors.blue.shade100;
    }

    // 3x3-as blokkok határainak vastagabb vonása
    final borderRight = (col == 2 || col == 5) ? 2.0 : 0.5;
    final borderBottom = (row == 2 || row == 5) ? 2.0 : 0.5;

    return GestureDetector(
      onTap: () => gameProvider.selectCell(row, col),
      child: Container(
        decoration: BoxDecoration(
          color: cellColor,
          border: Border(
            right: BorderSide(color: Colors.black, width: borderRight),
            bottom: BorderSide(color: Colors.black, width: borderBottom),
            left: BorderSide(color: Colors.grey, width: 0.5),
            top: BorderSide(color: Colors.grey, width: 0.5),
          ),
        ),
        child: Center(
          child: Text(
            cell.value == 0 ? '' : cell.value.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: cell.isFixed ? FontWeight.bold : FontWeight.normal,
              color: cell.isError
                  ? Colors.red
                  : (cell.isFixed ? Colors.black : Colors.blue.shade800),
            ),
          ),
        ),
      ),
    );
  }
}

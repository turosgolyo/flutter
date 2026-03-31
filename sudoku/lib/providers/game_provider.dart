import 'package:flutter/material.dart';
import '../models/sudoku_cell.dart';
import '../models/difficulty.dart';
import '../utils/sudoku_generator.dart';

class GameProvider extends ChangeNotifier {
  late List<List<SudokuCell>> board;
  int? selectedRow;
  int? selectedCol;
  Difficulty currentDifficulty = Difficulty.medium;

  GameProvider() {
    _initializeEmptyBoard();
  }

  void _initializeEmptyBoard() {
    board = List.generate(9, (_) => List.generate(9, (_) => SudokuCell()));
  }

  void startNewGame(Difficulty difficulty) {
    currentDifficulty = difficulty;

    int blanks;
    if (difficulty == Difficulty.easy) {
      blanks = 30;
    } else if (difficulty == Difficulty.medium)
      blanks = 40;
    else
      blanks = 50;

    SudokuGenerator generator = SudokuGenerator(blanks);
    generator.fillValues();
    List<List<int>> generatedBoard = generator.getBoard();

    board = List.generate(
      9,
      (r) => List.generate(9, (c) {
        int val = generatedBoard[r][c];
        return SudokuCell(value: val, isFixed: val != 0);
      }),
    );

    selectedRow = null;
    selectedCol = null;
    notifyListeners();
  }

  void selectCell(int row, int col) {
    selectedRow = row;
    selectedCol = col;
    notifyListeners();
  }

  void inputNumber(int number) {
    if (selectedRow == null || selectedCol == null) return;

    var cell = board[selectedRow!][selectedCol!];
    if (cell.isFixed) return;

    cell.value = number;
    _validateBoard();
    notifyListeners();
  }

  bool get isGameWon {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (board[r][c].value == 0 || board[r][c].isError) {
          return false;
        }
      }
    }
    return true;
  }

  bool isNumberComplete(int number) {
    if (number == 0) return false;
    int count = 0;
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        if (board[r][c].value == number) {
          count++;
        }
      }
    }
    return count >= 9;
  }

  void _validateBoard() {
    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        board[r][c].isError = false;
      }
    }

    for (int r = 0; r < 9; r++) {
      for (int c = 0; c < 9; c++) {
        int val = board[r][c].value;
        if (val == 0) continue;

        if (!_isValidPlacement(r, c, val)) {
          board[r][c].isError = true;
        }
      }
    }
  }

  bool _isValidPlacement(int row, int col, int val) {
    for (int c = 0; c < 9; c++) {
      if (c != col && board[row][c].value == val) return false;
    }
    for (int r = 0; r < 9; r++) {
      if (r != row && board[r][col].value == val) return false;
    }
    int startRow = (row ~/ 3) * 3;
    int startCol = (col ~/ 3) * 3;
    for (int r = startRow; r < startRow + 3; r++) {
      for (int c = startCol; c < startCol + 3; c++) {
        if (r != row && c != col && board[r][c].value == val) return false;
      }
    }
    return true;
  }
}

import 'dart:math';

class SudokuGenerator {
  late List<List<int>> board;
  int missingDigits;
  final Random _random = Random();

  SudokuGenerator(this.missingDigits) {
    board = List.generate(9, (_) => List.filled(9, 0));
  }

  void fillValues() {
    // Fill the diagonal 3x3 matrices
    _fillDiagonal();
    // Fill remaining blocks
    _fillRemaining(0, 3);
    // Remove missing digits
    _removeDigits();
  }

  void _fillDiagonal() {
    for (int i = 0; i < 9; i = i + 3) {
      _fillBox(i, i);
    }
  }

  bool _unUsedInBox(int rowStart, int colStart, int num) {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[rowStart + i][colStart + j] == num) {
          return false;
        }
      }
    }
    return true;
  }

  void _fillBox(int rowStart, int colStart) {
    int num;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        do {
          num = _random.nextInt(9) + 1;
        } while (!_unUsedInBox(rowStart, colStart, num));
        board[rowStart + i][colStart + j] = num;
      }
    }
  }

  bool _checkIfSafe(int i, int j, int num) {
    return _unUsedInRow(i, num) &&
        _unUsedInCol(j, num) &&
        _unUsedInBox(i - i % 3, j - j % 3, num);
  }

  bool _unUsedInRow(int i, int num) {
    for (int j = 0; j < 9; j++) {
      if (board[i][j] == num) return false;
    }
    return true;
  }

  bool _unUsedInCol(int j, int num) {
    for (int i = 0; i < 9; i++) {
      if (board[i][j] == num) return false;
    }
    return true;
  }

  bool _fillRemaining(int i, int j) {
    if (j >= 9 && i < 8) {
      i = i + 1;
      j = 0;
    }
    if (i >= 9 && j >= 9) {
      return true;
    }
    if (i < 3) {
      if (j < 3) {
        j = 3;
      }
    } else if (i < 6) {
      if (j == (i ~/ 3) * 3) {
        j = j + 3;
      }
    } else {
      if (j == 6) {
        i = i + 1;
        j = 0;
        if (i >= 9) {
          return true;
        }
      }
    }

    for (int num = 1; num <= 9; num++) {
      if (_checkIfSafe(i, j, num)) {
        board[i][j] = num;
        if (_fillRemaining(i, j + 1)) {
          return true;
        }
        board[i][j] = 0;
      }
    }
    return false;
  }

  void _removeDigits() {
    int count = missingDigits;
    while (count != 0) {
      int cellId = _random.nextInt(81);
      int i = cellId ~/ 9;
      int j = cellId % 9;
      if (board[i][j] != 0) {
        count--;
        board[i][j] = 0;
      }
    }
  }

  List<List<int>> getBoard() {
    return board;
  }
}

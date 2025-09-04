import 'dart:io';

import 'cell_type.dart';

class Board {
  final List<List<Cell>> cells;
  final int size;

  Board(this.size)
    : cells = List.generate(
        size,
        (_) => List.filled(size, Cell.empty),
      );

  void printBoard() {
    stdout.write('  ');
    for (int i = 0; i < size; i++) {
      stdout.write('${i + 1} ');
    }
    stdout.write('\n');

    for (int i = 0; i < size; i++) {
      stdout.write('${i + 1} ');

      for (int j = 0; j < size; j++) {
        switch (cells[i][j]) {
          case Cell.empty:
            stdout.write('. ');
          case Cell.cross:
            stdout.write('X ');
          case Cell.nought:
            stdout.write('O ');
          case Cell.zet:
            stdout.write('Z ');
        }
      }

      print('');
    }
  }

  bool setSymbol(int x, int y, Cell cellType) {
    if (cells[y][x] == Cell.empty) {
      cells[y][x] = cellType;
      return true;
    }

    return false;
  }

  bool checkWin(Cell player, {int winLength = 4}) {
    // строки
    if (_checkRows(player, winLength)) {
      return true;
    }

    // столбцы
    if (_checkColumns(player, winLength)) {
      return true;
    }

    // диагонали ↘
    if (_checkDiagonals(player, winLength, dr: 1, dc: 1)) {
      return true;
    }

    // диагонали ↗
    return _checkDiagonals(player, winLength, dr: -1, dc: 1);
  }

  bool _checkRows(Cell player, int winLength) {
    for (int row = 0; row < size; row++) {
      int count = 0;

      for (int column = 0; column < size; column++) {
        count = (cells[row][column] == player) ? count + 1 : 0;

        if (count == winLength) {
          return true;
        }
      }
    }

    return false;
  }

  bool _checkColumns(Cell player, int winLength) {
    for (int column = 0; column < size; column++) {
      int count = 0;

      for (int row = 0; row < size; row++) {
        count = (cells[row][column] == player) ? count + 1 : 0;

        if (count == winLength) {
          return true;
        }
      }
    }

    return false;
  }

  bool _checkDiagonals(
    Cell player,
    int winLength, {
    required int dr,
    required int dc,
  }) {
    // старт с левой границы
    for (int r = 0; r < size; r++) {
      int i = r;
      int j = 0;
      int count = 0;

      while (i >= 0 && i < size && j < size) {
        count = (cells[i][j] == player) ? count + 1 : 0;

        if (count == winLength) {
          return true;
        }

        i += dr;
        j += dc;
      }
    }

    // старт с верхней границы (кроме [0,0] или [size-1,0], оно уже было)
    for (int c = 1; c < size; c++) {
      int i = (dr == 1) ? 0 : size - 1;
      int j = c;
      int count = 0;

      while (i >= 0 && i < size && j < size) {
        count = (cells[i][j] == player) ? count + 1 : 0;

        if (count == winLength) {
          return true;
        }

        i += dr;
        j += dc;
      }
    }

    return false;
  }

  bool checkDraw() {
    return cells.every(
      (row) => row.every(
        (cell) => cell != Cell.empty,
      ),
    );
  }
}

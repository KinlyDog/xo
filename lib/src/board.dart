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

  bool isCellEmpty(int x, int y) {
    return cells[y][x] == Cell.empty;
  }

  bool setSymbol(int x, int y, Cell cellType) {
    if (isCellEmpty(x, y)) {
      cells[y][x] = cellType;
      return true;
    }

    return false;
  }

  bool checkWin(Cell player, {int winLength = 4}) {
    if (_checkRows(player, winLength)) {
      return true;
    }

    if (_checkColumns(player, winLength)) {
      return true;
    }

    if (_checkDiagonalsDownRight(player, winLength)) {
      return true;
    }

    if (_checkDiagonalsUpRight(player, winLength)) {
      return true;
    }

    return false;
  }

  bool _checkRows(Cell player, int winLength) {
    for (int r = 0; r < size; r++) {
      if (_hasConsecutive(cells[r], player, winLength)) {
        return true;
      }
    }

    return false;
  }

  bool _checkColumns(Cell player, int winLength) {
    for (int c = 0; c < size; c++) {
      final column = List<Cell>.generate(
        size,
        (r) => cells[r][c],
      );

      if (_hasConsecutive(column, player, winLength)) {
        return true;
      }
    }

    return false;
  }

  bool _checkDiagonalsDownRight(Cell player, int winLength) {
    for (int r = 0; r < size; r++) {
      int i = r;
      int j = 0;
      final diag = <Cell>[];

      while (i < size && j < size) {
        diag.add(cells[i][j]);
        i++;
        j++;
      }

      if (_hasConsecutive(diag, player, winLength)) {
        return true;
      }
    }

    for (int c = 1; c < size; c++) {
      int i = 0;
      int j = c;
      final diag = <Cell>[];

      while (i < size && j < size) {
        diag.add(cells[i][j]);
        i++;
        j++;
      }

      if (_hasConsecutive(diag, player, winLength)) {
        return true;
      }
    }

    return false;
  }

  bool _checkDiagonalsUpRight(Cell player, int winLength) {
    for (int r = size - 1; r >= 0; r--) {
      int i = r;
      int j = 0;
      final diag = <Cell>[];

      while (i >= 0 && j < size) {
        diag.add(cells[i][j]);
        i--;
        j++;
      }

      if (_hasConsecutive(diag, player, winLength)) {
        return true;
      }
    }

    for (int c = 1; c < size; c++) {
      int i = size - 1;
      int j = c;
      final diag = <Cell>[];

      while (i >= 0 && j < size) {
        diag.add(cells[i][j]);
        i--;
        j++;
      }

      if (_hasConsecutive(diag, player, winLength)) {
        return true;
      }
    }

    return false;
  }

  bool _hasConsecutive(List<Cell> sequence, Cell player, int winLength) {
    int count = 0;

    for (final cell in sequence) {
      if (cell == player) {
        count++;
      } else {
        count = 0;
      }

      if (count >= winLength) {
        return true;
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

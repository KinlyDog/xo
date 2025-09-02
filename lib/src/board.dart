import 'dart:io';

import 'cell_type.dart';

class Board {
  late List<List<Cell>> cells;
  final int size;

  Board(this.size) {
    cells = List.generate(
      size,
      (_) => List.filled(
        size,
        Cell.empty,
      ),
    );
  }

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

  bool _makeMove(int x, int y) {
    return cells[y][x] == Cell.empty;
  }

  bool setSymbol(int x, int y, Cell cellType) {
    if (_makeMove(x, y)) {
      cells[y][x] = cellType;
      return true;
    }

    return false;
  }

  bool checkWin(Cell player, {int winLength = 4}) {
    // Проверка горизонталей
    if (_checkLines(player, winLength)) {
      return true;
    }

    // Проверка вертикалей (вращаем матрицу и проверяем снова)
    var rotated = rotateMatrix(cells);
    if (_checkLinesInMatrix(rotated, player, winLength)) {
      return true;
    }

    // Проверка диагоналей через 4 поворота
    for (int i = 0; i < 4; i++) {
      if (_checkDiagonals(rotated, player, winLength)) {
        return true;
      }

      rotated = rotateMatrix(rotated);
    }

    return false;
  }

  // Проверка строк
  bool _checkLines(Cell player, int winLength) {
    return _checkLinesInMatrix(cells, player, winLength);
  }

  bool _checkLinesInMatrix(
    List<List<Cell>> matrix,
    Cell player,
    int winLength,
  ) {
    for (var row in matrix) {
      int count = 0;

      for (var cell in row) {
        count = (cell == player) ? count + 1 : 0;

        if (count == winLength) {
          return true;
        }
      }
    }

    return false;
  }

  // Проверка ↘ диагоналей
  bool _checkDiagonals(List<List<Cell>> matrix, Cell player, int winLength) {
    for (int startRow = winLength - 1; startRow < size; startRow++) {
      int i = startRow;
      int j = 0;
      int count = 0;

      while (i >= 0 && j < size) {
        count = (matrix[i][j] == player) ? count + 1 : 0;

        if (count == winLength) {
          return true;
        }

        i--;
        j++;
      }
    }
    return false;
  }

  // Поворот матрицы на 90° по часовой стрелке
  List<List<Cell>> rotateMatrix(List<List<Cell>> matrix) {
    return List.generate(
      size,
      (i) => List.generate(
        size,
        (j) => matrix[size - j - 1][i],
      ),
    );
  }

  bool checkDraw() {
    return cells.every(
      (row) => row.every(
        (cell) => cell != Cell.empty,
      ),
    );
  }
}

import 'dart:io';

import 'package:xo/tic_tac_toe.dart';

void main() {
  int? size;

  while (true) {
    stdout.write('Enter the size of the board (5-9): ');
    size = int.tryParse(stdin.readLineSync()!);
    size ??= 5;

    if (size < 5 || size > 9) {
      continue;
    }
    break;
  }

  Board board = Board(size);
  Player player = Player(Cell.cross);
  Game game = Game(board, player);
  game.play();
}

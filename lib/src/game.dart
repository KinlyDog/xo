import 'dart:io';

import '../tic_tac_toe.dart';
import 'game_state.dart';

class Game {
  final Board board;
  final Player currentPlayer;
  GameState state = GameState.playing;

  Game(this.board, this.currentPlayer);

  static void newGame() {
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

    Board newBoard = Board(size);
    Player newPlayer = Player(Cell.cross);
    Game newGame = Game(newBoard, newPlayer);
    newGame.play();
  }

  void resetGame() {
    Board resetBoard = Board(board.size);
    Player resetPlayer = Player(Cell.cross);
    Game resetGame = Game(resetBoard, resetPlayer);
    resetGame.play();
  }

  void updateState() {
    if (board.checkWin(Cell.cross)) {
      state = GameState.crossWin;
    } else if (board.checkWin(Cell.nought)) {
      state = GameState.noughtWin;
    } else if (board.checkWin(Cell.zet)) {
      state = GameState.zetWin;
    } else if (board.checkDraw()) {
      state = GameState.draw;
    }
  }

  void play() {
    while (state == GameState.playing) {
      board.printBoard();
      StringBuffer buffer = StringBuffer();
      buffer.write("${currentPlayer.symbol}'s turn. ");
      buffer.write("Enter row and column (e.g. 1 2): ");
      stdout.write(buffer.toString());

      bool validInput = false;
      int? x, y;

      while (!validInput) {
        String? input = stdin.readLineSync();

        if (input == null) {
          print("Invalid input. Please try again.");
          continue;
        }

        if (input == 'q') {
          state = GameState.quit;
          break;
        }

        // сброс состояния, новая игра
        if (input == 'r') {
          state = GameState.reset;
          resetGame();
          break;
        }

        var inputList = input.split(' ');
        if (inputList.length != 2) {
          print("Invalid input. Please try again.");
          continue;
        }

        x = int.tryParse(inputList[1]);
        y = int.tryParse(inputList[0]);

        if (x == null ||
            y == null ||
            x < 1 ||
            x > board.size ||
            y < 1 ||
            y > board.size) {
          print("Invalid input. Please try again.");
          continue;
        }

        x -= 1;
        y -= 1;

        if (board.setSymbol(x, y, currentPlayer.cellType)) {
          updateState();
          currentPlayer.switchPlayer();
          validInput = true;
        } else {
          stdout.writeln('This cell is already occupied!');
        }
      }
    }

    if (state == GameState.reset) {
      return;
    }

    board.printBoard();
    switch (state) {
      case GameState.crossWin:
        stdout.writeln('X wins!');
      case GameState.noughtWin:
        stdout.writeln('O wins!');
      case GameState.zetWin:
        stdout.writeln('Z wins!');
      case GameState.draw:
        stdout.writeln("It's a draw!");
      default:
        break;
    }

    stdout.writeln('Do u wanna play again? Press Y or any key for exit.');
    var input = stdin.readLineSync()!;

    if (input.toLowerCase() == 'y') {
      newGame();
    } else {
      print('Bye, bye!');
    }
  }
}

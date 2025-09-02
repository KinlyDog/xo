import 'cell_type.dart';

class Player {
  Cell cellType;

  Player(this.cellType);

  void switchPlayer() {
    cellType = cellType == Cell.cross ? Cell.nought : Cell.cross;
  }

  String get symbol => switch (cellType) {
    Cell.cross => 'X',
    Cell.nought => 'O',
    Cell.zet => 'Z',
    Cell.empty => throw UnimplementedError('Поле не может быть пустым'),
  };
}

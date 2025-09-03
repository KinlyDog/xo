import 'cell_type.dart';

class Player {
  Cell cellType;

  Player(this.cellType);

  void switchPlayer() {
    cellType = switch (cellType) {
      Cell.cross => Cell.nought,
      Cell.nought => Cell.zet,
      Cell.zet => Cell.cross,
      _ => throw StateError('Unexpected player state: $cellType'),
    };
  }

  String get symbol => switch (cellType) {
    Cell.cross => 'X',
    Cell.nought => 'O',
    Cell.zet => 'Z',
    _ => throw UnimplementedError('Неожиданное значение: $cellType'),
  };
}

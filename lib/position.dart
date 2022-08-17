class Position {
  int x, y, gridSize;

  Position(this.x, this.y, this.gridSize);

  int get index => x + y * gridSize;
  bool get withinFrame => 0 <= x && x < gridSize && 0 <= y && y < gridSize;
  List<Position> get neighbours => [_left, _right, _top, _bottom];

  Position get _left => Position(x - 1, y, gridSize);
  Position get _right => Position(x + 1, y, gridSize);
  Position get _top => Position(x, y - 1, gridSize);
  Position get _bottom => Position(x, y + 1, gridSize);
}

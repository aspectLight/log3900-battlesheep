enum BoardSize {
  small(10),
  medium(15),
  large(20);

  final int value;

  const BoardSize(this.value);

  static BoardSize fromInt(int size) {
    return BoardSize.values.firstWhere(
      (e) => e.value == size,
      orElse: () => throw ArgumentError('Invalid board size: $size'),
    );
  }
}

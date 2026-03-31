class SudokuCell {
  int value; // 0 jelenti az üreset, 1-9 a számokat
  final bool isFixed; // Igaz, ha a generált kezdőtábla része (nem módosítható)
  bool isError; // Igaz, ha szabálytalan a beírt szám

  SudokuCell({this.value = 0, this.isFixed = false, this.isError = false});
}

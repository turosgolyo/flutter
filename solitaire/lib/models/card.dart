enum Suit { hearts, diamonds, clubs, spades }

enum CardValue {
  ace,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
}

class PlayingCard {
  final Suit suit;
  final CardValue value;
  bool isFaceUp;
  bool isDraggable;

  PlayingCard({
    required this.suit,
    required this.value,
    this.isFaceUp = false,
    this.isDraggable = false,
  });

  @override
  String toString() {
    return '$value of $suit';
  }
}

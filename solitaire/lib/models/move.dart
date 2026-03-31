import 'card.dart';

enum PileType { stock, waste, foundation, tableau }

class Move {
  final List<PlayingCard> cards;
  final PileType fromPileType;
  final int fromPileIndex;
  final PileType toPileType;
  final int toPileIndex;
  final bool turnedCard;

  Move({
    required this.cards,
    required this.fromPileType,
    this.fromPileIndex = 0,
    required this.toPileType,
    this.toPileIndex = 0,
    this.turnedCard = false,
  });
}

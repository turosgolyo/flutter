import 'card.dart';
import 'deck.dart';
import 'move.dart';

class GameModel {
  late Deck deck;
  List<PlayingCard> stock = [];
  List<PlayingCard> waste = [];
  List<List<PlayingCard>> foundations = List.generate(4, (_) => []);
  List<List<PlayingCard>> tableaus = List.generate(7, (_) => []);
  int timer = 0;
  int difficulty = 1; // 1 for draw 1, 3 for draw 3
  List<Move> _history = [];

  GameModel() {
    _setupGame();
  }

  void _setupGame() {
    deck = Deck();
    deck.shuffle();

    // Deal cards to tableaus
    for (int i = 0; i < 7; i++) {
      for (int j = 0; j < i + 1; j++) {
        tableaus[i].add(deck.deal());
      }
      tableaus[i].last.isFaceUp = true;
    }

    stock = deck.cards;
  }

  void resetGame() {
    stock.clear();
    waste.clear();
    foundations = List.generate(4, (_) => []);
    tableaus = List.generate(7, (_) => []);
    timer = 0;
    _history.clear();
    _setupGame();
  }

  void recordMove(Move move) {
    _history.add(move);
  }

  void undo() {
    if (_history.isEmpty) {
      return;
    }

    Move lastMove = _history.removeLast();

    // Reverse the move
    List<PlayingCard> cards = lastMove.cards;

    // Remove cards from the 'to' pile
    switch (lastMove.toPileType) {
      case PileType.foundation:
        foundations[lastMove.toPileIndex].removeRange(
          foundations[lastMove.toPileIndex].length - cards.length,
          foundations[lastMove.toPileIndex].length,
        );
        break;
      case PileType.tableau:
        tableaus[lastMove.toPileIndex].removeRange(
          tableaus[lastMove.toPileIndex].length - cards.length,
          tableaus[lastMove.toPileIndex].length,
        );
        break;
      case PileType.waste:
        waste.removeRange(waste.length - cards.length, waste.length);
        break;
      case PileType.stock:
        stock.removeRange(stock.length - cards.length, stock.length);
        break;
    }

    // Add cards back to the 'from' pile
    switch (lastMove.fromPileType) {
      case PileType.waste:
        for (var card in cards) card.isFaceUp = true;
        waste.addAll(cards.reversed);
        break;
      case PileType.stock:
        for (var card in cards) card.isFaceUp = false;
        stock.addAll(cards.reversed);
        break;
      case PileType.foundation:
        foundations[lastMove.fromPileIndex].addAll(cards);
        break;
      case PileType.tableau:
        tableaus[lastMove.fromPileIndex].addAll(cards);
        if (lastMove.turnedCard) {
          tableaus[lastMove.fromPileIndex][tableaus[lastMove.fromPileIndex]
                          .length -
                      cards.length -
                      1]
                  .isFaceUp =
              false;
        }
        break;
    }
  }

  void dealFromStock() {
    List<PlayingCard> movedCards = [];
    if (stock.isEmpty) {
      if (waste.isEmpty) return; // Nothing to reset
      stock = List.from(waste.reversed);
      waste.clear();
      for (var card in stock) {
        card.isFaceUp = false;
      }
      recordMove(
        Move(
          cards: List.from(stock),
          fromPileType: PileType.waste,
          toPileType: PileType.stock,
        ),
      );
    } else {
      int count = difficulty == 1 ? 1 : 3;
      for (int i = 0; i < count && stock.isNotEmpty; i++) {
        PlayingCard card = stock.removeLast();
        card.isFaceUp = true;
        movedCards.add(card);
        waste.add(card);
      }
      recordMove(
        Move(
          cards: movedCards,
          fromPileType: PileType.stock,
          toPileType: PileType.waste,
        ),
      );
    }
  }
}

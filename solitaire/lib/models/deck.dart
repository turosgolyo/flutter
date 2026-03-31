import 'dart:math';
import 'card.dart';

class Deck {
  List<PlayingCard> cards = [];

  Deck() {
    for (var suit in Suit.values) {
      for (var value in CardValue.values) {
        cards.add(PlayingCard(suit: suit, value: value));
      }
    }
  }

  void shuffle() {
    cards.shuffle(Random());
  }

  PlayingCard deal() {
    return cards.removeLast();
  }

  List<PlayingCard> dealCards(int count) {
    List<PlayingCard> dealtCards = [];
    for (int i = 0; i < count; i++) {
      dealtCards.add(deal());
    }
    return dealtCards;
  }
}

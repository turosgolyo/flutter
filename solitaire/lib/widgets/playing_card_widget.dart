import 'package:flutter/material.dart';
import '../models/card.dart';

class PlayingCardWidget extends StatelessWidget {
  final PlayingCard card;
  final double size;
  final Function(PlayingCard, int)? onDragStarted;
  final Function(PlayingCard, List<PlayingCard>, int)? onDragEnd;

  const PlayingCardWidget({
    super.key,
    required this.card,
    this.size = 1.0,
    this.onDragStarted,
    this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<List<PlayingCard>>(
      data: [card],
      feedback: _buildCard(),
      childWhenDragging: Container(),
      child: _buildCard(),
    );
  }

  Widget _buildCard() {
    return Container(
      width: 100 * size,
      height: 150 * size,
      decoration: BoxDecoration(
        color: card.isFaceUp ? Colors.white : Colors.blue[900],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.black, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(3, 3),
          ),
        ],
      ),
      child: card.isFaceUp
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _cardValueToString(card.value),
                    style: TextStyle(
                      fontSize: 24 * size,
                      fontWeight: FontWeight.bold,
                      color: _cardColor(card.suit),
                    ),
                  ),
                  Text(
                    _suitToString(card.suit),
                    style: TextStyle(
                      fontSize: 24 * size,
                      color: _cardColor(card.suit),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Container(
                width: 80 * size,
                height: 130 * size,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
    );
  }

  String _cardValueToString(CardValue value) {
    switch (value) {
      case CardValue.ace:
        return 'A';
      case CardValue.two:
        return '2';
      case CardValue.three:
        return '3';
      case CardValue.four:
        return '4';
      case CardValue.five:
        return '5';
      case CardValue.six:
        return '6';
      case CardValue.seven:
        return '7';
      case CardValue.eight:
        return '8';
      case CardValue.nine:
        return '9';
      case CardValue.ten:
        return '10';
      case CardValue.jack:
        return 'J';
      case CardValue.queen:
        return 'Q';
      case CardValue.king:
        return 'K';
    }
  }

  String _suitToString(Suit suit) {
    switch (suit) {
      case Suit.hearts:
        return '♥';
      case Suit.diamonds:
        return '♦';
      case Suit.clubs:
        return '♣';
      case Suit.spades:
        return '♠';
    }
  }

  Color _cardColor(Suit suit) {
    return (suit == Suit.hearts || suit == Suit.diamonds)
        ? Colors.red
        : Colors.black;
  }
}

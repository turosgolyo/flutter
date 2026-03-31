import 'dart:async';

import 'package:flutter/material.dart';
import '../models/game_model.dart';
import '../widgets/playing_card_widget.dart';
import '../models/card.dart';
import '../models/move.dart';

class GameScreen extends StatefulWidget {
  final int difficulty;
  const GameScreen({super.key, this.difficulty = 1});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameModel gameModel;
  late Timer _timer;

  // To handle dragging multiple cards
  int _draggedFromPileIndex = -1;

  @override
  void initState() {
    super.initState();
    gameModel = GameModel();
    gameModel.difficulty = widget.difficulty;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        gameModel.timer++;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      appBar: AppBar(
        title: Text('Time: ${gameModel.timer}s'),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () {
              setState(() {
                gameModel.undo();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                gameModel.resetGame();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[800]!, Colors.green[600]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildTopPiles(),
              const SizedBox(height: 16),
              _buildTableauPiles(),
              if (_checkWinCondition()) _buildWinDialog(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopPiles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildStockAndWaste(), _buildFoundationPiles()],
    );
  }

  Widget _buildStockAndWaste() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              gameModel.dealFromStock();
            });
          },
          child: gameModel.stock.isNotEmpty
              ? PlayingCardWidget(card: gameModel.stock.last)
              : Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
        ),
        const SizedBox(width: 8),
        gameModel.waste.isNotEmpty
            ? Draggable<List<PlayingCard>>(
                data: [gameModel.waste.last],
                feedback: PlayingCardWidget(card: gameModel.waste.last),
                childWhenDragging: Container(),
                child: PlayingCardWidget(card: gameModel.waste.last),
                onDragEnd: (details) {
                  if (details.wasAccepted) {
                    Move move = Move(
                      cards: [gameModel.waste.last],
                      fromPileType: PileType.waste,
                      toPileType: PileType
                          .tableau, // This will be updated in the target
                    );
                    gameModel.recordMove(move);
                    setState(() {
                      gameModel.waste.removeLast();
                    });
                  }
                },
              )
            : Container(width: 100, height: 150),
      ],
    );
  }

  Widget _buildFoundationPiles() {
    return Row(
      children: gameModel.foundations.asMap().entries.map((entry) {
        int index = entry.key;
        List<PlayingCard> pile = entry.value;
        return DragTarget<List<PlayingCard>>(
          builder: (context, candidateData, rejectedData) {
            return Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: pile.isNotEmpty
                  ? PlayingCardWidget(card: pile.last)
                  : null,
            );
          },
          onWillAccept: (data) {
            if (data == null || data.length != 1) return false;
            return _isValidFoundationMove(data.first, pile);
          },
          onAccept: (data) {
            Move move = Move(
              cards: data,
              fromPileType: _draggedFromPileIndex == -1
                  ? PileType.waste
                  : PileType.tableau,
              fromPileIndex: _draggedFromPileIndex,
              toPileType: PileType.foundation,
              toPileIndex: index,
            );
            gameModel.recordMove(move);
            setState(() {
              gameModel.foundations[index].addAll(data);
              _removeCardsFromOrigin(data);
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTableauPiles() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: gameModel.tableaus.asMap().entries.map((entry) {
          int pileIndex = entry.key;
          List<PlayingCard> pile = entry.value;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: DragTarget<List<PlayingCard>>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent, // Ensures it can accept drags
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: pile.asMap().entries.map((entry) {
                        int cardIndex = entry.key;
                        PlayingCard card = entry.value;
                        if (!card.isFaceUp) {
                          return Positioned(
                            top: cardIndex * 30.0,
                            left: 0,
                            right: 0,
                            child: PlayingCardWidget(card: card),
                          );
                        }
                        return Positioned(
                          top: cardIndex * 30.0,
                          left: 0,
                          right: 0,
                          child: Draggable<List<PlayingCard>>(
                            data: _getDraggableCards(pile, cardIndex),
                            feedback: Material(
                              color: Colors.transparent,
                              child: SizedBox(
                                width: 100, // Base card width
                                height:
                                    150 +
                                    (_getDraggableCards(
                                          pile,
                                          cardIndex,
                                        ).length *
                                        30.0),
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: _getDraggableCards(pile, cardIndex)
                                      .asMap()
                                      .entries
                                      .map(
                                        (e) => Positioned(
                                          top: e.key * 30.0,
                                          left: 0,
                                          right: 0,
                                          child: PlayingCardWidget(
                                            card: e.value,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            childWhenDragging: Container(),
                            onDragStarted: () {
                              setState(() {
                                _draggedFromPileIndex = pileIndex;
                              });
                            },
                            onDragEnd: (details) {
                              setState(() {
                                _draggedFromPileIndex = -1;
                              });
                            },
                            child: PlayingCardWidget(card: card),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
                onWillAccept: (data) {
                  if (data == null) return false;
                  return _isValidTableauMove(data.first, pile);
                },
                onAccept: (data) {
                  bool turnedCard = false;
                  PileType fromType = _draggedFromPileIndex == -1
                      ? PileType.waste
                      : PileType.tableau;

                  if (fromType == PileType.tableau &&
                      _draggedFromPileIndex >= 0 &&
                      gameModel.tableaus[_draggedFromPileIndex].isNotEmpty &&
                      gameModel.tableaus[_draggedFromPileIndex].length >
                          data.length) {
                    final underlyingCardIndex =
                        gameModel.tableaus[_draggedFromPileIndex].length -
                        data.length -
                        1;
                    if (!gameModel
                        .tableaus[_draggedFromPileIndex][underlyingCardIndex]
                        .isFaceUp) {
                      gameModel
                              .tableaus[_draggedFromPileIndex][underlyingCardIndex]
                              .isFaceUp =
                          true;
                      turnedCard = true;
                    }
                  }

                  Move move = Move(
                    cards: data,
                    fromPileType: fromType,
                    fromPileIndex: _draggedFromPileIndex == -1
                        ? 0
                        : _draggedFromPileIndex,
                    toPileType: PileType.tableau,
                    toPileIndex: pileIndex,
                    turnedCard: turnedCard,
                  );
                  gameModel.recordMove(move);
                  setState(() {
                    gameModel.tableaus[pileIndex].addAll(data);
                    _removeCardsFromOrigin(data);
                  });
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<PlayingCard> _getDraggableCards(List<PlayingCard> pile, int cardIndex) {
    if (pile[cardIndex].isFaceUp) {
      return pile.sublist(cardIndex);
    }
    return [];
  }

  bool _isValidFoundationMove(PlayingCard card, List<PlayingCard> pile) {
    if (pile.isEmpty) {
      return card.value == CardValue.ace;
    } else {
      PlayingCard topCard = pile.last;
      return card.suit == topCard.suit &&
          card.value.index == topCard.value.index + 1;
    }
  }

  bool _isValidTableauMove(PlayingCard card, List<PlayingCard> pile) {
    if (pile.isEmpty) {
      return card.value == CardValue.king;
    } else {
      PlayingCard topCard = pile.last;
      return _isOppositeColor(card, topCard) &&
          card.value.index == topCard.value.index - 1;
    }
  }

  bool _isOppositeColor(PlayingCard card1, PlayingCard card2) {
    bool card1IsRed = card1.suit == Suit.hearts || card1.suit == Suit.diamonds;
    bool card2IsRed = card2.suit == Suit.hearts || card2.suit == Suit.diamonds;
    return card1IsRed != card2IsRed;
  }

  void _removeCardsFromOrigin(List<PlayingCard> cards) {
    if (gameModel.waste.isNotEmpty && gameModel.waste.last == cards.first) {
      gameModel.waste.removeLast();
      return;
    }
    for (var pile in gameModel.tableaus) {
      if (pile.contains(cards.first)) {
        pile.removeRange(pile.indexOf(cards.first), pile.length);
        if (pile.isNotEmpty) {
          pile.last.isFaceUp = true;
        }
        return;
      }
    }
  }

  bool _checkWinCondition() {
    return gameModel.foundations.every((pile) => pile.length == 13);
  }

  Widget _buildWinDialog() {
    return AlertDialog(
      title: const Text('You Won!'),
      content: Text(
        'Congratulations! You finished the game in ${gameModel.timer} seconds.',
      ),
      actions: [
        TextButton(
          child: const Text('New Game'),
          onPressed: () {
            setState(() {
              gameModel.resetGame();
            });
          },
        ),
      ],
    );
  }
}

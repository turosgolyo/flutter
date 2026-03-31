import 'package:flutter/material.dart';
import '../models/card.dart';
import 'playing_card_widget.dart';

class AnimatedPlayingCard extends StatefulWidget {
  final PlayingCard card;
  final Offset position;
  final Function(List<PlayingCard>)? onDragEnd;
  final Function(PlayingCard, int)? onDragStarted;

  const AnimatedPlayingCard({
    super.key,
    required this.card,
    required this.position,
    this.onDragEnd,
    this.onDragStarted,
  });

  @override
  State<AnimatedPlayingCard> createState() => _AnimatedPlayingCardState();
}

class _AnimatedPlayingCardState extends State<AnimatedPlayingCard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      left: widget.position.dx,
      top: widget.position.dy,
      child: PlayingCardWidget(card: widget.card),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MemoryGameApp());
}

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Szókártyák - Főmenü')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const MemoryGameScreen(initialWordPairs: {}),
                  ),
                );
              },
              child: const Text('Üres játék'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MemoryGameScreen(
                      initialWordPairs: {
                        'Kutya': 'Dog',
                        'Macska': 'Cat',
                        'Ház': 'House',
                        'Alma': 'Apple',
                        'Könyv': 'Book',
                        'Madár': 'Bird',
                      },
                    ),
                  ),
                );
              },
              child: const Text('Alapjáték'),
            ),
          ],
        ),
      ),
    );
  }
}

class MemoryGameApp extends StatelessWidget {
  const MemoryGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Szókártyák',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainMenuScreen(),
    );
  }
}

class WordCard {
  final int id;
  final String text;
  final int matchId;
  bool isFlipped;
  bool isMatched;

  WordCard({
    required this.id,
    required this.text,
    required this.matchId,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class MemoryGameScreen extends StatefulWidget {
  final Map<String, String> initialWordPairs;

  const MemoryGameScreen({super.key, required this.initialWordPairs});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late Map<String, String> _wordPairs;

  late List<WordCard> _cards;
  int? _firstSelectedIndex;
  bool _isProcessing = false;
  int _matchesFound = 0;

  @override
  void initState() {
    super.initState();
    _wordPairs = Map.from(widget.initialWordPairs);
    _initGame();
  }

  void _initGame() {
    _cards = [];
    int idCounter = 0;
    int matchIdCounter = 0;

    _wordPairs.forEach((hu, en) {
      _cards.add(WordCard(id: idCounter++, text: hu, matchId: matchIdCounter));
      _cards.add(WordCard(id: idCounter++, text: en, matchId: matchIdCounter));
      matchIdCounter++;
    });

    _cards.shuffle();
    _matchesFound = 0;
    _firstSelectedIndex = null;
    _isProcessing = false;
  }

  void _onCardTap(int index) {
    if (_isProcessing || _cards[index].isFlipped || _cards[index].isMatched) {
      return;
    }

    setState(() {
      _cards[index].isFlipped = true;
    });

    if (_firstSelectedIndex == null) {
      _firstSelectedIndex = index;
    } else {
      _isProcessing = true;
      _checkForMatch(index);
    }
  }

  void _checkForMatch(int secondIndex) {
    final firstIndex = _firstSelectedIndex!;
    if (_cards[firstIndex].matchId == _cards[secondIndex].matchId) {
      setState(() {
        _cards[firstIndex].isMatched = true;
        _cards[secondIndex].isMatched = true;
        _matchesFound++;
      });
      _resetSelection();
      if (_matchesFound == _wordPairs.length) {
        _showWinDialog();
      }
    } else {
      Timer(const Duration(seconds: 1), () {
        setState(() {
          _cards[firstIndex].isFlipped = false;
          _cards[secondIndex].isFlipped = false;
        });
        _resetSelection();
      });
    }
  }

  void _resetSelection() {
    setState(() {
      _firstSelectedIndex = null;
      _isProcessing = false;
    });
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Gratulálok!'),
        content: const Text('Megtaláltad az összes szópárt!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _initGame();
              });
            },
            child: const Text('Újra'),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog() {
    final TextEditingController termController = TextEditingController();
    final TextEditingController definitionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Új szópár hozzáadása'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: termController,
                decoration: const InputDecoration(
                  labelText: 'Első szó (pl. Magyar)',
                ),
              ),
              TextField(
                controller: definitionController,
                decoration: const InputDecoration(
                  labelText: 'Második szó (pl. Angol)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Mégse'),
            ),
            TextButton(
              onPressed: () {
                final term = termController.text.trim();
                final definition = definitionController.text.trim();
                if (term.isNotEmpty && definition.isNotEmpty) {
                  setState(() {
                    _wordPairs[term] = definition;
                    _initGame();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Hozzáadás'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Szókártyák - Tanulj játszva!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCardDialog,
            tooltip: 'Új szópár',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() => _initGame()),
            tooltip: 'Új játék',
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemCount: _cards.length,
          itemBuilder: (context, index) {
            final card = _cards[index];
            return GestureDetector(
              onTap: () => _onCardTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: card.isFlipped || card.isMatched
                      ? Colors.white
                      : Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueGrey, width: 2),
                  boxShadow: [
                    if (!card.isFlipped && !card.isMatched)
                      const BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                  ],
                ),
                child: Center(
                  child: card.isFlipped || card.isMatched
                      ? Text(
                          card.text,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: card.isMatched
                                ? Colors.green
                                : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : const Icon(
                          Icons.question_mark,
                          size: 40,
                          color: Colors.white,
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

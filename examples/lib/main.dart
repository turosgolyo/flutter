import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: DropdownButtonExample()));
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DropdownButtonExampleState();
  }
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  List<String> subjects = [
    'Matematika',
    'Magyar nyelv és irodalom',
    'Történelem',
  ];

  List<String> levels = ['Közép', 'Emelt'];

  late String selectedSubject;
  late String selectedLevel;

  @override
  void initState() {
    super.initState();
    selectedSubject = subjects[0];
    selectedLevel = levels[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tantárgy dropdown
            DropdownButton<String>(
              value: selectedSubject,
              items: subjects.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSubject = newValue!;
                });
              },
            ),

            const SizedBox(height: 20),

            // Szint dropdown
            DropdownButton<String>(
              value: selectedLevel,
              items: levels.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedLevel = newValue!;
                });
              },
            ),

            const SizedBox(height: 20),

            Text(
              'Kiválasztva: $selectedSubject - $selectedLevel szint',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

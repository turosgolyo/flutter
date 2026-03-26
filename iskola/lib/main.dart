import 'package:flutter/material.dart';

void main() {
  runApp(const School());
}

class School extends StatelessWidget {
  const School({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("School")),
        body: Row(
          children: [
            SizedBox(height: 200, child: Classes()),
            SizedBox(height: 200, child: Subject()),
          ],
        ),
      ),
    );
  }
}

class Classes extends StatelessWidget {
  final List<String> classes = ["13B", "13A", "13C", "12A", "12B"];

  Classes({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: classes.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text(classes[index]));
      },
    );
  }
}

class Subject extends StatelessWidget {
  Subject({super.key});

  final List<String> subjects = [
    "Történelem",
    "Matematika",
    "Fizika",
    "Kémia",
    "Biológia",
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: subjects.length,
      itemBuilder: (BuildContext context, int index) {
        return GridTile(child: Center(child: Text(subjects[index])));
      },
    );
  }
}

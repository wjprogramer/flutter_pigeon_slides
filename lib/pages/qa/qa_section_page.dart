import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/qa/qa_data.dart';

class QaSectionPage extends StatelessWidget {
  const QaSectionPage({super.key, required this.section});

  final QaSection section;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(section.title)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: section.items.length,
        itemBuilder: (context, index) {
          final item = section.items[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.question,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...item.answer.map(
                    (line) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('• $line'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


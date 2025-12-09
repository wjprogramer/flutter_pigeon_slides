import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/theme/theme.dart';

class ReadablePage extends StatelessWidget {
  const ReadablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('可讀性 Readable')),
      body: ListView(
        children: [
          Text.rich(
            TextSpan(
              text:
                  'Using this package eliminates the need to match strings between host and client for the names and data types of messages. '
                  'It supports nested classes, grouping messages into APIs, generation of asynchronous wrapper code, and sending messages in either direction. '
                  '',
              children: [
                TextSpan(
                  text: 'The generated code is readable ',
                  style: TextStyle(color: MyColors.highlight),
                ),
                TextSpan(text: 'and guarantees there are no conflicts between multiple clients of different versions.'),
              ],
            ),
          ),
          Divider(),
          Text(
            '來自官方文件的敘述 (backup: pigeon_is_readable_by_doc.png link: https://docs.flutter.dev/platform-integration/platform-channels#pigeon)',
          ),
        ],
      ),
    );
  }
}

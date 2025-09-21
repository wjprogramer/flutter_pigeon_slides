import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/pages/performance_plan/performance_plan_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  Widget _button(BuildContext context, {String text = '', WidgetBuilder? page}) {
    return ListTile(
      title: Text(text),
      trailing: Icon(Icons.chevron_right),
      onTap: () {
        if (page != null) {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => page(context)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menu')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [_button(context, text: 'Performance Plan', page: (_) => PerformancePlanPage())],
      ),
    );
  }
}

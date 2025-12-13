import 'package:flutter/material.dart';
import 'package:flutter_pigeon_slides/pages/analysis_aspects/analysis_aspects_data.dart';

class AnalysisAspectsPage extends StatelessWidget {
  const AnalysisAspectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pigeon 分析面向'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: analysisAspects.length,
        itemBuilder: (context, index) {
          final aspect = analysisAspects[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: aspect.icon != null
                  ? CircleAvatar(
                      backgroundColor: (aspect.color ?? Colors.grey)
                          .withOpacity(0.1),
                      child: Icon(
                        aspect.icon,
                        color: aspect.color ?? Colors.grey,
                      ),
                    )
                  : null,
              title: Text(aspect.name),
              subtitle: Text(aspect.description),
              trailing: aspect.pageBuilder != null
                  ? const Icon(Icons.chevron_right)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '待實作',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, size: 16),
                      ],
                    ),
              enabled: aspect.pageBuilder != null,
              onTap: aspect.pageBuilder != null
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: aspect.pageBuilder!,
                        ),
                      );
                    }
                  : null,
            ),
          );
        },
      ),
    );
  }
}


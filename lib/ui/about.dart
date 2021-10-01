import 'package:flutter/material.dart';

const _aboutText = '''
Автор: Избаш В.В.
Используемые сервисы: 
- openweathermap.org
- geonames.org
''';

class EotsAboutDialog extends StatelessWidget {
  const EotsAboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: const Text('О приложении'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            'Eye Of The Storm v1.0',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(_aboutText),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Закрыть'),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
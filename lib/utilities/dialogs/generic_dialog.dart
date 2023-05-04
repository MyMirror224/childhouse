import 'package:flutter/material.dart';


typedef DialogOptionsBuilder<T> = Map<String, T?> Function();
Future<T?> genericShowDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptionsBuilder dialogOptions,
}) {
  final options = dialogOptions();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((optionTitle) {
          final value = options[optionTitle];
          return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle));
        }).toList(),
      );
    },
  );
}

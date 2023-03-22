import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error Message'),
          content: Text(text),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed:() =>  Navigator.of(context).pop(),
            )
          ],
        );
      });
}
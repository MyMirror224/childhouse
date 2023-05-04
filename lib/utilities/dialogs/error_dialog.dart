import 'package:childhouse/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showErrorDialog(BuildContext context,String content) {
  return genericShowDialog(
    context: context,
    title: 'An error occuped',
    content: content,
    dialogOptions: () => {
      'Ok': null,
    },
  );
}

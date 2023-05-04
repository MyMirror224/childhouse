import 'package:childhouse/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return genericShowDialog(
    context: context,
    title: ' delete',
    content: 'Are you sure you want to delete this item?',
    dialogOptions: () => {
      'Cancel' : false,
      'Ok': true,
    }
  ).then((value) => value?? false);
}

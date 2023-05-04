import 'package:childhouse/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return genericShowDialog(
    context: context,
    title: 'Logout',
    content: 'Are you sure you want to logout?',
    dialogOptions: () => {
      'Cancel': false,
      'Yes': true,
    },
  ).then((value) => value?? false);
}

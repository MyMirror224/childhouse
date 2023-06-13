import 'package:childhouse/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/widgets.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return genericShowDialog(
    context: context,
    title: "Password reset",
    content:
        "We have now sent you a password reset link. Please check your email for more information.",
    dialogOptions: () => {
      'OK': null,
    },
  );
}

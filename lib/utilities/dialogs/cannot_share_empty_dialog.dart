
import 'package:childhouse/utilities/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showCannotShareEmptyDialog(BuildContext context){
  return genericShowDialog<void>(
    context: context,
     title: 'Error Share', 
     content: 'Cannot Share Empty',
      dialogOptions:  () => {
        'OK' : null,
      },
      );
}
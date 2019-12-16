import 'package:flutter/material.dart';

class CustomDialogTool {
  static AlertDialog buildDialog(final BuildContext context, final String title,
      final String message, final TextAlign alignment) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        message,
        textAlign: alignment,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}

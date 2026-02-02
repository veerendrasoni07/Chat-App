import 'package:flutter/material.dart';

class AlertDialogWarning extends StatelessWidget {
  Widget? title;
  Widget? content;
  void Function()? onSave;
  void Function()? onCancel;
  AlertDialogWarning({super.key, required this.title, required this.content,required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:title,
      content: content,
      actions: [
        TextButton(
          onPressed:onSave,
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
            textStyle: TextStyle(
              fontSize: 18,
            )
          ),
          child: const Text("Confirm")
        ),
        TextButton(
          onPressed: ()=>Navigator.of(context).pop(),
          style: TextButton.styleFrom(

            foregroundColor: Colors.grey,
            textStyle: TextStyle(
              fontSize: 18,
            )
          ),
          child: const Text("Cancel")
        ),
      ]
    );
  }
}

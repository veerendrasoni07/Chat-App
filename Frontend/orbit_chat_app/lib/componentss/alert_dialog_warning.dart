import 'package:flutter/material.dart';



  Widget alertDialogWarning({required Text title, required Text content,required   void Function()? onSave,required BuildContext context}) {
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


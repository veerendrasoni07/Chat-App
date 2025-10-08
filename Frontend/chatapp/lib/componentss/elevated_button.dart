import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:google_fonts/google_fonts.dart';
// import your UserNamePage here

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  const CustomElevatedButton({Key? key, required this.onPressed, required this.buttonText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 70),
        maximumSize: Size(double.infinity, 80),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      onPressed: onPressed,
      child: AutoSizeText(
        buttonText,
          maxFontSize: 20,
          minFontSize: 16,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.w600,
        color: Colors.white
      ),),
    );
  }
}
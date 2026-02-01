import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF450072),
              Color(0xFF330060),
              Color(0xFF27003F),
              Color(0xFF17001F),
            ]
          )
        ),
        child: Stack(
          children: [
            Positioned.fill(
                child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 30,
                      sigmaY: 30,
                    )
                )
            ),
            Center(child: Text("Upcoming page",style: GoogleFonts.montserrat(
              fontSize: MediaQuery.of(context).size.width * 0.1,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),),)
          ],
        ),
      ),
    );
  }
}

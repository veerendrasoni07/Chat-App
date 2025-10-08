import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 6, 26, 137),
              Color.fromARGB(255, 3, 40, 72),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.08,
                      vertical: size.height * 0.05,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 🟡 Lottie animation (top)
                        Lottie.asset(
                          'assets/animation/globe.json',
                          width: size.width * 0.8,
                          height: size.height * 0.55,
                          fit: BoxFit.contain,
                        ),
                        // 🟣 Text section (bottom)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              "🌍 Always in Sync",
                              style: GoogleFonts.poppins(
                                fontSize: size.width * 0.08,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                        
                              ),
                            ),
                            const SizedBox(height: 10),
                            AutoSizeText(
                              "Chat across devices seamlessly and keep your conversations flowing anytime, anywhere.",
                              minFontSize: 14,
                              maxFontSize: 18,
                              style: GoogleFonts.nunito(
                                fontSize: size.width * 0.045,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.9),
                               
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

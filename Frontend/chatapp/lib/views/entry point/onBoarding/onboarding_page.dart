import 'package:chatapp/componentss/elevated_button.dart';
import 'package:chatapp/views/entry%20point/authentication/login_screen.dart' show LoginScreen;
import 'package:chatapp/views/entry%20point/authentication/sign_up_screen.dart';
import 'package:chatapp/views/entry%20point/onBoarding/pages/first_page.dart';
import 'package:chatapp/views/entry%20point/onBoarding/pages/second_page.dart';
import 'package:chatapp/views/entry%20point/onBoarding/pages/third_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController pageController = PageController();
  bool isLastPage = false;

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
              Color(0xFF6C63FF), // primary violet
              Color(0xFF1A1A2E), // deep navy
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // PageView
            PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() => isLastPage = index == 2);
              },
              children: const [FirstPage(), SecondPage(), ThirdPage()],
            ),

            // Bottom controls
            Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: size.height * 0.05),
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => pageController.jumpToPage(2),
                    child: Text(
                      "Skip",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.white.withOpacity(0.4),
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 8,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (isLastPage) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const ChooseLoginOrSignUp(),
                          ),
                        );
                      } else {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      isLastPage ? "Get Started" : "Next",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}

class ChooseLoginOrSignUp extends StatefulWidget {
  const ChooseLoginOrSignUp({super.key});

  @override
  State<ChooseLoginOrSignUp> createState() => _ChooseLoginOrSignUpState();
}

class _ChooseLoginOrSignUpState extends State<ChooseLoginOrSignUp> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
               Color.fromARGB(255, 255, 217, 0),
              Color.fromARGB(255, 198, 158, 15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        
        
            Icon(Icons.chat, size: 100, color: Colors.white),
            SizedBox(height: 20),          
        
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.02),
              child: CustomElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())), buttonText: "Login"),
            ),
            Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                    indent: 20,
                    endIndent: 10,
                  ),
                ),
                Text(
                  "OR",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey[400],
                    thickness: 1,
                    indent: 10,
                    endIndent: 20,
                  ),
                ),
              ],
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.height * 0.02),
              child: CustomElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpFlow())), buttonText: "Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}

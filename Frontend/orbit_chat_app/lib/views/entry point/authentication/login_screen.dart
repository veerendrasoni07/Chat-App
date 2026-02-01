import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbit_chat_app/controller/auth_controller.dart';
import 'package:orbit_chat_app/views/entry%20point/authentication/sign_up_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isShown = false;
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;
    final height = media.size.height;
    final scale = width / 390; // base design width

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.95),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Form(
          key: _formKey,
          child:
            Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Login to your account!",

                      style: GoogleFonts.poppins(
                        fontSize: 15 * scale,
                        fontWeight: FontWeight.bold,
                        color:Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    // Email Field
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      style: GoogleFonts.openSans(
                          fontSize: 18 * scale,
                          fontWeight: FontWeight.bold),
                      cursorColor: Theme.of(context).colorScheme.inversePrimary,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: GoogleFonts.openSans(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 16 * scale,
                            fontWeight: FontWeight.bold),
                        enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    // Password Field
                    TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      obscureText: isShown == false ? true : false,
                      cursorColor: Theme.of(context).colorScheme.inversePrimary,
                      style: GoogleFonts.openSans(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 18 * scale,
                          fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.openSans(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 16 * scale,
                            fontWeight: FontWeight.bold),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isShown == false ? Icons.visibility_off : Icons.visibility,
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                              onPressed: () {
                                setState(() {
                                  isShown = !isShown;
                                });
                              },
                            ),
                        enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                        focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: GoogleFonts.nunito(
                              color:Theme.of(context).colorScheme.inversePrimary, fontSize: 14 * scale),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.03),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          minimumSize: Size(width * 0.75, height * 0.065),
                        ),
                        onPressed: () async {
                          await AuthController().login(
                              email: emailController.text,
                              password: passwordController.text,
                              context: context,
                              ref: ref);
                        },
                        child: Text(
                          "Login",
                          style: GoogleFonts.montserrat(
                              color:  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 20 * scale,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Divider(),
                            Text(
                              "OR",
                            ),
                            Divider(),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black)
                              ),
                              child: Image.asset('assets/icons/google_png.png',height: 50,width: 50,fit: BoxFit.cover,),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: GoogleFonts.nunito(
                              color: Colors.black, fontSize: 14 * scale),
                        ),
                        TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpFlow())),
                            child: Text(
                              "Sign Up",
                              style: GoogleFonts.nunito(
                                  color: Colors.black, fontSize: 16 * scale),
                            )
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
      ),
      
    );
  }
}

import 'dart:ui'; // Import this for ImageFilter
import 'package:chatapp/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerStatefulWidget {
   LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent, // Make the app bar transparent
        elevation: 0, // Remove the shadow
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand, // Expand the Stack to fill the screen
        children: [
          // Step 1: Add the background image
          Image.asset(
            'assets/images/snow_background.jpg',
            fit: BoxFit.cover,
          ),

          // Step 2: Apply the BackdropFilter over the image
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Adjust sigma for blur intensity
            child: Container(
              color: Colors.black.withOpacity(0.3), // Optional semi-transparent overlay
            ),
          ),

          // Step 3: Add your non-blurred content on top
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 18),
                  child: Text(
                    "Login to your account!",
                    style: GoogleFonts.montserrat(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                // Add more widgets for your login form here
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: emailController,
                    style: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                    validator: (value){
                      if(value == null ||value.isEmpty){
                        return 'Please enter your email';
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      )
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: passwordController,
                    style: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                    validator: (value){
                      if(value == null ||value.isEmpty){
                        return 'Please enter your password';
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                        labelStyle: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      )
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Forgot Password?",style: GoogleFonts.openSans(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    minimumSize:Size(MediaQuery.of(context).size.width*.75, 50) ,
                  ),
                    onPressed: ()async{
                      await AuthController().login(email: emailController.text, password: passwordController.text, context: context, ref: ref);
                    },
                    child: Text("Login",style: GoogleFonts.montserrat(color: Colors.blueAccent,fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 5),)
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",style: GoogleFonts.openSans(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
                    TextButton(onPressed: ()=> Navigator.pushNamedAndRemoveUntil(context, '/register', (route) => false), child: Text("Sign Up",style: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)))
                  ]
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

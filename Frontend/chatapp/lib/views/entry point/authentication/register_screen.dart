// import 'dart:ui'; // Import this for ImageFilter
// import 'package:chatapp/controller/auth_controller.dart';
// import 'package:chatapp/views/entry%20point/authentication/login_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class RegisterScreen extends ConsumerStatefulWidget {
//   RegisterScreen({super.key});
//
//   @override
//   ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends ConsumerState<RegisterScreen> {
//   final TextEditingController emailController = TextEditingController();
//
//   final TextEditingController passwordController = TextEditingController();
//
//   final TextEditingController fullNameController = TextEditingController();
//   bool isEnable = false;
//
//   String?gender;
//
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   final AuthController controller = AuthController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.transparent, // Make the app bar transparent
//         elevation: 0, // Remove the shadow
//       ),
//       extendBodyBehindAppBar: true,
//       body: Form(
//         key: _formKey,
//         child: Stack(
//           fit: StackFit.expand, // Expand the Stack to fill the screen
//           children: [
//             // Step 1: Add the background image
//             Image.asset(
//               'assets/images/snow_background.jpg',
//               fit: BoxFit.cover,
//             ),
//
//             // Step 2: Apply the BackdropFilter over the image
//             BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Adjust sigma for blur intensity
//               child: Container(
//                 color: Colors.black.withOpacity(0.3), // Optional semi-transparent overlay
//               ),
//             ),
//
//             // Step 3: Add your non-blurred content on top
//             Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 18),
//                     child: Text(
//                       "Register to your account!",
//                       style: GoogleFonts.montserrat(
//                         fontSize: 30,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   // Add more widgets for your Register form here
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextFormField(
//                       controller: fullNameController,
//                       style: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
//                       decoration: InputDecoration(
//                           labelText: 'Full Name',
//                           labelStyle: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           )
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 15,),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextFormField(
//                       controller: emailController,
//                       style: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
//                       decoration: InputDecoration(
//                           labelText: 'Email',
//                           labelStyle: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           )
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 15,),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: TextFormField(
//                       controller: passwordController,
//                       obscureText: isEnable ? true : false,
//                       validator: (value){
//                         if(value == null ||value.isEmpty){
//                           return 'Please enter your password';
//                         }else{
//                           return null;}
//                       },
//                       keyboardType: TextInputType.visiblePassword,
//                       style: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
//                       decoration: InputDecoration(
//                           labelText: 'Password',
//                           labelStyle: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
//                           suffixIcon: IconButton(
//                             icon: isEnable ? Icon( Icons.visibility_off,color: Colors.white,): Icon( Icons.visibility,color: Colors.white,),
//                             onPressed: (){
//                               setState(() {
//                                 isEnable = !isEnable;
//                               });
//                             },
//                           ),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.white),
//                           )
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 15.0),
//                     child: Text("Gender",style: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
//                   ),
//                   RadioListTile(
//                     value: 'male',
//                     groupValue: gender,
//                     activeColor: Colors.white,
//                     onChanged: (value){
//                       setState(() {
//                         gender = value!;
//                       });
//                     },
//                       title: Text("Male",style: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
//                   ),
//                   RadioListTile(
//                     value: 'female',
//                     groupValue: gender,
//                     activeColor: Colors.white,
//                     hoverColor: Colors.white,
//                     tileColor: Colors.white,
//                     selectedTileColor: Colors.white,
//                     toggleable: true,
//                     onChanged: (value){
//                       setState(() {
//                         gender = value!;
//                       });
//                     },
//                     title: Text("Female",style: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
//                   ),
//                   SizedBox(height: 20,),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         Text("Forgot Password?",style: GoogleFonts.openSans(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 20,),
//                   Center(
//                     child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(15)
//                           ),
//                           minimumSize:Size(MediaQuery.of(context).size.width*.75, 50) ,
//                         ),
//                         onPressed: ()async{
//                           if(_formKey.currentState!.validate()){
//                             await controller.signUp(fullname: fullNameController.text, email: emailController.text, password: passwordController.text, gender: gender!, context: context, ref: ref);
//                           }
//                         },
//                         child: Text("Register",style: GoogleFonts.montserrat(color: Colors.blueAccent,fontSize: 20,fontWeight: FontWeight.bold,letterSpacing: 5),)
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text("Already have an account?",style: GoogleFonts.openSans(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold)),
//                         TextButton(onPressed: ()=> Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false), child: Text("Login",style: GoogleFonts.openSans(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold)))
//                       ]
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

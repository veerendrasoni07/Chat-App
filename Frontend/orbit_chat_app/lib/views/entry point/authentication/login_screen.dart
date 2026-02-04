import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbit_chat_app/controller/auth_controller.dart';
import 'package:orbit_chat_app/views/entry%20point/authentication/sign_up_screen.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pinput/pinput.dart';

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
                        TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordFlow()));
                          },
                          child: Text("Forgot Password?",
                            style: GoogleFonts.nunito(
                                color:Theme.of(context).colorScheme.inversePrimary, fontSize: 14 * scale),),
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
                          showDialog(context: context, builder: (_)=>Center(child: CircularProgressIndicator(),));
                          await AuthController().login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              context: context,
                              ref: ref);
                          Navigator.pop(context);
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
                    // Column(
                    //   children: [
                    //     const Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Divider(),
                    //         Text(
                    //           "OR",
                    //         ),
                    //         Divider(),
                    //       ],
                    //     ),
                    //     Row(
                    //       children: [
                    //         Container(
                    //           height: 50,
                    //           width: 50,
                    //           decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(10),
                    //               color: Colors.white,
                    //               border: Border.all(color: Colors.black)
                    //           ),
                    //           child: Image.asset('assets/icons/google_png.png',height: 50,width: 50,fit: BoxFit.cover,),
                    //         )
                    //       ],
                    //     ),
                    //   ],
                    // ),
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

class ChangePasswordFlow extends StatefulWidget {
  const ChangePasswordFlow({super.key});

  @override
  State<ChangePasswordFlow> createState() => _ChangePasswordFlowState();
}

class _ChangePasswordFlowState extends State<ChangePasswordFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), // email
    GlobalKey<FormState>(), // otp
    GlobalKey<FormState>(), // password
  ];
  TextEditingController passController1 = TextEditingController();
  TextEditingController passController2 = TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  late final TextEditingController pinController;
  late final FocusNode focusNode;
  late final GlobalKey<FormState> formKey;
  bool isEnable = false;

  @override
  void initState() {
    super.initState();

    formKey = GlobalKey<FormState>();
    pinController = TextEditingController();
    focusNode = FocusNode();


  }


  void nextPage(){
    if(_currentPage < 2){
      setState(() => _currentPage++);
      _pageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
    }
  }
  void previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
    pinController.dispose();
    focusNode.dispose();
    formKey.currentState!.dispose();
    emailController.dispose();
    passController1.dispose();
    passController2.dispose();
    controller.dispose();
  }



  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: borderColor),
      ),
    );
    return Scaffold(
        appBar: AppBar(
            leading:IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  size: 15,
                  color: Colors.black),
              onPressed: () => {
                _currentPage > 0 ? previousPage() : Navigator.pop(context)
              },
            )

        ),
        body: SafeArea(
            child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Form(
                    key: _formKeys[0],
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text("Please Enter Your Registered Email!",style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: emailController,
                            cursorColor: Colors.white,
                            validator: (value)=> value == null || value.isEmpty
                                ? "Please enter registered email"
                                : null,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            decoration: InputDecoration(
                                hintText: "Enter registered email",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                prefixIcon: Icon(Icons.email),
                                prefixIconColor: Colors.blue,
                                filled: true,
                                fillColor: Colors.grey.shade900,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  gapPadding: 10,
                                )
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: ()async{
                            if(_formKeys[0].currentState!.validate()){
                              showDialog(context: context,barrierDismissible: false, builder: (context){
                                return Center(child: CircularProgressIndicator(color: Colors.white,),);
                              });
                              await AuthController().getOTP(emailController.text, context);
                              Navigator.pop(context);
                              nextPage();
                            }
                          },
                          child: Text("Next",style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                          ),)
                        )
                      ],
                    ),
                  ) ,
                  Form(
                    key: _formKeys[1],
                    child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("OTP Is Sent To Your Registered Email!",style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                          Directionality(
                            // Specify direction if desired
                            textDirection: TextDirection.ltr,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Pinput(
                                controller: pinController,
                                focusNode: focusNode,
                                length: 6,
                                defaultPinTheme: defaultPinTheme,
                                separatorBuilder: (index) => const SizedBox(width: 8),
                                hapticFeedbackType: HapticFeedbackType.lightImpact,
                                onCompleted: (pin) async{
                                  showDialog(context: context,barrierDismissible: false, builder: (context){
                                    return Center(child: CircularProgressIndicator(color: Colors.white,),);
                                  });
                                  await AuthController().verifyOTP(emailController.text, int.parse(pin) );
                                  Navigator.pop(context);
                                  nextPage();
                                },
                                onChanged: (value) {
                                  debugPrint('onChanged: $value');
                                },
                                cursor: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 9),
                                      width: 22,
                                      height: 1,
                                      color: focusedBorderColor,
                                    ),
                                  ],
                                ),
                                focusedPinTheme: defaultPinTheme.copyWith(
                                  decoration: defaultPinTheme.decoration!.copyWith(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: focusedBorderColor),
                                  ),
                                ),
                                submittedPinTheme: defaultPinTheme.copyWith(
                                  decoration: defaultPinTheme.decoration!.copyWith(
                                    color: fillColor,
                                    borderRadius: BorderRadius.circular(19),
                                    border: Border.all(color: focusedBorderColor),
                                  ),
                                ),
                                errorPinTheme: defaultPinTheme.copyBorderWith(
                                  border: Border.all(color: Colors.redAccent),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Didn't receive OTP?",style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),),
                              SizedBox(width: 5,),
                              OtpTimerButton(
                                  onPressed: ()async{
                                    showDialog(context: context,barrierDismissible: false, builder: (context){
                                      return Center(child: CircularProgressIndicator(color: Colors.white,),);
                                    });
                                    await AuthController().getOTP(emailController.text, context);
                                    Navigator.pop(context);
                                  },
                                  backgroundColor: Colors.green,
                                  text: Text("Resend OTP",style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16
                                  )),
                                  loadingIndicator: CircularProgressIndicator(color: Colors.grey,),
                                  duration: 60
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),



                          // Padding(
                          //   padding: const EdgeInsets.all(12.0),
                          //   child: TextFormField(
                          //     controller: controller,
                          //     cursorColor: Colors.white,
                          //     validator: (value)=> value == null || value.isEmpty
                          //         ? "Please confirm your password"
                          //         : null,
                          //     style: TextStyle(
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.bold,
                          //       fontSize: 16,
                          //     ),
                          //     decoration: InputDecoration(
                          //         hintText: "Enter OTP here",
                          //         hintStyle: TextStyle(
                          //           color: Colors.white,
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 16,
                          //         ),
                          //         prefixIcon: Icon(Icons.email),
                          //         prefixIconColor: Colors.blue,
                          //         filled: true,
                          //         fillColor: Colors.grey.shade900,
                          //         border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(10),
                          //           gapPadding: 10,
                          //         )
                          //     ),
                          //   ),
                          // ),

                        ]
                    ),
                  ),
                  SingleChildScrollView(
                    child: Form(
                      key: _formKeys[2],
                      child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text("Please Enter Your New Password!",style: GoogleFonts.poppins(
                                color: Colors.grey,
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: passController1,
                                cursorColor: Colors.white,
                                validator: (value) =>
                                value == null || value.isEmpty
                                    ? "Please confirm your password"
                                    : null,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                    hintText: "Enter new password",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    prefixIcon: Icon(Icons.lock),
                                    prefixIconColor: Colors.blue,
                                    filled: true,
                                    fillColor: Colors.grey.shade900,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      gapPadding: 10,
                                    )
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextFormField(
                                controller: passController2,
                                validator: (value) =>
                                value == null || value.isEmpty
                                    ? "Please enter new password"
                                    : null,
                                cursorColor: Colors.white,
                                obscureText: isEnable ? true : false ,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                decoration: InputDecoration(
                                    hintText: "Confirm new password",
                                    hintStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    prefixIcon: Icon(Icons.lock),
                                    prefixIconColor: Colors.blue,
                                    filled: true,
                                    fillColor: Colors.grey.shade900,
                                    suffixIcon: IconButton(onPressed: (){
                                      setState(() {
                                        isEnable = !isEnable;
                                      });
                                    }, icon: Icon(isEnable==true ? Icons.visibility_off : Icons.remove_red_eye)),
                                    suffixIconColor: Colors.blue,

                                    suffixStyle: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      gapPadding: 10,
                                    )
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 5,
                                shadowColor: Colors.black,
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                ),
                                minimumSize: Size(200, 50),
                                maximumSize: Size(200, 50),
                                fixedSize: Size(200, 50),
                                side: BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                                surfaceTintColor: Colors.blue,
                                foregroundColor: Colors.blue,
                                splashFactory: InkSplash.splashFactory,
                              ),
                              onPressed: ()async{
                                bool isValid = _formKeys[2].currentState!.validate();

                                if (isValid) {
                                  if (passController1.text != passController2.text) {
                                    //showSnackBar(context, "Password does not match", "Please confirm your password", ContentType.failure);
                                  } else {
                                    showDialog(context: context,barrierDismissible: false, builder: (context){
                                      return Center(child: CircularProgressIndicator(color: Colors.white,),);
                                    });
                                    await AuthController().resetPassword(
                                      email: emailController.text,
                                      password: passController1.text,
                                      context: context,
                                    );
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                    }
                                  }
                                }
                              },
                              child: Text("Confirm",style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16
                              ),),
                            )
                          ]
                      ),
                    ),
                  )
                ]
            )
        )
    );
  }
}
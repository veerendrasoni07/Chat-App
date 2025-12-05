import 'dart:async';
import 'package:chatapp/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/componentss/elevated_button.dart';

class SignUpFlow extends ConsumerStatefulWidget {
  const SignUpFlow({super.key});

  @override
  ConsumerState<SignUpFlow> createState() => _SignUpFlowState();
}

class _SignUpFlowState extends ConsumerState<SignUpFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // ✅ All controllers here for persistence
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthController _authController = AuthController();
  Timer? debounce;
  String? gender;
  bool isPassShown = false;
  bool isUserNameExist = false;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), // Name
    GlobalKey<FormState>(), // Username
    GlobalKey<FormState>(), // Email
    GlobalKey<FormState>(), // Gender
    GlobalKey<FormState>(), // Password
  ];


  void checkUserName(String username)async{
    final bool userName = await _authController.usernameCheck(username);
    setState(() {
      isUserNameExist = userName;
    });
  }

  void userNameOnChanged(String value){
    if(debounce?.isActive ?? false ){
      print("cancel kr dia is ki maa ki ");
      debounce?.cancel();
    }
    debounce = Timer(Duration(milliseconds: 800), (){
      print("check kr dia");
      checkUserName(value.trim());
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    debounce?.cancel();
    super.dispose();
  }

  void nextPage() {
    if (_formKeys[_currentPage].currentState!.validate()) {
      if (_currentPage < 4) {
        setState(() => _currentPage++);
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                size: 15,
                    color: Colors.grey),
                onPressed: previousPage,
              )
            : null,
      ),

      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(), // Controlled manually
          children: [
            // 1️⃣ Name Page
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08,
                    vertical: size.height * 0.05),
                child: Form(
                  key: _formKeys[0],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "What's your name?",
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.09,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? "Please enter your name"
                                : null,
                        cursorColor: Colors.green,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter your name",
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          enabled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      CustomElevatedButton(
                        buttonText: "Next",
                        onPressed: nextPage,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2️⃣ Username Page
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08,
                    vertical: size.height * 0.05),
                child: Form(
                  key: _formKeys[1],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Create a username",
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.08,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        controller: _userNameController,
                        validator: (value) =>
                        value == null || value.isEmpty
                            ? "Please enter your username"
                            : null,
                        cursorColor: Colors.green,
                        onChanged: (value)=>userNameOnChanged(value),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter your username",
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          enabled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none
                          ),
                        ),
                      ),
                      if (isUserNameExist == false && _userNameController.text.isNotEmpty)
                        const Text(
                          "Username already exists",
                          style: TextStyle(color: Colors.red),
                        )
                      else
                        const Text(
                          "Username is available",
                          style: TextStyle(color: Colors.green),
                        ),
                      SizedBox(height: size.height * 0.05),
                      CustomElevatedButton(
                        buttonText: "Next",
                        onPressed: (){
                          if(isUserNameExist && _formKeys[1].currentState!.validate()){
                            nextPage();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 3️⃣ Email Page
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08,
                    vertical: size.height * 0.05),
                child: Form(
                  key: _formKeys[2],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "What's your email?",
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.09,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        controller: _emailController,
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? "Please enter your email"
                                : null,
                        cursorColor: Colors.green,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      CustomElevatedButton(
                        buttonText: "Next",
                        onPressed: nextPage,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 4️⃣ Gender Page
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08,
                    vertical: size.height * 0.05),
                child: Form(
                  key: _formKeys[3],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "What's your gender?",
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.09,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      RadioListTile<String>(
                        title: const Text("Male"),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        value: "male",
                        groupValue: gender,
                        activeColor: Colors.green,
                        tileColor: Colors.grey.shade200,
                        onChanged: (value) => setState(() => gender = value),
                      ),
                      SizedBox(height: size.height * 0.01),
                      RadioListTile<String>(
                        title: const Text("Female"),
                        value: "female",
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: Colors.grey.shade200,
                        activeColor: Colors.blue,

                        groupValue: gender,
                        onChanged: (value) => setState(() => gender = value),
                      ),
                      SizedBox(height: size.height * 0.01),
                      RadioListTile<String>(
                        title: const Text("Other"),
                        value: "other",
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        tileColor: Colors.grey.shade200,
                        activeColor: Colors.pink,
                        groupValue: gender,
                        onChanged: (value) => setState(() => gender = value),
                      ),
                      SizedBox(height: size.height * 0.05),
                      CustomElevatedButton(
                        buttonText: "Next",
                        onPressed: () {
                          if (gender != null) {
                            nextPage();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Please select your gender")));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 5️⃣ Password Page
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.08,
                    vertical: size.height * 0.05),
                child: Form(
                  key: _formKeys[4],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Set your password",
                        maxLines: 2,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: size.width * 0.09,
                        ),
                      ),
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: false,
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? "Please enter your password"
                                : null,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp
                        ),
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: isPassShown ? false : true,
                        validator: (value) => value != _passwordController.text
                            ? "Passwords do not match"
                            : null,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp
                        ),
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                          hintText: "Confirm password",
                          filled: true,
                          fillColor: Colors.grey.shade200,
                          suffixIcon: IconButton(onPressed: (){
                            setState(() {
                              isPassShown = !isPassShown;
                            });
                          }, icon: isPassShown ? Icon(CupertinoIcons.eye_solid) :Icon( CupertinoIcons.eye_slash_fill)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.05),
                      CustomElevatedButton(
                        buttonText: "Accept and Continue",
                        onPressed: () {
                          if (_formKeys[4].currentState!.validate()) {
                            // ✅ All data collected, proceed to sign-up
                            print("Name: ${_nameController.text}");
                            print("Username: ${_userNameController.text}");
                            print("Email: ${_emailController.text}");
                            print("Gender: $gender");
                            print("Password: ${_passwordController.text}");
                            AuthController().signUp(fullname: _nameController.text,username: _userNameController.text, email: _emailController.text, password: _passwordController.text, gender: gender!, context: context, ref: ref);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

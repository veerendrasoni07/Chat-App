import 'package:chatapp/provider/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  String? gender;
  bool isUserNameExist = false;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(), // Name
    GlobalKey<FormState>(), // Username
    GlobalKey<FormState>(), // Email
    GlobalKey<FormState>(), // Gender
    GlobalKey<FormState>(), // Password
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
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
    final socket = ref.read(socketProvider);
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
                        decoration: InputDecoration(
                          hintText: "Enter your name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
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
                        onChanged: (value){
                          socket.usernameCheck(_userNameController.text);
                        },
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? "Please enter a username"
                                : null,
                        decoration: InputDecoration(
                          hintText: "Enter your username",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      if(isUserNameExist)
                        Text("Username already exist",style: TextStyle(color: Colors.red),),
                      SizedBox(height: size.height * 0.05),
                      CustomElevatedButton(
                        buttonText: "Next",
                        onPressed: (){
                          if(!isUserNameExist && _formKeys[1].currentState!.validate()){
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
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
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
                        value: "male",
                        groupValue: gender,
                        onChanged: (value) => setState(() => gender = value),
                      ),
                      RadioListTile<String>(
                        title: const Text("Female"),
                        value: "female",
                        groupValue: gender,
                        onChanged: (value) => setState(() => gender = value),
                      ),
                      RadioListTile<String>(
                        title: const Text("Other"),
                        value: "other",
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
                        obscureText: true,
                        validator: (value) =>
                            value == null || value.isEmpty
                                ? "Please enter your password"
                                : null,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.02),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        validator: (value) => value != _passwordController.text
                            ? "Passwords do not match"
                            : null,
                        decoration: InputDecoration(
                          hintText: "Confirm password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
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

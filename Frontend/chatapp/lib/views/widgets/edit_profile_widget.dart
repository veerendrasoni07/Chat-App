import 'dart:ui';


import 'package:chatapp/componentss/responsive.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget _glassAvatar(String profilePic,String text,ResponsiveClass size) {
  return Container(
    width: size.wp(30),
    height: size.hp(30),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.20),
            Colors.white.withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 8))
        ]),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: profilePic.isNotEmpty ? Image.network(profilePic,fit: BoxFit.cover,) : Center(
          child: Hero(
            tag: text,
            child: Text(
              text[0] ,
              style: GoogleFonts.poppins(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late final TextEditingController nameController;
  late final TextEditingController bioController;
  late final TextEditingController phoneController;
  late final TextEditingController locationController;
  String? gender;
  bool isSaving = false;


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: height * 0.9,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF450072),
                Color(0xFF330060),
                Color(0xFF27003F),
                Color(0xFF17001F),
              ],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16,
            ),
            child: Column(
              children: [
                _dragHandle(),
                Expanded(child: _form()),
                _saveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _form(){
    return SingleChildScrollView(
      child: Column(
        children: [
          _label("Name"),
          _field(nameController, "Enter your name"),
          _label("Bio"),
          _field(bioController, "Enter your bio"),
          _label("Location"),
          _field(locationController, "Enter your location"),
          _label("Gender"),
          _genderOption("Male"),
          _genderOption("Female"),
          _genderOption("Other"),
        ],
      ),
    );
  }
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
  Widget _dragHandle() {
    return Container(
      width: 50,
      height: 5,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
  Widget _field(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _genderOption(String value) {
    return RadioListTile<String>(
      value: value,
      groupValue: gender,
      title: Text(
        value.toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
      onChanged: (v) => setState(() => gender = v),
      activeColor: Colors.greenAccent,
    );
  }

  Widget _saveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: isSaving ? null : (){},
          child: isSaving
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Save"),
        ),
      ),
    );
  }
}

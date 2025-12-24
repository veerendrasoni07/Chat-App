import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/componentss/elevated_button.dart';
import 'package:chatapp/componentss/responsive.dart';
import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/localDB/model/user_isar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> editProfileBottomSheet(BuildContext context,UserIsar user,WidgetRef ref,TextEditingController nameController,TextEditingController bioController,TextEditingController phoneController,TextEditingController locationController )async{
  String? gender;
  await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      sheetAnimationStyle: const AnimationStyle(
        curve: Curves.fastOutSlowIn,
        duration: Duration(milliseconds: 350,),
      ),
      builder: (context){
        return StatefulBuilder(
          builder:(context,setState){
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.85,
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
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20,sigmaY: 20),
                      ),
                    ),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                            ),
                            _glassAvatar('',user.fullname , ResponsiveClass(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width)),
                            Text(
                              "Name",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const Divider(color: Colors.white12, thickness: 0.4),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Enter your name",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              "Bio",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const Divider(color: Colors.white12, thickness: 0.4),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Enter your bio",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              "Location",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const Divider(color: Colors.white12, thickness: 0.4),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: "Enter your location",
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            AutoSizeText(
                              "What's your gender?",
                              maxLines: 2,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const Divider(color: Colors.white12, thickness: 0.4),
                            const SizedBox(height:10),
                            RadioListTile<String>(
                              title:  Text("Male",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              value: "male",
                              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Colors.green; // Color when selected
                                }
                                return Colors.white; // Color when NOT selected (the outer circle)
                              }),
                              groupValue: gender,
                              tileColor: Colors.grey.shade200,
                              onChanged: (value) => setState(() => gender = value),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            RadioListTile<String>(
                              title:  Text("Female",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                              value: "female",
                              enabled: true,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tileColor: Colors.grey.shade200,
                              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Colors.blue; // Color when selected
                                }
                                return Colors.white; // Color when NOT selected (the outer circle)
                              }),
                              hoverColor: Colors.white,
                              groupValue: gender,
                              onChanged: (value) => setState(() => gender = value),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            RadioListTile<String>(
                              title:  Text("Other",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                              value: "other",

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              tileColor: Colors.grey.shade200,
                              fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Colors.pink; // Color when selected
                                }
                                return Colors.white; // Color when NOT selected (the outer circle)
                              }),
                              groupValue: gender,
                              onChanged: (value) => setState(() => gender = value),
                            ),


                            CustomElevatedButton(
                              buttonText: "Save",
                              onPressed: () {
                                if (gender != null) {
                                  AuthController().updateUserProfile(
                                      fullname: nameController.text,
                                      bio: bioController.text,
                                      phone: phoneController.text,
                                      location: locationController.text,
                                      gender: gender!,
                                      ref: ref,
                                      context: context
                                  );
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
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
  );
}
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
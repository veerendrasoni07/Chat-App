import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/controller/group_controller.dart';
import 'package:chatapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import 'package:google_fonts/google_fonts.dart';


Future<void> newGroupModalSheet(BuildContext context, TextEditingController controller,List<User> users,WidgetRef ref) async {
  List<User> selectedUsers = [];
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // we'll handle the design manually
    enableDrag: true,
    sheetAnimationStyle: const AnimationStyle(
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1,)
    ),
    builder: (_) {
      final mediaQuery = MediaQuery.of(context);

      return StatefulBuilder(
        builder:(context,setState){
          return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(), // close keyboard when tapping outside
          child: Container(
            height: mediaQuery.size.height * 0.85, // 85% height like Snapchat’s “Create Group” sheet
            decoration: const BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 20,
                    bottom: mediaQuery.viewInsets.bottom + 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Handle bar
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      // Title
                      Center(
                        child: Text(
                          "Create New Group",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input Field
                      TextField(
                        controller: controller,
                        cursorColor: Colors.green,
                        style: GoogleFonts.montserrat(fontSize: 16.sp,color: Theme.of(context).colorScheme.primary),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                          prefixIcon:  Icon(Icons.group, color: Theme.of(context).colorScheme.primary,),
                          hintText: "Enter group name",
                          hintStyle: GoogleFonts.montserrat(color:Theme.of(context).colorScheme.primary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none
                          ),
                        ),
                      ),

                      AutoSizeText('To:',style: GoogleFonts.montserrat(fontSize: 16.sp,color: Theme.of(context).colorScheme.primary),),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: List.generate(selectedUsers.length, (index) {
                          return Chip(
                            color: WidgetStateProperty.all( Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2)),
                            label: Text(selectedUsers[index].fullname,style: GoogleFonts.montserrat(fontSize: 14.sp,color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w700)),
                            deleteIcon: const Icon(Icons.cancel),
                            onDeleted: ()=> setState(() {
                              selectedUsers.remove(selectedUsers[index]);
                            }), // use onDeleted instead of deleteIcon button
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // Member list
                      Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final user = users[index];
                            final isSelected = selectedUsers.contains(user);
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: ClipOval(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaY: 10,sigmaX: 10),
                                  child: Container(
                                    height: 40.h,
                                    width: 40.w,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.25),
                                        width: 1.2,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: AutoSizeText(
                                        users[index].fullname[0],
                                        style:  TextStyle(color:Theme.of(context).colorScheme.primary,fontSize: 16.sp),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                users[index].fullname,
                                style: GoogleFonts.montserrat(fontSize: 14, color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w700),
                              ),
                              trailing: selectedUsers.contains(users[index]) ?  Icon(Icons.check_circle,color: Colors.green,) : IconButton(
                                icon:  Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.primary,),
                                onPressed: () {
                                  setState((){
                                    if (isSelected) {
                                      selectedUsers.remove(user);
                                    } else {
                                      selectedUsers.add(user);
                                    }
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),

                      // Create button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async{
                            GroupController().createNewGroup(groupName: controller.text, members: selectedUsers,context: context);
                          },
                          child: Text(
                            "Create Group",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
    }
      );
    },
  );
}

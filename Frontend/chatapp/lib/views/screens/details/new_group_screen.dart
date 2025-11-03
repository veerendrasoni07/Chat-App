import 'dart:ui';
import 'package:chatapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> newGroupModalSheet(BuildContext context, TextEditingController controller,List<User> users) async {
  List<User> selectedUsers = [];
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // we'll handle the design manually
    enableDrag: true,
    sheetAnimationStyle: AnimationStyle(
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
                    color: Colors.white.withOpacity(0.9),
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
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Input Field
                      TextField(
                        controller: controller,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: const Icon(Icons.group, color: Colors.black54),
                          hintText: "Enter group name",
                          hintStyle: GoogleFonts.montserrat(color: Colors.grey[600]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black, width: 1.2),
                          ),
                        ),
                      ),

                      Text('To:'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: List.generate(selectedUsers.length, (index) {
                          return Chip(
                            label: Text(selectedUsers[index].fullname),
                            deleteIcon: Icon(Icons.cancel),
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
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey[300],
                                child: Text(
                                  users[index].fullname[0],
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ),
                              title: Text(
                                users[index].fullname,
                                style: GoogleFonts.montserrat(fontSize: 14, color: Colors.black87),
                              ),
                              trailing: selectedUsers.contains(users[index]) ?  Icon(Icons.check_circle,color: Colors.green,) : IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.black54),
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
                          onPressed: () {
                            Navigator.pop(context);
                            // Handle creation
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

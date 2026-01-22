import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/componentss/elevated_button.dart';
import 'package:chatapp/componentss/responsive.dart';
import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/localDB/model/user_isar.dart';
import 'package:chatapp/provider/auth_manager_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountScreen extends ConsumerStatefulWidget {
  final String backgroundType;
  final UserIsar user;
  const AccountScreen({super.key, required this.backgroundType,required this.user});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> with TickerProviderStateMixin{
  double _rotateX = 0;
  double _rotateY = 0;
  double _scale = 1;

  double _nx = 0;
  double _ny = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String? gender;
  // ---- Premium Gradient Based On Type ----
  List<Color> _background(String type) {
    switch (type) {
      case 'coder':
        return [
          const Color(0xFF0F2027),
          const Color(0xFF203A43),
          const Color(0xFF2C5364)
        ];
      case 'creator':
        return [
          const Color(0xFF3A0CA3),
          const Color(0xFF7209B7),
          const Color(0xFFF72585)
        ];
      default:
        return [
          const Color(0xFF450072),
          const Color(0xFF270249),
          const Color(0xFF1F0033)
        ];
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    bioController.dispose();
    phoneController.dispose();
    locationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final userId = ref.watch(userProvider)?.id == null ? "" : ref.watch(userProvider)!.id;
    final isMe = widget.user.userId == userId;
    return Scaffold(
      body: Stack(
        children: [
          // ---------- Premium Background ----------
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _background(widget.backgroundType),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context,constraint){
                  final size = ResponsiveClass(constraint.maxHeight, constraint.maxWidth);
                  return  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () =>Navigator.pop(context),
                            icon: Icon(Icons.arrow_back_ios_new, size: size.wp(6),color:primary),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon:  Icon(Icons.qr_code_2, size: size.wp(6),color:primary)),
                              IconButton(
                                  onPressed: () =>{},
                                  icon: Icon(Icons.more_vert, size: size.wp(6),color:primary)),
                            ],
                          ),
                        ],
                      ),
                      _buildHeader(widget.user,size,isMe),
                      SizedBox(height: size.hp(8)),
                      _interactiveTiltCard(),
                      SizedBox(height: size.hp(10)),
                      _buildSettingsList(context,ref,size,isMe,widget.user,gender,nameController,bioController,phoneController,locationController),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader(UserIsar user,ResponsiveClass size,bool isMe) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.wp(3)),
      child: Row(
        children: [
          glassAvatar(user.profilePic,user.fullname,size),
          SizedBox(width: size.wp(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullname,
                    style: GoogleFonts.poppins(
                        fontSize: size.font(28),
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                SizedBox(height: size.hp(1)),
                Text(user.email,
                    style: GoogleFonts.poppins(
                        fontSize:size.font(16), color: Colors.white70)),
                SizedBox(height: size.hp(5)),
                Row(
                  children: [
                    isMe ? _iosButton("Edit Profile",size,()async{
                      return await editProfileBottomSheet(context, user, ref, nameController, bioController, phoneController, locationController);
                    }) : _iosButton("Following",size,(){}),
                    SizedBox(width: size.wp(5)),
                    isMe ?const SizedBox() : _iosButton("Message",size,(){}),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _iosButton(String text,ResponsiveClass size,VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: size.wp(2), vertical: size.hp(2)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.wp(4)),
            color: Colors.white.withOpacity(0.12),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
              fontSize: size.font(18), color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }



  Widget _interactiveTiltCard() {
    return Listener(
      onPointerUp: (_) => setState(() {
        _rotateX = 0;
        _rotateY = 0;
        _scale = 1;
      }),
      onPointerMove: (value) {
        final size = MediaQuery.of(context).size.width * 0.8;
        final center = size / 2;
        final dx = value.localPosition.dx - center;
        final dy = value.localPosition.dy - center;

        _nx = dx / center;
        _ny = dy / center;

        setState(() {
          _rotateY = _nx * 0.18;
          _rotateX = -_ny * 0.18;
          _scale = 1.06;
        });
      },
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 1, end: _scale),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        builder: (context, s, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_rotateX)
              ..rotateY(_rotateY)
              ..scale(s),
            child: child,
          );
        },
        child: _glassStatsCard(),
      ),
    );
  }


  Widget _glassStatsCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withOpacity(0.2)),

        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.10),
            Colors.white.withOpacity(0.04)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            //Frosted Blur
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: const SizedBox(),
              ),
            ),

            // Shine layer
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(_nx, _ny),
                    radius: 1.1,
                    colors: [
                      Colors.white.withOpacity(0.18),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),

            _buildStatsContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsContent() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statColumn("1.8K", "Messages"),
              _statColumn("36", "Contacts"),
              _statColumn("412", "Media"),
              _statColumn("2 yrs", "Joined"),
            ],
          ),
          Divider(
            color: Colors.white.withOpacity(0.2),
            thickness: 1,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.user.bio.isNotEmpty == true
                  ? widget.user.bio
                  : "Available",
              style: GoogleFonts.poppins(
                  fontSize: 15, color: Colors.white70),
            ),
          )
        ],
      ),
    );
  }


  Widget _statColumn(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 3),
        Text(label,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
      ],
    );
  }
}
Widget _buildSettingsList(context,WidgetRef ref,ResponsiveClass size,bool isMe,UserIsar user,String? gender,TextEditingController nameController,TextEditingController bioController,TextEditingController phoneController,TextEditingController locationController) {
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: size.wp(2.5)),
    child: Column(
      children: [

         if(isMe)
           _settingsTile(
               Icons.person, "Edit Profile",
                   ()async{
                 return await  showModalBottomSheet(
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
                             return Container(
                               decoration: const BoxDecoration(
                                 gradient: LinearGradient(
                                     begin: Alignment.topLeft,
                                     end: Alignment.bottomRight,
                                     colors: [
                                       Color(0xFF450072),
                                       Color(0xFF270249),
                                       Color(0xFF000148),
                                       Color(0xFF000818),
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
                                           glassAvatar(user.profilePic,user.fullname , ResponsiveClass(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width)),
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
                                           SizedBox(height: MediaQuery.of(context).size.height * 0.05),

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
                             );
                           }
                       );
                     }
                 );
               },
               size
           ),
        _settingsTile(Icons.lock, "Privacy", () {},size),
        _settingsTile(Icons.image, "Media & Storage", () {},size),
        _settingsTile(Icons.block, "Blocked Users", () {},size),
        if(isMe)
          _settingsTile(Icons.logout, "Logout", () {
            ref.read(authManagerProvider.notifier).logout(context: context);
          },size),
      ],
    ),
  );
}

Widget _settingsTile(IconData icon, String title, VoidCallback onTap,ResponsiveClass size) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin:  EdgeInsets.only(bottom: size.wp(3)),
      padding:  EdgeInsets.symmetric(horizontal: size.wp(6), vertical: size.hp(4)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size.wp(4)),
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: size.wp(6)),
          SizedBox(width: size.wp(3)),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: size.font(18),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded,
              color: Colors.white.withOpacity(0.4), size: size.wp(3)),
        ],
      ),
    ),
  );
}
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
                  height: MediaQuery.of(context).size.height ,
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
                  child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 20,
                        sigmaY: 20
                      ),
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                        left: 24,
                        right: 24,
                        top: 20,
                    ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(child: glassAvatar('',user.fullname , ResponsiveClass(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width))),
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
                                          controller: nameController,
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
                                          controller: bioController,
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
                                          controller: locationController,
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
                                      ],
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.06,
                                    ),
                                    BottomSheet(
                                        onClosing: (){}, builder: (context){
                                      return Padding(
                                        padding:  EdgeInsets.symmetric(vertical:MediaQuery.of(context).viewInsets.bottom + 16,horizontal: 16.0),
                                        child: CustomElevatedButton(
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
                                                      content: Text("Please select your gender")
                                                  )
                                              );
                                            }
                                          },
                                        ),
                                      );
                                    })


                                  ],
                                ),
                      ),
                    )
                  ),

                ),
              );
            }
        );
      }
  );
}

Widget glassAvatar(String profilePic,String text,ResponsiveClass size) {
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
  );
}

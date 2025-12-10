import 'dart:ui';
import 'package:chatapp/controller/group_controller.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/views/screens/details/account_screen.dart';
import 'package:chatapp/views/screens/details/chat_screen.dart';
import 'package:chatapp/views/screens/details/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../provider/userProvider.dart';

class GroupScreen extends ConsumerStatefulWidget {
  final List<User> groupMembers;
  final List<User> groupAdmin;
  final String groupName;
  final String proPic;
  const GroupScreen({super.key, required this.groupMembers,required this.groupAdmin,required this.proPic,required this.groupName});

  @override
  ConsumerState<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen> {
  final GroupController _groupController = GroupController();

 

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(


        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF450072),
                    const Color(0xFF270249),
                    const Color(0xFF1F0033)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  _header(context, primary),
                  Center(child: _avatar(context, widget.proPic, widget.groupName,80.r)),
                  Center(child: Text(widget.groupName,style: _titleStyle(context,25.sp),),),
                  const SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Group Admins",style: _titleStyle(context,18.sp),),
                  ),
                  ListView.builder(
                    padding: const EdgeInsets.all(16),
                      itemCount: widget.groupAdmin.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        final admin = widget.groupAdmin[index];
                        return personTile(context, admin,user!);
                      }
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("Group Members",style: _titleStyle(context,18.sp),),
                  ),
                  ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: widget.groupMembers.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        final members =widget.groupMembers[index];
                        return personTile(context, members,user!);
                      }
                  )
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget personTile(BuildContext context, User a,User user) {
    return GestureDetector(
      onTap: () {
        if(user.id != a.id){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AccountScreen(user: a, backgroundType: '',),
            ),
          );
        }
      },
      child: _glassTile(
        context: context,
        child: Row(
          children: [
            GestureDetector(onTap: (){
              if(user.id != a.id){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AccountScreen(user: a, backgroundType: '',),
                  ),
                );
              }
            },child: _avatar(context, a.profilePic, a.fullname,26.r)),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.id == a.id ? "You" :  a.fullname,
                    style: _titleStyle(context,18.sp),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "@${a.username}",
                    style: _subtitleStyle(context),
                  ),
                ],
              ),
            ),
            if(user.id != a.id)
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>  ChatScreen(
                        fullname: a.fullname,
                        receiverId: a.id,
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.dehaze_rounded),
                color: Theme.of(context).colorScheme.primary,
              ),

          ],
        ),
      ),
    );
  }

  Widget _avatar(BuildContext context, String pic, String name,double size) {
    return CircleAvatar(
      radius: size,
      backgroundColor:
      Theme.of(context).colorScheme.primary.withOpacity(0.15),
      backgroundImage: pic.isNotEmpty ? NetworkImage(pic) : null,
      child: pic.isEmpty
          ? Text(
        name[0].toUpperCase(),
        style: _titleStyle(context,18.sp),
      )
          : null,
    );
  }

  TextStyle _titleStyle(BuildContext context,double size) {
    return TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w600,
      fontSize: size,
    );
  }

  TextStyle _subtitleStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
      fontSize: 13,
    );
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Text(
          "No notifications",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}




  Widget _button(
      BuildContext ctx, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.6)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


Widget _glassTile({required BuildContext context, required Widget child}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.06),
      border: Border.all(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
      ),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    ),
  );
}
Widget _header(BuildContext context, Color primary) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, size: 28, color: primary),
        ),
        Text(
          "Notification",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox()
      ],
    ),
  );
}
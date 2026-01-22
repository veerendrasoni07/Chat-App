import 'dart:ui';
import 'package:chatapp/controller/group_controller.dart';
import 'package:chatapp/localDB/model/user_isar.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/group_controller_provider.dart';
import 'package:chatapp/views/screens/details/account_screen.dart';
import 'package:chatapp/views/screens/details/chat_screen.dart';
import 'package:chatapp/views/screens/details/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../provider/userProvider.dart';

class GroupScreen extends ConsumerStatefulWidget {
  final String groupId;
  final List<UserIsar> groupMembers;
  final List<UserIsar> groupAdmin;
  final String groupName;
  final String proPic;
  const GroupScreen({super.key,required this.groupId, required this.groupMembers,required this.groupAdmin,required this.proPic,required this.groupName});

  @override
  ConsumerState<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends ConsumerState<GroupScreen> {
  final GroupController _groupController = GroupController();






 

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final primary = Theme.of(context).colorScheme.primary;
    final groupRepo = ref.read(groupRepoProvider);

    return Scaffold(


        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                     Color(0xFF450072),
                     Color(0xFF270249),
                     Color(0xFF1F0033)
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
                      final a = widget.groupAdmin[index];
                        return personTile(context, a, user!);
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
                        final member = widget.groupMembers[index];
                        return Slidable(
                          key: const ValueKey(0),
                          endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                    onPressed: (context){
                                      showDialog(
                                          context: context,
                                          builder: (_){
                                            return AlertDialog(
                                              title: const Text("Are you sure?"),
                                              content: const Text("Do you want to remove this member?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: (){
                                                  Navigator.pop(_);
                                                  },
                                                  style: const ButtonStyle(
                                                    backgroundColor: WidgetStatePropertyAll(Colors.black)
                                                  ),
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: ()async{
                                                    await groupRepo.removeMembersFromTheGroup([member.userId], widget.groupId, context,ref);
                                                    Navigator.pop(_);
                                                  },
                                                  style: const ButtonStyle(
                                                    backgroundColor: WidgetStatePropertyAll(Colors.red)
                                                  ),
                                                  child: const Text("Remove"),
                                                )
                                              ],

                                            );
                                          }
                                      );
                                    },
                                  flex: 1,
                                    icon: Icons.delete,
                                    backgroundColor: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ]
                          ),
                            child: personTile(context, widget.groupMembers[index], user!)
                        );

                      }
                  )
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget personTile(BuildContext context, UserIsar a,User user) {
    return GestureDetector(
      onTap: () {
        if(user.id != a.id){
          Get.to(
                ()=> AccountScreen(user: a, backgroundType: '',),
            transition: Transition.fadeIn,
            duration:const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
          );
        }
      },
      child: _glassTile(
        context: context,
        child: Row(
          children: [
            GestureDetector(onTap: (){
              if(user.id != a.id){
                Get.to(
                      ()=> AccountScreen(user: a, backgroundType: '',),
                  transition: Transition.fadeIn,
                  duration:const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                );
              }
            },child: _avatar(context, a.profilePic, a.fullname,26.r)),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.id == a.userId ? "You" :  a.fullname,
                    style: _titleStyle(context,18.sp),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "@${a.email}",
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
                        receiverId: a.userId,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                color: Theme.of(context).colorScheme.primary,
              ),

          ],
        ),
      ),
    );
  }

  Widget _avatar(BuildContext context, String pic, String name,double size) {
    return Hero(
      tag: name,
      child: CircleAvatar(
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
      ),
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
          "Group",
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.1),
      ],
    ),
  );
}
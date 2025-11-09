import 'dart:ui';

import 'package:chatapp/controller/message_controller.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/group_provider.dart';
import 'package:chatapp/provider/messageProvider.dart';
import 'package:chatapp/provider/online_status_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/views/screens/details/add_friend_screen.dart';
import 'package:chatapp/views/screens/details/chat_screen.dart';
import 'package:chatapp/views/screens/details/group_chat_screen.dart';
import 'package:chatapp/views/screens/details/new_group_screen.dart';
import 'package:chatapp/views/screens/details/profile_screen.dart';
import 'package:chatapp/views/screens/details/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  late Future<List<User>> futureUsers;
  List<User> users = [];
  final TextEditingController newGroupController = TextEditingController();
  final MessageController controller = MessageController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final currentUser = ref.read(userProvider);
    if (currentUser != null) {
      futureUsers = controller.getUsers(userId: currentUser.id);
      users = await futureUsers;
    }
  }

  void showSnapchatStyleMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 400),
      ),
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                _buildMenuItem(Icons.chat_bubble, "New Chat", () {
                  Navigator.pop(context);
                }),
                _buildMenuItem(Icons.group, "New Group", () {
                  newGroupModalSheet(context, newGroupController, users, ref);
                }),
                _buildMenuItem(Icons.person_add_alt_1, "Add Friend", () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AddFriendScreen()),
                  );
                }),
                _buildMenuItem(Icons.settings, "Settings", () {
                  Navigator.pop(context);
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: TextStyle(fontSize: 16.sp,color: Theme.of(context).colorScheme.primary)),
      onTap: onTap,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    newGroupController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(statusListener);
    final groups = ref.watch(groupProvider);

    print(groups);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.09,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.1),
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      "Chats",
                      style: GoogleFonts.poppins(
                        color:
                            currentIndex == 0
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate().shake(duration: Duration(seconds: 1)),
                  ),
                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: () {
                      _pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      "Groups",
                      style: GoogleFonts.poppins(
                        color:
                            currentIndex == 1
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate().shake(duration: Duration(seconds: 1)),
                  ),
                ],
              ),
              centerTitle: true,
              leadingWidth: MediaQuery.of(context).size.width * 0.3,
              leading: FittedBox(
                child: Row(
                  children: [
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProfileScreen()),
                        );
                      },
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            height: 40.r,
                            width: 40.r,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              // translucent glass tone
                              border: Border.all(
                                color: Colors.white.withOpacity(0.25),
                                width: 1.2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              ref.read(userProvider)?.fullname[0] ?? '',
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          height: 40.r,
                          width: 40.r,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            // translucent glass tone
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 1.2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Hero(
                              tag: "search_animation",
                              child: Icon(
                                Icons.search_rounded,
                                size: 20.r,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SearchScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 20, sigmaX: 20),
                    child: Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        // translucent glass tone
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1.2,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.more_vert,
                          size: 18.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => showSnapchatStyleMenu(context),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
              ],
            ),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => currentIndex = index),
        children: [
          // ✅ Chats Page
          FutureBuilder<List<User>>(
            future: futureUsers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No users available'));
              }

              final users = snapshot.data!;
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: users.length,

                itemBuilder: (context, index) {
                  final user = users[index];
                  final userStatus = status[user.id];
                  final message = ref.watch(messageProvider(user.id));
                  final unreadCount = message
                      .where((m) => m.senderId == user.id && m.status != 'seen')
                      .length;

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0.h,
                      horizontal: 10.0.w,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: ListTile(
                            style: ListTileStyle.drawer,
                            leading: ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 20,
                                  sigmaY: 20,
                                ),
                                child: Container(
                                  height: 40.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    // translucent glass tone
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.25),
                                      width: 1.2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      user.fullname[0],
                                      style: GoogleFonts.openSans(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            title: Text(
                              user.fullname,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 18.sp,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            trailing: Column(
                              children: [

                              ],
                            ),
                            subtitle: unreadCount!=0 ? Text("${unreadCount} New Messages",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.blueAccent.shade400)) : null,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => ChatScreen(
                                        receiverId: user.id,
                                        fullname: user.fullname,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),

          // ✅ Groups Page (placeholder)
          RefreshIndicator(
            onRefresh: () async {},
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: groups.length,

              itemBuilder: (context, index) {
                final group = groups[index];

                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 4.0.h,
                    horizontal: 10.0.w,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                        ),
                        child: ListTile(
                          style: ListTileStyle.drawer,
                          leading: ClipOval(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 20,
                                sigmaY: 20,
                              ),
                              child: Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  // translucent glass tone
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                    width: 1.2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    group.groupName[0],
                                    style: GoogleFonts.openSans(
                                      color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          title: Text(
                            group.groupName,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.sp,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          onTap: () {
                            print("Group Id : ${group.groupId}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => GroupChatScreen(fullname: group.groupName, groupId: group.groupId)
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

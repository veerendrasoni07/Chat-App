import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/controller/friend_controller.dart';
import 'package:chatapp/models/user_status.dart';
import 'package:chatapp/provider/combined_chat_provider.dart';
import 'package:chatapp/provider/friends_provider.dart';
import 'package:chatapp/views/screens/details/new_group_screen.dart';
import 'package:chatapp/views/screens/details/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/provider/online_status_provider.dart';
import 'package:chatapp/views/screens/details/chat_screen.dart';
import 'package:chatapp/views/screens/details/group_chat_screen.dart';
import 'package:chatapp/views/screens/details/add_friend_screen.dart';
import 'package:chatapp/views/screens/details/profile_screen.dart';

// Your unified provider

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final FriendController _friendController = FriendController();
  void fetchAllFriends(){
    _friendController.getAllFriends(ref: ref);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllFriends();
  }


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final chats = ref.watch(combinedChatProvider);
    final status = ref.watch(statusListener);

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildGlassCapsuleHeader(context, user),
            _buildFriendOrbit(context, ref, status),
            Divider(color: Colors.white12, thickness: 0.4),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 6),
                physics: BouncingScrollPhysics(),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final item = chats[index];
                  return _buildChatTile(context, item, ref);
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:_buildRadialMenu(context, ref)
    );
    
  }

  // ---------------------------- GLASS CAPSULE HEADER ----------------------------
  Widget _buildGlassCapsuleHeader(BuildContext context, user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .colorScheme
                  .inversePrimary
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: user!),
                        ),
                      ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    child: Text(
                      user?.fullname[0] ?? "?",
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .inversePrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                GestureDetector(
                  onTap: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddFriendScreen(),
                        ),
                      ),
                  child: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    child: Icon(Icons.search_rounded,color: Theme.of(context).colorScheme.inversePrimary,)
                  ),
                ),

                Spacer(),

                Text(
                  "Orbit",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .inversePrimary,
                  ),
                ),

                Spacer(),

                IconButton(
                  icon: Icon(Icons.notifications, color: Theme
                      .of(context)
                      .colorScheme
                      .inversePrimary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NotificationScreen()),
                    );
                  },
                ),

                Icon(Icons.menu, color: Theme
                    .of(context)
                    .colorScheme
                    .inversePrimary),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------- FRIEND ORBIT ----------------------------
  Widget _buildFriendOrbit(BuildContext context, WidgetRef ref,
      Map<String, UserStatus> status) {
    final friends = ref.watch(friendsProvider);

    return friends.isEmpty ? SizedBox() : SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final f = friends[index];
          final isOnline = status[f.id] == true;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: (){
                        final friends = ref.read(friendsProvider);
                        final friend = friends.firstWhere(
                              (u) => u.id == f.id
                        );
                        if (friend == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FutureBuilder(
                                future: FriendController().getUserById(userId: f.id),
                                builder: (context, snap) {
                                  if (!snap.hasData) {
                                    return Scaffold(
                                      body: Center(child: CircularProgressIndicator()),
                                    );
                                  }
                                  return ProfileScreen(user: snap.data!);
                                },
                              ),
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(user: friend),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor:  Theme
                            .of(context)
                            .colorScheme
                            .inversePrimary.withOpacity(0.15),
                        child: Text(
                          f.fullname[0],
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme
                                .of(context)
                                .colorScheme
                                .inversePrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          height: 14,
                          width: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                AutoSizeText(
                  f.fullname.split(" ").first,
                  style: GoogleFonts.poppins(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .inversePrimary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.8
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ---------------------------- CHAT TILE ----------------------------
  Widget _buildChatTile(BuildContext context, dynamic item, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .colorScheme
                  .inversePrimary
                  .withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: ListTile(
              leading: GestureDetector(
                onTap: () {
                  final friends = ref.read(friendsProvider);
                  final friend = friends.firstWhere(
                        (u) => u.id == item.id,
                  );

                  if (friend == null) {
                    // fallback → fetch from server
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FutureBuilder(
                          future: FriendController().getUserById(userId: item.id),
                          builder: (context, snap) {
                            if (!snap.hasData) {
                              return Scaffold(
                                body: Center(child: CircularProgressIndicator()),
                              );
                            }
                            return ProfileScreen(user: snap.data!);
                          },
                        ),
                      ),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(user: friend),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.15),
                  child: AutoSizeText(
                    item.name[0],
                    style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              title: AutoSizeText(
                item.name,
                style: GoogleFonts.poppins(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .inversePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                  letterSpacing: 1.8
                ),
              ),
              subtitle: item.unreadCount > 0
                  ? Text(
                "${item.unreadCount} new messages",
                style: TextStyle(color: Colors.blueAccent),
              )
                  : null,
              onTap: () {
                if (item.isGroup) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          GroupChatScreen(
                            fullname: item.name,
                            groupId: item.id,
                          ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ChatScreen(
                            receiverId: item.id,
                            fullname: item.name,
                          ),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
Widget _buildRadialMenu(BuildContext context, WidgetRef ref) {
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.10),
    child: FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.25),
      child: Icon(Icons.add, color: Theme.of(context).colorScheme.inversePrimary),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildRadialOptions(context, ref),
              ],
            );
          },
        );
      },
    ),
  );
}

Widget _buildRadialOptions(BuildContext context, WidgetRef ref) {
  final friends = ref.watch(friendsProvider);
  final controller = TextEditingController();
  final users = friends;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
    decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inversePrimary,
        borderRadius: BorderRadius.circular(20)
    ),
    child: Wrap(
      children: [
        _radialItem(context, Icons.chat_bubble, "New Chat", () {}),
        SizedBox(width: 10,),
        _radialItem(context, Icons.group, "New Group", () => newGroupModalSheet(context, controller, users, ref)
        ),
        SizedBox(width: 10,),
        _radialItem(context, Icons.person_add, "Add Friend", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddFriendScreen()),
          );
        }),
      ],
    ),
  );
}

Widget _radialItem(
    BuildContext context, IconData icon, String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ],
    ),
  );
}

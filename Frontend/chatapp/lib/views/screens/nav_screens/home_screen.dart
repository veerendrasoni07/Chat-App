import 'dart:ui';

import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/controller/message_controller.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/online_status_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/views/screens/details/add_friend_screen.dart';
import 'package:chatapp/views/screens/details/chat_screen.dart';
import 'package:chatapp/views/screens/details/new_group_screen.dart';
import 'package:chatapp/views/screens/details/profile_screen.dart';
import 'package:chatapp/views/screens/details/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<User>> futureUsers;
  List<User> users = [];
  TextEditingController newGroupController = TextEditingController();
  final AuthController authController = AuthController();
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
      setState(() {}); // Trigger FutureBuilder
    }
  }

  void showSnapchatStyleMenu(BuildContext context) async{
    showModalBottomSheet(
      context: context,

      isScrollControlled: true, // makes it full-screen if needed
      backgroundColor: Colors.transparent, // we’ll make our own background
      sheetAnimationStyle: AnimationStyle(
        curve: Curves.fastEaseInToSlowEaseOut,
        duration: const Duration(seconds: 1),
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child:
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // blurred background
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width*0.06,
                        height: MediaQuery.of(context).size.height * 0.004,
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      ListTile(
                        leading: const Icon(Icons.chat_bubble, color: Colors.black87),
                        title: const Text('New Chat'),
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to profile
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.group, color: Colors.black87),
                        title: const Text('New Group'),
                        onTap: () {
                          newGroupModalSheet(context, newGroupController,users);
                          // Navigate to add friend
                        },
                      ),

                      ListTile(
                        leading: const Icon(Icons.person_add_alt_1, color: Colors.black87),
                        title: const Text('Add Friend'),
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to settings
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.app_shortcut_rounded, color: Colors.black87),
                        title: const Text('Shortcut'),
                        onTap: () {
                          Navigator.pop(context);
                          // Navigate to settings
                        },
                      ),
                      const SizedBox(height: 10),

                    ],
                  ),
                ),
              ),


        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the statusListener here to rebuild the whole list when any status changes
    final status = ref.watch(statusListener);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Chats',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,

        // LEFT SIDE (leading)
        leadingWidth: 100,
        leading: Row(
          children: [
            const SizedBox(width: 10),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen()));
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Center(
                  child: Text(
                    ref.read(userProvider)?.fullname[0] ?? '',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.search, size: 18, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_)=>SearchScreen()));
                },
              ),
            ),
          ],
        ),

        // RIGHT SIDE (actions)
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.person_add_alt_1,
                size: 18,
                color: Colors.white,
              ),
              onPressed: () {
                // Add friend action
                Navigator.push(context, MaterialPageRoute(builder: (_)=>AddFriendScreen()));
              },
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.settings, size: 18, color: Colors.white),
              onPressed: () {
                // Settings action
                showSnapchatStyleMenu(context);
              },
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: FutureBuilder<List<User>>(
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

          return Column(
            children: [
              Divider(
                height: 1,
                color: Color.fromARGB(255, 226, 226, 226),
                thickness: 1,
              ),
              Expanded(
                child: ListView.separated(
                  key: PageStorageKey('user_list'),
                  itemCount: users.length,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder:
                      (context, index) => const Divider(
                        height: 1,
                        color: Color.fromARGB(255, 226, 226, 226),
                        thickness: 1,
                      ),
                  itemBuilder: (context, index) {
                    final user = users[index];

                    // Get the current online status from statusListener
                    final userStatus = status[user.id];
                    final online = userStatus?.isOnline ?? false;
                    final lastSeen = userStatus?.lastSeen;

                    return ClipRRect(
                      borderRadius:
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ).borderRadius,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: online ? Colors.green : Colors.red,
                          child: Center(child: Text(user.fullname[0])),
                        ),
                        minVerticalPadding: 10,
                        minLeadingWidth: 10,
                        horizontalTitleGap: 2,

                        title: Text(
                          user.fullname,
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        subtitle:
                            online
                                ? const Text(
                                  "Online",
                                  style: TextStyle(color: Colors.greenAccent),
                                )
                                : lastSeen != null
                                ? Text(
                                  "Last seen: ${lastSeen.toLocal()}",
                                  style: const TextStyle(color: Colors.grey),
                                )
                                : const Text(
                                  "Offline",
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ChatScreen(
                                    receiverId: user.id,
                                    fullname: user.fullname,
                                  ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Divider(
                height: 1,
                color: Color.fromARGB(255, 226, 226, 226),
                thickness: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}

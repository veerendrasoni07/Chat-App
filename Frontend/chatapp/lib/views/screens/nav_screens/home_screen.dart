import 'dart:ui';

import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/controller/message_controller.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/online_status_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/views/screens/nav_screens/chat_screen.dart';
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
      setState(() {}); // Trigger FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the statusListener here to rebuild the whole list when any status changes
    final status = ref.watch(statusListener);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/snow_tree_background.jpg',
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FutureBuilder<List<User>>(
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
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];

                        // Get the current online status from statusListener
                        final userStatus = status[user.id];
                        final online = userStatus?.isOnline ?? false;
                        final lastSeen = userStatus?.lastSeen;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundColor: online ? Colors.green : Colors.red,
                              child: Center(child: Text(user.fullname[0])),
                            ),
                            title: Text(
                              user.fullname,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: online
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
                                  builder: (context) => ChatScreen(
                                    receiverId: user.id,
                                    fullname: user.fullname,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbit_chat_app/localDB/Mapper/mapper.dart';
import 'package:orbit_chat_app/models/user.dart';
import 'package:orbit_chat_app/models/user_status.dart';
import 'package:orbit_chat_app/provider/activity_provider.dart';
import 'package:orbit_chat_app/provider/app_start_up.dart';
import 'package:orbit_chat_app/provider/backend_sync_provider.dart';
import 'package:orbit_chat_app/provider/combined_chat_provider.dart';
import 'package:orbit_chat_app/provider/friend_controller_provider.dart';
import 'package:orbit_chat_app/provider/friend_stream_provider.dart';
import 'package:orbit_chat_app/provider/online_status_provider.dart';
import 'package:orbit_chat_app/provider/userProvider.dart';
import 'package:orbit_chat_app/views/screens/details/account_screen.dart';
import 'package:orbit_chat_app/views/screens/details/add_friend_screen.dart';
import 'package:orbit_chat_app/views/screens/details/new_group_screen.dart';
import 'package:orbit_chat_app/views/screens/details/notification_screen.dart';
import 'package:orbit_chat_app/views/screens/details/profile_screen.dart';
import 'package:orbit_chat_app/views/screens/details/setting_screen.dart';
import 'package:orbit_chat_app/views/widgets/chat_tile.dart';

// Your unified provider

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(ref.watch(appStartUpProvider)!=true){
      Future.microtask((){
        if(context.mounted){
          ref.read(backendSyncProvider).backendSync(ref: ref,context: context);
          ref.read(appStartUpProvider.notifier).appStartUp();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final friendStream = ref.watch(combinedChatStream);
    final status = ref.watch(statusListener);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.primary,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        strokeWidth: 3,
        edgeOffset: 10,
        displacement: 10,
        onRefresh: () async {
          await ref
              .read(backendSyncProvider)
              .backendSync(ref: ref, context: context);
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF450072),
                    Color(0xFF270249),
                    Color(0xFF1F0033),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    _buildGlassCapsuleHeader(context, user, ref),
                    _buildFriendOrbit(context, ref, status),
                    const Divider(color: Colors.white12, thickness: 0.4),
                    friendStream.when(
                      data: (friends) {
                        return friends.isEmpty
                            ? const Center(child: Text("NO friends"))
                            : Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemCount: friends.length,
                                  itemBuilder: (context, index) {
                                    final friend = friends[index];
                                    return ChatTile(
                                      chatId: friend.id,
                                      isGroup: friend.isGroup,
                                    );
                                  },
                                ),
                              );
                      },
                      error: (error, stackTrace) => Text(error.toString()),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: _buildRadialMenu(context, ref)
    );
  }
}

// ---------------------------- GLASS CAPSULE HEADER ----------------------------
Widget _buildGlassCapsuleHeader(
  BuildContext context,
  User user,
  WidgetRef ref,
) {
  final activities = ref.watch(activityProvider);
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
    child: Container(
      width: MediaQuery.of(context).size.width * 0.95,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.10),
            Colors.white.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 40, sigmaX: 40),
              ),
            ),
            Row(
              children: [
                /// ------------------------ PROFILE BUTTON (iOS GLASS) ------------------------
                GestureDetector(
                  onTap: () => Get.to(
                    () => AccountScreen(
                      backgroundType: "artist",
                      user: mapUserToIsar(user),
                    ),
                    transition: Transition.leftToRightWithFade,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  ),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.1,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.16),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Center(
                          child: AutoSizeText(
                            user.fullname[0],
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              height: 1,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                /// ------------------------ SEARCH BUTTON (iOS GLASS) ------------------------
                GestureDetector(
                  onTap: () => Get.to(
                    () => const AddFriendScreen(),
                    transition: Transition.leftToRightWithFade,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  ),

                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.1,
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.16),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Icon(
                          Icons.search_rounded,
                          size: 24,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                    ),
                  ),
                ),

                Spacer(),

                /// ------------------------ TITLE ------------------------
                Text(
                  "Orbit",
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),

                Spacer(),

                /// ------------------------ NOTIFICATION BUTTON (GLASS) ------------------------
                Stack(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1.1,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.16),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                      ),
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite_border_outlined,
                              size: 22,
                              color: Colors.white.withOpacity(0.95),
                            ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () => Get.to(
                              () => const NotificationScreen(),
                              transition: Transition.native,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (activities.isNotEmpty)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(width: 8),

                /// ------------------------ MENU BUTTON (GLASS) ------------------------
                GestureDetector(
                  onTap: () => Get.to(
                    () => SettingsScreen(user: user),
                    transition: Transition.native,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  ),
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.16),
                          Colors.white.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Icon(
                          Icons.menu,
                          size: 24,
                          color: Colors.white.withOpacity(0.95),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

// ---------------------------- FRIEND ORBIT ----------------------------
Widget _buildFriendOrbit(
  BuildContext context,
  WidgetRef ref,
  Map<String, UserStatus> status,
) {
  final friends = ref.watch(friendStreamProvider);
  return friends.when(
    data: (friends) {
      return friends.isEmpty
          ? SizedBox()
          : SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  final f = friends[index];
                  final isOnline = status[f.userId]?.isOnline == true;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                final friend = friends.firstWhere(
                                  (u) => u.userId == f.userId,
                                );
                                Get.to(()=> AccountScreen(
                                  backgroundType: '',
                                  user: friend,
                                ),transition: Transition.cupertinoDialog,duration: const Duration(milliseconds: 400),curve: Curves.easeInOut,);
                              },
                              child: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.25),
                                  ),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.16),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                  ),
                                ),
                                child: ClipOval(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 20,
                                      sigmaY: 20,
                                    ),
                                    child: Center(
                                      child: Text(
                                        f.fullname.isEmpty ? "?" : f.fullname[0],
                                        style: GoogleFonts.poppins(
                                          fontSize: 14.sp,
                                          height: 1,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
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
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        AutoSizeText(
                          f.fullname.split(" ").first,
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.8,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
    },
    error: (error, stackTrace) => Text(error.toString()),
    loading: () => const Center(child: CircularProgressIndicator()),
  );
}

Widget _buildRadialMenu(BuildContext context, WidgetRef ref) {
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.10),
    child: FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.25),
      child: Icon(Icons.add, color: Theme.of(context).colorScheme.primary),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [_buildRadialOptions(context, ref)],
            );
          },
        );
      },
    ),
  );
}

Widget _buildRadialOptions(BuildContext context, WidgetRef ref) {
  final friends = ref.watch(friendStreamProvider);
  final controller = TextEditingController();
  final users = friends;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.45),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Wrap(
      children: [
        _radialItem(context, Icons.chat_bubble, "New Chat", () {}),
        const SizedBox(width: 10),
        _radialItem(
          context,
          Icons.group,
          "New Group",
          () => newGroupModalSheet(context, controller, users.value!, ref),
        ),
        const SizedBox(width: 10),
        _radialItem(context, Icons.person_add, "Add Friend", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddFriendScreen()),
          );
        }),
      ],
    ),
  );
}

Widget _radialItem(
  BuildContext context,
  IconData icon,
  String label,
  VoidCallback onTap,
) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.15),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ],
    ),
  );
}

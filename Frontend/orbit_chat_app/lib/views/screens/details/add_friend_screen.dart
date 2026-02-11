import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orbit_chat_app/componentss/responsive.dart';
import 'package:orbit_chat_app/localDB/Mapper/mapper.dart';
import 'package:orbit_chat_app/localDB/model/user_isar.dart';
import 'package:orbit_chat_app/models/interaction.dart';
import 'package:orbit_chat_app/models/user.dart';
import 'package:orbit_chat_app/provider/friend_controller_provider.dart';
import 'package:orbit_chat_app/provider/friend_stream_provider.dart';
import 'package:orbit_chat_app/provider/sent_request_provider.dart';
import 'package:orbit_chat_app/provider/socket_provider.dart';
import 'package:orbit_chat_app/provider/userProvider.dart';
import 'package:orbit_chat_app/views/screens/details/account_screen.dart';
import 'package:orbit_chat_app/views/screens/details/chat_screen.dart';


class AddFriendScreen extends ConsumerStatefulWidget {
  const AddFriendScreen({super.key});

  @override
  ConsumerState<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends ConsumerState<AddFriendScreen> {
  List<User> futureUserList = [];
  Timer? debounce;
  bool isLoading = false;

  void sendFriendRequest(String fromUserId, String toUserId) {
    final socket = ref.read(socketProvider);
    socket.sendRequest(fromUserId, toUserId);
  }




  void onChangeUsername(String username) {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 450), () {
      if (username.trim().isNotEmpty) {
        friendSuggestion(username);
      } else {
        setState(() => futureUserList = []);
      }
    });
  }

  Future<void> friendSuggestion(String username) async {
    final _friend = ref.read(friendRepoProvider);
    setState(() => isLoading = true);
    final users = await _friend.searchUser(username: username,ref: ref,context: context);
    setState(() {
      futureUserList = users;
      isLoading = false;
    });
  }

  Future<void> getAllRequests({required WidgetRef ref,required BuildContext context}) async {
    ref.read(sentRequestProvider.notifier).loadInitialData(context: context,ref: ref);
  }

  @override
  void initState() {
    super.initState();
    getAllRequests(context: context,ref: ref);
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final fromUser = ref.watch(userProvider);
    final friends = ref.watch(friendStreamProvider);
    final sentRequest = ref.watch(sentRequestProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
               Color(0xFF450072),
               Color(0xFF270249),
               Color(0xFF1F0033)
            ]
          )
        ),
        child:  SafeArea(
          child: LayoutBuilder(
            builder: (context,constraints){
              final size = ResponsiveClass(constraints.maxHeight,constraints.maxWidth);
              return Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    _buildHeader(context, primary,size),
                    SizedBox(height: size.hp(3)),

                    _buildSearchBar(primary,size),
                    SizedBox(height: size.hp(3)),

                    if (isLoading) _buildLoader(primary,size),

                    friends.when(
                        data: (friends){
                          return Expanded(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: futureUserList.isEmpty && !isLoading
                                  ? friends.isNotEmpty ? _buildFriendsSection(friends, primary) : _buildEmptyState(primary,size)
                                  : _buildUserList(
                                  futureUserList,
                                  sentRequest,
                                  friends,
                                  fromUser!.id,
                                  primary,
                                  size
                              ),
                            ),
                          );
                        },
                        error: (error, stackTrace) => Text(error.toString()),
                        loading: () => const Center(child: CircularProgressIndicator(),)
                    ),


                    SizedBox(height: size.hp(3)),


                  ],
                ),
              );
            },
          ),
        ),
      )
    );
  }

  // ---------------- BEAUTIFUL HEADER ----------------
  Widget _buildHeader(BuildContext context, Color primary,ResponsiveClass size) {
    return Row(
      children: [
        AutoSizeText(
          "Add Friends",
          style: GoogleFonts.poppins(
            fontSize: size.font(25),
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: primary, size: size.font(26)),
        ),
      ],
    );
  }

  // ---------------- SEARCH BAR ----------------
  Widget _buildSearchBar(Color primary,ResponsiveClass size) {
    return Container(
      decoration: BoxDecoration(
        color: primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(size.wp(4)),
      ),
      child: TextField(
        onChanged: onChangeUsername,
        autocorrect: true,
        style:
        GoogleFonts.poppins(fontSize: size.font(16), color: primary),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search_rounded, color: primary),
          hintText: "Search username",
          hintStyle: GoogleFonts.poppins(
              color: primary.withOpacity(0.6), fontSize: size.font(14)),
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(vertical:size.hp(3.5), horizontal: size.wp(3.5)),
        ),
      ),
    );
  }

  // ---------------- LOADER ----------------
  Widget _buildLoader(Color primary,ResponsiveClass size) {
    return Padding(
      padding: EdgeInsets.only(top: size.wp(4)),
      child: CircularProgressIndicator(strokeWidth: 2.2, color: primary),
    );
  }

  // ---------------- EMPTY UI ----------------
  Widget _buildEmptyState(Color primary,ResponsiveClass size) {
    return Center(
      child: AutoSizeText(
        "Start typing to search",
        style: GoogleFonts.poppins(
          fontSize: size.font(15),
          color: primary.withOpacity(0.6),
        ),
      ),
    );
  }

  // ---------------- USER LIST ----------------
  Widget _buildUserList(
      List<User> users,
      List<Interaction> sentRequest,
      List<UserIsar> friends,
      String fromUserId,
      Color primary,
      ResponsiveClass size
      ) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (_, __) => SizedBox(height: size.hp(2.5)),
      itemBuilder: (context, index) {
        final u = users[index];
        final alreadySent =
        sentRequest.any((x) => mapUserToIsar(x.toUser!).userId == u.id);
        bool alreadyFriend = friends.any((x)=>x.userId== u.id);

        final userIsar = mapUserToIsar(u);
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AccountScreen(user: userIsar, status: alreadyFriend? "accepted" : alreadySent ? "pending" : "follow",backgroundType: '',),
              ),
            );
          },
          child: Container(
            padding:
            EdgeInsets.symmetric(horizontal: size.wp(3), vertical: 12.h),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(size.wp(4)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: size.wp(5),
                  backgroundColor: primary.withOpacity(0.3),
                  child: Text(
                    u.fullname[0].toUpperCase(),
                    style: TextStyle(color: primary, fontSize: size.font(18)),
                  ),
                ),
                SizedBox(width: size.wp(3)),
          
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        u.fullname,
                        style: GoogleFonts.poppins(
                            fontSize: size.font(16),
                            fontWeight: FontWeight.w600,
                            color: primary),
                      ),
                      // Text(
                      //   "@${u.username}",
                      //   style: GoogleFonts.poppins(
                      //     fontSize: size.font(13),
                      //     color: primary.withOpacity(0.7),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                alreadyFriend ? GestureDetector(
                  onTap:()=> Get.to(
                      ()=> ChatScreen(fullname: u.fullname, receiverId: u.id),
                    transition: Transition.leftToRightWithFade,
                    duration:const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                  ),
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                    padding:  EdgeInsets.symmetric(horizontal: size.wp(2), vertical: size.hp(2)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(size.wp(3)),
                      color: Colors.green,
                    ),
                    curve: Curves.easeInOut,
                    child:  Row(
                      children: [
                        const Icon(Icons.done),
                        AutoSizeText("Message",style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),)
                      ],
                    )
                  ),
                ) :
                GestureDetector(
                  onTap:alreadySent ? (){} : () => sendFriendRequest(fromUserId, u.id),
                  child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                    padding: EdgeInsets.symmetric(horizontal: size.wp(2), vertical: size.hp(2.5)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: alreadySent ? Colors.white.withOpacity(0.2): Colors.blueAccent,
                    ),
                    curve: Curves.easeInOut,
                    child: alreadySent ?  AutoSizeText("Pending",style: GoogleFonts.poppins(
        fontSize: 14.sp,
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.w600
        ),) :Row(
                      children: [
                        Icon(Icons.done,color: Theme.of(context).colorScheme.primary,),
                        AutoSizeText("Add",style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600
                        ),)
                      ],
                    ),
                  ),
                )
          
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------- FRIENDS SECTION ----------------
  Widget _buildFriendsSection(List<UserIsar> friends, Color primary) {
    if (friends.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Friends",
          style: GoogleFonts.poppins(
            color: primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20)
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final fr = friends[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: primary.withOpacity(0.2),
                  child: Text(fr.fullname[0], style: TextStyle(color: primary)),
                ),
                title: Text(fr.fullname, style: GoogleFonts.poppins(color: primary)),
                //subtitle: Text("@${fr.username}", style: GoogleFonts.poppins(color: primary.withOpacity(0.6))),
                trailing: Icon(Icons.messenger_rounded, color: primary),
              );
            },
          ),
        )
      ],
    );
  }

  
}

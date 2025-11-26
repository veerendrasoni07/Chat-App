import 'dart:async';
import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/models/interaction.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/friends_provider.dart';
import 'package:chatapp/provider/request_provider.dart';
import 'package:chatapp/provider/sent_request_provider.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controller/friend_controller.dart';

class AddFriendScreen extends ConsumerStatefulWidget {
  const AddFriendScreen({super.key});

  @override
  ConsumerState<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends ConsumerState<AddFriendScreen> {
  final FriendController _friendController = FriendController();
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
    setState(() => isLoading = true);
    final users = await _friendController.searchUser(username: username);
    setState(() {
      futureUserList = users;
      isLoading = false;
    });
  }

  Future<void> getAllRequests() async {
    ref.read(sentRequestProvider.notifier).loadInitialData();
  }

  @override
  void initState() {
    super.initState();
    getAllRequests();
  }

  @override
  void dispose() {
    debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.inversePrimary;

    final fromUser = ref.watch(userProvider);
    final friends = ref.watch(friendsProvider);
    final sentRequest = ref.watch(sentRequestProvider);
    final requests = ref.watch(requestProvider(fromUser!.id));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildHeader(context, primary),
              SizedBox(height: 16.h),

              _buildSearchBar(primary),
              SizedBox(height: 16.h),

              if (isLoading) _buildLoader(primary),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: futureUserList.isEmpty && !isLoading
                      ? friends.isNotEmpty ? _buildFriendsSection(friends, primary) : _buildEmptyState(primary)
                      : _buildUserList(
                    futureUserList,
                    sentRequest,
                    friends,
                    fromUser.id,
                    primary,
                  ),
                ),
              ),


              SizedBox(height: 8.h),

      
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- BEAUTIFUL HEADER ----------------
  Widget _buildHeader(BuildContext context, Color primary) {
    return Row(
      children: [
        Text(
          "Add Friends",
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close, color: primary, size: 26),
        ),
      ],
    );
  }

  // ---------------- SEARCH BAR ----------------
  Widget _buildSearchBar(Color primary) {
    return Container(
      decoration: BoxDecoration(
        color: primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: TextField(
        onChanged: onChangeUsername,
        autocorrect: true,
        style:
        GoogleFonts.poppins(fontSize: 16.sp, color: primary),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search_rounded, color: primary),
          hintText: "Search username",
          hintStyle: GoogleFonts.poppins(
              color: primary.withOpacity(0.6), fontSize: 14.sp),
          border: InputBorder.none,
          contentPadding:
          EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        ),
      ),
    );
  }

  // ---------------- LOADER ----------------
  Widget _buildLoader(Color primary) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: CircularProgressIndicator(strokeWidth: 2.2, color: primary),
    );
  }

  // ---------------- EMPTY UI ----------------
  Widget _buildEmptyState(Color primary) {
    return Center(
      child: Text(
        "Start typing to search",
        style: GoogleFonts.poppins(
          fontSize: 15.sp,
          color: primary.withOpacity(0.6),
        ),
      ),
    );
  }

  // ---------------- USER LIST ----------------
  Widget _buildUserList(
      List<User> users,
      List<Interaction> sentRequest,
      List<User> friends,
      String fromUserId,
      Color primary,
      ) {
    return ListView.separated(
      itemCount: users.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final u = users[index];
        final alreadySent =
        sentRequest.any((x) => x.toUser.id == u.id);
        bool alreadyFriend = friends.any((x)=>x.id == u.id);

        return Container(
          padding:
          EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: primary.withOpacity(0.3),
                child: Text(
                  u.fullname[0].toUpperCase(),
                  style: TextStyle(color: primary, fontSize: 18),
                ),
              ),
              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u.fullname,
                      style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: primary),
                    ),
                    Text(
                      "@${u.username}",
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: primary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              alreadyFriend ? GestureDetector(
                onTap:(){},
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 350),
                  padding:  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.green,
                  ),
                  curve: Curves.easeInOut,
                  child: Row(
                    children: [
                      Icon(Icons.done),
                      Text("Friend")
                    ],
                  )
                ),
              ) :
              GestureDetector(
                onTap:alreadySent ? (){} : () => sendFriendRequest(fromUserId, u.id),
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: alreadySent ? Colors.deepOrange : Colors.purple,
                  ),
                  curve: Curves.easeInOut,
                  child: alreadySent ? Text("Pending") :Row(
                    children: [
                      Icon(Icons.done),
                      Text("Add")
                    ],
                  ),
                ),
              )

            ],
          ),
        );
      },
    );
  }

  // ---------------- FRIENDS SECTION ----------------
  Widget _buildFriendsSection(List<User> friends, Color primary) {
    if (friends.isEmpty) return SizedBox();

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
            physics: NeverScrollableScrollPhysics(),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final fr = friends[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: primary.withOpacity(0.2),
                  child: Text(fr.fullname[0], style: TextStyle(color: primary)),
                ),
                title: Text(fr.fullname),
                subtitle: Text("@${fr.username}"),
                trailing: Icon(Icons.message, color: primary),
              );
            },
          ),
        )
      ],
    );
  }

  
}

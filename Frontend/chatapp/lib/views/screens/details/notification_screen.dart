import 'dart:ui';
import 'package:chatapp/controller/friend_controller.dart';
import 'package:chatapp/models/interaction.dart';
import 'package:chatapp/provider/activity_provider.dart';
import 'package:chatapp/provider/friend_controller_provider.dart';
import 'package:chatapp/provider/request_provider.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/views/screens/details/chat_screen.dart';
import 'package:chatapp/views/screens/details/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../provider/userProvider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final requests = ref.watch(requestProvider(user!.id));
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
              children: [
                _header(context, primary),
                Expanded(
                  child:  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Requests Title
                      requests.isNotEmpty ? _sectionTitle(context, "Friend Requests"): Center(child: Text("No Requests",style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),),),
            
                      ...requests.map((req) => _RequestTile(
                        key: ValueKey(req.id),
                        req: req,
                        userId: user.id,
                      )),
            
                      if (requests.isNotEmpty) const SizedBox(height: 20),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _activityTile(BuildContext context, Interaction a) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProfileScreen(user: a.fromUser),
        ),
      ),
      child: _glassTile(
        context: context,
        child: Row(
          children: [
            _avatar(context, a.fromUser.profilePic, a.fromUser.fullname),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    a.fromUser.fullname,
                    style: _titleStyle(context),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "@${a.fromUser.username}",
                    style: _subtitleStyle(context),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      fullname: a.fromUser.fullname,
                      receiverId: a.fromUser.id,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.messenger_outline),
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar(BuildContext context, String pic, String name) {
    return CircleAvatar(
      radius: 26,
      backgroundColor:
      Theme.of(context).colorScheme.primary.withOpacity(0.15),
      backgroundImage: pic.isNotEmpty ? NetworkImage(pic) : null,
      child: pic.isEmpty
          ? Text(
        name[0].toUpperCase(),
        style: _titleStyle(context),
      )
          : null,
    );
  }

  TextStyle _titleStyle(BuildContext context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontWeight: FontWeight.w600,
      fontSize: 16,
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

/// ----------------------
///  REQUEST TILE
/// ----------------------

class _RequestTile extends ConsumerStatefulWidget {
  final Interaction req;
  final String userId;
  const _RequestTile({super.key, required this.req, required this.userId});

  @override
  ConsumerState<_RequestTile> createState() => _RequestTileState();
}

class _RequestTileState extends ConsumerState<_RequestTile>
    with SingleTickerProviderStateMixin {
  bool accepted = false;

  @override
  Widget build(BuildContext context) {
    final req = widget.req;

    return _glassTile(
      context: context,
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 26,
            backgroundColor: Theme.of(context)
                .colorScheme
                .primary
                .withOpacity(0.15),
            child: Text(
              req.fromUser.fullname[0].toUpperCase(),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              req.fromUser.fullname,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: accepted
                ? _accepted()
                : Row(
              children: [
                _button(context, "Accept", Colors.greenAccent,
                        () => _accept(req)),
                const SizedBox(width: 10),
                _button(context, "Reject", Colors.redAccent,
                        () => _reject(req)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accepted() {
    return Container(
      key: const ValueKey("acc"),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.25),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.6)),
      ),
      child: const Text(
        "Accepted ✓",
        style: TextStyle(
          color: Colors.greenAccent,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
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

  void _accept(Interaction req) {
    setState(() => accepted = true);
    final socket = ref.read(socketProvider);
    socket.acceptRequest({
      'senderId': req.fromUser.id,
      'receiverId': widget.userId,
    });
  }

  void _reject(Interaction req) {
    final socket = ref.read(socketProvider);
    socket.requestRejected(req.fromUser.id, req.toUser.id);
    ref.read(requestProvider(req.fromUser.id).notifier)
        .removeByFrom(req.fromUser.id);
  }
}

/// ----------------------
///  FROSTED GLASS CONTAINER
/// ----------------------

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
import 'dart:ui';
import 'package:chatapp/controller/friend_controller.dart';
import 'package:chatapp/models/interaction.dart';
import 'package:chatapp/provider/activity_provider.dart';
import 'package:chatapp/provider/request_provider.dart';
import 'package:chatapp/provider/socket_provider.dart';
import 'package:chatapp/views/screens/details/chat_screen.dart';
import 'package:chatapp/views/screens/details/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../provider/userProvider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  final FriendController _friendController = FriendController();

  Future<void> getAllRequests() async {
    _friendController.getAllRequests(ref);
  }

  @override
  void initState() {
    super.initState();
    getAllRequests();
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(requestProvider(ref.read(userProvider)!.id));
    final activities = ref.watch(activityProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Requests Header ---
          if (requests.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Friend Requests",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

          // --- Requests List ---
          ...requests.map((req) => _RequestTile(
            key: ValueKey(req.id),
            req: req,
            userId: user!.id,
          )),

          const SizedBox(height: 20),

          // --- Activities Header ---
          if (activities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                "Recent Activity",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

          // EMPTY STATE
          if (requests.isEmpty && activities.isEmpty)
            _buildEmptyState(context),

          // --- Activities List ---
          ...activities.map((activity) => _activityTile(context, activity)),
        ],
      ),
    );
  }
  Widget _activityTile(BuildContext context, Interaction activity) {
    return GestureDetector(
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(user: activity.fromUser))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.08),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor:
              Theme.of(context).colorScheme.inversePrimary.withOpacity(0.15),
              backgroundImage:
              activity.fromUser.profilePic != null &&
                  activity.fromUser.profilePic.isNotEmpty
                  ? NetworkImage(activity.fromUser.profilePic)
                  : null,
              child: activity.fromUser.profilePic == null ||
                  activity.fromUser.profilePic!.isEmpty
                  ? Text(
                activity.fromUser.fullname[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )
                  : null,
            ),
            const SizedBox(width: 14),
      
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.fromUser.fullname,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "@${activity.fromUser.username}",
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
      
            IconButton(onPressed: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ChatScreen(fullname: activity.fromUser.fullname, receiverId: activity.fromUser.id))),icon:Icon(Icons.messenger),
                color: Theme.of(context).colorScheme.inversePrimary),
          ],
        ),
      ),
    );
  }


  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        "No pending requests",
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontSize: 16,
        ),
      ),
    );
  }
}

/// Separate stateful widget for each tile so it owns animation state properly
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

  // small delay before removing tile from provider to allow animation
  static const Duration _acceptedShowDuration = Duration(milliseconds: 450);

  @override
  Widget build(BuildContext context) {
    final req = widget.req;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .inversePrimary
                  .withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.15),
                  child: Text(
                    req.fromUser.fullname[0].toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    req.fromUser.fullname,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Animated switcher for accept/reject -> accepted
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      FadeTransition(opacity: anim, child: child),
                  child: accepted
                      ? _acceptedButton(context)
                      : Row(
                    key: const ValueKey("buttons"),
                    children: [
                      _actionButton(
                        label: "Accept",
                        color: Colors.greenAccent,
                        onTap: () => _onAcceptPressed(req),
                      ),
                      const SizedBox(width: 10),
                      _actionButton(
                        label: "Reject",
                        color: Colors.redAccent,
                        onTap: () => _onRejectPressed(req),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _acceptedButton(BuildContext context) {
    return Container(
      key: const ValueKey("accepted"),
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

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.25),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.6)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  void _onAcceptPressed(Interaction req) {
    setState(() => accepted = true);

    // Optimistic UI: ask server to accept
    final socket = ref.read(socketProvider);
    socket.acceptRequest({
      'senderId': req.fromUser.id,
      'receiverId': widget.userId,
    });

    // Remove request from provider after short delay so animation finishes

  }

  void _onRejectPressed(Interaction req) {
    final socket = ref.read(socketProvider);
    final requestP = ref.read(requestProvider(req.fromUser.id).notifier);
    socket.requestRejected(req.fromUser.id, req.toUser.id);
    requestP.removeByFrom(req.fromUser.id);
  }
}

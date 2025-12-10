import 'dart:ui';
import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends ConsumerWidget {
  final User user;
  const SettingsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
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
                const SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Column(
                      children: [
                        _profileTile(user),
                        const SizedBox(height: 20),
                        _sectionTitle("Account"),
                        _glassTile(Icons.person_rounded, "Edit Profile"),
                        _glassTile(Icons.phone_android, "Change Phone"),
                        _glassTile(Icons.logout, "Logout",
                            onTap: () => AuthController().logout(context, ref)),

                        const SizedBox(height: 25),
                        _sectionTitle("Chats"),
                        _glassTile(Icons.wallpaper_rounded, "Chat Wallpaper"),
                        _glassTile(Icons.hd_rounded, "Media Quality"),
                        _glassSwitchTile("Auto-download Media", true),

                        const SizedBox(height: 25),
                        _sectionTitle("Notifications"),
                        _glassSwitchTile("Message Notifications", true),
                        _glassSwitchTile("Sound Effects", true),
                        _glassSwitchTile("Vibration", true),

                        const SizedBox(height: 25),
                        _sectionTitle("Privacy"),
                        _glassTile(Icons.visibility_rounded, "Last Seen"),
                        _glassTile(Icons.photo_rounded, "Profile Photo"),
                        _glassTile(Icons.block, "Blocked Users"),

                        const SizedBox(height: 25),
                        _sectionTitle("About"),
                        _glassTile(Icons.info_rounded, "App Info"),
                        _glassTile(Icons.bug_report_rounded, "Report a Bug"),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---- HEADER ----
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
            "Settings",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.qr_code_2, size: 28, color: primary),
          ),
        ],
      ),
    );
  }

  // ---- PROFILE TILE ----
  Widget _profileTile(User user) {
    return _glassContainer(
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 32,
          backgroundColor: Colors.white.withOpacity(0.2),
          backgroundImage:
          user.profilePic.isNotEmpty ? NetworkImage(user.profilePic) : null,
          child: user.profilePic.isEmpty
              ? Text(
            user.fullname[0],
            style: const TextStyle(color: Colors.white, fontSize: 28),
          )
              : null,
        ),
        title: Text(
          user.fullname,
          style: GoogleFonts.poppins(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: Text(
          user.email,
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.white70),
        ),
        trailing: Icon(Icons.edit, color: Colors.white.withOpacity(0.8)),
      ),
    );
  }

  // ---- SECTION HEADER ----
  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style:
        GoogleFonts.poppins(fontSize: 15, color: Colors.white.withOpacity(0.8)),
      ),
    );
  }

  // ---- GLASS TILE ----
  Widget _glassTile(IconData icon, String label, {VoidCallback? onTap}) {
    return _glassContainer(
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.white, size: 26),
        title: Text(label,
            style: GoogleFonts.poppins(fontSize: 15, color: Colors.white)),
        trailing: Icon(Icons.arrow_forward_ios_rounded,
            size: 16, color: Colors.white54),
      ),
    );
  }

  // ---- GLASS SWITCH TILE ----
  Widget _glassSwitchTile(String text, bool initial) {
    return _glassContainer(
      child: StatefulBuilder(
        builder: (context, setState) {
          return SwitchListTile(
            value: initial,
            onChanged: (v) => setState(() => initial = v),
            activeColor: Colors.white,
            inactiveThumbColor: Colors.white70,
            title: Text(text,
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.white)),
          );
        },
      ),
    );
  }

  // ---- GLASS CONTAINER ----
  Widget _glassContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
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
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
          child: child,
        ),
      ),
    );
  }
}

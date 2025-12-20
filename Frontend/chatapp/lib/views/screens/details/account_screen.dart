import 'dart:ui';
import 'package:chatapp/componentss/responsive.dart';
import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/localDB/model/user_isar.dart';
import 'package:chatapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountScreen extends ConsumerStatefulWidget {
  final String backgroundType;
  final UserIsar user;
  const AccountScreen({super.key, required this.backgroundType,required this.user});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> with TickerProviderStateMixin{
  double _rotateX = 0;
  double _rotateY = 0;
  double _scale = 1;

  double _nx = 0;
  double _ny = 0;

  // ---- Premium Gradient Based On Type ----
  List<Color> _background(String type) {
    switch (type) {
      case 'coder':
        return [
          const Color(0xFF0F2027),
          const Color(0xFF203A43),
          const Color(0xFF2C5364)
        ];
      case 'creator':
        return [
          const Color(0xFF3A0CA3),
          const Color(0xFF7209B7),
          const Color(0xFFF72585)
        ];
      default:
        return [
          const Color(0xFF450072),
          const Color(0xFF270249),
          const Color(0xFF1F0033)
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: Stack(
        children: [
          // ---------- Premium Background ----------
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _background(widget.backgroundType),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context,constraint){
                  final size = ResponsiveClass(constraint.maxHeight, constraint.maxWidth);
                  return  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () =>Navigator.pop(context),
                            icon: Icon(Icons.arrow_back_ios_new, size: size.wp(6),color:primary),
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon:  Icon(Icons.qr_code_2, size: size.wp(6),color:primary)),
                              IconButton(
                                  onPressed: () =>AuthController().logout(context, ref),
                                  icon: Icon(Icons.more_vert, size: size.wp(6),color:primary)),
                            ],
                          ),
                        ],
                      ),
                      _buildHeader(widget.user,size),
                      SizedBox(height: size.hp(8)),
                      _interactiveTiltCard(),
                      SizedBox(height: size.hp(10)),
                      _buildSettingsList(context,ref,size),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader(UserIsar user,ResponsiveClass size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.wp(3)),
      child: Row(
        children: [
          _glassAvatar(user.profilePic,user.fullname,size),
          SizedBox(width: size.wp(3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.fullname,
                    style: GoogleFonts.poppins(
                        fontSize: size.font(28),
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                SizedBox(height: size.hp(1)),
                Text(user.email,
                    style: GoogleFonts.poppins(
                        fontSize:size.font(16), color: Colors.white70)),
                SizedBox(height: size.hp(5)),
                Row(
                  children: [
                    _iosButton("Following",size),
                    SizedBox(width: size.wp(5)),
                    _iosButton("Message",size),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }


  Widget _iosButton(String text,ResponsiveClass size) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: size.wp(5), vertical: size.hp(2)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size.wp(4)),
          color: Colors.white.withOpacity(0.12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
            fontSize: size.font(18), color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }


  Widget _glassAvatar(String profilePic,String text,ResponsiveClass size) {
    return Container(
      width: size.wp(30),
      height: size.hp(30),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.20),
              Colors.white.withOpacity(0.05)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 8))
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: profilePic.isNotEmpty ? Image.network(profilePic,fit: BoxFit.cover,) : Center(
            child: Hero(
              tag: text,
              child: Text(
                text[0] ,
                style: GoogleFonts.poppins(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _interactiveTiltCard() {
    return Listener(
      onPointerUp: (_) => setState(() {
        _rotateX = 0;
        _rotateY = 0;
        _scale = 1;
      }),
      onPointerMove: (value) {
        final size = MediaQuery.of(context).size.width * 0.8;
        final center = size / 2;
        final dx = value.localPosition.dx - center;
        final dy = value.localPosition.dy - center;

        _nx = dx / center;
        _ny = dy / center;

        setState(() {
          _rotateY = _nx * 0.18;
          _rotateX = -_ny * 0.18;
          _scale = 1.06;
        });
      },
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 1, end: _scale),
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        builder: (context, s, child) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(_rotateX)
              ..rotateY(_rotateY)
              ..scale(s),
            child: child,
          );
        },
        child: _glassStatsCard(),
      ),
    );
  }


  Widget _glassStatsCard() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withOpacity(0.2)),

        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.10),
            Colors.white.withOpacity(0.04)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            //Frosted Blur
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: const SizedBox(),
              ),
            ),

            // Shine layer
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(_nx, _ny),
                    radius: 1.1,
                    colors: [
                      Colors.white.withOpacity(0.18),
                      Colors.transparent
                    ],
                  ),
                ),
              ),
            ),

            _buildStatsContent(),
          ],
        ),
      ),
    );
  }

  // ---------------- Stats Content Inside Glass ----------------
  Widget _buildStatsContent() {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statColumn("1.8K", "Messages"),
              _statColumn("36", "Contacts"),
              _statColumn("412", "Media"),
              _statColumn("2 yrs", "Joined"),
            ],
          ),
          Divider(
            color: Colors.white.withOpacity(0.2),
            thickness: 1,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.user.bio.isNotEmpty == true
                  ? widget.user.bio
                  : "Available",
              style: GoogleFonts.poppins(
                  fontSize: 15, color: Colors.white70),
            ),
          )
        ],
      ),
    );
  }


  Widget _statColumn(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 3),
        Text(label,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white70)),
      ],
    );
  }
}
Widget _buildSettingsList(context,WidgetRef ref,ResponsiveClass size) {
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: size.wp(2.5)),
    child: Column(
      children: [
        _settingsTile(Icons.person, "Edit Profile", () {},size),
        _settingsTile(Icons.lock, "Privacy", () {},size),
        _settingsTile(Icons.image, "Media & Storage", () {},size),
        _settingsTile(Icons.block, "Blocked Users", () {},size),
        _settingsTile(Icons.logout, "Logout", () {
          AuthController().logout(context, ref);
        },size),
      ],
    ),
  );
}

Widget _settingsTile(IconData icon, String title, VoidCallback onTap,ResponsiveClass size) {
  return Container(
    margin:  EdgeInsets.only(bottom: size.wp(3)),
    padding:  EdgeInsets.symmetric(horizontal: size.wp(6), vertical: size.hp(4)),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size.wp(4)),
      color: Colors.white.withOpacity(0.08),
      border: Border.all(color: Colors.white.withOpacity(0.15)),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.white, size: size.wp(6)),
        SizedBox(width: size.wp(3)),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: size.font(18),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Icon(Icons.arrow_forward_ios_rounded,
            color: Colors.white.withOpacity(0.4), size: size.wp(3)),
      ],
    ),
  );
}

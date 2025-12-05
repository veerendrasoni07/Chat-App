import 'dart:ui';
import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountScreen extends ConsumerStatefulWidget {
  final String backgroundType;
  final User user;
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
    final TabController _tabController = TabController(length: 3, vsync: this);
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () =>Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_new, size: 28,color:primary),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon:  Icon(Icons.qr_code_2, size: 28,color:primary)),
                          IconButton(
                              onPressed: () =>AuthController().logout(context, ref),
                              icon: Icon(Icons.more_vert, size: 28,color:primary)),
                        ],
                      ),
                    ],
                  ),
                  _buildHeader(widget.user),
                  const SizedBox(height: 35),
                  _interactiveTiltCard(),
                  const SizedBox(height: 35),
                  Container(
                    height: 50, // Define a height for your custom tab bar area
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                      gradient: LinearGradient(
                          colors: [
                        Colors.white.withOpacity(0.10),
                        Colors.white.withOpacity(0.04)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    ),
                    child:ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                            child: Stack(
                              children: [
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 40,
                                    sigmaY: 40,
                                  ),
                                ),
                                TabBar(
                                    controller: _tabController,
                                    //indicatorPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),

                                    //splashFactory: NoSplash.splashFactory, // No ripple
                                    dividerColor: Colors.white.withOpacity(0.35),
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.white.withOpacity(0.45),
                                    tabs: [
                                      Tab(
                                        icon:Icon(Icons.grid_view_rounded,size: 30,) ,
                                      ),
                                      Tab(
                                        icon:Icon(Icons.camera_alt_rounded,size: 30,) ,
                                      ),
                                      Tab(
                                        icon:Icon(Icons.favorite,size: 30,) ,
                                      )
                                    ]
                                ),
                              ],
                            )
                        ),


                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController, // If using a custom TabController

                      children: <Widget>[
                        Center(child: Text('Content for Tab 1')),
                        Center(child: Text('Content for Tab 2')),
                        Center(child: Text('Content for Tab 3')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- HEADER --------------------
  Widget _buildHeader(User user) {
    return Row(
      children: [
        _glassAvatar(user.profilePic,user.fullname),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.fullname,
                  style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              const SizedBox(height: 2),
              Text(user.email,
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _iosButton("Following"),
                  const SizedBox(width: 10),
                  _iosButton("Message"),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  // -------------- iOS Capsule Buttons --------------
  Widget _iosButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white.withOpacity(0.12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
            fontSize: 13, color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }

  // -------------- Premium Glass Avatar --------------
  Widget _glassAvatar(String profilePic,String text) {
    return Container(
      width: 90,
      height: 90,
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
    );
  }

  // ---------------- Interactive Tilt Card ----------------
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

  // ---------------- Premium Stats Glass Card ----------------
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
              _statColumn("251", "Posts"),
              _statColumn("1.2K", "Followers"),
              _statColumn("52K", "Views"),
              _statColumn("8K", "Likes"),
            ],
          ),
          Divider(
            color: Colors.white.withOpacity(0.2),
            thickness: 1,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "App developer | Builder | Growth mindset 🚀",
              style:
              GoogleFonts.poppins(fontSize: 15, color: Colors.white70),
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

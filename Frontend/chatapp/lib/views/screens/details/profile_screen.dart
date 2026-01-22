import 'dart:async';
import 'dart:math';
import 'package:chatapp/controller/auth_controller.dart';
import 'package:chatapp/models/user.dart';
import 'package:chatapp/provider/auth_manager_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The main profile screen widget
class ProfileScreen extends ConsumerStatefulWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with TickerProviderStateMixin {
  // For 3D tilt
  double tiltX = 0.0;
  double tiltY = 0.0;

  // Orbit animations
  late final AnimationController orbitController;

  // Aura / ring animation
  late final AnimationController auraController;

  // Page controller for swipe sections
  final PageController pageController = PageController(viewportFraction: 0.98);

  // Fake activity list
  late final List<String> activities;

  // Badges
  final List<_Badge> badges = [
    _Badge(label: 'Creator', color: Colors.pinkAccent),
    _Badge(label: 'Early', color: Colors.orangeAccent),
    _Badge(label: 'Streak 30', color: Colors.greenAccent),
  ];

  // Current background gradient based on user.type
  late List<Color> backgroundGradient;

  // For floating button press animations
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();

    //isFollowing = widget.user.isFollowing;

    orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(); // continuous orbit

    auraController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    activities = [
      'Joined the platform 1 year ago',
      'Hit 10k followers',
      'Posted "How to build a scalable app"',
      'Earned Creator badge',
      'Started a livestream',
      'Reached 500 posts',
    ];

    backgroundGradient = _gradientForType('coder');
  }

  @override
  void dispose() {
    orbitController.dispose();
    auraController.dispose();
    pageController.dispose();
    super.dispose();
  }

  List<Color> _gradientForType(String type) {
    switch (type) {
      case 'coder':
        return [Colors.teal.shade900, Colors.cyan.shade700];
      case 'creator':
        return [Colors.deepPurple.shade800, Colors.pinkAccent.shade200];
      case 'artist':
        return [Colors.indigo.shade900, Colors.purple.shade600];
      case 'gamer':
        return [Colors.deepPurple.shade900, Colors.blueAccent.shade400];
      default:
        return [Colors.blueGrey.shade900, Colors.blueGrey.shade700];
    }
  }

  void _onPointerMove(PointerEvent event, Size cardSize) {
    // compute relative position to center and convert to small tilt angles
    final centerX = cardSize.width / 2;
    final centerY = cardSize.height / 2;
    final dx = (event.localPosition.dx - centerX) / centerX;
    final dy = (event.localPosition.dy - centerY) / centerY;
    setState(() {
      tiltY = dx * 0.08; // rotation around Y axis
      tiltX = -dy * 0.08; // rotation around X axis
    });
  }

  void _onPointerExit(PointerEvent event) {
    setState(() {
      tiltX = 0.0;
      tiltY = 0.0;
    });
  }

  void _toggleFollow() {
    setState(() {
      isFollowing = !isFollowing;
    });

    // In real app: call backend and optimistically update provider/state
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // layer background gradient that reacts subtly to page scrolled
    return Scaffold(
      body: Stack(
        children: [
          // Reactive gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: backgroundGradient,
                stops: const [0.0, 0.95],
              ),
            ),
          ),

          // Subtle animated overlay shapes
          Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundPainter(
                time: DateTime.now().millisecondsSinceEpoch % 100000,
                seed: widget.user.id.hashCode,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Column(
                children: [
                  // Top bar: name + small actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_back_ios_new),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.qr_code_2)),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.more_vert)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Hero floating card (3D parallax + aura + orbiting badges)
                  Listener(
                    onPointerMove: (e) {
                      // approximate size since we know typical card size — we can refine by using a GlobalKey if needed
                      _onPointerMove(e, Size(size.width - 48, 220));
                    },
                    //onPointerUp: (_) => _onPointerExit(),
                    //onPointerCancel: (_) => _onPointerExit(_),
                    child: Center(
                      child: Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001) // perspective
                          ..rotateX(tiltX)
                          ..rotateY(tiltY),
                        alignment: FractionalOffset.center,
                        child: _buildHeroCard(size),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // PageView for swipe sections
                  SizedBox(
                    height: 330,
                    child: PageView(
                      controller: pageController,
                      children: [
                        _buildTimelineSection(),
                        _buildCollectionsSection(),
                        _buildFriendsSection(),
                        _buildAchievementsSection(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dots indicator
                  _DotsIndicator(controller: pageController, itemCount: 4),


                  ElevatedButton(onPressed: ()=>ref.read(authManagerProvider.notifier).logout(context: context), child: Text("Logout"))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(Size screenSize) {
    final cardWidth = min(760.0, screenSize.width - 24);
    final cardHeight = 220.0;
    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.03),
            blurRadius: 1,
          )
        ],
        border: Border.all(color: Colors.white.withOpacity(0.06)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.02),
            Colors.white.withOpacity(0.01),
          ],
        ),
      ),
      child: Stack(
        children: [
          // subtle blurred background glow
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.45,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.02),
                        Colors.transparent
                      ],
                      center: Alignment.topLeft,
                      radius: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // content row
          Row(
            children: [
              const SizedBox(width: 18),
              // profile + aura
              SizedBox(
                width: 140,
                height: 140,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // orbiting badges
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: orbitController,
                        builder: (_, __) {
                          // compute angle base
                          final base = orbitController.value * 2 * pi;
                          return Stack(
                            children: List.generate(badges.length, (i) {
                              final angle = base + (i * 2 * pi / badges.length);
                              final radius = 60.0 + (i * 6);
                              final x = cos(angle) * radius;
                              final y = sin(angle) * radius * 0.6;
                              return Transform.translate(
                                offset: Offset(x, y),
                                child: Opacity(
                                  opacity: 0.95 - (i * 0.15),
                                  child: _BadgeWidget(badges[i]),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                    ),

                    // aura ring
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: AnimatedBuilder(
                        animation: auraController,
                        builder: (_, __) {
                          return CustomPaint(
                            painter: _AuraPainter(
                              progress: auraController.value,
                              baseColors: backgroundGradient,
                            ),
                          );
                        },
                      ),
                    ),

                    // circular avatar with initials
                    Material(
                      color: Colors.transparent,
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.black.withOpacity(0.3),
                        child: Text(
                          widget.user.fullname.isNotEmpty
                              ? widget.user.fullname[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 18),

              // user info column
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // username + tagline
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.user.fullname,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          // small QR
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.03),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.qr_code, size: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '@${widget.user.username}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "I am the best ",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // stat row
                      Row(
                        children: [
                          _StatBlock(
                              title: 'Followers', value: '${widget.user.connections.length}'),
                          const SizedBox(width: 14),
                          _StatBlock(title: 'Posts', value: '0'),
                          const SizedBox(width: 14),
                          _StatBlock(title: 'Level', value: 'Creator'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // floating action buttons overlay (Follow / Message / More)
          Positioned(
            right: 14,
            bottom: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _FloatingPillButton(
                  label: isFollowing ? 'Following' : 'Follow',
                  icon: isFollowing ? Icons.check : Icons.person_add_alt_1,
                  onTap: _toggleFollow,
                  active: isFollowing,
                ),
                const SizedBox(width: 8),
                _FloatingPillButton(
                  label: 'Message',
                  icon: Icons.message_outlined,
                  onTap: () {},
                  active: false,
                ),
                const SizedBox(width: 8),
                _FloatingPillButton(
                  label: 'More',
                  icon: Icons.more_horiz,
                  onTap: () {},
                  active: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // TIMELINE SECTION
  Widget _buildTimelineSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Timeline',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: activities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                return _TimelineItem(
                  title: activities[i],
                  timeAgo: '${(i + 1) * 2}d ago',
                  accent: i.isEven ? Colors.pinkAccent : Colors.lightBlueAccent,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // COLLECTIONS (simple cards)
  Widget _buildCollectionsSection() {
    final collections = [
      'Tutorials',
      'Design Ideas',
      'Code Snippets',
      'Shorts',
      'Collaborations',
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Collections',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3/2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: collections.length,
              itemBuilder: (context, i) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        backgroundGradient.first.withOpacity(0.18 + i*0.02),
                        backgroundGradient.last.withOpacity(0.06 + i*0.02),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(collections[i], style: const TextStyle(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.playlist_play, size: 18),
                          const SizedBox(width: 8),
                          Text('${(i+1)*12} items', style: TextStyle(color: Colors.white.withOpacity(0.7))),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // FRIENDS GRID
  Widget _buildFriendsSection() {
    final friends = List.generate(12, (i) => 'Friend ${i+1}');
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Friends', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 0.9),
              itemCount: friends.length,
              itemBuilder: (context, i){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.white.withOpacity(0.06),
                      child: Text('${friends[i][0]}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    Text(friends[i], style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // ACHIEVEMENTS
  Widget _buildAchievementsSection() {
    final achievements = [
      {'label': 'Creator Pro', 'desc': 'Top Creator rank', 'color': Colors.purpleAccent},
      {'label': 'Streak 30', 'desc': '30 day activity', 'color': Colors.greenAccent},
      {'label': 'Collab Star', 'desc': '10 collabs', 'color': Colors.blueAccent},
      {'label': 'Verified', 'desc': 'Community verified', 'color': Colors.amberAccent},
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Achievements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.6, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: achievements.length,
              itemBuilder: (context, i){
                final a = achievements[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        (a['color'] as Color).withOpacity(0.18),
                        backgroundGradient.last.withOpacity(0.05)
                      ],
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(colors: [(a['color'] as Color).withOpacity(0.85), (a['color'] as Color).withOpacity(0.35)]),
                          boxShadow: [BoxShadow(color: (a['color'] as Color).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 6))],
                        ),
                        child: const Icon(Icons.workspace_premium, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a['label'] as String, style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(a['desc'] as String, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.black.withOpacity(0.18),
    borderRadius: BorderRadius.circular(14),
    border: Border.all(color: Colors.white.withOpacity(0.04)),
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 18, offset: const Offset(0, 8))],
  );
}

/// Custom floating pill button used in hero card
class _FloatingPillButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  const _FloatingPillButton({required this.label, required this.icon, required this.onTap, required this.active});

  @override
  State<_FloatingPillButton> createState() => _FloatingPillButtonState();
}

class _FloatingPillButtonState extends State<_FloatingPillButton> with SingleTickerProviderStateMixin {
  late final AnimationController ctl;
  @override
  void initState() {
    super.initState();
    ctl = AnimationController(vsync: this, duration: const Duration(milliseconds: 220));
  }
  @override
  void dispose() { ctl.dispose(); super.dispose(); }

  void _onTap() {
    ctl.forward().then((_) => ctl.reverse());
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final scale = 1 - (ctl.value * 0.06);
    return GestureDetector(
      onTap: _onTap,
      child: Transform.scale(
        scale: scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: widget.active ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 18, color: Colors.white.withOpacity(0.95)),
              const SizedBox(width: 8),
              Text(widget.label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small stat widget in hero card
class _StatBlock extends StatelessWidget {
  final String title;
  final String value;
  const _StatBlock({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        Text(title, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7))),
      ],
    );
  }
}

/// Simple badge model
class _Badge {
  final String label;
  final Color color;
  _Badge({required this.label, required this.color});
}

/// Widget that renders badge circle
class _BadgeWidget extends StatelessWidget {
  final _Badge badge;
  const _BadgeWidget(this.badge);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: badge.color.withOpacity(0.95),
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: badge.color.withOpacity(0.25), blurRadius: 8)],
      ),
      alignment: Alignment.center,
      child: Text(
        badge.label[0],
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

/// Aura painter draws animated gradient ring
class _AuraPainter extends CustomPainter {
  final double progress;
  final List<Color> baseColors;
  _AuraPainter({required this.progress, required this.baseColors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2;
    final stroke = 6 + (sin(progress * pi * 2) * 2.2);
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: pi * 2,
      colors: [
        baseColors[0].withOpacity(0.95),
        baseColors[1].withOpacity(0.8),
        Colors.white.withOpacity(0.85),
        baseColors[0].withOpacity(0.85),
      ],
      transform: GradientRotation(progress * pi * 2),
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius - stroke / 2, paint);

    // inner subtle ring
    final innerPaint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius - 10, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _AuraPainter old) => old.progress != progress;
}

/// Timeline item widget
class _TimelineItem extends StatelessWidget {
  final String title;
  final String timeAgo;
  final Color accent;
  const _TimelineItem({required this.title, required this.timeAgo, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
            Container(width: 2, height: 60, color: Colors.white.withOpacity(0.03))
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.03)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(timeAgo, style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Dots indicator for PageView
class _DotsIndicator extends StatefulWidget {
  final PageController controller;
  final int itemCount;
  const _DotsIndicator({required this.controller, required this.itemCount});

  @override
  State<_DotsIndicator> createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends State<_DotsIndicator> {
  double page = 0.0;
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_listener);
  }

  void _listener() {
    setState(() {
      page = widget.controller.page ?? widget.controller.initialPage.toDouble();
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = List.generate(widget.itemCount, (i) {
      final dist = (page - i).abs().clamp(0.0, 1.0);
      final size = 12.0 - (dist * 6.0);
      final opacity = 1.0 - (dist * 0.6);
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        width: size,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(opacity),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }
}

/// Subtle animated background painter for identity feel
class _BackgroundPainter extends CustomPainter {
  final int time;
  final int seed;
  _BackgroundPainter({required this.time, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.fill;
    final random = Random(seed);
    // draw a few soft blobs
    for (var i = 0; i < 3; i++) {
      final dx = size.width * (0.2 + i * 0.25) + sin((time / 1000) + i) * 12;
      final dy = size.height * (0.2 + i * 0.18) + cos((time / 1000) - i) * 16;
      final r = size.width * (0.35 - i * 0.08);
      p.shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.02 * (i + 1)),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset(dx, dy), radius: r));
      canvas.drawCircle(Offset(dx, dy), r, p);
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter old) => true;
}

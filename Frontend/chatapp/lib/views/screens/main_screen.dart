import 'dart:ui';
import 'package:chatapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'nav_screens/camera_screen.dart';
import 'nav_screens/home_screen.dart';

class MainScreen extends ConsumerStatefulWidget {

  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late final PageController _pageController;
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);

    _pages = const [
      HomeScreen(),
      CameraScreen(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_selectedIndex == index) return;   // avoid useless rebuilds
    setState(() => _selectedIndex = index);
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: _buildGlassNavBar(),
    );
  }

  Widget _buildGlassNavBar() {
    return Container(
      height: 70,
      margin: const EdgeInsets.all(16),
      width: MediaQuery.of(context).size.width * 0.92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
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
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            //Frosted Blur
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: const SizedBox(),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem("inactive", 'assets/icons/home.png', 0),
                _navItem("inactive", 'assets/icons/add-post.png', 1),
              ],
            )

          ],
        ),
      ),
    );
  }

  Widget _navItem(String inactive, String activeIcon, int index) {
    final isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        width: 50,
        height: 50,
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        child: Image.asset(activeIcon,color: Theme.of(context).colorScheme.primary,)
      ),
    );
  }
}

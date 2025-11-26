import 'dart:ui';
import 'package:chatapp/provider/friends_provider.dart';
import 'package:chatapp/views/screens/details/add_friend_screen.dart';
import 'package:chatapp/views/screens/details/new_group_screen.dart';
import 'package:chatapp/views/screens/details/notification_screen.dart';
import 'package:chatapp/views/screens/nav_screens/camera_screen.dart';
import 'package:chatapp/views/screens/nav_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int selectedIndex = 0;
  final PageController pageController = PageController();

  final List<Widget> pages = const [
    HomeScreen(),
    CameraScreen()
  ];

  void onPageChanged(int index) {
    setState(() => selectedIndex = index);
  }

  void onItemTapped(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: pages,
      ),

      bottomNavigationBar: _buildGlassNavBar(),
    );
  }

  //Center Floating Add Button
  Widget _centerAddButton() {
    return GestureDetector(
      onTap: ()=> {},
      child: Container(
        height: 68,
        width: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.purpleAccent, Colors.blueAccent],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 36),
      ),
    );
  }

  Widget _buildGlassNavBar() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      width: MediaQuery.of(context).size.width * 0.2,
      margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navItem(Icons.chat_bubble_outline_rounded,Icons.chat_bubble, 0),
                _navItem(Icons.camera_alt_outlined,Icons.camera_alt_rounded ,1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon1,IconData icon2, int index) {
    final bool active = index == selectedIndex;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(8),
        child: Icon(
          active ? icon2 : icon1,
          size: 28,
          color: active ? Theme.of(context).colorScheme.inverseSurface : Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
        ),
      ),
    );
  }
}




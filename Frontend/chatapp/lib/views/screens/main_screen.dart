import 'package:chatapp/views/screens/nav_screens/camera_screen.dart';
import 'package:chatapp/views/screens/nav_screens/home_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int selectedIndex = 0;
  final PageController pageController = PageController();
  void onPageChanged(int index){
    setState(() {
      selectedIndex = index;
    });
  }

  void onItemTapped(int index){
    pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> pages = [
    HomeScreen(),
    CameraScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:PageView(
        controller: pageController,
        onPageChanged:onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: pages,

      ) ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat),label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt),label: ''),
        ],
      ),
    );
  }
}
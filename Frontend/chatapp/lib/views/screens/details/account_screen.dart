import 'dart:ui';

import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  final String backgroundType;
  const AccountScreen({super.key,required this.backgroundType});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  double _rotateX = 0;
  double _rotateY = 0;

  double _norX = 0;
  double _norY = 0;
  double _scale = 1.0;


  List<Color> _gradientForType(String type) {
    switch (type) {
      case 'coder':
        return [Colors.teal.shade900, Colors.cyan.shade700];
      case 'creator':
        return [Colors.deepPurple.shade800, Colors.pinkAccent.shade200];
      case 'artist':
        return [ Colors.purple.shade600,Colors.brown.shade900,Colors.indigo.shade900];
      case 'gamer':
        return [Colors.deepPurple.shade900, Colors.blueAccent.shade400];
      default:
        return [Colors.blueGrey.shade900, Colors.blueGrey.shade700];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _gradientForType(widget.backgroundType)
              )
            ),
          ),

          Column(
            children: [
              Listener(
                onPointerUp: (value){
                  setState(() {
                    _rotateY = 0;
                    _rotateX = 0;
                    _scale = 1.0;
                  });
                },
                onPointerMove: (value){
                  final size = MediaQuery.of(context).size.width * 0.75;
                  final center = size/2;
                  final dx = value.localPosition.dx - center;
                  final dy = value.localPosition.dy - center;
                  _norX = dx/center;
                  _norY = dy/center;
                  setState(() {
                    _rotateY = _norX * 0.15;
                    _rotateX = -_norY * 0.15;
                    _scale = 1.08;
                  });

                },
                child: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 1,end: _scale),
                    duration: Duration(milliseconds: 450),
                    builder: (context,size,child){
                      return Transform(
                        alignment: Alignment.center,
                          transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateX(_rotateX)
                              ..rotateY(_rotateY)
                              ..scale(size),
                        child: child,
                      );
                    },
                  curve: Curves.easeInOut,
                  child: Center(child: personTiltCard(_norX,_norY)) ,
                ),
              ),
            ],
          )



        ],
      ),
    );
  }

Widget glowLayer(double nx,double ny){
    return AnimatedContainer(
        duration: Duration(milliseconds: 150),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(nx,ny),
            radius: 1.2,
            colors: [
              Colors.white.withOpacity(0.18),
              Colors.transparent,
            ]
        )
      ),
    );
}

  Widget personTiltCard(double nx, double ny) {
    return Container(
      width:  MediaQuery.of(context).size.width * 0.95,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  color: Colors.blueAccent.withOpacity(0.05),
                ),
              ),
            ),

            Positioned.fill(child: glowLayer(nx, ny)),
          ],
        ),
      ),
    );
  }


}

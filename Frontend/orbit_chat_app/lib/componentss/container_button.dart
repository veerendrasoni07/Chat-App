import 'package:flutter/material.dart';

class ContainerButton extends StatelessWidget {
  double height;
  double width;
  String text;
  ContainerButton({super.key,required this.height,required this.width,required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:height ,
      width: width,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft,end: Alignment.topRight,colors: [Colors.blue.shade700,Colors.blue.shade900]),
        borderRadius: BorderRadius.circular(25)
      ),
      child: Center(child: Text(text,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)),
    );
  }
}

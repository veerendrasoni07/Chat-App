import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart' show Placeholder;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body:  SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: TextField(
                        controller: controller,
                        cursorColor: Colors.green,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            hintText: "Search",
                            prefixIcon: Hero(tag: "search_animation",child: Icon(Icons.search_rounded,color: Theme.of(context).colorScheme.primary,)).animate().shake(duration: Duration(seconds: 2)),
                            hintStyle: GoogleFonts.montserrat(fontSize: 15,color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w700),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)
                            )
                        ),
                      ),
                    ),
                    Expanded(child: TextButton(onPressed: ()=>Navigator.pop(context), child: AutoSizeText("Cancel",style: GoogleFonts.montserrat(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w600,fontSize: 14.sp),)))
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}

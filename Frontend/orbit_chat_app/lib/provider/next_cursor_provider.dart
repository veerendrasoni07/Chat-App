
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:orbit_chat_app/models/next_cursor.dart';

class NextCursorProvider extends StateNotifier<NextCursor?>{
  NextCursorProvider():super(null);

  void addCursor(NextCursor cursor)async{
    state = cursor;
  }

}

final nextCursorProvider = StateNotifierProvider<NextCursorProvider,NextCursor?>((ref)=>NextCursorProvider());


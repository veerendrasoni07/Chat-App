import 'package:chatapp/models/next_cursor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NextCursorProvider extends StateNotifier<NextCursor?>{
  NextCursorProvider():super(null);

  void addCursor(NextCursor cursor)async{
    state = cursor;
  }

}

final nextCursorProvider = StateNotifierProvider<NextCursorProvider,NextCursor?>((ref)=>NextCursorProvider());


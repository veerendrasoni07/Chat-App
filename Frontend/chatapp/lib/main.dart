import 'package:chatapp/localDB/models/group_isar.dart';
import 'package:chatapp/localDB/models/group_message_isar.dart';
import 'package:chatapp/localDB/models/message_isar.dart';
import 'package:chatapp/localDB/models/user_isar.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:chatapp/provider/theme_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/theme/dark_theme.dart';
import 'package:chatapp/theme/light_mode.dart';
import 'package:chatapp/views/entry%20point/onBoarding/onboarding_page.dart';
import 'package:chatapp/views/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  final dir = await getApplicationDocumentsDirectory();
  final directory = dir.path;
  final isar = await Isar.open(
      [
        UserIsarSchema,
        MessagesIsarSchema,
        GroupIsarSchema,
        GroupMessageIsarSchema
      ],
      directory: directory
  );
  runApp(
      ProviderScope(
        overrides: [isarProvider.overrideWithValue(isar)],
          child: const MyApp()
      )
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    Future<void> checkUserAndToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      final String? user = prefs.getString('user');
      if (token != null && user != null) {
        ref.read(userProvider.notifier).addUser(user);
      } else {
        ref.read(userProvider.notifier).signOut();
      }
    }

    return MaterialApp(
      home: FutureBuilder(
        future: checkUserAndToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final user = ref.read(userProvider);
            return user != null ? MainScreen() : OnboardingPage();
          }
        },
      ),
      darkTheme: darkMode,
      theme: lightMode,
      themeMode: theme,

      debugShowCheckedModeBanner: false,
 
    );
  }
}


import 'package:chatapp/provider/backend_sync_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:chatapp/localDB/provider/isar_provider.dart';
import 'package:chatapp/provider/theme_provider.dart';
import 'package:chatapp/provider/userProvider.dart';
import 'package:chatapp/theme/dark_theme.dart';
import 'package:chatapp/theme/light_mode.dart';
import 'package:chatapp/views/entry%20point/onBoarding/onboarding_page.dart';
import 'package:chatapp/views/screens/main_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localDB/model/group_isar.dart';
import 'localDB/model/user_isar.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final directory = dir.path;
  final isar = await Isar.open(
      [
        UserIsarSchema,
        GroupIsarSchema,
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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask((){
      ref.read(backendSyncProvider).backendSync();
    });
  }


  @override
  Widget build(BuildContext context) {
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

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_,__){
        return  MaterialApp(
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
      },
    );
  }
}
//
// import 'package:chatapp/provider/backend_sync_provider.dart';
// import 'package:chatapp/views/screens/nav_screens/home_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
//
// import 'localDB/model/group_isar.dart';
// import 'localDB/model/user_isar.dart';
// import 'localDB/provider/isar_provider.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final dir = await getApplicationDocumentsDirectory();
//   final isar = await Isar.open(
//     [
//       UserIsarSchema,
//       GroupIsarSchema
//     ],
//     directory: dir.path,
//   );
//   runApp(
//       ProviderScope(
//           overrides: [
//             isarProvider.overrideWithValue(isar)
//           ],
//           child: const MyApp()
//       )
//   );
// }
// class MyApp extends ConsumerStatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   ConsumerState<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends ConsumerState<MyApp> {
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Future.microtask((){
//       ref.read(backendSyncProvider).backendSync();
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//         home: HomeScreen()
//     );
//   }
// }

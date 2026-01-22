
import 'package:chatapp/localDB/model/message_isar.dart';
import 'package:chatapp/provider/auth_manager_provider.dart';
import 'package:chatapp/provider/backend_sync_provider.dart';
import 'package:chatapp/views/entry%20point/authentication/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
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
        MessageIsarSchema
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
      ref.read(backendSyncProvider).backendSync(ref: ref,context: context);
    });
  }


  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeProvider);
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_,__){
        return  GetMaterialApp(
          home: ref.watch(authManagerProvider) == AuthStatus.authenticated ? const MainScreen() : const LoginScreen() ,
          defaultTransition: Transition.cupertino,
          darkTheme: darkMode,
          theme: lightMode,
          themeMode: theme,

          debugShowCheckedModeBanner: false,

        );
      },
    );
  }
}
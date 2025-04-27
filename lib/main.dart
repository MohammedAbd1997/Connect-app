import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'Helper/SharedPreferance/shared_preferance.dart';
import 'Screens/SplashScreen/view/splash_screen.dart';
import 'Utils/Translation.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SpHelper.spHelper.initSharedPrefrences();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
        minTextAdapt: true,
        ensureScreenSize: true,
        builder: (context, widget) => GetMaterialApp(
            themeMode: ThemeMode.system,
            theme: ThemeData(fontFamily: 'Dubai'),
            translations: Messages(),
            locale:
            Locale(SpHelper.spHelper.getLanguage()! == "A" ? "ar" : "en"),
            debugShowCheckedModeBanner: false,
            home: const SplashScreen()));
  }
}

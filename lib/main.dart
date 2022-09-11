import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:salondec/bindings/init_binding.dart';
import 'package:salondec/menu/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:salondec/firebase_options.dart';
import 'package:salondec/page_router.dart';

Future main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // await GetStorage.init();

    runApp(MyApp());
  },
      (error, stacktrace) => log("[${DateTime.now()}]",
          name: "Error_log",
          time: DateTime.now(),
          error: error,
          stackTrace: stacktrace));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Salon de Chungdam",
      initialBinding: InitialBinding(),
      theme: ThemeData(
          primaryColor: const Color(0xff365859),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            centerTitle: true,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Abhaya Libre',
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
            iconTheme: IconThemeData(color: Colors.black),
          )),
      // home: const LoginScreen(),
      //home: MainPage(title: "home",),

      initialRoute: PageRouter.initial,
      //페이지 라우터
      getPages: PageRouter.routes,
    );
  }
}

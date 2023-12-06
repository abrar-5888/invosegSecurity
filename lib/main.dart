import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:invoseg_security/firebase_options.dart';
import 'package:invoseg_security/splashscreen.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(const MyApp());
    print("Success");
  } catch (e) {
    print("Failed due to ($e)");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

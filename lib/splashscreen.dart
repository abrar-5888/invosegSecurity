import 'package:flutter/material.dart';
import 'package:invoseg_security/loginPage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Welcome ! please Login to continue"),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
          backgroundColor: Colors.grey[700],
          textColor: Colors.green,
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.asset("assets/images/izmir.jpg")),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Powered By",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
              height: 100,
              width: 100,
              child: Image.asset("assets/images/TransparentLogo.png")),
          const Text(
            "INVOSEG",
            style: TextStyle(shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 1.0,
                color: Colors.black,
              ),
            ], fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
          )
        ],
      ),
    );
  }
}

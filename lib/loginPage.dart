import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:invoseg_security/tab.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var logins = {"user": "", "pass": ""};

  final GlobalKey<FormState> _formKey = GlobalKey();
  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // EasyLoading.show(status: 'Authenticating...');
      try {
        print("try Work");

        // print(logins['pass']);
        FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: logins['user'].toString().trim(),
                password: logins['pass'].toString().trim())
            .then((e) async {
          User? userCredential = FirebaseAuth.instance.currentUser;

          if (logins['user']!.startsWith('app')) {
            if (userCredential != null) {
              EasyLoading.showSuccess("Login Successfully");
              Future.delayed(const Duration(seconds: 1), () {
                EasyLoading.dismiss();
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabsScreen(
                            index: 0,
                          )));
              _formKey.currentState!.reset();
            } else {
              EasyLoading.showError("Invalid Credentials");
              Future.delayed(const Duration(seconds: 1), () {
                EasyLoading.dismiss();
              });
            }
          } else {
            print("Eror");
            EasyLoading.showError("Invalid Credentials");
            Future.delayed(const Duration(seconds: 1), () {
              EasyLoading.dismiss();
            });
          }
        });
      } catch (e) {
        print("Catch work");
        EasyLoading.dismiss();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            //     image: DecorationImage(
            //   image: NetworkImage(
            //       'https://w0.peakpx.com/wallpaper/395/822/HD-wallpaper-city-amoled-black-building-city-new-night-sky.jpg'),
            //   fit: BoxFit.cover,
            //   colorFilter: new ColorFilter.mode(
            //       Colors.black.withOpacity(0.7), BlendMode.dstATop),
            // )
            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25.0),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(),
                            child: Column(
                              children: <Widget>[
                                const Image(
                                  image: AssetImage('assets/images/izmir.jpg'),
                                  height: 150,
                                  width: 150,
                                ),
                                // FittedBox(
                                //   fit: BoxFit.fitWidth,
                                //   child: Container(
                                //     child: Text(
                                //       "Shop, Heal, and Stay Secure with the Smart Lake City",
                                //       style: TextStyle(
                                //         fontSize: (MediaQuery.of(context).size.width -
                                //                 MediaQuery.of(context).padding.top) *
                                //             0.060,
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.black,
                                //       ),
                                //       textAlign: TextAlign.center,
                                //     ),
                                //   ),
                                // ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 15.0),
                                        child: Icon(
                                          Icons.person_outline,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        height: 10.0,
                                        width: 1.0,
                                        color: Colors.grey.withOpacity(0.5),
                                        margin: const EdgeInsets.only(
                                            left: 00.0, right: 10.0),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          decoration: const InputDecoration(
                                            labelText: 'Email or PhoneNo',
                                            border: InputBorder.none,
                                            hintText:
                                                'Enter your Email Address or PhoneNo',
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                          validator: (value) {
                                            return null;

                                            // if (value!.isEmpty) {
                                            //   return 'Invalid email!';
                                            // } else if (!value.contains('@')) {
                                            //   // return 'Invalid email';
                                            //   if (!value.contains('03') ||
                                            //       !value.contains('+92')) {
                                            //     return 'Invalid Number';
                                            //   }
                                            //   return ' invalid email';
                                            // }
                                          },
                                          onSaved: (value) {
                                            logins['user'] = value!;
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Row(
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 15.0),
                                        child: Icon(
                                          Icons.lock_open,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        height: 10.0,
                                        width: 1.0,
                                        color: Colors.grey.withOpacity(0.5),
                                        margin: const EdgeInsets.only(
                                            left: 00.0, right: 10.0),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            labelText: 'Password',
                                            border: InputBorder.none,
                                            hintText:
                                                'Enter your Password here',
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10),
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty ||
                                                value.length < 6) {
                                              return 'Password is too short!';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            logins['pass'] = value!;
                                          },
                                          obscureText: true,
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    height: 50,
                                    child: Container(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          login();
                                        },
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            )),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Colors.black),
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20))),
                                        child: const Text('Login',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle:
                                              const TextStyle(fontSize: 10),
                                        ),
                                        onPressed: () {
                                          EasyLoading.showInfo(
                                              "Currently in progress");
                                          Future.delayed(
                                              const Duration(seconds: 1), () {
                                            EasyLoading.dismiss();
                                          });
                                          // Navigator.push(
                                          //     context,
                                          //     PageTransition(
                                          //         duration: Duration(
                                          //             milliseconds: 700),
                                          //         type: PageTransitionType
                                          //             .rightToLeftWithFade,
                                          //         child:
                                          //             PhoneVerificationScreen()));
                                        },
                                        child: const Text(
                                          'Forgot Password ?',
                                          style: TextStyle(
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'Controllers/AuthentificationController.dart';
import 'Models/Status.dart';
import 'Statics/Statics.dart';
import 'homePage.dart';
import 'login.dart';
void main() {
  configLoading();
  runApp(MyApp());

  print("working on $baseURL");
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoading = true;

  AuthentificationController authentificationController =
      new AuthentificationController();

  @override
  void initState() {
    super.initState();

    authentificationController.authentificationStatus().then((status) async {
      setState(() {
        isLoading = false;
      });

      switch (status) {
        case AuthStatus.tokenNull:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
          break;
        case AuthStatus.tokenExpired:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
          break;
        case AuthStatus.connected:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          break;

        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? SpinKitRing(
                    color: Theme.of(context).primaryColor,
                    size: 50.0,
                    lineWidth: 4,
                  )
                : Text("")
          ],
        ),
      ),
    );
  }
}

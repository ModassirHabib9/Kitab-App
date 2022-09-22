import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kitaab_project/utils/colors_resource.dart';
import 'package:kitaab_project/views/auth/login_screen.dart';
import 'package:kitaab_project/views/home/home_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    print("Hy Email" + email.toString());
    Timer(
        Duration(seconds: 3),
        () => email != null
            ? Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen()))
            : Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => Login_Screen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.appMainColor,
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60),
                Center(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 120,
                    padding: const EdgeInsets.all(12),
                    alignment: Alignment.center,
                    child: const Text(
                      "Kitab App",
                      style: TextStyle(
                          fontSize: 32,
                          color: ColorResources.colorWhite,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          /*Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(height: 5),
              Text(
                "Lorem Ipsum dolor set",
                style: TextStyle(
                    fontSize: 16,
                    color: ColorResources.WHITE,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )*/
        ],
      )),
    );
  }
}

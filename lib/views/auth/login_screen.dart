// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:kitaab_project/views/auth/rigister_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/my_custom_btn.dart';
import '../../widgets/my_custom_textfield.dart';
import '../home/home_screen.dart';
import 'forgot_pass_screen.dart';

class Login_Screen extends StatefulWidget {
  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final _formKey = GlobalKey<FormState>();
  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  var email = "";
  var password = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  userLogin() async {
    SharedPreferences pref;
    try {
      showAlertDialog(context);
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
      pref = await SharedPreferences.getInstance();
      pref.setString("email", email);
      print("Email" + email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // ignore: avoid_print
        print("No User Found for that Email");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        print("Wrong Password Provided by User");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Password Provided by User",
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ),
        );
      }
    }
  }

  Saveuserid(String id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userid', id);
    // prefs.setInt('usertype', selectedindex);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
    Saveuserid('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    MyCustomTextField(
                      hintText: "Email",
                      width: double.infinity,
                      controller: emailController,
                      // controller: controller,
                      // decoration: decoration
                    ),
                    const SizedBox(height: 10),
                    MyCustomTextField(
                      controller: passwordController,
                      hintText: "Password",
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, a, b) =>
                                    Forgot_Password_Screen(),
                                transitionDuration: Duration(seconds: 0),
                              ),
                              (route) => false);
                        },
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("Forgot Password"))),
                    const SizedBox(height: 20),
                    Container(
                      height: 45,
                      width: double.infinity,
                      child: MyCustomButton(
                        text: "LOGIN",
                        onPressed: () async {
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              email = emailController.text;
                              password = passwordController.text;
                            });
                            userLogin();
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an Account? ",
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          TextButton(
                            onPressed: () async {
                              Saveuserid(["UserId"].toString());
                              print("Stored Id" + ["uid"].toString());

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, a, b) =>
                                        Registration_Screen(),
                                    transitionDuration: Duration(seconds: 0),
                                  ),
                                  (route) => false);
                            },
                            child: Text('Signup',
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 18)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

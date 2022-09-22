import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UserAuth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  getUser(String email, String password) async {
    try {
      // to get location of current user
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (response.user != null) {
        prefs.setString('userEmail', email);
        prefs.setString('userId', response.user!.uid);
        prefs.setBool('routing', true);

        // Get.offAll(BottomNavigationBarScreen());
      } else {
        Get.snackbar(
          'Error',
          'Something went wrong',
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } on FirebaseAuthException catch (e) {
      //use switch case to handle specific errors
      if (e.code == 'ERROR_INVALID_EMAIL') {
        Get.snackbar(
          'Error',
          'Invalid email',
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      } else if (e.code == 'ERROR_WRONG_PASSWORD') {
        Get.snackbar(
          'Error',
          'Wrong password',
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      } else if (e.code == 'ERROR_USER_NOT_FOUND') {
        Get.snackbar(
          'Error',
          'User not found',
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      } else if (e.code == 'ERROR_USER_DISABLED') {
        Get.snackbar(
          'Error',
          'User disabled',
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      } else if (e.code == 'ERROR_TOO_MANY_REQUESTS') {
        Get.snackbar('Error', 'Too many requests',
            icon: Icon(Icons.error, color: Colors.white));
      }
    } catch (e) {
      //use get.snackbar to show error
      print(e.toString());
    }
  }

  userRigister(String email, String password) async {
    try {
      final User = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (User != null) {
        return User.user!.uid;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        Get.snackbar(
          'Error',
          'Email already in use',
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      } else if (e.code == 'ERROR_WEAK_PASSWORD') {
        Get.snackbar(
          'Error',
          'Password is too weak',
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Email already exist',
          icon: Icon(
            Icons.error,
            color: Colors.white,
          ),
          backgroundColor: Colors.black,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      print("some error");
    }
  }
}

class LoginViewModel extends ChangeNotifier {
  String? _email;
  FirebaseAuth auth = FirebaseAuth.instance;

  String? _password;

  bool isvisible = false;

  UserAuth user = UserAuth();
  dialog(BuildContext context, bool value) {
    value
        ? showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: new Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text("Loading..."),
                    ),
                    SizedBox(
                      width: 14,
                    ),
                    CircularProgressIndicator(
                      color: Color(0xffFF8000),
                    ),
                  ],
                ),
              );
            })
        : Navigator.pop(context);
  }

  // here ***** user registor
  userRigiter(String email, String password, BuildContext context) async {
    try {
      dialog(context, true);
      _email = email;
      _password = password;
      user.getUser(_email.toString(), _password.toString());
      dialog(context, false);
      notifyListeners();
    } catch (e) {
      dialog(context, false);
    }
  }

  /// update password
  updatePassword(BuildContext context, email) async {
    try {
      print("email is :$email");
      await auth.sendPasswordResetEmail(email: email).then((value) {
        // Get.offAll(LoginScreen());
      });
    } on FirebaseAuthException catch (e) {
      // use if condition
      if (e.code == 'auth/invalid-email') {
        //
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "Email is not valid",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              actions: [
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );

        print('email is invalid');
      } else if (e.code == 'auth/user-not-found') {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "User not found",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              actions: [
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        print('user not found');
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                "Something went wrong",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              actions: [
                MaterialButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        print('something went wrong');
      }
    } catch (e) {
      print("some in updatePassword");
    }
  }
}

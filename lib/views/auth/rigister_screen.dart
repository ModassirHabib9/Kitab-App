import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitaab_project/utils/colors_resource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/my_custom_btn.dart';
import '../../widgets/my_custom_textfield.dart';
import 'login_screen.dart';

class Registration_Screen extends StatefulWidget {
  @override
  _Registration_ScreenState createState() => _Registration_ScreenState();
}

class _Registration_ScreenState extends State<Registration_Screen> {
  bool isMale = false;

  final TextEditingController email = TextEditingController();
  final TextEditingController fullName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController c_password = TextEditingController();

  final GlobalKey<ScaffoldState> scaffold = GlobalKey<ScaffoldState>();
  FirebaseStorage storage = FirebaseStorage.instance;
  File? selectedImage;

  Future getImage() async {
    var image = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      selectedImage = File(image!.path);
    });
  }

  ///     Location   ///////////////////////////////////////////
  static String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static RegExp regExp = new RegExp(p);
  bool isLoading = false;
  UserCredential? authResult;
  void submit() async {
    setState(() {
      isLoading = true;
    });
    try {
      authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
    } on PlatformException catch (e) {
      String message = "Please Check Internet";
      if (e.message != null) {
        message = e.message.toString();
      }
      // ignore: deprecated_member_use
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }

    final response = await FirebaseStorage.instance.ref().child(
        '/user_profile/' + DateTime.now().millisecondsSinceEpoch.toString());

    final upload = await response.putFile(selectedImage!.absolute);

    var downloadUrl = await (await upload).ref.getDownloadURL();

    print("this is url $downloadUrl");

    await FirebaseFirestore.instance
        .collection("UserRegistration")
        .doc(authResult!.user!.uid)
        .set({
      "imgUrl": downloadUrl,
      "UserName": fullName.text,
      "UserEmail": email.text,
      "UserId": authResult!.user!.uid,
      "UserNumber": phoneNumber.text,
      "UserLocation": locationController.text,
      "password": password.text,
      // "UserGender": isMale == true ? "Male" : "Female"
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => Login_Screen(),
      ),
    );
    setState(() {
      isLoading = false;
    });
  }

  void vaildation() {
    if (selectedImage.isNull &&
        email.text.isEmpty &&
        password.text.isEmpty &&
        c_password.text.isEmpty &&
        fullName.text.isEmpty &&
        address.text.isEmpty &&
        phoneNumber.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Fill All Fields"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (selectedImage.isNull) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Image"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (fullName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Your Name"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Your Email"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Valid Email"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (phoneNumber.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Your Phone Number"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (phoneNumber.text.length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Valid Phone Number"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Your Password"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (password.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Must Be 6 Characters"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (c_password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Your Confirm Password"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (c_password.text != password.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Not Match"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (phoneNumber.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Your Phone Number"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (phoneNumber.text.length < 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Valid Phone Number"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please Enter Your Password"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Must Be 8 Characters"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else if (password.text != c_password.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password Not Match"),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } else {
      submit();
    }
  }

  Widget _buildAllTextFormField() {
    return Container(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              // getImage();
            },
            child: selectedImage != null
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    width: 80,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: FileImage(selectedImage!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : Stack(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          shape: BoxShape.circle,
                          color: ColorResources.colorYellow,
                        ),
                        child: Text("Profile"),
                      ),
                      Positioned(
                        child: Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorResources.colorWhite,
                              border: Border.all(
                                color: ColorResources.colorBlack,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                getImage();
                              },
                              icon: Icon(
                                Icons.edit,
                                size: 15,
                                color: ColorResources.colorBlack,
                              ),
                            )),
                        bottom: 0,
                        right: 0,
                      )
                    ],
                  ),
          ),
          SizedBox(height: 20),
          MyCustomTextField(
            controller: fullName,
            hintText: "Full Name",
          ),
          const SizedBox(height: 10),
          MyCustomTextField(
            controller: email,
            hintText: "Email",
          ),
          const SizedBox(height: 10),
          MyCustomTextField(
            controller: phoneNumber,
            hintText: "Phone Number",
          ),
          const SizedBox(height: 10),
          MyCustomTextField(
            controller: password,
            hintText: "Password",
          ),
          const SizedBox(height: 10),
          MyCustomTextField(
            controller: c_password,
            hintText: "Confirm Password",
          ),
        ],
      ),
    );
  }

  Widget _buildButtonPart() {
    return isLoading == false
        ? Container(
            height: 45,
            width: double.infinity,
            child: MyCustomButton(
              text: "LOGIN",
              onPressed: () async {
                // Validate returns true if the form is valid, otherwise false.
                vaildation();
              },
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 60, right: 20, left: 20),
          child: ListView(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  _buildAllTextFormField(),
                  const SizedBox(height: 20),
                  _buildButtonPart(),
                  const SizedBox(height: 20),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () => {
                            Navigator.pushAndRemoveUntil(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, a, b) =>
                                      Login_Screen(),
                                  transitionDuration: Duration(seconds: 0),
                                ),
                                (route) => false)
                          },
                          child: const Text('LOGIN',
                              style: TextStyle(
                                  color: Colors.blueAccent, fontSize: 18)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

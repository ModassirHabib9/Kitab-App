import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFireStore {
  userSendData(String fullname, String email, String password,
      String phoneNumber, String location, String userId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await FirebaseFirestore.instance
          .collection('User')
          .doc(userId.toString())
          .set({
        'fullName': fullname,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
        'location': location,
        'userId': userId,
        "dateTime":
            "${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}",
      }).then((value) async {
        prefs.setBool('routing', true);
        prefs.setString('userId', userId);
        prefs.setString('userEmail', email);

        print('>>>>>>>>>>>>>>>>>>>>>>>success');
        print("data sent");
        // Get.offAll(BottomNavigationBarScreen());
      });
    } catch (e) {
      print('>>>>>>>>>>>>>>>>>>.database error');

      print("error in database");
    }
  }
}

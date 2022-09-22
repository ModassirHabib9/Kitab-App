import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String? id;
  final String? address;
  final String? displayName;
  final String? email;
  final String? lastName;
  final String? phone;
  final String? photoURL;

  Users({
    this.id,
    this.address,
    this.displayName,
    this.email,
    this.lastName,
    this.phone,
    this.photoURL,
  });
}

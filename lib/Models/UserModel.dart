// // import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:queuing_system/Models/LocationModel.dart';
// import 'package:queuing_system/Models/NameModel.dart';

// class UserDetailsModel {
//   String
//     age,
//     contact,
//     currentQueue,
//     email,
//     qrID,
//     messagingToken,
//     secretLoginHash,
//     storeAppointed,
//     userType,
//     id;

//   NameModel name;
//   LocationModel location;
//   DateTime registeredDate;

//   UserDetailsModel ( String id, Map<dynamic, dynamic> data ) {
//     this.id = id ?? "";
//     this.age = data["age"] ?? "";
//     this.contact = data["contact"] ?? "";
//     this.currentQueue = data["currentQueue"] ?? "";
//     this.email = data["email"] ?? "";
//     this.qrID = data["qrID"] ?? "";
//     this.messagingToken = data["messagingToken"] ?? "";
//     this.secretLoginHash = data["secretLoginHash"] ?? "";
//     this.storeAppointed = data["storeAppointed"] ?? "";
//     this.userType = data["userType"] ?? "";
//     this.name = NameModel( data["name"] ?? {} );
//     this.location = LocationModel( data["location"] ?? {} );
//     if(data['registeredDate'] is DateTime){
//       this.registeredDate = data['registeredDate'];
//     } else if((data['registeredDate'] as Timestamp) != null){
//       this.registeredDate = (data['registeredDate'] as Timestamp).toDate();
//     }
//   }

//   setUserDetails() {
//     return {
//       "age" : this.age,
//       "contact" : this.contact,
//       "currentQueue" : this.currentQueue,
//       "email" : this.email,
//       "qrID" : this.qrID,
//       "messagingToken" : this.messagingToken,
//       "secretLoginHash" : this.secretLoginHash,
//       "storeAppointed" : this.storeAppointed,
//       "userType" : "normal",
//       "name" : this.name.setName(),
//       "location" : this.location.setLocation(),
//       "registeredDate" : FieldValue.serverTimestamp(),
//     };
//   }
// }

// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserModel {
  UserModel({
    this.id,
    this.username,
    this.password,
    this.firstname,
    this.lastname,
    this.age,
    this.address,
    this.phoneno,
    this.usertype,
    this.fcmToken,
    this.image,
  });

  String id;
  String username;
  String password;
  String firstname;
  String lastname;
  String age;
  String address;
  String phoneno;
  String usertype;
  String fcmToken;
  String image;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        password: json["password"],
        firstname: json["firstname"],
        lastname: json["lastname"],
        age: json["age"],
        address: json["address"],
        phoneno: json["phoneno"],
        usertype: json["usertype"],
        fcmToken: json["fcmToken"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "password": password,
        "firstname": firstname,
        "lastname": lastname,
        "age": age,
        "address": address,
        "phoneno": phoneno,
        "usertype": usertype,
        "fcmToken": fcmToken,
        "image": image,
      };
}

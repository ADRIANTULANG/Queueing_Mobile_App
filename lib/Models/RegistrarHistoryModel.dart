// To parse this JSON data, do
//
//     final registrarHistoryModel = registrarHistoryModelFromJson(jsonString);

import 'dart:convert';

List<RegistrarHistoryModel> registrarHistoryModelFromJson(String str) =>
    List<RegistrarHistoryModel>.from(
        json.decode(str).map((x) => RegistrarHistoryModel.fromJson(x)));

String registrarHistoryModelToJson(List<RegistrarHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegistrarHistoryModel {
  RegistrarHistoryModel({
    this.id,
    this.customerId,
    this.queueType,
    this.dateCreated,
    this.status,
    this.fcmToken,
    this.lastname,
    this.firstname,
    this.customertype,
    this.purpose,
  });

  String id;
  String customerId;
  String queueType;
  DateTime dateCreated;
  String status;
  String fcmToken;
  String lastname;
  String firstname;
  String customertype;
  String purpose;

  factory RegistrarHistoryModel.fromJson(Map<String, dynamic> json) =>
      RegistrarHistoryModel(
        id: json["id"],
        customerId: json["customer_id"],
        queueType: json["queue_type"],
        dateCreated: DateTime.parse(json["date_created"]),
        status: json["status"],
        fcmToken: json["fcmToken"],
        lastname: json["lastname"],
        firstname: json["firstname"],
        customertype: json["customertype"],
        purpose: json["purpose"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "queue_type": queueType,
        "date_created": dateCreated.toIso8601String(),
        "status": status,
        "fcmToken": fcmToken,
        "firstname": firstname,
        "lastname": lastname,
        "customertype": customertype,
        "purpose": purpose,
      };
}

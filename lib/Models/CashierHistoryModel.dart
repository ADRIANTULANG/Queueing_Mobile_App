// To parse this JSON data, do
//
//     final CashierHistoryModel = CashierHistoryModelFromJson(jsonString);

import 'dart:convert';

List<CashierHistoryModel> cashierHistoryModelFromJson(String str) =>
    List<CashierHistoryModel>.from(
        json.decode(str).map((x) => CashierHistoryModel.fromJson(x)));

String cashierHistoryModelToJson(List<CashierHistoryModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CashierHistoryModel {
  CashierHistoryModel({
    this.id,
    this.customerId,
    this.queueType,
    this.dateCreated,
    this.status,
    this.fcmToken,
    this.lastname,
    this.firstname,
    this.customertype,
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

  factory CashierHistoryModel.fromJson(Map<String, dynamic> json) =>
      CashierHistoryModel(
        id: json["id"],
        customerId: json["customer_id"],
        queueType: json["queue_type"],
        dateCreated: DateTime.parse(json["date_created"]),
        status: json["status"],
        fcmToken: json["fcmToken"],
        lastname: json["lastname"],
        firstname: json["firstname"],
        customertype: json["customertype"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "queue_type": queueType,
        "date_created": dateCreated.toIso8601String(),
        "status": status,
        "fcmToken": fcmToken,
        "lastname": lastname,
        "firstname": firstname,
        "customertype": customertype,
      };
}

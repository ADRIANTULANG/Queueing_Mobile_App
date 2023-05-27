// To parse this JSON data, do
//
//     final queueModel = queueModelFromJson(jsonString);

import 'dart:convert';

List<QueueModel> queueModelFromJson(String str) =>
    List<QueueModel>.from(json.decode(str).map((x) => QueueModel.fromJson(x)));

String queueModelToJson(List<QueueModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QueueModel {
  QueueModel({
    this.id,
    this.customerId,
    this.queueType,
    this.dateCreated,
    this.status,
    this.purpose,
  });

  String id;
  String customerId;
  String queueType;
  DateTime dateCreated;
  String status;
  String purpose;

  factory QueueModel.fromJson(Map<String, dynamic> json) => QueueModel(
        id: json["id"],
        customerId: json["customer_id"],
        queueType: json["queue_type"],
        dateCreated: DateTime.parse(json["date_created"]),
        status: json["status"],
        purpose: json["purpose"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "queue_type": queueType,
        "date_created": dateCreated.toIso8601String(),
        "status": status,
        "purpose": purpose,
      };
}

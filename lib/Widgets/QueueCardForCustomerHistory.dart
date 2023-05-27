import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:queuing_system/Class/CurrentQueuCardClass.dart';
import 'package:queuing_system/Variables/size.dart';

import '../Models/QueueModel.dart';

class QueueCardForCustomer extends StatefulWidget {
  const QueueCardForCustomer({
    @required this.status,
    @required this.listall,
    @required this.date,
    @required this.id,
    @required this.queuetype,
    @required this.index,
    @required this.purpose,
  });
  final String status;
  final List<QueueModel> listall;
  final String queuetype;
  final String id;
  final String purpose;
  final int index;
  final DateTime date;
  @override
  _QueueCardForCustomerState createState() => _QueueCardForCustomerState(
      status: status,
      id: id,
      date: date,
      purpose: purpose,
      queuetype: queuetype,
      index: index,
      listall: listall);
}

class _QueueCardForCustomerState extends State<QueueCardForCustomer> {
  _QueueCardForCustomerState({
    @required this.status,
    @required this.index,
    @required this.listall,
    @required this.date,
    @required this.purpose,
    @required this.id,
    @required this.queuetype,
  });
  String status;
  DateTime date;
  List<QueueModel> listall;
  String purpose;
  int index;
  String queuetype;
  String id;

  QueueCardClass queueClass = QueueCardClass();
  final box = GetStorage();

  estimatedTime() async {
    if (status == "Pending") {
      if (queuetype == "cashier") {
        int estimatedtime = 0;
        bool isHit = false;
        for (var i = 0; i < listall.length; i++) {
          if (listall[i].queueType == 'cashier') {
            if (id == listall[i].id) {
              isHit = true;
            } else {
              if (isHit == true) {
              } else {
                estimatedtime = estimatedtime + 8;
              }
            }
          }
        }
        print(Duration(minutes: estimatedtime));
        var splitString =
            Duration(minutes: estimatedtime).toString().split(":");

        if (splitString[0].toString() == "0" &&
            splitString[1].toString() == "00") {
          time = "Its your turn!";
        } else if (splitString[0].toString() == "0" &&
            splitString[1].toString() != "00") {
          time = splitString[1].toString() + "  minute/s";
        } else if (splitString[1].toString() == "00" &&
            splitString[0].toString() != "0") {
          time = splitString[0].toString() +
              "  hour/s & " +
              splitString[1].toString() +
              " minute/s";
        } else if (splitString[1].toString() != "00" &&
            splitString[0].toString() != "0") {
          time = splitString[0].toString() +
              "  hour/s & " +
              splitString[1].toString() +
              " minute/s";
        }
      } else {
        int estimatedtime = 0;
        bool isHit = false;
        for (var i = 0; i < listall.length; i++) {
          if (listall[i].queueType == 'registrar') {
            if (id == listall[i].id) {
              isHit = true;
            } else {
              if (isHit == true) {
              } else {
                estimatedtime = estimatedtime + 12;
              }
            }
          }
        }
        print(Duration(minutes: estimatedtime));
        var splitString =
            Duration(minutes: estimatedtime).toString().split(":");

        if (splitString[0].toString() == "0" &&
            splitString[1].toString() == "00") {
          time = "Its your turn!";
        } else if (splitString[0].toString() == "0" &&
            splitString[1].toString() != "00") {
          time = splitString[1].toString() + "  minute/s";
        } else if (splitString[1].toString() == "00" &&
            splitString[0].toString() != "0") {
          time = splitString[0].toString() +
              "  hour/s & " +
              splitString[1].toString() +
              " minute/s";
        } else if (splitString[1].toString() != "00" &&
            splitString[0].toString() != "0") {
          time = splitString[0].toString() +
              "  hour/s & " +
              splitString[1].toString() +
              " minute/s";
        }
      }
    }
  }

  String time = '';

  @override
  void initState() {
    super.initState();
    if (box.read('usertype') == 'customer') {
      estimatedTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(15),
        width: PhoneSize(context).width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              //Dito naman ilalagay yung number mo sa pila/etc.
              "#" + id,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 22, letterSpacing: 8),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 12,
              ),
              Text(
                "status",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontSize: detail == 0 ? 18 : 14,
                ),
              ),
              Text(
                " :   ",
                style: TextStyle(
                  color: Colors.black54,
                  // fontSize: detail == 0 ? 18 : 14,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  time == "Its your turn!" ? "Processing" : status,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: detail == 0 ? 18 : 14,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 12,
              ),
              Text(
                "type",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontSize: detail == 0 ? 18 : 14,
                ),
              ),
              Text(
                " :   ",
                style: TextStyle(
                  color: Colors.black54,
                  // fontSize: detail == 0 ? 18 : 14,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  queuetype,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: detail == 0 ? 18 : 14,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 12,
              ),
              Text(
                "purpose",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontSize: detail == 0 ? 18 : 14,
                ),
              ),
              Text(
                " :   ",
                style: TextStyle(
                  color: Colors.black54,
                  // fontSize: detail == 0 ? 18 : 14,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  purpose,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: detail == 0 ? 18 : 14,
                  ),
                ),
              ),
            ],
          ),
          status == "Pending" && box.read('usertype') == "customer"
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Text(
                      "Estimated time",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                        // fontSize: detail == 0 ? 18 : 14,
                      ),
                    ),
                    Text(
                      " :   ",
                      style: TextStyle(
                        color: Colors.black54,
                        // fontSize: detail == 0 ? 18 : 14,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        time,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // fontSize: detail == 0 ? 18 : 14,
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 12,
              ),
              Text(
                "Date",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  // fontSize: detail == 0 ? 18 : 14,
                ),
              ),
              Text(
                " :   ",
                style: TextStyle(
                  color: Colors.black54,
                  // fontSize: detail == 0 ? 18 : 14,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  DateFormat.yMMMMd().format(date) +
                      " " +
                      DateFormat.jm().format(date),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: detail == 0 ? 18 : 14,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
      elevation: 8.0,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:queuing_system/Class/CurrentQueuCardClass.dart';
import 'package:queuing_system/Variables/size.dart';

import '../Models/QueueModel.dart';

class QueueCard extends StatefulWidget {
  const QueueCard({
    @required this.status,
    @required this.listall,
    @required this.date,
    @required this.id,
    @required this.queuetype,
    @required this.index,
  });
  final String status;
  final List<QueueModel> listall;
  final String queuetype;
  final String id;
  final int index;
  final DateTime date;
  @override
  _QueueCardState createState() => _QueueCardState(
      status: status,
      id: id,
      date: date,
      queuetype: queuetype,
      index: index,
      listall: listall);
}

class _QueueCardState extends State<QueueCard> {
  _QueueCardState({
    @required this.status,
    @required this.index,
    @required this.listall,
    @required this.date,
    @required this.id,
    @required this.queuetype,
  });
  String status;
  DateTime date;
  List<QueueModel> listall;

  int index;
  String queuetype;
  String id;

  QueueCardClass queueClass = QueueCardClass();
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
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
                  status,
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

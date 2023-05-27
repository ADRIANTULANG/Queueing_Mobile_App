import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:queuing_system/Class/CurrentQueuCardClass.dart';
import 'package:queuing_system/Variables/size.dart';
import 'package:http/http.dart' as http;

import '../Config/Endpoint.dart';

class QueueCardPendingQueue extends StatefulWidget {
  const QueueCardPendingQueue({
    @required this.status,
    @required this.date,
    @required this.id,
    @required this.queuetype,
    @required this.userfcmToken,
    @required this.refresh,
  });
  final String status;
  final String queuetype;
  final String id;
  final String userfcmToken;
  final Function refresh;
  final DateTime date;
  @override
  _QueueCardPendingQueueState createState() => _QueueCardPendingQueueState(
      status: status,
      id: id,
      date: date,
      refresh: refresh,
      queuetype: queuetype,
      userfcmToken: userfcmToken);
}

class _QueueCardPendingQueueState extends State<QueueCardPendingQueue> {
  _QueueCardPendingQueueState({
    @required this.status,
    @required this.date,
    @required this.id,
    @required this.queuetype,
    @required this.userfcmToken,
    @required this.refresh,
  });
  String status;
  String userfcmToken;
  final Function refresh;
  DateTime date;
  String queuetype;
  String id;

  QueueCardClass queueClass = QueueCardClass();

  sendNotification_turn_is_near(String userToken) async {
    var pushnotif = await http.post(
        Uri.parse('${AppEndpoint.endPointDomain}/push-notification.php'),
        body: {
          "fcmtoken": userToken,
          "title": "Message",
          "body": "Please go near to the cashier. Thank you"
        });
    print("e2e notif: ${pushnotif.body}");
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  //Dito naman ilalagay yung number mo sa pila/etc.
                  "#" + id,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 8),
                ),
              ),
              IconButton(
                  onPressed: () {
                    sendNotification_turn_is_near(userfcmToken);
                  },
                  icon: Icon(
                    Icons.notification_add,
                    color: Colors.lightBlue,
                  )),
            ],
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

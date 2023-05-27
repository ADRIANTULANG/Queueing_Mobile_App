import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:queuing_system/Class/CurrentQueuCardClass.dart';
import 'package:queuing_system/Variables/size.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import '../Config/Endpoint.dart';

class QueueCardLatestQueue extends StatefulWidget {
  const QueueCardLatestQueue({
    @required this.status,
    @required this.date,
    @required this.id,
    @required this.queuetype,
    @required this.userfcmToken,
    @required this.refresh,
    @required this.fullname,
    @required this.customertype,
    @required this.purpose,
  });
  final String status;
  final String queuetype;
  final String id;
  final String userfcmToken;
  final String fullname;
  final String customertype;
  final String purpose;
  final Function refresh;

  final DateTime date;
  @override
  _QueueCardLatestQueueState createState() => _QueueCardLatestQueueState(
      status: status,
      id: id,
      date: date,
      queuetype: queuetype,
      purpose: purpose,
      fullname: fullname,
      customertype: customertype,
      refresh: refresh,
      userfcmToken: userfcmToken);
}

class _QueueCardLatestQueueState extends State<QueueCardLatestQueue> {
  _QueueCardLatestQueueState({
    @required this.status,
    @required this.date,
    @required this.refresh,
    @required this.id,
    @required this.userfcmToken,
    @required this.queuetype,
    @required this.fullname,
    @required this.customertype,
    @required this.purpose,
  });
  String status;
  DateTime date;
  Function refresh;
  String queuetype;
  String userfcmToken;
  String id;
  String fullname;
  String purpose;

  String customertype;

  QueueCardClass queueClass = QueueCardClass();

  sendNotification_its_users_turn(String userToken) async {
    var pushnotif = await http.post(
        Uri.parse('${AppEndpoint.endPointDomain}/push-notification.php'),
        body: {
          "fcmtoken": userToken,
          "title": "Message",
          "body": "It's your turn. Please go to $queuetype window. Thank you"
        });
    print("e2e notif: ${pushnotif.body}");
  }

  sendNotification_queue_discarded(String userToken) async {
    var pushnotif = await http.post(
        Uri.parse('${AppEndpoint.endPointDomain}/push-notification.php'),
        body: {
          "fcmtoken": userToken,
          "title": "Message",
          "body": "Queue discarded"
        });
    print("e2e notif: ${pushnotif.body}");
  }

  update_status({@required String status}) async {
    try {
      var url =
          Uri.parse("${AppEndpoint.endPointDomain}/update-queue-status.php");
      var response = await http.post(url, body: {
        'queue_id': id,
        'status': status,
        'month': date.month.toString().length == 1
            ? "0${date.month.toString()}"
            : date.month.toString(),
        'year': date.year.toString(),
        'date': date.day.toString().length == 1
            ? "0${date.day.toString()}"
            : date.day.toString(),
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        if (status == "No Show") {
          sendNotification_queue_discarded(userfcmToken);
        }
        refresh();
      } else {}
      Navigator.of(context).pop();
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  Future<void> showDialogMessage({@required String confirmtype}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text("Mark this queue as '$confirmtype'?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                if (confirmtype == "Done") {
                  update_status(status: "Done");
                } else {
                  update_status(status: "No Show");
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[100],
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
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        sendNotification_its_users_turn(userfcmToken);
                      },
                      icon: Icon(
                        Icons.notification_add,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        showDialogMessage(confirmtype: "Done");
                      },
                      icon: Icon(
                        Icons.done_rounded,
                        color: Colors.green[300],
                      )),
                  IconButton(
                      onPressed: () {
                        showDialogMessage(confirmtype: "No Show");
                      },
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.red,
                      )),
                ],
              )
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
                "Status",
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
                "Queue type",
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
                "Purpose",
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 12,
              ),
              Text(
                "Name",
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
                  fullname,
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
                "Usertype",
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
                  customertype,
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

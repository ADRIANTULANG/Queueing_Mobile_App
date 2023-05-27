import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:queuing_system/Class/StringExtensions.dart';
import 'package:toast/toast.dart';

import '../Config/Endpoint.dart';
import 'package:http/http.dart' as http;

import '../Models/CashierHistoryModel.dart';
import '../Widgets/QueueCardForLatestQueue.dart';
import '../Widgets/QueueCardForPendingQueue.dart';

class CashierQRCodePage extends StatefulWidget {
  const CashierQRCodePage();
  // final UserDetailsModel userDetailsModel;
  @override
  _CashierQRCodePageState createState() => _CashierQRCodePageState();
}

class _CashierQRCodePageState extends State<CashierQRCodePage> {
  final box = GetStorage();
  List<CashierHistoryModel> latest_queue_list = <CashierHistoryModel>[];
  List<CashierHistoryModel> pending_queue = <CashierHistoryModel>[];
  @override
  void initState() {
    super.initState();
    getLatestQueue();
    getQueuesPending();
  }

  getLatestQueue() async {
    latest_queue_list.clear();
    try {
      var url = Uri.parse(
          "${AppEndpoint.endPointDomain}/get-latest-cashier-queue.php");
      var response = await http.post(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          var placeholder = await cashierHistoryModelFromJson(jsonEncode(data));
          setState(() {
            latest_queue_list = placeholder;
          });
          if (latest_queue_list.length != 0) {
            setCurrentlyServing(id: latest_queue_list[0].id);
          }
        }
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  getQueuesPending() async {
    pending_queue.clear();
    try {
      var url = Uri.parse(
          "${AppEndpoint.endPointDomain}/get-pending-cashier-queue.php");
      var response = await http.post(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          data.removeAt(0);
          var placeholder = await cashierHistoryModelFromJson(jsonEncode(data));
          setState(() {
            pending_queue = placeholder;
          });
        }
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  setCurrentlyServing({@required String id}) async {
    try {
      var url = Uri.parse(
          "${AppEndpoint.endPointDomain}/update-queue-currently-serving-cashier.php");
      var response = await http.post(url, body: {'queue_id': id});

      if (response.statusCode == 200) {
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  refresh() async {
    print("Called");
    getQueuesPending();
    getLatestQueue();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () => refresh(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Stack(
              children: <Widget>[
                latest_queue_list.isEmpty || latest_queue_list.length == 0
                    ? SizedBox()
                    : Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: QueueCardLatestQueue(
                          purpose: "Payment",
                          refresh: refresh,
                          userfcmToken: latest_queue_list[0].fcmToken,
                          status: latest_queue_list[0].status,
                          date: latest_queue_list[0].dateCreated,
                          id: latest_queue_list[0].id,
                          queuetype: latest_queue_list[0].queueType,
                          fullname: latest_queue_list[0]
                                  .firstname
                                  .capitalize()
                                  .toString() +
                              " " +
                              latest_queue_list[0]
                                  .lastname
                                  .capitalize()
                                  .toString(),
                          customertype: latest_queue_list[0].customertype,
                        )),
                Positioned(
                    bottom: 0,
                    top: 180,
                    left: 0,
                    right: 0,
                    child: Container(
                      child: ListView.builder(
                        itemCount: pending_queue.length,
                        itemBuilder: (BuildContext context, int index) {
                          return QueueCardPendingQueue(
                              refresh: refresh,
                              userfcmToken: pending_queue[0].fcmToken,
                              status: pending_queue[index].status,
                              date: pending_queue[index].dateCreated,
                              id: pending_queue[index].id,
                              queuetype: pending_queue[index].queueType);
                        },
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

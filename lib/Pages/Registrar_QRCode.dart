import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:queuing_system/Class/StringExtensions.dart';
import 'package:queuing_system/Widgets/QueueCardForPendingQueue.dart';
import 'package:toast/toast.dart';

import '../Config/Endpoint.dart';
import '../Models/RegistrarHistoryModel.dart';
import '../Widgets/QueueCardForLatestQueue.dart';

class RegistarQRCodePage extends StatefulWidget {
  const RegistarQRCodePage();
  // final UserDetailsModel userDetailsModel;
  @override
  _RegistarQRCodePageState createState() => _RegistarQRCodePageState();
}

class _RegistarQRCodePageState extends State<RegistarQRCodePage> {
  final box = GetStorage();
  List<RegistrarHistoryModel> latest_queue_list = <RegistrarHistoryModel>[];
  List<RegistrarHistoryModel> pending_queue = <RegistrarHistoryModel>[];
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
          "${AppEndpoint.endPointDomain}/get-latest-registrar-queue.php");
      var response = await http.post(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          var placeholder =
              await registrarHistoryModelFromJson(jsonEncode(data));
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
          "${AppEndpoint.endPointDomain}/get-pending-registrar-queue.php");
      var response = await http.post(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        if (data.length == 0 || data.isEmpty) {
        } else {
          data.removeAt(0);
          var placeholder =
              await registrarHistoryModelFromJson(jsonEncode(data));
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
          "${AppEndpoint.endPointDomain}/update-queue-currently-serving-registrar.php");
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
                          purpose: latest_queue_list[0].purpose,
                          fullname:
                              latest_queue_list[0].firstname.capitalize() +
                                  " " +
                                  latest_queue_list[0].lastname.capitalize(),
                          refresh: refresh,
                          userfcmToken: latest_queue_list[0].fcmToken,
                          status: latest_queue_list[0].status,
                          date: latest_queue_list[0].dateCreated,
                          id: latest_queue_list[0].id,
                          queuetype: latest_queue_list[0].queueType,
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
                              userfcmToken: pending_queue[index].fcmToken,
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../Config/Endpoint.dart';
import '../Models/QueueModel.dart';
import '../Widgets/QueueCardForCustomerHistory.dart';
// import 'package:queuing_system/Class/MainPageClass.dart';

class CustomerHistory extends StatefulWidget {
  @override
  _CustomerHistoryState createState() => _CustomerHistoryState();
}

class _CustomerHistoryState extends State<CustomerHistory> {
  final box = GetStorage();
  List<QueueModel> queue_list = <QueueModel>[];
  List<QueueModel> queue_list_all = <QueueModel>[];
  List<QueueModel> queue_list_currently_serving_for_Registrar = <QueueModel>[];
  List<QueueModel> queue_list_currently_serving_for_Cashier = <QueueModel>[];
  bool isLoading = true;
  String currently_Serving_id_for_Registrar = '';
  String currently_Serving_id_for_Cashier = '';
  @override
  void initState() {
    super.initState();
    print("Called");
    getHistory();
    getCurrentlyServing_registrar();
    getCurrentlyServing_cashier();
  }

  getHistory() async {
    try {
      var url =
          Uri.parse("${AppEndpoint.endPointDomain}/get-customer-history.php");
      var response =
          await http.post(url, body: {'customerid': box.read('id').toString()});

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          var listplaceholder = await queueModelFromJson(jsonEncode(data));
          await getAllQueue();

          setState(() {
            queue_list = listplaceholder;
            isLoading = false;
          });
        }
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  getAllQueue() async {
    try {
      var url = Uri.parse(
          "${AppEndpoint.endPointDomain}/get-customer-history-all.php");
      var response = await http.post(
        url,
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          var listplaceholder = await queueModelFromJson(jsonEncode(data));
          setState(() {
            queue_list_all = listplaceholder;
            isLoading = false;
          });
        }
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  getCurrentlyServing_registrar() async {
    DateTime date = DateTime.now();
    try {
      var url = Uri.parse(
          "${AppEndpoint.endPointDomain}/get-currently-serving-registrar.php");
      var response = await http.post(url, body: {
        'month': date.month.toString().length == 1
            ? "0${date.month.toString()}"
            : date.month.toString(),
        'year': date.year.toString(),
        'date': date.day.toString().length == 1
            ? "0${date.day.toString()}"
            : date.day.toString(),
      });

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          var listplaceholder = await queueModelFromJson(jsonEncode(data));
          setState(() {
            queue_list_currently_serving_for_Registrar = listplaceholder;
            isLoading = false;
            if (queue_list_currently_serving_for_Registrar.length != 0) {
              currently_Serving_id_for_Registrar =
                  queue_list_currently_serving_for_Registrar[0].id.toString();
            }
          });
        }
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  getCurrentlyServing_cashier() async {
    DateTime date = DateTime.now();
    try {
      var url = Uri.parse(
          "${AppEndpoint.endPointDomain}/get-currently-serving-cashier.php");
      var response = await http.post(url, body: {
        'month': date.month.toString().length == 1
            ? "0${date.month.toString()}"
            : date.month.toString(),
        'year': date.year.toString(),
        'date': date.day.toString().length == 1
            ? "0${date.day.toString()}"
            : date.day.toString(),
      });

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
        } else {
          var listplaceholder = await queueModelFromJson(jsonEncode(data));
          setState(() {
            queue_list_currently_serving_for_Cashier = listplaceholder;
            isLoading = false;
            if (queue_list_currently_serving_for_Cashier.length != 0) {
              currently_Serving_id_for_Cashier =
                  queue_list_currently_serving_for_Cashier[0].id.toString();
            }
          });
        }
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  // estimatedTime({@required String id}) async {
  //   int time = 0;
  //   bool isHit = false;
  //   for (var i = 0; i < queue_list.length; i++) {
  //     if (id == queue_list[i].id) {
  //       isHit = true;
  //     } else {
  //       if (isHit == true) {
  //       } else {
  //         time = time + 8;
  //       }
  //     }
  //   }
  //   print(Duration(minutes: time));
  //   return time.toString();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : RefreshIndicator(
              onRefresh: () => getHistory(),
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Currently Serving :",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).textScaleFactor * 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.08),
                            Text(
                              "Registrar :",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          15),
                            ),
                            Text(
                              currently_Serving_id_for_Registrar,
                              style: TextStyle(
                                  letterSpacing: 5,
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          25),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.08),
                            Text(
                              "Cashier :",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          15),
                            ),
                            Text(
                              currently_Serving_id_for_Cashier,
                              style: TextStyle(
                                  letterSpacing: 5,
                                  fontSize:
                                      MediaQuery.of(context).textScaleFactor *
                                          25),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ListView.builder(
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                        itemCount: queue_list.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: QueueCardForCustomer(
                                purpose: queue_list[index].purpose,
                                listall: queue_list_all,
                                index: index,
                                queuetype: queue_list[index].queueType,
                                id: queue_list[index].id,
                                date: queue_list[index].dateCreated,
                                status: queue_list[index].status,
                                // cardFor: "history",
                              ));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:queuing_system/Widgets/QueueCard.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../Config/Endpoint.dart';
import '../Models/RegistrarHistoryModel.dart';

class RegistartHistoryPage extends StatefulWidget {
  @override
  _RegistartHistoryPageState createState() => _RegistartHistoryPageState();
}

class _RegistartHistoryPageState extends State<RegistartHistoryPage> {
  List<RegistrarHistoryModel> history_queue = <RegistrarHistoryModel>[];

  @override
  void initState() {
    super.initState();
    getQueuesHistory();
  }

  getQueuesHistory() async {
    try {
      var url = Uri.parse(
          "${AppEndpoint.endPointDomain}/get-history-registrar-queue.php");
      var response = await http.post(url);

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        if (data.length == 0 || data.isEmpty) {
        } else {
          var placeholder =
              await registrarHistoryModelFromJson(jsonEncode(data));
          setState(() {
            history_queue = placeholder;
          });
        }
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () => getQueuesHistory(),
        child: Center(
          child: history_queue.length != 0
              ? ListView.builder(
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                  itemCount: history_queue.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: QueueCard(
                          index: index,
                          listall: [],
                          status: history_queue[index].status,
                          date: history_queue[index].dateCreated,
                          id: history_queue[index].id,
                          queuetype: history_queue[index].queueType,
                        ));
                  },
                )
              : Text("Create place holder here"),
        ),
      ),
    );
  }
}

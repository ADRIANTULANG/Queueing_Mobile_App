import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../Config/Endpoint.dart';

class CustomerScanner extends StatefulWidget {
  @override
  _CustomerScannerState createState() => _CustomerScannerState();
}

class _CustomerScannerState extends State<CustomerScanner> {
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isPause = false;
  String result = '';
  final box = GetStorage();

  String selectedValue = 'Viewing Grades';
  List<String> types = [
    'Viewing Grades',
    'Registering for Classes',
    'Updating Student Record',
    'Issuing Transcript and Diplomas',
    'Verifying Enrollment',
    'Changing Academic Records'
  ];

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  createQueue({@required String queue, @required String reasons}) async {
    try {
      var url = Uri.parse("${AppEndpoint.endPointDomain}/create-queue.php");
      var response = await http.post(url, body: {
        'queuetype': queue,
        'purpose': reasons,
        'customerid': box.read('id').toString()
      });

      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: const Text('Success!'),
        // ));
        Toast.show("Success", context,
            backgroundColor: Colors.blue, duration: 3, gravity: Toast.TOP);
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          backgroundColor: Colors.red, duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  check_if_there_is_pending_transaction(
      {@required String type, @required String reason}) async {
    try {
      String api = '';
      if (type == "cashier") {
        api = 'check-if-customer-is-pending-in-cashier.php';
      } else {
        api = 'check-if-customer-is-pending-in-registrar.php';
      }
      var url = Uri.parse("${AppEndpoint.endPointDomain}/$api");
      var response =
          await http.post(url, body: {'customerid': box.read('id').toString()});
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        if (data.length == 0 || data.isEmpty) {
        } else {
          print(data[0]['counts']);
          if (int.parse(data[0]['counts'].toString()) == 0) {
            if (type == 'cashier') {
              createQueue(queue: "cashier", reasons: "Payment");
            } else {
              createQueue(queue: "registrar", reasons: reason);
            }
          } else {
            Toast.show("You have Pending queue please wait.Thank you.", context,
                backgroundColor: Colors.red, duration: 3, gravity: Toast.TOP);
          }
        }
        return true;
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          backgroundColor: Colors.red, duration: 3, gravity: Toast.TOP);
      print(e);
      return false;
    }
  }

  Future<void> showPursposeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Please select purpose."),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.only(left: 10),
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton(
                      underline: SizedBox(),
                      isExpanded: true,
                      hint: Text(
                          'Please choose a location'), // Not necessary for Option 1
                      value: selectedValue,
                      onChanged: (newValue) {
                        setState(() {
                          selectedValue = newValue;
                        });
                      },
                      items: types.map((location) {
                        return DropdownMenuItem(
                          child: new Text(location),
                          value: location,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          }),
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
                check_if_there_is_pending_transaction(
                    type: "registrar", reason: selectedValue);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
              child: Container(
            child: Center(
              child: InkWell(
                onTap: () async {
                  if (isPause == true) {
                    await controller?.resumeCamera();
                    setState(() {
                      result = "";
                      isPause = false;
                    });
                  } else {
                    await controller?.pauseCamera();
                    setState(() {
                      result = "";
                      isPause = true;
                    });
                  }
                },
                child: Container(
                  child: isPause == true
                      ? Icon(
                          Icons.play_arrow,
                          size: 50,
                        )
                      : Icon(
                          Icons.pause,
                          size: 50,
                        ),
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.blueAccent,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      // await controller?.pauseCamera();
      result = scanData.code;
      if (result != '') {
        setState(() {
          isPause = true;
        });
        print("code: ${result}");
        await controller?.pauseCamera();
        if (result.trim() == "registrar") {
          showPursposeDialog();
        } else if (result.trim() == "cashier") {
          check_if_there_is_pending_transaction(
              type: "cashier", reason: "Payment");
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

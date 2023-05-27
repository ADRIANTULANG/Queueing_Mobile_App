import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:queuing_system/Pages/MainPage.dart';
import 'package:queuing_system/Widgets/CustomElevatedButton.dart';
import 'package:queuing_system/Widgets/SubPagesAppBar.dart';
import 'package:queuing_system/Widgets/TextField.dart';
// import 'package:queuing_system/transitions/slide_route.dart';
// import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../Config/Endpoint.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController username_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  TextEditingController confirm_password_controller = TextEditingController();
  TextEditingController firsttname_controller = TextEditingController();
  TextEditingController lastname_controller = TextEditingController();
  TextEditingController contactnumber_controller = TextEditingController();
  TextEditingController age_controller = TextEditingController();
  TextEditingController state_controller = TextEditingController();
  TextEditingController province_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();

  register(
      {@required String username,
      @required String password,
      @required String customertype,
      @required String firstname,
      @required String lastname,
      @required String age,
      @required String address,
      @required String phoneno}) async {
    try {
      var url = Uri.parse("${AppEndpoint.endPointDomain}/register.php");
      var response = await http.post(url, body: {
        'username': username,
        'password': password,
        'firstname': firstname,
        'lastname': lastname,
        'age': age,
        'address': address,
        'phoneno': phoneno,
        'usertype': 'customer',
        'customertype': customertype
      });

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Toast.show("Successfully Created", context,
            duration: 3, gravity: Toast.TOP);
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  check_if_number_exist({@required String phoneno}) async {
    try {
      var url =
          Uri.parse("${AppEndpoint.endPointDomain}/check-if-number-exist.php");
      var response = await http.post(url, body: {
        'number': phoneno,
      });

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];
        print(int.parse(data[0]['count'].toString()));
        if (int.parse(data[0]['count'].toString()) == 0) {
          return false;
        } else {
          Toast.show("Phone no. Already exist.", context,
              backgroundColor: Colors.red, duration: 3, gravity: Toast.TOP);
          return true;
        }
      } else {
        return true;
      }
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
      return true;
    }
  }

  String selectedValue = 'Student';
  List<String> types = ['Student', 'Guardian'];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: SubPagesAppBar(
            title: "Registration",
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          child: ListView(
            padding: EdgeInsets.all(15),
            primary: false,
            children: [
              Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Login Details',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Container(
                          height: 180,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MyTextField(
                                controller: username_controller,
                                hintText: "Email",
                                keyboardType: null,
                                inputFormatter: [],
                              ),
                              MyTextField(
                                controller: password_controller,
                                hintText: "Password",
                                keyboardType: null,
                                inputFormatter: [],
                              ),
                              MyTextField(
                                controller: confirm_password_controller,
                                hintText: "Confirm Password",
                                keyboardType: null,
                                inputFormatter: [],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ////////////////////////////////////////////////////////////////////////
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'User Details',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Container(
                          height: 240,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      controller: firsttname_controller,
                                      hintText: "First name",
                                      keyboardType: null,
                                      inputFormatter: [],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: MyTextField(
                                      controller: lastname_controller,
                                      hintText: "Last name",
                                      keyboardType: null,
                                      inputFormatter: [],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      controller: contactnumber_controller,
                                      hintText: "Contact Number",
                                      keyboardType: null,
                                      inputFormatter: [],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    width: 100,
                                    child: MyTextField(
                                      controller: age_controller,
                                      hintText: "Age",
                                      keyboardType: null,
                                      inputFormatter: [],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyTextField(
                                      controller: state_controller,
                                      hintText: "State",
                                      keyboardType: null,
                                      inputFormatter: [],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: MyTextField(
                                      controller: province_controller,
                                      hintText: "Province",
                                      keyboardType: null,
                                      inputFormatter: [],
                                    ),
                                  ),
                                ],
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
                              MyTextField(
                                controller: address_controller,
                                hintText: "Complete address",
                                keyboardType: null,
                                inputFormatter: [],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ////////////////////////////////////////////////////////////////////////
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: CustomElevatedButton(
                        title: "REGISTER",
                        onTap: () async {
                          if (username_controller.text.isEmpty ||
                              password_controller.text.isEmpty ||
                              confirm_password_controller.text.isEmpty ||
                              firsttname_controller.text.isEmpty ||
                              lastname_controller.text.isEmpty ||
                              contactnumber_controller.text.isEmpty ||
                              age_controller.text.isEmpty ||
                              state_controller.text.isEmpty ||
                              province_controller.text.isEmpty ||
                              address_controller.text.isEmpty) {
                            Toast.show("Missing fields", context,
                                backgroundColor: Colors.red,
                                duration: 3,
                                gravity: Toast.BOTTOM);
                          } else if (password_controller.text !=
                              confirm_password_controller.text) {
                            print("dont match");

                            Toast.show("Password not match", context,
                                backgroundColor: Colors.red,
                                duration: 3,
                                gravity: Toast.BOTTOM);
                          } else {
                            print("register");
                            bool isExist = await check_if_number_exist(
                                phoneno: contactnumber_controller.text);
                            if (isExist == false) {
                              register(
                                  customertype: selectedValue.toString(),
                                  username: username_controller.text,
                                  password: password_controller.text,
                                  firstname: firsttname_controller.text,
                                  lastname: lastname_controller.text,
                                  age: age_controller.text,
                                  address: state_controller.text +
                                      " " +
                                      province_controller.text +
                                      " " +
                                      address_controller.text,
                                  phoneno: contactnumber_controller.text);
                            }
                          }
                          // if (registration.validate("fields")) {
                          //   registration.processRegistration(context).then((isRegistered){
                          //     if (isRegistered) {
                          //       print("User created........");
                          //       Navigator.pop(context);
                          //       Navigator.pushReplacement(context, SlideRightRoute(page: MainPage()));
                          //     }
                          //   });
                          // } else {
                          //   Toast.show(registration.validate("message"), context, duration: 4, gravity: Toast.BOTTOM);
                          // }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

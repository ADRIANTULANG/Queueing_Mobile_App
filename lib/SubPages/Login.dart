import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:queuing_system/Methods/Style.dart';
import 'package:queuing_system/Pages/MainPage.dart';
import 'package:queuing_system/SubPages/Registration.dart';
import 'package:queuing_system/Variables/color.dart';
import 'package:queuing_system/Widgets/ShowAlertDialogForgotPass.dart';
import 'package:queuing_system/transitions/slide_route.dart';
import 'package:queuing_system/Widgets/TextField.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../Config/Endpoint.dart';
import '../Models/UserModel.dart';
import '../Variables/global.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final box = GetStorage();
  TextEditingController username_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  login({String username, String password}) async {
    List<UserModel> userModel = <UserModel>[];
    try {
      var url = Uri.parse("${AppEndpoint.endPointDomain}/login.php");
      var response = await http
          .post(url, body: {'username': username, 'password': password});

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body)['data'];

        if (data.length == 0 || data.isEmpty) {
          Toast.show("Invalid username or password", context,
              duration: 3, gravity: Toast.TOP);
        } else {}
        var modeledData = await userModelFromJson(jsonEncode(data));
        userModel = modeledData;
        box.write("id", userModel[0].id);
        box.write("username", userModel[0].username);
        box.write("password", userModel[0].password);
        box.write("firstname", userModel[0].firstname);
        box.write("lastname", userModel[0].lastname);
        box.write("address", userModel[0].address);
        box.write("phoneno", userModel[0].phoneno);
        box.write("usertype", userModel[0].usertype);

        box.write("age", userModel[0].age);
        box.write("image", userModel[0].image);
        setState(() {
          userType = userModel[0].usertype;
        });
        await updateUserToken(userModel[0].id);
        Navigator.pushReplacement(context, SlideRightRoute(page: MainPage()));
      } else {}
    } on Exception catch (e) {
      Toast.show("Something is wrong check internet connection", context,
          duration: 3, gravity: Toast.TOP);
      print(e);
    }
  }

  updateUserToken(String id) async {
    await http.post(Uri.parse("${AppEndpoint.endPointDomain}/update-token.php"),
        body: {'fcmToken': box.read('fcmToken'), 'id': id});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundColor(),
        child: ListView(
          primary: false,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(height: 35),
                    Container(
                      height: 180,
                      width: 180,
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 50),
                    MyTextField(
                      controller: username_controller,
                      hintText: "Username",
                      keyboardType: null,
                      inputFormatter: [],
                    ),
                    SizedBox(height: 25),
                    MyTextField(
                      controller: password_controller,
                      hintText: "Password",
                      keyboardType: null,
                      inputFormatter: [],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => showAlertForgotPassword(context),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Container(
                      height: 40.0,
                      child: ElevatedButton(
                        onPressed: () {
                          if (username_controller.text.isEmpty ||
                              password_controller.text.isEmpty) {
                            // Toast.show("Invalid username or password", context);
                            Toast.show("Invalid username or password", context,
                                duration: 3, gravity: Toast.TOP);
                          } else {
                            login(
                                username: username_controller.text,
                                password: password_controller.text);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: (RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0))),
                            padding: EdgeInsets.all(0.0)),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  secondaryColorLight.withOpacity(0.8),
                                  primaryColorLight.withOpacity(0.1)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30.0)),
                          child: Container(
                            constraints: BoxConstraints(
                                maxWidth: 300.0, minHeight: 50.0),
                            alignment: Alignment.center,
                            child: Text(
                              "LOGIN",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Don\'t have an account? ',
                        ),
                        TextSpan(
                          text: 'Sign up here!',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: primaryColor,
                              fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.push(context,
                                SlideRightRoute(page: RegistrationPage())),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

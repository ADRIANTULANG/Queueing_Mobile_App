// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:queuing_system/Models/UserModel.dart';
import 'package:queuing_system/Pages/Customer_CreateUser.dart';
// import 'package:queuing_system/Pages/Registrar_HistoryPage.dart';
import 'package:queuing_system/Pages/Registrar_HistoryPage.dart';
import 'package:queuing_system/Pages/ProfilePage.dart';
import 'package:queuing_system/Pages/Registrar_QRCode.dart';
import 'package:queuing_system/Pages/Customer_Scanner.dart';

import 'package:queuing_system/Presentation/custom_icons_icons.dart';

import '../Pages/Cashier_HistoryPage.dart';
import '../Pages/Cashier_QRCode.dart';

String userType = "";

ValueNotifier<String> pageTitle = ValueNotifier("");

String token = '';
// var db = FirebaseFirestore.instance;
// FirebaseAuth auth = FirebaseAuth.instance;
// User loggedUser;
// FirebaseMessaging messaging = new FirebaseMessaging();

// ValueNotifier<UserDetailsModel> myUserDetails =
//     ValueNotifier<UserDetailsModel>(UserDetailsModel('', {}));

List<Widget> pagesForRegistar = [
  RegistartHistoryPage(),
  RegistarQRCodePage(),
  ProfilePage()
];

List<Widget> pagesForCashier = [
  CashierHistoryPage(),
  CashierQRCodePage(),
  ProfilePage()
];
List<Widget> pagesForCustomer = [
  CustomerHistory(),
  CustomerScanner(),
  ProfilePage()
];

List<Widget> tabsForRegistrar = [
  Tab(child: Icon(CustomIcons.history2)),
  Tab(child: Icon(CustomIcons.qr_1)),
  Tab(child: Icon(CustomIcons.profile)),
];

List<Widget> tabsForCashier = [
  Tab(child: Icon(CustomIcons.history2)),
  Tab(child: Icon(CustomIcons.qr_1)),
  Tab(child: Icon(CustomIcons.profile)),
];

List<Widget> tabsForCustomer = [
  Tab(child: Icon(CustomIcons.history2)),
  Tab(child: Icon(CustomIcons.qr_1)),
  Tab(child: Icon(CustomIcons.profile)),
];

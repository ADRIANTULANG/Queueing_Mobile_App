import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:queuing_system/Class/MainPageClass.dart';
import 'package:queuing_system/Methods/Style.dart';
import 'package:queuing_system/Variables/global.dart';
import 'package:queuing_system/Widgets/BottomNavigation.dart';
import 'package:queuing_system/Widgets/CustomAppBar.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  MainPageClass root = MainPageClass();
  final box = GetStorage();

  @override
  void initState() {
    final box = GetStorage();
    pageTitle.addListener(() {
      if (!root.isDispose) {
        setState(() {});
      }
    });
    //pageTitle.value = "QR Code";
    root.tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    if (box.read('usertype') != null) {
      userType = box.read('usertype');
      if (userType == "customer") {
        pageTitle.value = "Scan";
      } else if (userType == "registrar") {
        pageTitle.value = "Queue";
      } else {
        pageTitle.value = "Queue";
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    root.isDispose = true;
    pageTitle.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0),
            child: AppBar(
              centerTitle: true,
              elevation: 0,
              automaticallyImplyLeading: true,
            )),
        bottomNavigationBar: BottomNavigation(
          tabController: root.tabController,
        ),
        body: SafeArea(
          child: Container(
            decoration: backgroundColor(),
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: <Widget>[
                CustomAppBar(),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: box.read('usertype') == "customer"
                        ? pagesForCustomer
                        : box.read('usertype') == "registrar"
                            ? pagesForRegistar
                            : pagesForCashier,
                    controller: root.tabController,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:queuing_system/Class/BottomNavigationClass.dart';
import 'package:queuing_system/Variables/color.dart';
import 'package:queuing_system/Variables/global.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    @required this.tabController,
  });

  final TabController tabController;
  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  BottomNavigationClass navigation = BottomNavigationClass();
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        color: primaryDarkColor,
        child: TabBar(
          onTap: (index) => navigation.onTapTabBar(index),
          controller: widget.tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          // unselectedLabelColor: Color(0xff9d9d9d),
          unselectedLabelColor: Colors.white,
          tabs: box.read('usertype') == "customer"
              ? tabsForCustomer
              : box.read('usertype') == "registrar"
                  ? tabsForRegistrar
                  : tabsForCashier,
        ));
  }
}

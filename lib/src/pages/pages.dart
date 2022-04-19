import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../generated/l10n.dart';
import '../elements/DrawerWidget.dart';
import '../models/route_argument.dart';
import '../pages/markets.dart';
import '../pages/messages.dart';
import '../pages/orders.dart';
import '../pages/profile.dart';
import '../pages/settings.dart';

// ignore: must_be_immutable
class PagesTestWidget extends StatefulWidget {
  dynamic currentTab;
  DateTime currentBackPressTime;
  RouteArgument routeArgument;
  Widget currentPage = OrdersWidget();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  PagesTestWidget({
    Key key,
    this.currentTab,
  }) {
    if (currentTab != null) {
      if (currentTab is RouteArgument) {
        routeArgument = currentTab;
        currentTab = int.parse(currentTab.id);
      }
    } else {
      currentTab = 2;
    }
  }

  @override
  _PagesTestWidgetState createState() {
    return _PagesTestWidgetState();
  }
}

class _PagesTestWidgetState extends State<PagesTestWidget> {
  initState() {
    super.initState();
    _selectTab(widget.currentTab);
  }

  @override
  void didUpdateWidget(PagesTestWidget oldWidget) {
    _selectTab(oldWidget.currentTab);
    super.didUpdateWidget(oldWidget);
  }

  void _selectTab(int tabItem) {
    setState(() {
      widget.currentTab = tabItem; // == 3 ? 1 : tabItem;
      switch (tabItem) {
        case 0:
          widget.currentPage = ProfileWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 1:
          widget.currentPage = MarketsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 2:
          widget.currentPage = OrdersWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 3:
          widget.currentPage = MessagesWidget(parentScaffoldKey: widget.scaffoldKey); //FavoritesWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
        case 4:
          widget.currentPage = SettingsWidget(parentScaffoldKey: widget.scaffoldKey);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        key: widget.scaffoldKey,
        drawer: DrawerWidget(),
        body: widget.currentPage,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).accentColor,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          iconSize: 22,
          elevation: 0,
          backgroundColor: Colors.transparent,
          selectedIconTheme: IconThemeData(size: 28),
          unselectedItemColor: Theme.of(context).focusColor.withOpacity(1),
          currentIndex: widget.currentTab,
          onTap: (int i) {
            print(i);
            this._selectTab(i);
          },
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: Image.asset("assets/img/profile.png",height: 25,width: 25,color: widget.currentTab == 0 ? Theme.of(context).accentColor:Colors.black),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/img/my_stores.png",height: 25,width: 25,color: widget.currentTab == 1 ? Theme.of(context).accentColor:Colors.black),
              label: '',
            ),

            BottomNavigationBarItem(
                label: '',
                icon: Container(
                  width: 42,
                  height: 42,
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.only(bottom: 5),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 40, offset: Offset(0, 15)),
                      BoxShadow(color: Theme.of(context).accentColor.withOpacity(0.4), blurRadius: 13, offset: Offset(0, 3))
                    ],
                  ),
                  child: Image.asset("assets/img/home.png",height: 20,width: 20,color: widget.currentTab == 2 ? Theme.of(context).primaryColor:Theme.of(context).primaryColor.withOpacity(1)),
                )),
            BottomNavigationBarItem(
              icon: Image.asset("assets/img/messages.png",height: 25,width: 25,color: widget.currentTab == 3 ? Theme.of(context).accentColor:Colors.black),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/img/settings.png",height: 25,width: 25,color: widget.currentTab == 4 ? Theme.of(context).accentColor:Colors.black),
              label: '',
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (widget.currentBackPressTime == null || now.difference(widget.currentBackPressTime) > Duration(seconds: 2)) {
      widget.currentBackPressTime = now;
      Fluttertoast.showToast(msg: S.of(context).tapBackAgainToLeave);
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }
}

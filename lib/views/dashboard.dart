// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:rentit4me/views/bottomNavigation.dart';
import 'package:rentit4me/views/home_screen.dart';
import 'package:rentit4me/views/offer_made_screen.dart';
import 'package:rentit4me/views/tabItem.dart';

class Dashboard extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 0;
  // list tabs here
  final List<TabItem> tabs = [
    TabItem(
      tabName: "Dashboard",
      icon: Icons.list,
      page: HomeScreen(),
    ),
    TabItem(
      tabName: "Offer Made",
      icon: Icons.list,
      page: OfferMadeScreen(),
    ),
    // TabItem(
    //   tabName: "Cart",
    //   icon: Icons.list,
    //   page: CategoryScreen(),
    // ),
    // TabItem(
    //   tabName: "Campaign",
    //   icon: Icons.list,
    //   page: CampaignScreen(),
    // ),
    // TabItem(
    //   tabName: "Help",
    //   icon: Icons.list,
    //   page: HelpScreen(),
    // ),
  ];

  DashboardState() {
    // indexing is necessary for proper funcationality
    // of determining which tab is active
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  // sets current tab index
  // and update state
  void _selectTab(int index) {
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState?.popUntil((route) => route.isFirst);
    } else {
      // update the state
      // in order to repaint

      setState(() => currentTab = index);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope handle android back btn
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await tabs[currentTab].key.currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (currentTab != 0) {
            // select 'main' tab
            _selectTab(0);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      // this is the base scaffold
      // don't put appbar in here otherwise you might end up
      // with multiple appbars on one screen
      // eventually breaking the app
      child: Scaffold(
          // indexed stack shows only one child
          body: IndexedStack(
            index: currentTab,
            children: tabs.map((e) => e.page).toList(),
          ),
          // Bottom navigation

          bottomNavigationBar: BottomNavigation(
            onSelectTab: _selectTab,
            tabs: tabs,
          )),
    );
  }
}

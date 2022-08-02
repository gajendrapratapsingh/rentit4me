// ignore_for_file: use_key_in_widget_constructors

import 'dashboard.dart';
import 'package:flutter/material.dart';
import 'tabItem.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({
    this.onSelectTab,
    this.tabs,
  });
  final ValueChanged<int> onSelectTab;
  final List<TabItem> tabs;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        selectedItemColor: Colors.black, currentIndex: DashboardState.currentTab,
        unselectedItemColor: Colors.grey,
        // elevation: 10,

        selectedFontSize: 12,
        items: tabs
            .map(
              (e) => _buildItem(
                index: e.getIndex(),
                icon: e.icon,
                tabName: e.tabName,
              ),
            )
            .toList(),
        onTap: (index) => onSelectTab(
          index,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(
      {int index, IconData icon, String tabName}) {
    // if (index == 2) {
    //   return BottomNavigationBarItem(
    //       icon: Positioned(
    //         bottom: 10,
    //         child: const CircleAvatar(
    //           radius: 20,
    //           child: const Icon(Icons.add),
    //         ),
    //       ),
    //       label: tabName);
    // } else {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Icon(
          icon,
          shadows: DashboardState.currentTab == index
              ? [
                  Shadow(
                      blurRadius: 0.5,
                      color: Colors.white,
                      offset: Offset(0, 0.5)),
                  Shadow(
                      blurRadius: 0.5,
                      color: Colors.white,
                      offset: Offset(0.5, 0.5)),
                  Shadow(
                      blurRadius: 0.5,
                      color: Colors.white,
                      offset: Offset(0.5, 0)),
                  // Shadow(
                  //     blurRadius: 10, color: Colors.white, offset: Offset(0, 1))
                ]
              : [],
          color:
              DashboardState.currentTab == index ? Colors.black : Colors.grey,
          size: 22,
        ),
      ),
      label: tabName,
    );
    // }
  }

  Color _tabColor({int index}) {
    return DashboardState.currentTab == index ? Colors.cyan : Colors.grey;
  }
}

import 'package:flutter/material.dart';
import 'package:mulaidulu_app/view/coba_event_view.dart';
import 'package:mulaidulu_app/view/event_view.dart';
import 'package:mulaidulu_app/view/new_event_view.dart';
import 'package:mulaidulu_app/view/task_view.dart';
import 'package:mulaidulu_app/view_model/my_app_bar.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  PageController _pageController = PageController();
  List<Widget> _screen = [
    TaskView(),
    EventView(),
  ];

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  void _selectedItem(String selectedItem) {
    print(selectedItem);
  }

  int lastIndex = 1;

  void _selectedTab(int index) {
    print(index);
    print(lastIndex);
    if (index == 0) {
      if (isDrawerOpen) {
        setState(() {
          xOffset = 0;
          yOffset = 0;
          scaleFactor = 1;
          isDrawerOpen = false;
        });
      } else {
        setState(() {
          xOffset = 230;
          yOffset = 150;
          scaleFactor = 0.6;
          isDrawerOpen = true;
        });
      }
    } else if (index == 3) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              color: Color(0xFF737373),
              height: 100,
              child: Container(
                child: _buildSettingMenu(),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                ),
              ),
            );
          });
    } else {
      _pageController.jumpToPage(index-1);
      lastIndex = index;
    }
  }

  Column _buildSettingMenu() {
    if (lastIndex == 1) {
      return Column(children: <Widget>[
        ListTile(
          leading: Icon(Icons.add_circle),
          title: Text('Test'),
          onTap: () => _selectedItem('Test'),
        ),
      ]);
    } else {
      return Column(children: <Widget>[
        ListTile(
          leading: Icon(Icons.add_circle),
          title: Text('Test 2'),
          onTap: () => _selectedItem('Test 2'),
        ),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor)
        ..rotateY(isDrawerOpen ? -0.5 : 0),
      duration: Duration(milliseconds: 250),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0),
        child: Container(
          child: Scaffold(
            body: PageView(
              controller: _pageController,
              children: _screen,
              physics: NeverScrollableScrollPhysics(),
            ),
            bottomNavigationBar: MyAppBar(
              color: Colors.grey,
              selectedColor: Colors.red,
              notchedShape: CircularNotchedRectangle(),
              onTabSelected: _selectedTab,
              // onTabSelected: _onItemTapped,
              items: [
                isDrawerOpen
                    ? MyAppBarItem(iconData: Icons.arrow_forward)
                    : MyAppBarItem(iconData: Icons.menu),
                MyAppBarItem(iconData: Icons.assignment_turned_in),
                MyAppBarItem(iconData: Icons.event_note),
                MyAppBarItem(iconData: Icons.more_vert),
              ],
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              tooltip: 'Increment',
              child: Icon(Icons.add),
              elevation: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mulaidulu_app/view/dashboard_view.dart';
import 'package:mulaidulu_app/view/home_view.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DashboardView(),
          HomeView(),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  List<Map> drawerItems=[
    {
      'icon': Icons.home,
      'title' : 'Profile'
    },
    {
      'icon': Icons.settings,
      'title' : 'Settings'
    },
    {
      'icon': Icons.subdirectory_arrow_left,
      'title' : 'Logout'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      padding: EdgeInsets.only(top: 50, bottom: 40, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 35,),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tirta Yudha Hernanda',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text('tirtayudhahernanda@gmail.com',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14))
                ],
              )
            ],
          ),
          Column(
            children: drawerItems.map((element) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(element['icon'],color: Colors.white,size: 25,),
                  SizedBox(width: 10,),
                  Text(element['title'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20))
                ],

              ),
            )).toList(),
          ),
          Row(
            children: [
              // Icon(
              //   Icons.keyboard_arrow_right,
              //   color: Colors.white,
              // ),
              Text(
                'Nama Aplikasi |',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Apa aja dah',
                style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          )
        ],
      ),
    );
  }
}

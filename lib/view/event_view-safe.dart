import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventView extends StatefulWidget {
  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 180),
            child: Column(
              children: List.generate(
                24,
                    (index) => cardWidget(
                      indexTime: index,
                    ),
              ),
            ),
          ),
          Container(
            color: Color(0xff5b418f),
            padding: EdgeInsets.all(16),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  headerTop(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(top: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        14,
                        (index) => dateWidget(
                          index: index,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class cardWidget extends StatelessWidget {
  final indexTime;
  const cardWidget({
    Key key, this.indexTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            children: <Widget>[
              Text(
                ((indexTime < 10)? "0${0+indexTime}.00":"${0+indexTime}.00"),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              lineGen(
                lines: [40.0, 20.0, 40.0],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Container(
            width: 100,
            height: 110,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                bottomLeft: Radius.circular(8.0),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 6),
              padding: EdgeInsets.only(left: 12, top: 4),
              color: Colors.deepPurple[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 21,
                    child: Row(
                      children: <Widget>[
                        Text("13.00 - 12.45"),
                        VerticalDivider(
                          width: 16,
                          thickness: 2,
                          color: Colors.black54,
                        ),
                        Text("Gak tau isi apa"),
                      ],
                    ),
                  ),
                  Text(
                    "Judul schedule",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class lineGen extends StatelessWidget {
  final lines;

  const lineGen({
    Key key,
    this.lines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        3,
        (index) => Container(
            height: 2,
            width: lines[index],
            color: Colors.black26,
            margin: EdgeInsets.symmetric(vertical: 16)),
      ),
    );
  }
}

class headerTop extends StatelessWidget {
  const headerTop({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Daily',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Schedule',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            'January',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class dateWidget extends StatefulWidget {
  final index;
  const dateWidget({
    Key key, this.index,
  }) : super(key: key);
  @override
  _dateWidgetState createState() => _dateWidgetState();
}

class _dateWidgetState extends State<dateWidget> {
  bool _selectedDate = true;
  var listDay = ["Mon", "Tu", "We", "Th", "Fr", "Sat","Sun","Mon", "Tu", "We", "Th", "Fr", "Sat","Sun",];


  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDate = !_selectedDate;
          });
        },
        child: Container(
          decoration: _selectedDate
              ? null
              : BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
          padding: EdgeInsets.only(top:8,bottom: 8,right: 16,left: 16),
          child: Column(
            children: <Widget>[
              Text(
                listDay[widget.index],
                style: TextStyle(
                  color: _selectedDate ? Colors.white60 : Colors.white,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                "${10 + widget.index}",
                style: TextStyle(
                  fontWeight:
                      _selectedDate ? FontWeight.normal : FontWeight.bold,
                  color: _selectedDate ? Colors.white60 : Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _selectedDate ? Colors.white60 : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

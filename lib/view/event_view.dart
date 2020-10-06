import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:table_calendar/table_calendar.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

class EventView extends StatefulWidget {
  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView> with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;
  CalendarController _calendarControllerNew;
  String currentMonth = DateFormat.yMMMM().format(DateTime.now());
  String selectedMonth;
  DateTime pickedDate;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    pickedDate = _selectedDay;

    _events = {
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
        'Event B0',
        'Event C0'
      ],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): [
        'Event A2',
        'Event B2',
        'Event C2',
        'Event D2'
      ],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): [
        'Event A4',
        'Event B4',
        'Event C4'
      ],
      _selectedDay.subtract(Duration(days: 4)): [
        'Event A5',
        'Event B5',
        'Event C5'
      ],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): [
        'Event A8',
        'Event B8',
        'Event C8',
        'Event D8'
      ],
      _selectedDay.add(Duration(days: 3)):
          Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): [
        'Event A10',
        'Event B10',
        'Event C10'
      ],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): [
        'Event A12',
        'Event B12',
        'Event C12',
        'Event D12'
      ],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): [
        'Event A14',
        'Event B14',
        'Event C14'
      ],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _calendarControllerNew = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    _calendarControllerNew.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    selectedMonth = DateFormat.yMMMM().format(day);
    if (selectedMonth != currentMonth) {
      currentMonth = selectedMonth;
    }
    print('CALLBACK: _onDaySelected $selectedMonth');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    selectedMonth = DateFormat.yMMMM().format(first);
    if (selectedMonth != currentMonth) {
      setState(() {
        currentMonth = selectedMonth;
      });
    }
    print('CALLBACK: _onVisibleDaysChanged $selectedMonth');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  void _onDaySelectedNew(DateTime day, List events) {
    Navigator.pop(context);
    print('CALLBACK: _onDaySelected $selectedMonth');
    setState(() {
      _selectedEvents = events;
      _calendarController.setSelectedDay(
        DateTime(day.year,day.month,day.day),
        runCallback: true,
      );
    });
  }

  void _onVisibleDaysChangedNew(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged $selectedMonth');
  }

  void _onCalendarCreatedNew(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

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
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
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
                        RichText(
                          text: TextSpan(
                              text: currentMonth,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // _pickDate();
                                  _askedToLead();
                                },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // headerTop(stringMonth: currentMonth),
                  Container(child: _buildTableCalendarWithBuilders()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
      locale: 'en_US',
      calendarController: _calendarControllerNew,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        outsideStyle: TextStyle().copyWith(
          color: Color(0xFF9E9E9E),
          fontSize: 18,
        ),
        outsideHolidayStyle: TextStyle().copyWith(
          color: Color(0xFFEF9A9A),
          fontSize: 18,
        ),
        outsideWeekendStyle: TextStyle().copyWith(
          color: Color(0xFFEF9A9A),
          fontSize: 18,
        ),
        weekdayStyle: TextStyle().copyWith(
            color: Colors.black,
            // fontWeight: FontWeight.bold,
            fontSize: 20),
        weekendStyle: TextStyle().copyWith(
            color: Color(0xFFF44336),
            // fontWeight: FontWeight.bold,
            fontSize: 20),
        holidayStyle: TextStyle().copyWith(
            color: Color(0xFFF44336),
            // fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle().copyWith(
            color: Colors.black,
            // fontWeight: FontWeight.bold,
            fontSize: 14),
        weekendStyle: TextStyle().copyWith(
            color: Color(0xFFF44336),
            // fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle().copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      builders: CalendarBuilders(
        // dayBuilder: (context,date, _){
        //   return Container(
        //     margin: const EdgeInsets.all(4.0),
        //     padding: const EdgeInsets.only(top: 5.0, left: 6.0),
        //     width: 100,
        //     height: 100,
        //     child: Text(
        //       '${date.day}',
        //       style: TextStyle().copyWith(fontSize: 16.0,color: Colors.white),
        //     ),
        //   );
        // },
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelectedNew(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChangedNew,
      onCalendarCreated: _onCalendarCreatedNew,
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'en_US',
      calendarController: _calendarController,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.week,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        outsideStyle: TextStyle().copyWith(
          color: Color(0xFF9E9E9E),
          fontSize: 18,
        ),
        outsideHolidayStyle: TextStyle().copyWith(
          color: Color(0xFFEF9A9A),
          fontSize: 18,
        ),
        outsideWeekendStyle: TextStyle().copyWith(
          color: Color(0xFFEF9A9A),
          fontSize: 18,
        ),
        weekdayStyle: TextStyle().copyWith(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            fontSize: 20),
        weekendStyle: TextStyle().copyWith(
            color: Color(0xFFF44336),
            // fontWeight: FontWeight.bold,
            fontSize: 20),
        holidayStyle: TextStyle().copyWith(
            color: Color(0xFFF44336),
            // fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle().copyWith(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            fontSize: 14),
        weekendStyle: TextStyle().copyWith(
            color: Color(0xFFF44336),
            // fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
      headerVisible: false,
      builders: CalendarBuilders(
        // dayBuilder: (context,date, _){
        //   return Container(
        //     margin: const EdgeInsets.all(4.0),
        //     padding: const EdgeInsets.only(top: 5.0, left: 6.0),
        //     width: 100,
        //     height: 100,
        //     child: Text(
        //       '${date.day}',
        //       style: TextStyle().copyWith(fontSize: 16.0,color: Colors.white),
        //     ),
        //   );
        // },
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildButtons() {
    final dateTime = _events.keys.elementAt(_events.length - 2);

    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              child: Text('Month'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.month);
                });
              },
            ),
            RaisedButton(
              child: Text('2 weeks'),
              onPressed: () {
                setState(() {
                  _calendarController
                      .setCalendarFormat(CalendarFormat.twoWeeks);
                });
              },
            ),
            RaisedButton(
              child: Text('Week'),
              onPressed: () {
                setState(() {
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        RaisedButton(
          child: Text(
              'Set day ${dateTime.day}-${dateTime.month}-${dateTime.year}'),
          onPressed: () {
            _calendarController.setSelectedDay(
              DateTime(dateTime.year, dateTime.month, dateTime.day),
              runCallback: true,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year-5),
      lastDate: DateTime(DateTime.now().year+5),
      initialDate: pickedDate,
      helpText: 'Select date', // Can be used as title
      cancelText: 'CANCEL',
      confirmText: 'OK',
      fieldLabelText: 'Enter date',
      fieldHintText: 'Month/Date/Year',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(), // This will change to light theme.
          child: child,
        );
      },
    );

    if(date != null)
      setState(() {
        pickedDate = date;
        _calendarController.setSelectedDay(
          DateTime(pickedDate.year,pickedDate.month,pickedDate.day),
          runCallback: true,
        );
      });

  }

  Future<void> _askedToLead() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              height: 400,
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  _buildTableCalendar(),
                ],
              ),
            ),
          );
        }
    );
  }
}

class cardWidget extends StatelessWidget {
  final indexTime;

  const cardWidget({
    Key key,
    this.indexTime,
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
                ((indexTime < 10)
                    ? "0${0 + indexTime}.00"
                    : "${0 + indexTime}.00"),
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

// class headerTop extends StatelessWidget {
//   final stringMonth;
//
//   const headerTop({
//     Key key, this.stringMonth
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(bottom: 16),
//       child: Row(
//         children: <Widget>[
//           Row(
//             children: <Widget>[
//               Text(
//                 'Daily',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(width: 10),
//               Text(
//                 'Schedule',
//                 style: TextStyle(
//                   color: Colors.white60,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           Spacer(),
//           RichText(
//             text: TextSpan(
//               text: stringMonth,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () {
//                 print('test');
//                 _EventViewState()._pickDate();
//               }
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
// }

class dateWidget extends StatefulWidget {
  final index;

  const dateWidget({
    Key key,
    this.index,
  }) : super(key: key);

  @override
  _dateWidgetState createState() => _dateWidgetState();
}

class _dateWidgetState extends State<dateWidget> {
  bool _selectedDate = true;
  var listDay = [
    "Mon",
    "Tu",
    "We",
    "Th",
    "Fr",
    "Sat",
    "Sun",
    "Mon",
    "Tu",
    "We",
    "Th",
    "Fr",
    "Sat",
    "Sun",
  ];

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
          padding: EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 16),
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

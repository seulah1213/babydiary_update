import 'package:babydiary_seulahpark/helpers/food_db_helper.dart';
import 'package:babydiary_seulahpark/models/color_picker.dart';
import 'package:babydiary_seulahpark/models/food_model.dart';
import 'package:babydiary_seulahpark/screens/add_calendar_screen.dart';
import 'package:babydiary_seulahpark/screens/drawer_screen.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Food> foodList;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  MeetingDataSource getMeetingDetails() {
    return MeetingDataSource(foodList);
  }

  @override
  void initState() {
    super.initState();
    _updateFoodList();
  }

  _updateFoodList() {
    FoodDBhelper.instance.getFoodList().then((value) {
      setState(() {
        foodList = value;
      });
    });
  }

  calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      setState(() {
        List<Food> tappedFoodList = calendarTapDetails.appointments.cast();
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                color: Color(0xff757575),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: ListView.separated(
                    padding: EdgeInsets.all(2),
                    itemCount: tappedFoodList?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: EdgeInsets.all(2),
                          height: 50,
                          child: ListTile(
                            leading: Icon(Icons.label,
                                color:
                                    colors[tappedFoodList[index].background]),
                            title: Text('${tappedFoodList[index].name}'),
                            subtitle: Text(
                                '${tappedFoodList[index].fromDate.toString().substring(0, 10)} '
                                '~ ${tappedFoodList[index].toDate.toString().substring(0, 10)}'),
                            trailing: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text('삭제하시겠습니까?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                FoodDBhelper.instance
                                                    .deleteFood(
                                                        tappedFoodList[index]
                                                            .id);
                                                _updateFoodList();
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        '/calendar',
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                              });
                                            },
                                            child: Text('네')),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('아니오'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddCalendarScreen(
                                      food: tappedFoodList[index],
                                    ),
                                  ));
                            },
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(height: 5, color: Colors.white),
                  ),
                ),
              );
            });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            return _scaffoldKey.currentState?.openDrawer();
          },
          icon: Icon(Icons.menu),
        ),
        title: Text('식단표'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddCalendarScreen(),
                    ));
              })
        ],
      ),
      drawer: DrawerScreen(),
      body: SfCalendar(
        view: CalendarView.month,
        todayHighlightColor: Color(0xFFFE8189),
        headerHeight: 50,
        headerStyle: CalendarHeaderStyle(textAlign: TextAlign.center),
        appointmentTextStyle: TextStyle(
          fontSize: 11,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
        dataSource: getMeetingDetails(),
        onTap: calendarTapped,
        monthViewSettings: MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          numberOfWeeksInView: 4,
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Food> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].fromDate;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].toDate;
  }

  @override
  String getSubject(int index) {
    return appointments[index].name;
  }

  @override
  Color getColor(int index) {
    return colors[appointments[index].background];
  }

  @override
  String getNotes(int index) {
    return appointments[index].step;
  }

  @override
  int getCounts(int index) {
    return appointments[index].eventCount;
  }
}

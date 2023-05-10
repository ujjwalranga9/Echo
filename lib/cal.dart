import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:calendar_agenda/calendar_agenda.dart';

class Calender extends StatelessWidget {
  Calender({Key? key,required this.update}) : super(key: key);
  Function update;




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),


      body: SfCalendar(

        // loadMoreWidgetBuilder: (context, loadMoreAppointments) {
        //
        //   return Image.network("https://dailyaudiobooks.b-cdn.net/wp-content/uploads/2022/06/41WIbflfG2L._SX323_BO1204203200.jpg",height: 100,);
        // },
        // backgroundColor: Colors.black,
        view: CalendarView.month,

        onTap: (details){

        },
        monthCellBuilder: (BuildContext buildContext,MonthCellDetails details){
          CalendarAppointmentDetails details2 =  CalendarAppointmentDetails(details.date, details.appointments, details.bounds);

          return Container(
            decoration: BoxDecoration(
              // border: Border.all(width: 0.1),
              borderRadius: BorderRadius.circular(0)
            ),
             child:  (details.date == details2.date) ? Center(child: Text(details.date.day.toString())): Image.network("https://dailyaudiobooks.b-cdn.net/wp-content/uploads/2022/06/41WIbflfG2L._SX323_BO1204203200.jpg",),

          );
        },
        dataSource: MeetingDataSource(_getDataSource()),

        appointmentBuilder: (BuildContext context,CalendarAppointmentDetails details){
          final  meeting = details.appointments.first;
          return Image.network(meeting.image, //fit: BoxFit.cover,
              width: details.bounds.width,
              height: details.bounds.height);
        },

        monthViewSettings: const MonthViewSettings(showTrailingAndLeadingDates: false,

            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,showAgenda: true),

        // monthViewSettings: const MonthViewSettings(showAgenda: true),
      ),
    );
  }
}
List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  final DateTime today = DateTime.now();
  final DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  const image = "https://dailyaudiobooks.b-cdn.net/wp-content/uploads/2022/06/41WIbflfG2L._SX323_BO1204203200.jpg";


  meetings.add(Meeting('Power of Now', startTime, endTime, const Color(0xFF0F8644), true,image));
  return meetings;
}


class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }



  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
  String image(int index){
    return appointments![index].image;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,this.image);

  String image;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
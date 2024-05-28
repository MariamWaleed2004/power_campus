import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 6,
        dataSource: MeetingDataSource(getAppointment()),
      ),
    );
  }
}

List<Appointment> getAppointment() {
  List<Appointment> meeting = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));

  meeting.add(Appointment(
    startTime: startTime,
    endTime: endTime,
    subject: 'subject',
    color: Colors.blue,
  ));
  return meeting;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}




// final DocumentReference parentDocRef =
    //     FirebaseFirestore.instance.collection('Courses').doc(courseId);

    // final CollectionReference subcollectionRef =
    //     parentDocRef.collection('addedBy');

    // await subcollectionRef.add({
    //   'userId': user.uid,
    // });

    // await FirebaseFirestore.instance.collection('AddedCourses').add({
    //   'username': userData.data()!['username'],
    //   'userid': user.uid,
    //   'addedAt': Timestamp.now(),
    //   'courseId': courseId,
    //   'courseTitle': courseTitle,
    // });

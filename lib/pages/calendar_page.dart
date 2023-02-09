import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_04_05/model/exam_data_source.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/exam_list_item.dart';

class CalendarPage extends StatelessWidget {
  final List<ExamItem> events;

  const CalendarPage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The title text which will be shown on the action bar
        title: const Text(
          "Calendar",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SfCalendar(
        view: CalendarView.month,
        firstDayOfWeek: 1,
        cellBorderColor: Colors.transparent,
        dataSource: ExamDataSource(events),
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          showAgenda: true,
        ),
      ),
    );
  }

}

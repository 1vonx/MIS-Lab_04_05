import 'dart:ui';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:lab_04_05/model/exam_list_item.dart';

class ExamDataSource extends CalendarDataSource{

  ExamDataSource(List<ExamItem> source){
    appointments = source;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }
}
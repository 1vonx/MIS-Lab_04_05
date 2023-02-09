import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_04_05/model/exam_list_item.dart';

class TimeText extends StatelessWidget {
  final ExamItem item;

  const TimeText(this.item, {super.key});

  bool _checkIfSingleDigit(int value) {
    if (value / 10 < 1) {
      return false;
    }

    return true;
  }

  String _getText() {
    String startHourText;
    String startMinText;
    String endHourText;
    String endMinText;
    String finalText;

    startHourText = _checkIfSingleDigit(item.startTime.hour)
        ? "${item.startTime.hour}"
        : "0${item.startTime.hour}";
    startMinText = _checkIfSingleDigit(item.startTime.minute)
        ? "${item.startTime.minute}"
        : "0${item.startTime.minute}";
    endHourText = _checkIfSingleDigit(item.startTime.hour)
        ? "${item.endTime.hour}"
        : "0${item.endTime.hour}";
    endMinText = _checkIfSingleDigit(item.startTime.minute)
        ? "${item.endTime.minute}"
        : "0${item.endTime.minute}";
    finalText = "Time : $startHourText:$startMinText - $endHourText:$endMinText";

    return finalText;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _getText(),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

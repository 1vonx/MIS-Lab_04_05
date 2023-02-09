import 'package:flutter/cupertino.dart';
import 'package:lab_04_05/model/exam_list_item.dart';

class DateTimeText extends StatelessWidget {
  final ExamItem listItem;

  const DateTimeText(this.listItem, {super.key});

  bool _checkIfSingleDigit(int value) {
    if (value / 10 < 1) {
      return false;
    }

    return true;
  }

  String _getText() {
    String dayText;
    String monthText;
    String startHourText;
    String startMinText;
    String endHourText;
    String endMinText;
    String finalText;

    dayText = _checkIfSingleDigit(listItem.startTime.day)
        ? "${listItem.startTime.day}"
        : "0${listItem.startTime.day}";
    monthText = _checkIfSingleDigit(listItem.startTime.month)
        ? "${listItem.startTime.month}"
        : "0${listItem.startTime.month}";
    startHourText = _checkIfSingleDigit(listItem.startTime.hour)
        ? "${listItem.startTime.hour}"
        : "0${listItem.startTime.hour}";
    startMinText = _checkIfSingleDigit(listItem.startTime.minute)
        ? "${listItem.startTime.minute}"
        : "0${listItem.startTime.minute}";
    endHourText = _checkIfSingleDigit(listItem.startTime.hour)
        ? "${listItem.endTime.hour}"
        : "0${listItem.endTime.hour}";
    endMinText = _checkIfSingleDigit(listItem.startTime.minute)
        ? "${listItem.endTime.minute}"
        : "0${listItem.endTime.minute}";
    finalText =
        "$dayText.$monthText.${listItem.startTime.year} $startHourText:$startMinText - $endHourText:$endMinText";

    return finalText;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _getText(),
      style: const TextStyle(
        fontSize: 15,
      ),
    );
  }
}

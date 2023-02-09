import 'package:flutter/material.dart';
import 'package:lab_04_05/model/menu_item.dart';

class MenuItems {
  static const List<ButtonMenuItem> itemsFirst = [calendarItem];

  static const List<ButtonMenuItem> itemsSecond = [logoutItem];

  static const calendarItem =
      ButtonMenuItem(text: 'Calendar', icon: Icons.calendar_month);

  static const logoutItem = ButtonMenuItem(text: 'Logout', icon: Icons.logout);
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_04_05/data/menu_items.dart';
import 'package:lab_04_05/model/menu_item.dart';
import 'package:lab_04_05/pages/map_page.dart';
import '../model/exam_list_item.dart';
import '../service/notification/notification_api.dart';
import '../widgets/date_time_text.dart';
import '../widgets/new_item.dart';
import 'calendar_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'event_details_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<StatefulWidget> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final user = FirebaseAuth.instance.currentUser!;
  List<ExamItem> _listItems = [];

  Future<List<ExamItem>> readItems() => FirebaseFirestore.instance
      .collection("examEvents")
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get()
      .then((response) => response.docs
          .map((element) => ExamItem.fromJson(element.data()))
          .toList());

  void _addItemFunction(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewItem(_addNewItemToList));
        });
  }

  void _addNewItemToList(ExamItem item) {
    setState(() {
      _listItems.add(item);
    });
  }

  void _deleteItem(String id) {
    setState(() {
      FirebaseFirestore.instance.collection("examEvents").doc(id).delete();
    });
  }

  @override
  void initState() {
    super.initState();

    NotificationApi.init();
    listenNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // The title text which will be shown on the action bar
          title: const Text(
            "Exam List",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<ButtonMenuItem>(
              onSelected: (item) => onSelected(context, item),
              itemBuilder: (context) => [
                ...MenuItems.itemsFirst.map(buildItem).toList(),
                const PopupMenuDivider(
                  height: 20,
                ),
                ...MenuItems.itemsSecond.map(buildItem).toList(),
                const PopupMenuDivider(
                  height: 20,
                ),
                ...MenuItems.itemsThird.map(buildItem).toList(),
              ],
              color: Colors.white,
            )
          ]),
      body: Center(
          child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hello, ${user.email!} !",
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<ExamItem>>(
              future: readItems(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    snapshot.error.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                } else if (snapshot.hasData) {
                  _listItems = snapshot.data!;
                  if (_listItems.isEmpty) {
                    const Text(
                      "No exam events entered.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (ctx, index) {
                      return Card(
                        shadowColor: Colors.cyanAccent,
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        child: ListTile(
                          title: Text(
                            _listItems[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: DateTimeText(_listItems[index]),
                          trailing: FittedBox(
                            child: Row(
                              children: [
                                IconButton(
                                    icon: const Icon(
                                      Icons.notifications_active_outlined,
                                      color: Colors.cyan,
                                    ),
                                    onPressed: () async {
                                      await NotificationApi.showNotification(
                                        title: 'Exam Management App',
                                        body: 'You have an upcoming exam!',
                                        payload: _listItems[index].id,
                                      );
                                    }),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.cyan,
                                  ),
                                  onPressed: () =>
                                      _deleteItem(_listItems[index].id),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: _listItems.length,
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => _addItemFunction(context),
      ),
    );
  }

  PopupMenuItem<ButtonMenuItem> buildItem(ButtonMenuItem item) {
    return PopupMenuItem<ButtonMenuItem>(
      value: item,
      child: Row(
        children: [
          Icon(
            item.icon,
            size: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(item.text),
        ],
      ),
    );
  }

  void onSelected(BuildContext context, ButtonMenuItem item) {
    switch (item) {
      case MenuItems.calendarItem:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CalendarPage(events: _listItems),
        ));
        break;
      case MenuItems.mapItem:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MapPage(events: _listItems),
        ));
        break;
      case MenuItems.logoutItem:
        FirebaseAuth.instance.signOut();
        break;
    }
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  Future<void> onClickedNotification(String? payload) async =>
      await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EventDetailsPage(eventId: payload!),
      ));
}

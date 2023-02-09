import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab_04_05/model/exam_list_item.dart';
import 'package:lab_04_05/widgets/time_text.dart';

class EventDetailsPage extends StatelessWidget {
  final String eventId;

  const EventDetailsPage({super.key, required this.eventId});

  Future<ExamItem> getItem() => FirebaseFirestore.instance
      .collection("examEvents")
      .where('id', isEqualTo: eventId)
      .get()
      .then((response) => response.docs
          .map((element) => ExamItem.fromJson(element.data()))
          .single);

  @override
  Widget build(BuildContext context) {
    ExamItem examItem;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Exam Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<ExamItem>(
        future: getItem(),
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
            examItem = snapshot.data!;
            return Center(
              child: Card(
                  shadowColor: Colors.cyanAccent,
                  color: Colors.cyan[100],
                  elevation: 50,
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            examItem.name,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyan,
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Card(
                            color: Colors.cyan,
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                                child: Text(
                                  "Date: ${examItem.startTime.day}/"
                                  "${examItem.startTime.month}/"
                                  "${examItem.startTime.year}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          Card(
                            color: Colors.cyan,
                            child: SizedBox(
                              width: 250,
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                                child: TimeText(examItem),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

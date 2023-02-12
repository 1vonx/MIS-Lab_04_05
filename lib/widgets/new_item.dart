import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'package:lab_04_05/model/exam_list_item.dart';
import 'package:nanoid/nanoid.dart';

class NewItem extends StatefulWidget {
  final Function addItem;

  const NewItem(this.addItem, {super.key});

  @override
  State<StatefulWidget> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final _nameController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  GoogleMapController? _controller;
  List<Marker> markers = [];
  int id = 1;

  Future addItemToDB({required ExamItem item}) async {
    final docItem =
        FirebaseFirestore.instance.collection("examEvents").doc(item.id);
    final json = item.toJson();
    await docItem.set(json);
  }

  late LatLng _latLng;

  void _submitData() {
    if (_startDateController.text.isEmpty ||
        _endDateController.text.isEmpty ||
        _latLng == null) {
      return;
    }
    final enteredName = _nameController.text;
    final enteredStartDateTime = DateTime.parse(_startDateController.text);
    final enteredEndDateTime = DateTime.parse(_endDateController.text);
    final lat = _latLng.latitude;
    final lon = _latLng.longitude;

    if (enteredName.isEmpty) {
      return;
    }

    final newItem = ExamItem(
        id: nanoid(6),
        userId: FirebaseAuth.instance.currentUser!.uid,
        name: enteredName,
        color: Colors.cyan,
        startTime: enteredStartDateTime,
        endTime: enteredEndDateTime,
        latitude: lat,
        longitude: lon);

    widget.addItem(newItem);
    addItemToDB(item: newItem);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          const Center(
            child: Text(
              "Add a new exam event:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.cyan,
              ),
            ),
          ),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Name",
              prefixIcon: Icon(Icons.text_fields),
            ),
            onSubmitted: (_) => _submitData(),
          ),
          DateTimeField(
            controller: _startDateController,
            decoration: const InputDecoration(
              labelText: "Start Date&Time",
              prefixIcon: Icon(Icons.calendar_today),
            ),
            format: DateFormat("yyyy-MM-dd HH:mm"),
            onShowPicker: (BuildContext context, DateTime? currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));

              if (date != null) {
                final time = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 12, minute: 0));
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
            },
            onFieldSubmitted: (_) => _submitData(),
          ),
          DateTimeField(
            controller: _endDateController,
            decoration: const InputDecoration(
              labelText: "End Date&Time",
              prefixIcon: Icon(Icons.calendar_today),
            ),
            format: DateFormat("yyyy-MM-dd HH:mm"),
            onShowPicker: (BuildContext context, DateTime? currentValue) async {
              final date = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100));

              if (date != null) {
                final time = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 12, minute: 0));
                return DateTimeField.combine(date, time);
              } else {
                return currentValue;
              }
            },
            onFieldSubmitted: (_) => _submitData(),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              initialCameraPosition: const CameraPosition(
                  target: LatLng(42.0041222, 21.4073592), zoom: 14),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: (LatLng latLng) {
                Marker marker = Marker(
                  markerId: MarkerId('$id'),
                  position: LatLng(latLng.latitude, latLng.longitude),
                  infoWindow: const InfoWindow(title: 'Where does the exam take place?'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                );
                markers.add(marker);
                _latLng = latLng;
                id = id + 1;
                setState(() {});
              },
              markers: markers.map((e) => e).toSet(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: const Text(
              "Add",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () => _submitData(),
          ),
        ],
      ),
    );
  }
}

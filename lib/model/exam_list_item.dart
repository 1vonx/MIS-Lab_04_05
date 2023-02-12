import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ExamItem {
  final String id;
  final String userId;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String subject;
  final Color color;
  final double longitude;
  final double latitude;

  ExamItem(
      {this.id = '',
      required this.userId,
      required this.name,
      this.subject = '',
      required this.startTime,
      required this.endTime,
      this.color = Colors.cyan,
      required this.longitude,
      required this.latitude});

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'name': name,
        'startTime': startTime,
        'endTime': endTime,
        'longitude': longitude,
        'latitude': latitude
      };

  static ExamItem fromJson(Map<String, dynamic> json) => ExamItem(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
      longitude: json['longitude'],
      latitude: json['latitude']);
}

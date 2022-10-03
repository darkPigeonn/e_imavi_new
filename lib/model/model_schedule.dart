import 'package:flutter/material.dart';

class Schedule {
  late int date;
  late String name,description,piket1, piket2;

  Schedule({required this.date, required this.name, required this.description, required this.piket1, required this.piket2});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return new Schedule(
        date: json['Tanggal'],
        name: json['Nama'],
        description : json['Bahasa'],
        piket1: json['Nyapu'],
        piket2: json['Ngelap']
     );
  }
}
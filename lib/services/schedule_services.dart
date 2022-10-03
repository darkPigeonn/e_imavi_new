import 'dart:convert';

import 'package:e_imavi/model/model_schedule.dart';
import '';
import 'package:http/http.dart' as http;
class ScheduleController{
  static const String url = "https://script.google.com/macros/s/AKfycbxuHTQprMUAWhXqLxqDT2RKMrKVLECBha4MaK0BsAjVN7cWn7AEQi81XMhwwQ9cz3E/exec";
  static const STATUS_SUCCESS = "SUCCESS";

  Future<List<Schedule>> getScheduleList() async {
    return await http.get(Uri.parse(url)).then((resonse){
      var jsonSchedule = jsonDecode(resonse.body) as List;
      return jsonSchedule.map((json) => Schedule.fromJson(json)).toList();
    });
  }
  Future<Schedule> getScheduleToday() async {
    final date = DateTime.now();
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      List result = jsonDecode(response.body);
      final today = result.where((element) => element["Tanggal"] == date.day).toList();
      print(today[0]);
      return Schedule.fromJson(today[0]);
      // return ModelUser.fromJson(result);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
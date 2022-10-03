import 'dart:convert';

import 'package:e_imavi/model/model_kronik.dart';
import 'package:e_imavi/model/model_permit.dart';
import 'package:e_imavi/utils/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class KronikService {
  Future<List<KronikModel>> getHistoryKronik() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final profileToken = prefs.get('profileToken');

    Map<String, String> headers = {
      'Id': '6147f10d33abc530a445fe84',
      'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
      "Authorization": "bearer $profileToken",
      "Partner": "imavi"
    };
    final response = await http.get(
      Uri.parse(url + 'kroniks/getHistory'),
      headers: headers,
    );
    print(response);

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      print(result);
      return result.map(((e) => KronikModel.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Map<String, dynamic>> createKronik(Map data) async {
    Map dataBody = data;

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();

      var token = sp.getString("profileToken").toString();

      final response = await http.post(Uri.parse(url + "kroniks/create"),
          body: json.encode(dataBody),
          headers: {
            'Id': '6147f10d33abc530a445fe84',
            'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
            "Authorization": "bearer $token",
            'partner': "imavi",
            'Content-Type': 'application/json'
          });
      print(url);
      var dataErr;
      var data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        print(data);
        return data;
      } else {
        dataErr = {'message': data['message']};
        print(dataErr);
        throw (dataErr);
      }
    } catch (e) {
      throw (e);
    }
  }
}

final kronikService = Provider<KronikService>((ref) => KronikService());

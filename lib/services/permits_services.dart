import 'dart:convert';

import 'package:e_imavi/model/model_permit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PermitsServices{
  final urlPermits = "https://api.imavi.org/imavi/permits/";


  Future<List<PermitModel>> getHistoryPermit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final profileToken = prefs.get('profileToken');

    Map<String, String> headers = {
      'Id': '6147f10d33abc530a445fe84',
      'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
      "Authorization": "bearer $profileToken",
      "Partner" : "imavi"
    };
    final response = await http.get(
      Uri.parse(urlPermits + 'getHistory'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      print(result);
      return result.map(((e) => PermitModel.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  Future<Map<String, dynamic>> createPermits(String reason, String startDatePermit, String endDatePermit) async{

    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      final url = Uri.parse(urlPermits+"create");
      var token = sp.getString("profileToken").toString();

      Map dataBody = {
        "reason" : reason,
        "startDatePermit" : startDatePermit,
        "endDatePermit" : endDatePermit
      };

      final response = await http.post(
        url,
        body: json.encode(dataBody),
        headers: {
          'Id': '6147f10d33abc530a445fe84',
          'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
          "Authorization": "bearer $token",
          'partner' : "imavi",
          'Content-Type' : 'application/json'
        }
      );
      print(url);
      var dataErr;
      var data = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        print(data);
        return data;
      } else {
        dataErr = {'message' : data['message']};
        print(dataErr);
        throw (dataErr);
      }
    } catch (e) {
      throw (e);
    }
  }
}

final permitProvider = Provider<PermitsServices>((ref) => PermitsServices());
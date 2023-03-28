import 'dart:convert';

import 'package:e_imavi/utils/helpers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../utils/env.dart';

Future<dynamic> wfhAttendance(data, userId, context) async {
  EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var dataReturn = false;
  try {
    await uploadImages(data['image'], userId).then((value) async {
      var imageUrl = value;
      //get current position
      var positions = await getCurrentLocation();

      final dataSave = {
        'userId': userId,
        'type': data['type'],
        'locationNote': data['locationNote'],
        'location': positions,
        'note': data['note'],
        'isWfh': true,
        'images': imageUrl
      };
      final body = jsonEncode(dataSave);

      Map<String, String> headers = {
        'Id': '6147f10d33abc530a445fe84',
        'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
        "Content-type": "application/json"
      };
      final response = await http.post(Uri.parse(url + 'users/attendance'),
          headers: headers, body: body);
      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        EasyLoading.showSuccess(responseBody['message']);
        dataReturn = true;
      } else {
        EasyLoading.showError(responseBody['message']);
      }
    });
  } catch (error) {
    return ("Gagal upload, terjadi gangguan jaringan");
  }
  return dataReturn;
}

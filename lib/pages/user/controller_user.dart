import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/env.dart';

checkEquals(a, b) {
  print('ds');
  print(a);
  print(b);
  return a == b;
}

doResetPassword(password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final profileToken = prefs.get('profileToken');

  Map<String, String> headers = {
    'Id': '6147f10d33abc530a445fe84',
    'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
    "Content-type": "application/json",
    "Authorization": "bearer $profileToken"
  };

  Map dataSend = {
    'password': password,
  };
  final body = json.encode(dataSend);
  final response = await http.post(
      Uri.parse(url + 'users/reset-password-mobile'),
      headers: headers,
      body: body);

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

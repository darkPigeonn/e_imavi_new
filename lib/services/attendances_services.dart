import 'dart:convert';
import 'dart:developer';

import 'package:e_imavi/model/model_attendances.dart';
import 'package:e_imavi/model/model_user.dart';
import 'package:e_imavi/model/user.dart';
import 'package:e_imavi/utils/env.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<ModelAttendances>> getAttendances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final profileToken = prefs.get('profileToken');

    Map<String, String> headers = {
      'Id': '6147f10d33abc530a445fe84',
      'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
      "Authorization": "bearer $profileToken"
    };
    print(url);
    final response = await http.get(
      Uri.parse(url + 'users/attendanceHistory'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result.map(((e) => ModelAttendances.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  Future<ModelUser> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final profileToken = prefs.get('profileToken');

     Map<String, String> headers = {
      'Id': '6147f10d33abc530a445fe84',
      'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
      "Authorization": "bearer $profileToken"
    };

     final response = await http.get(
      Uri.parse(url + 'users/profile'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      prefs.setString('idProfileUser', result['_id']);

      return ModelUser.fromJson(result);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
  Future<List<ModelResources1>> getArticles() async {
    Map<String, String> headers = {
      'Id': '619c3c2e29baa215519da64d',
      'Secret': '360039ed-79a6-4853-8304-c7b21e166f5f',
      'partner': 'keuskupanSby'
    };
    final response = await http.get(
      Uri.parse('https://api.imavi.org/imavi/articles/get-all'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result.map(((e) => ModelResources1.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<ModelResources1>> getNews() async {
    Map<String, String> headers = {
      'Id': '619c3c2e29baa215519da64d',
      'Secret': '360039ed-79a6-4853-8304-c7b21e166f5f',
      'partner': 'keuskupanSby'
    };
    final response = await http.get(
      Uri.parse('https://api.imavi.org/imavi/news/get-all'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body);
      return result.map(((e) => ModelResources1.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<ModelResources1>> getReflections() async {
    Map<String, String> headers = {
      'Id': '619c3c2e29baa215519da64d',
      'Secret': '360039ed-79a6-4853-8304-c7b21e166f5f',
      'partner': 'keuskupanSby'
    };
    final response = await http.get(
      Uri.parse('https://api.imavi.org/imavi/news/get-all'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('ini berita');
      final List result = jsonDecode(response.body);
      print(result);
      return result.map(((e) => ModelResources1.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<ModelResources1>> getPrayers() async {
    Map<String, String> headers = {
      'Id': '619c3c2e29baa215519da64d',
      'Secret': '360039ed-79a6-4853-8304-c7b21e166f5f',
      'partner': 'keuskupanSby'
    };
    final response = await http.get(
      Uri.parse('https://api.imavi.org/imavi/prayers/get-all'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('ini doa');
      final List result = jsonDecode(response.body);
      print(result);
      return result.map(((e) => ModelResources1.fromJson(e))).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}

final apiProvider = Provider<ApiService>((ref) => ApiService());

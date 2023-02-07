import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_imavi/utils/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_imavi/pages/base.dart';
import 'package:e_imavi/pages/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:e_imavi/components/const_color.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool isLoading = false;

  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  static FirebaseFirestore _db = FirebaseFirestore.instance;
  //function
  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();
    // // Save the initial token to the database
    // await saveTokenToDatabase(token!);

    // // Any time the token refreshes, store this in the database too.
    // FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }
  loginUser() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = _email.text;
    String password = _password.text;


    //get token fcm firebase
    String? token = await FirebaseMessaging.instance.getToken();

    Map data = {"username": username, "password": password, "token_fcm": token};
    //note : meski sudah bentuk objek, harus di encode dulu agar masuk ke body
    final body = jsonEncode(data);

    Map<String, String> headers = {
      'Id': '6147f10d33abc530a445fe84',
      'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
      "Content-type": "application/json"
    };

    final response = await http.post(
        Uri.parse(url + 'users/login'),
        headers: headers,
        body: body);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      prefs.setString("profileToken", data['profileToken']);
      prefs.setBool("login", true);

      Fluttertoast.showToast(
        msg: 'Berhasil Logim',
        backgroundColor: Color.fromARGB(255, 2, 115, 0),
        textColor: Colors.white,
      );

                            EasyLoading.dismiss();

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BaseLayout()));
    } else {
      var data = jsonDecode(response.body);

                            EasyLoading.dismiss();
      Fluttertoast.showToast(
        msg: data['message'],
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }



  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: mBackgroundColor,
          constraints: BoxConstraints(
            maxHeight: size.height,
            maxWidth: size.width,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Form(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        35, MediaQuery.of(context).size.height * 0.1, 35, 35),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text(
                            "E-IMAVI",
                            style: mStyleTitle,
                          ),
                        ),
                        Center(
                          child: Text(
                            "Aplikasi untuk aktifitas karyawan",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: mSubtitle,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value != null && value.trim().length < 3) {
                              return 'This field requires a minimum of 3 characters';
                            }
                            return null;
                          },
                          controller: _email,
                          decoration: const InputDecoration(
                              labelText: 'Masukan Email',
                              border: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 5))),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value != null && value.trim().length < 3) {
                              return 'This field requires a minimum of 3 characters';
                            }

                            return null;
                          },
                          controller: _password,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                              labelText: 'Masukan Password',
                              border: OutlineInputBorder(),

                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.red, width: 5),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                        ),

                        ElevatedButton(
                          onPressed: () async {
                            EasyLoading.show();
                            await loginUser();

                          },
                          child: Text('Masuk'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

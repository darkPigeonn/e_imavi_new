import 'dart:io';

import 'package:e_imavi/components/const_color.dart';
import 'package:e_imavi/core.dart';
import 'package:e_imavi/provider/data_provider.dart';
import 'package:e_imavi/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/firestore_api.dart';
import '../login.dart';
import 'controller_user.dart';

class UserPage extends ConsumerStatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool isLoading = false;

  bool _passwordVisible = false;

  @override
  Widget build(
    BuildContext context,
  ) {
    // print(user.email);
    final _data = ref.watch(userProfileProvider);

    final Storage storage = Storage();

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Profil'),
        backgroundColor: mColorPurple,
      ),
      body: Stack(
        children: [
          background(),
          _data.when(
            data: (data) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.all(20),
                        child: FutureBuilder(
                          future: storage.downloadUrl(data.id),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasData) {
                              final image2 = NetworkImage(snapshot.data!);
                              return ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  child: Ink.image(
                                    image: image2,
                                    fit: BoxFit.cover,
                                    width: 200,
                                    height: 200,
                                    child: InkWell(onTap: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      final image = await ImagePicker()
                                          .getImage(
                                              source: ImageSource.gallery);

                                      if (image == null) return;

                                      final directory =
                                          await getApplicationDocumentsDirectory();
                                      final name = basename(image.path);
                                      final imageFile =
                                          File('${directory.path}/$name');
                                      final newImage = await File(image.path)
                                          .copy(imageFile.path);
                                      await storage.uploadImage(
                                          image.path, data.id);
                                    }),
                                  ),
                                ),
                              );
                            }
                            if (snapshot.connectionState ==
                                    ConnectionState.waiting ||
                                !snapshot.hasData) {
                              return ClipOval(
                                child: Material(
                                  color: Colors.transparent,
                                  // child: Ink.image(
                                  //   image: image,
                                  //   fit: BoxFit.cover,
                                  //   width: 80,
                                  //   height: 80,
                                  //   child: InkWell(onTap: onClicked),
                                  // ),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        data.fullName,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Container(
                      child: Text(
                        data.jabatan,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.all(30),
                      padding: EdgeInsets.all(20),
                      child: Column(children: [
                        TextFormField(
                          validator: (value) {
                            if (value != null && value.trim().length < 3) {
                              return 'This field requires a minimum of 3 characters';
                            }
                            return null;
                          },
                          controller: _email,
                          decoration: const InputDecoration(
                              labelText: 'Masukan Password Baru',
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
                            labelText: 'Masukan Password Kembali',
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
                            // EasyLoading.show();
                            // await loginUser();
                            var password = _email.text.toString();
                            var repeatPassword = _password.text.toString();

                            var check = checkEquals(password, repeatPassword);

                            if (!check) {
                              EasyLoading.showError('Kata Sandi tidak sama!');
                              return;
                            }

                            var doReset = await doResetPassword(password);
                            if (doReset) {
                              EasyLoading.showSuccess(
                                  'Kata Sandi Berhasil Diperbaharui');

                              final pref =
                                  await SharedPreferences.getInstance();
                              await pref.clear();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            } else {
                              EasyLoading.showError(
                                  'Kata Sandi Gagal Diperbaharui');
                            }
                          },
                          child: Text('Masuk'),
                        )
                      ]),
                    ),
                  ],
                ),
              );
            },
            error: (error, stackTrace) {
              return Text('Terjadi Kesalahan');
            },
            loading: () {
              return CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}

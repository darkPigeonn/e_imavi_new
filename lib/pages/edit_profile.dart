import 'dart:io';

import 'package:e_imavi/model/user.dart';
import 'package:e_imavi/services/firestore_api.dart';
import 'package:e_imavi/services/user_preferences.dart';
import 'package:e_imavi/widgets/profile_widget.dart';
import 'package:e_imavi/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late User user;
  final Storage storage = Storage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = UserPreferences.getUser();
  }

  Future<void> putAccountData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();


  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.purple,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          const SizedBox(
            height: 16,
          ),
          ProfileWidget(
            imagePath: user.imagePath,
            onClicked: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              final image = await ImagePicker()
                        .getImage(source: ImageSource.gallery);

                    if (image == null) return;

                    final directory = await getApplicationDocumentsDirectory();
                    final name = basename(image.path);
                    final imageFile = File('${directory.path}/$name');
                    final newImage =
                        await File(image.path).copy(imageFile.path);

                    await storage.uploadImage(image.path, name);

                    setState(() => user = user.copy(imagePath: newImage.path));
            },
            isEdit: true,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Full Name',
            text: user.name,
            onChanged: (name) => user = user.copy(
              imagePath: name,
            ),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Email',
            text: user.email,
            onChanged: (email) => user = user.copy(
              email: email,
            ),
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Jabatan',
            text: user.email,
            onChanged: (jabatan) => user = user.copy(email: jabatan),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: StadiumBorder(),
              onPrimary: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: Text('Simpan'),
            onPressed: () async {
              UserPreferences.setUser(user);
            },
          )
        ],
      ),
    );
  }
}

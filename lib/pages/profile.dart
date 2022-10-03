import 'dart:io';

import 'package:e_imavi/model/user.dart';
import 'package:e_imavi/pages/edit_profile.dart';
import 'package:e_imavi/provider/data_provider.dart';
import 'package:e_imavi/services/firestore_api.dart';
import 'package:e_imavi/widgets/bottomnavigation.dart';
import 'package:e_imavi/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilUserPage extends ConsumerWidget {
  final String imagePath;

  ProfilUserPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _data = ref.watch(userProfileProvider);

    final Storage storage = Storage();

    return Container(
      margin: EdgeInsets.all(10),
      child: _data.when(
        data: (_data){
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                   buildName(_data),
                    ProfileWidget(
                      onClicked: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                          final image = await ImagePicker()
                              .getImage(source: ImageSource.gallery);

                          if (image == null) return;

                          final directory = await getApplicationDocumentsDirectory();
                          final name = basename(image.path);
                          final imageFile = File('${directory.path}/$name');
                          final newImage = await File(image.path).copy(imageFile.path);
                          await storage.uploadImage(image.path, imagePath);

                          // setState(() => user = user.copy(imagePath: newImage.path));
                      },
                      imagePath: imagePath ,
                    ),

                    // buildAbout()
                  ],

              ),
            ],
          );
        },
        error: (err, stack) => Center(child: Text('Error $err')),
        loading: () => const CircularProgressIndicator()
      )
    );
  }

  Widget buildName(data) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              // user.name,
              data.fullName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
            ),
          ),
          new Container(
            child: Text(

              // user.email,
              data.email + ' | ' + data.jabatan,
              textAlign: TextAlign.start,
              style: TextStyle(color: Colors.grey),
            ),
          ),

        ],
      );

  Widget buildAbout() => Container(
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jabatan',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Staff IT',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

   Widget buildImage2() {

    final Storage storage = Storage();
    final image = NetworkImage(
        "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png");

    return FutureBuilder(
      future: storage.downloadUrl('spn_09.jpg'),
      builder: (BuildContext context,AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return ClipOval(
            child: Material(

              color: Colors.transparent,
              // child: Ink.image(
              //   image: snapshot.data!,
              //   fit: BoxFit.cover,
              //   width: 80,
              //   height: 80,
              //   child: InkWell(onTap: (){}),
              // ),
              child: Container(
                width: 80,
                height: 80,
                child: Image.network(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          return ClipOval(
            child: Material(

              color: Colors.transparent,
              child: Ink.image(
                image: image,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                child: InkWell(onTap: (){}),
              ),
            ),
          );
        }
        return Container();
      }
    );
  }
}

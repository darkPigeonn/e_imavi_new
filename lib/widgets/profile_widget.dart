import 'dart:io';

import 'package:e_imavi/services/firestore_api.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;

  //preferences
  const ProfileWidget(
      {Key? key,
      required this.imagePath,
      required this.onClicked,
      this.isEdit = false})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: Stack(
        children: [
          buildImage2(),
          // Positioned(bottom: 0, right: 4, child: buildEditIcon(color))
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = imagePath.contains('https://')
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath));

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image as ImageProvider,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

   Widget buildImage2() {
    final Storage storage = Storage();


    final image = NetworkImage(
        "https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_960_720.png");

    return FutureBuilder(
      future: storage.downloadUrl(imagePath),
      builder: (BuildContext context,AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          final image2 = NetworkImage(snapshot.data!);
          return ClipOval(
            child: Material(

              color: Colors.transparent,
              child: Ink.image(
                image: image2,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
                child: InkWell(onTap: onClicked),
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
                child: InkWell(onTap: onClicked),
              ),
            ),
          );
        }
        return Container();
      }
    );
  }
  Widget buildEditIcon(Color color) => buildCircle(
        color: color,
        all: 8,
        child: Icon(
          isEdit ? Icons.camera_alt : Icons.edit,
          size: 20,
          color: Colors.white,
        ),
      );
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}

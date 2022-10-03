import 'package:flutter/material.dart';

class background extends StatelessWidget {
  const background({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 131, 17, 176),
                Color.fromARGB(255, 69, 2, 95),
              ],
            )
      )
    );
  }
}
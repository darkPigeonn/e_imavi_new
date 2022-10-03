import 'package:flutter/material.dart';

class MenuItem2 extends StatelessWidget {
  final VoidCallback onPressed;
  final String images;
  final String title;



  const MenuItem2({Key? key, required this.images, required this.title, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width : 100,
      padding: EdgeInsets.symmetric(vertical: 5),

        child: InkWell(
          onTap: onPressed,
          child: Column(
            children: <Widget>[
              if(images != "images") Image.asset(images, scale: 5,)
              else CircleAvatar(
                backgroundColor: Color.fromARGB(255, 255, 153, 0),
                child: const Text('PP'),
              ),

              SizedBox(
                height: 5,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple),
              )
            ],
          ),
        ),

    );
  }
}
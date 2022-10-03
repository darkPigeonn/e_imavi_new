import 'package:e_imavi/components/const_color.dart';
import 'package:e_imavi/model/model_kronik.dart';
import 'package:flutter/material.dart';
import 'package:simple_moment/simple_moment.dart';

class DetailKronik extends StatelessWidget {
  final KronikModel dataDetails;
  const DetailKronik({Key? key, required this.dataDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Moment rawDate = Moment.parse(dataDetails.createdAt.toString());
    var date = rawDate.format('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: mPrimary,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  dataDetails.title.toString(),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  dataDetails.subject.toString() +
                      ' | ' +
                      dataDetails.character.toString() +
                      ' | ' +
                      dataDetails.type.toString() +
                      ' | ' +
                      dataDetails.concerns.toString(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(dataDetails.content.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

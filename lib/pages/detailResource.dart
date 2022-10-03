import 'package:e_imavi/model/model_attendances.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:flutter_tts/flutter_tts.dart';

class DetailResource extends StatefulWidget {
  final ModelResources1 dataDetails;
  DetailResource({Key? key, required this.dataDetails}) : super(key: key);

  @override
  State<DetailResource> createState() => _DetailResourceState();
}

class _DetailResourceState extends State<DetailResource> {
  final FlutterTts flutterTts = FlutterTts();
    bool listen = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
  }

  speech(String text) async {
    await flutterTts.setLanguage("in");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  final String urlImage =
      'https://static.imavi.org/komunio/archived/komunio_media/';
  @override
  Widget build(BuildContext context) {
    ModelResources1 data = widget.dataDetails;

    Moment rawDate = Moment.parse(data.publishDate);
    var date = rawDate.format('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Color.fromARGB(255, 106, 0, 124),
        actions: [
          Padding(
            padding: EdgeInsets.all(0),
            child: IconButton(
              icon: (listen == false) ? Icon(Icons.hearing) : Icon(Icons.hearing_disabled),
              onPressed: () {
                if (listen == false) {
                  String parsedstring = Bidi.stripHtmlIfNeeded(data.content);
                  speech(parsedstring);
                  setState(() {
                    listen = true;
                  });
                } else {
                  flutterTts.stop();
                  setState(() {
                    listen = false;
                  });
                }
              },
            ),
          ),
          IconButton(
              icon: Icon(Icons.share_outlined),
              onPressed: () {
                Share.share('text');
              },
            ),

        ],
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width,
              child: Text(
                data.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Image.network(
              data.imageLink.contains('https') ? data.imageLink :
              urlImage + data.imageLink,
              errorBuilder: (context, error, stackTrace) {
                return Container();
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(color: Color.fromARGB(255, 139, 9, 0)),
                    child: Text(
                      data.author,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration:
                        BoxDecoration(color: Color.fromARGB(255, 213, 99, 0)),
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Html(
                data: data.content,
                style: {
                  "body": Style(
                      fontSize: FontSize(16.0), textAlign: TextAlign.justify)
                },
              ),
            )
          ],
        )),
      ),
    );
  }
}

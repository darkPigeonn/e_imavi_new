import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:e_imavi/controller/wfh_controller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/uiHelpers.dart';
// import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as webGM;

class Wfh extends StatefulWidget {
  final userId;

  const Wfh({super.key, required this.userId});

  @override
  State<Wfh> createState() => _WfhState();
}

class _WfhState extends State<Wfh> {
  //controler
  final _location = TextEditingController();
  final _catatan = TextEditingController();
  //images
  File? _image;

  Future getImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.camera);

    if (image == null) return;
    final imageTemporay = File(image.path);

    print("imageTemporay");
    print(imageTemporay);
    setState(() {
      this._image = imageTemporay;
    });
  }

  //GIS
  var lat, long;
  final Set<Marker> _marker = {};
  bool showMaps = false;

  String _flagValue = 'In';

  var jam = '';
  String dateNow = DateFormat("yyyy-MM-dd").format(DateTime.now());
  void startJam() {
    Timer.periodic(new Duration(seconds: 1), (_) {
      var tgl = new DateTime.now();
      var formatedjam = new DateFormat.Hms().format(tgl);
      setState(() {
        jam = formatedjam;
      });
    });
  }

  _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      long = position.longitude;
      showMaps = true;
      _marker.add(
        Marker(
            markerId: MarkerId("${position.latitude}, ${position.longitude}"),
            position: LatLng(position.latitude, position.longitude),
            icon: BitmapDescriptor.defaultMarker),
      );
    });
  }

  //example
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startJam();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          color: Color.fromARGB(255, 106, 0, 124),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    'Input Presensi',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    jam + ' WIB',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    formatHrdFull(dateNow),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Lokasi Presensi'),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _location,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Catatan'),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                validator: (value) {
                  if (value != null && value.trim().length < 3) {
                    return 'This field requires a minimum of 3 characters';
                  }
                  return null;
                },
                maxLines: 5,
                controller: _catatan,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Silahkan ambil foto'),
              SizedBox(
                height: 5,
              ),
              _image == null
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: OutlinedButton(
                        onPressed: () => getImage(),
                        child: Text(
                          'Ambi Foto',
                          style:
                              TextStyle(color: Color.fromARGB(255, 99, 0, 157)),
                        ),
                      ),
                    )
                  : Center(
                      child: Image.file(
                        _image!,
                        width: 250,
                        height: 250,
                      ),
                    ),
              new Padding(
                padding: EdgeInsets.only(bottom: 10),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Map dataSave = {
                          'locationNote': _location.text,
                          'note': _catatan.text,
                          'image': _image,
                          'type': 'in',
                        };
                        wfhAttendance(dataSave, widget.userId);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 99, 0, 157)),
                      child: Text('Masuk')),
                  ElevatedButton(
                      onPressed: () {
                        Map dataSave = {
                          'locationNote': _location.text,
                          'note': _catatan.text,
                          'image': _image,
                          'type': 'out',
                        };
                        wfhAttendance(dataSave, widget.userId);
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 99, 0, 157)),
                      child: Text('Pulang')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

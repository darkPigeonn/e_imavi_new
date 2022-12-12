import 'dart:io';

import 'package:dospace/dospace.dart' as dospace;
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<String> uploadImages(File file, String id) async {
  print('hola halo');

  dospace.Spaces spaces = new dospace.Spaces(
    region: "sgp1",
    accessKey: "JCF6N7HWI4BIHYE5QLMD",
    secretKey: "7aGiKWmNa/hy78c9SrYHPkoPwhjoSl4YGVM9PHuFL/Y",
  );

  String basePathDigitalOcean =
      'https://imavistatic.sgp1.digitaloceanspaces.com';

  // for (String name in await spaces.listAllBuckets()) {
  //   print('bucket : ${name}');
  // }
  var date = DateTime.now();
  String formattedDate = DateFormat('dd-mm-yyyy').format(date);

  var _fileName = 'presensi-' + formattedDate + '-' + id;
  var _extension = '.jpg';
  var _contentType = 'image/.jpg';
  var _filePath = file.path;
  var _filePathDigitalOcean =
      "https://cdn.imavi.org" + '/photoPresensi/' + _fileName + _extension;

  dospace.Bucket bucket = spaces.bucket('imavistatic');

  try {
    await bucket
        .uploadFile("photoPresensi/" + (_fileName + _extension), file,
            _extension, dospace.Permissions.public)
        .then((value) {});

    Map dataReturn = {
      'statusCode': 200,
      'body': _filePathDigitalOcean,
    };
    return _filePathDigitalOcean;
  } catch (e) {
    throw (e);
  }
}

getCurrentLocation() async {
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

  return position;
}

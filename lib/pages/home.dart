import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:e_imavi/components/const_color.dart';
import 'package:e_imavi/model/model_schedule.dart';
import 'package:e_imavi/model/user.dart';
import 'package:e_imavi/pages/kronik/listKronik.dart';
import 'package:e_imavi/pages/permits/ijin.dart';
import 'package:e_imavi/pages/listResources.dart';
import 'package:e_imavi/pages/login.dart';
import 'package:e_imavi/pages/profile.dart';
import 'package:e_imavi/services/firestore_api.dart';
import 'package:e_imavi/services/notification.dart';
import 'package:e_imavi/services/schedule_services.dart';
import 'package:e_imavi/services/user_preferences.dart';
import 'package:e_imavi/utils/env.dart';
import 'package:e_imavi/widgets/background.dart';
import 'package:e_imavi/widgets/bottomnavigation.dart';
import 'package:e_imavi/widgets/menuItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
//alert
import 'package:fluttertoast/fluttertoast.dart';

//local notifikasi
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //variabel
  late bool isActiveNotif = false;
  bool isLoading = true;
  bool isLoadingSchedule = true;
  late String nama = '';
  late String jabatan = '';
  late String partner = '';
  late String userId = ''; //ini id di profile user
  String label = "";

  //get location
  Position? _currentPosition;
  String? _currentAddress;

  //easy loading
  Timer? _timer;
  late double _progress;

  String _scanBarcode = 'Unknown';

  //image storage
  final Storage storage = Storage();

  //User
  late User user;

  //Shedule
  Schedule schedule = Schedule(date: 0, name: '-', description: '-', piket1: '-', piket2: '-');


  //function
  sendNotification(String title) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };
    try{
     http.Response response = await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),headers: <String,String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAyCmUOOA:APA91bFUJFdIt7DAF_qkh7oHC2uqW954-HTTPmnP2VecGNlM6lj7UgaRr3OiT4ZR58Z0EecOW3OGkSOoWWnq4h8AERYssrGT-J00jnqLIAFfOfp_QnbwI7_XTjoHtlcDysL7oY19DGyh'
      },
      body: jsonEncode(<String,dynamic>{
        'notification': <String,dynamic> {'title': title,'body': 'You are followed by someone'},
        'priority': 'high',
        'data': data,
        'to': 'd-Mpc7oqRPmNcXdXtkh2up:APA91bGztCM594GjJeVVPPF0RW4cVuIuf89OeZxNePIX2XQY84o_G4zBMqBVtqt4vU_0uMBCCeD7tzvBxwaUJtfawWWfYwkKoalp3imd-1br5umKC4c8yi1evBKzOa42Lh3rliJuVheR'
      })
      );
      print(response.body);

     if(response.statusCode == 200){
       print("Yeh notificatin is sended");
     }else{
       print("Error");
     }

    }catch(e){

    }

  }

  getDataSchedule() async {

    Schedule data = await ScheduleController().getScheduleToday();
    setState(() {
      schedule = data;
      isLoadingSchedule = false;
    });
  }
  getDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // notif
    final notifAlert = prefs.get('notifStatus');
    if (notifAlert == true) {
      print('object ki');
    }

    final profileToken = prefs.get('profileToken');
    print(profileToken);
    final loginChek = prefs.get('login');
    Map<String, String> headers = {
      'Id': '6147f10d33abc530a445fe84',
      'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
      "Authorization": "bearer $profileToken"
    };
    final response = await http.get(
      Uri.parse(url + 'users/profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      setState(() {
        // user.copy(imagePath: '', name: userData['fullName'], email: userData['email'], about: '');
        user.copy(
            imagePath: '',
            name: userData['fullName'],
            email: userData['email'],
            about: '',
            isDarkMode: false);

        if (loginChek == true) {
          UserPreferences.setUser(user);
          prefs.setBool('login', false);
        }
        nama = userData['fullName'];
        partner = userData['outlets'][0];
        jabatan = userData['jabatan'];
        userId = userData['_id'];

        if (partner == 'imavi') {
          label = "Institutum Theologicum \nIoannis Mariae Vianney Surabayanum";
        }
        if (partner == 'garum') {
          label = "Seminari \nGarum";
        } else {
          label = "Seminari Tinggi \nProvidentia Dei";
        }

        isLoading = false;

      });
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  attendance(type) async {
    EasyLoading.show(status: 'loading...', maskType: EasyLoadingMaskType.black);

    final distance = await getDistance(partner);
    var dt = DateTime.now();


    // //flag qr
    bool flagQr = true;
    if (type == 'in') {
      final cekQr = await scanQR();
      // if(dt.hour > 6 && dt.hour <= 16){
      // } else {
      //   EasyLoading.showError('Anda input kehadiran diluar jam masuk');
      //   return;
      // }
    } else if (type == 'out') {
      flagQr = true;
    }

    if ( flagQr == false) {
      // ngecek hasil barcode
      if (_scanBarcode ==
          'Institutum Theologicum Ioannis Mariae Vianney Surabayanum') {
        flagQr = true;
      } else {
          EasyLoading.showError('Anda belum scan QR');
      }
    }

    if (flagQr == true) {

        final DateTime checkInDateTime = DateTime.now();
      final dataCheckIn = {
        'userId': userId,
        'type': type,
        'location': distance
      };
        final body = jsonEncode(dataCheckIn);

        Map<String, String> headers = {
          'Id': '6147f10d33abc530a445fe84',
          'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
          "Content-type": "application/json"
        };
        final response = await http.post(
            Uri.parse(url + 'users/attendance'),
            headers: headers,
            body: body);

        final responseBody = jsonDecode(response.body);
        if (response.statusCode == 200) {
          EasyLoading.showSuccess(responseBody['message']);
        } else {
          EasyLoading.showError(responseBody['message']);
        }


    }
  }

  // getSchedule() async {
  //   schedule = await ScheduleController().getScheduleToday();
  // }
  Future<Position> getDistance(partner) async {
    bool serviceEnabled;
    bool distance = false;
    LocationPermission permission;

    serviceEnabled =
        await Geolocator.isLocationServiceEnabled(); // cek permision location

    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Silahkan akftifkan lokasi mu!');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Tidak dapat ijin untuk akses lokasi");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Tidak dapat mengakses lokasi');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // double maksimalDistance = 80.0;

    // double currentLatitude = position.latitude;
    // double currentLongitude = position.longitude;

    // double officeLatitude = -7.26991;
    // double officeLongtitude = 112.81251;

    // if (partner == 'garum') {
    //   officeLatitude = -8.073732;
    //   officeLongtitude = 112.226548;
    // }
    // try {
    //   List<Placemark> placemarks =
    //       await placemarkFromCoordinates(officeLatitude, officeLongtitude);
    //   Placemark place = placemarks[0];

    //   double jarak = Geolocator.distanceBetween(
    //       currentLatitude, currentLongitude, officeLatitude, officeLongtitude);
    //   print(jarak);

    //   if (jarak <= maksimalDistance) {
    //     distance = true;
    //   }
    // } catch (e) {
    //   print(e);
    // }
    return position;
  }

  @override
  void initState() {
    super.initState();
    user = UserPreferences.getUser();
    getDataUser();
    getNotificationStatus();
    getDataSchedule();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => HomePage(),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      await Navigator.pushNamed(context, '/secondPage');
    });
  }

  int _current = 0;

  //set notifications
  setNotificationStatus(int code) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    //mengaktifkan notifikasi
    if (code == 1) {
      setState(() {
        isActiveNotif = true;
      });
      pref.setBool('isNotificationStatus', true);
    }
    else if (code == 0) {
      setState(() {
        isActiveNotif = false;
      });
      pref.setBool('isNotificationStatus', false);
    }
  }
  getNotificationStatus() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    final notificationStatus = pref.getBool('isNotificationStatus');

    if (notificationStatus == false) {
      isActiveNotif = false;
    } else if ( notificationStatus == true) {
      isActiveNotif = true;
    }
    else {
      pref.setBool('isNotificationStatus', false);
    }
  }

  //SCANNER

  Future<void> startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
      body : Stack(
        children: [
          background(),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5,),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Text(
                              'E-IMAVI',
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Color.fromARGB(255, 255, 183, 0),
                                  fontWeight: FontWeight.bold),
                            ),
                          Row(
                            children: [
                              IconButton(
                                icon: isActiveNotif==false ? Icon(Icons.notifications_off_sharp, color: Color.fromARGB(255, 255, 183, 0),) : Icon(Icons.notifications_on, color: Color.fromARGB(255, 255, 183, 0),),
                                onPressed: () async {
                                  if (!isActiveNotif) {
                                  await scheduleWorkTime(0, 'Waktunya Jam Pulang',
                                      'Jangan lupa klik jam pulang ya $nama', Time(16, 00));
                                      setState(() {

                                        setNotificationStatus(1);
                                        Fluttertoast.showToast(
                                          msg: 'Notifikasi Pulang On',
                                          backgroundColor: Color.fromARGB(255, 2, 115, 0),
                                          textColor: Colors.white,
                                        );
                                      });
                                  } else {
                                      await cancelNotification();
                                    setState(() {
                                        setNotificationStatus(0);
                                        Fluttertoast.showToast(
                                          msg: 'Notifikasi Pulang Off',
                                          backgroundColor: Color.fromARGB(255, 2, 115, 0),
                                          textColor: Colors.white,
                                        );
                                      });
                                  }
                                },
                              ),
                              IconButton(onPressed: () async{
                                final pref = await SharedPreferences.getInstance();
                                await pref.clear();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                              }, icon: Icon(Icons.logout, color: Color.fromARGB(255, 255, 183, 0),))
                            ],
                          ),

                        ],
                      ),
                    ),
                    ProfilUserPage(
                      imagePath: userId,
                    ),
                    SizedBox(height: 10,),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // if you need this
                          side: BorderSide(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                top: 24,
                                left: 16,
                              ),
                              child: Center(
                                child: Text(
                                  'Silahkan melakukan presensi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      attendance('in');
                                    },
                                      style: ElevatedButton.styleFrom(
                                          primary:
                                              Color.fromARGB(255, 99, 0, 157)),
                                    child: Text('Masuk'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      attendance('out');
                                    },
                                    style:
                                        ElevatedButton.styleFrom(
                                          primary:
                                              Color.fromARGB(255, 99, 0, 157)),
                                    child: Text(
                                      'Pulang',
                                    ),

                                  ),
                                ],
                              ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                child: Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary:
                                              Color.fromARGB(255, 99, 0, 157),
                                          fixedSize: Size(100, 40)),
                                      onPressed: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    IjinPage()));
                                        // final snackBar = SnackBar(
                                        //   content: const Text('Comming Soon'),
                                        // );
                                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      },
                                      child: Text('Ijin')),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),

                    SizedBox(height: 20,),
                    partner == 'imavi'?
                    Container(
                      decoration: new BoxDecoration(
                         gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Color.fromARGB(255, 176, 54, 225),
                            Color.fromARGB(255, 172, 92, 222),
                            Color.fromARGB(255, 222, 99, 243),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          new BoxShadow(
                            color: Color.fromARGB(255, 211, 211, 211),
                            blurRadius: 4.0,
                          ),
                        ],
                      ),

                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                              child: isLoadingSchedule
                                  ? Center(child: CircularProgressIndicator())
                                  : Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(child: Text(schedule.name, style: mStyleSubTitle)),

                                Container(child: Text(schedule.piket1, style: mStyleSubTitle)),

                              ],
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text("Bahasa "+schedule.description, style: mStyleSubTitle ,)),
                                Container(child: Text(schedule.piket2, style: mStyleSubTitle)),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ) : Container(),

                    Container(
                      margin : EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    MenuItem2(
                                      images: 'assets/images/art.png',
                                      title: 'Artikel',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ListReources(
                                                      resourcesLabel: 'Articles',
                                                    )));
                                      },
                                    ),
                                    MenuItem2(
                                        images: 'assets/images/berita.png',
                                        title: 'Berita',
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ListReources(
                                                        resourcesLabel: 'News',
                                                      )));
                                        }),
                                    MenuItem2(
                                        images: 'assets/images/doa.png',
                                        title: 'Doa',
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ListReources(
                                                      resourcesLabel: 'Prayers')));
                                        }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Center(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(255, 99, 0, 157),
                                      fixedSize: Size(100, 40)),
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ListKronik()));
                                    // final snackBar = SnackBar(
                                    //   content: const Text('Comming Soon'),
                                    // );
                                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  },
                                  child: Text('Kronik')),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              )
            ),
          )
        ],
      )
    );
  }
}


class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      );
}

import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:e_imavi/provider/data_provider.dart';
import 'package:e_imavi/widgets/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HistoryAttendances extends ConsumerWidget {
  static var today = new DateTime.now();
  var formatedTanggal = new DateFormat.MMMM().format(today);
  HistoryAttendances({Key? key}) : super(key: key);

  String utcToLocal(date) {
    late String dataReturn = '-';
    print(date);
    if (date != '-') {
      var local = DateTime.parse(date).toLocal();
      dataReturn = DateFormat.Hm().format(local);
    }

    return dataReturn;
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future refreshData() async {
      ref.refresh(userAttendanceProvider);
    }
    final _data = ref.watch(userAttendanceProvider);
      return Scaffold(
       floatingActionButton: FloatingActionButton(
        onPressed: refreshData,
        tooltip: 'Increment',
        child: const Icon(Icons.replay),
      ), //
        body: RefreshIndicator(
          onRefresh: refreshData,
           color: Colors.white,
        backgroundColor: Colors.purple,
          child: _data.when(
              data: (_data) {
                return SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.only(top: 50),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          Center(child: Text('Daftar Hadir Bulan $formatedTanggal', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),),
                          Container(
                            color: Colors.white,
                            padding:
                                EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                            child: DefaultTextStyle(
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Tanggal",
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Jam Masuk",
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Jam Keluar",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ..._data.map(
                            (e) => Container(
                              color: Colors.white,
                              padding:
                                  EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                              child: DefaultTextStyle(
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        e.date,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        utcToLocal(e.checkIn),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        utcToLocal(e.checkOut),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                );

              },
              error: (err, s) {
                return Center(
                  child: Text(err.toString()),
                );
              },
              loading: () => Center(
                    child: CircularProgressIndicator(),
                  )),
        ));
  }
  // State<HistoryAttendances> createState() => _HistoryAttendancesState();
}

// final months = [
//   {"code": 01, "label": "Januari"},
//   {"code": 02, "label": "Februari"},
//   {"code": 03, "label": "Maret"},
//   {"code": 04, "label": "April"},
//   {"code": 05, "label": "Mei"},
//   {"code": 06, "label": "Juni"},
//   {"code": 07, "label": "Juli"},
//   {"code": 08, "label": "Agustus"},
//   {"code": 09, "label": "September"},
//   {"code": 10, "label": "Oktober"},
//   {"code": 11, "label": "November"},
//   {"code": 12, "label": "Desember"},
// ];

// class _HistoryAttendancesState extends State<HistoryAttendances> {
//   //initial variabel
//   late List<dynamic> listAttendance;
//   getAttendance() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     final profileToken = prefs.get('profileToken');

//     Map<String, String> headers = {
//       'Id': '6147f10d33abc530a445fe84',
//       'Secret': '88022467-0b5c-4e61-8933-000cd884aaa8',
//       "Authorization": "bearer $profileToken"
//     };
//     final response = await http.get(
//       Uri.parse('https://api.imavi.org/imavi/users/attendanceHistory'),
//       headers: headers,
//     );
//     print(response.statusCode);
//     if (response.statusCode == 200) {
//       final userData = jsonDecode(response.body);
//       setState(() {
//         listAttendance = userData;
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     getAttendance();
//   }

//   String? selectedValue;
//   @override
//   Widget build(BuildContext context) {
//     print(listAttendance);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'IMAVI',
//           style: TextStyle(color: Colors.purple),
//         ),
//         elevation: 0,
//       ),
//       backgroundColor: Colors.grey[50],
//       body: Container(
//         child: Column(
//           children: [
//             DropdownButtonFormField2(
//               decoration: InputDecoration(
//                 //Add isDense true and zero Padding.
//                 //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
//                 isDense: true,
//                 contentPadding: EdgeInsets.zero,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 //Add more decoration as you want here
//                 //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
//               ),
//               isExpanded: true,
//               hint: const Text(
//                 'Silahkan pilih bulan',
//                 style: TextStyle(fontSize: 14),
//               ),
//               icon: const Icon(
//                 Icons.arrow_drop_down,
//                 color: Colors.black45,
//               ),
//               iconSize: 30,
//               buttonHeight: 50,
//               buttonPadding: const EdgeInsets.only(left: 20, right: 10),
//               dropdownDecoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               items: months
//                   .map((item) => DropdownMenuItem<Object>(
//                         value: item['code'],
//                         child: Text(
//                           '${item['label']}',
//                           style: const TextStyle(
//                             fontSize: 14,
//                           ),
//                         ),
//                       ))
//                   .toList(),
//               validator: (value) {
//                 if (value == null) {
//                   return 'Please select gender.';
//                 }
//               },
//               onChanged: (value) {
//                 //Do something when changing the item if you want.
//               },
//               onSaved: (value) {
//                 selectedValue = value.toString();
//               },
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 columns: <DataColumn>[
//                   DataColumn(label: Text("Tanggal")),
//                   DataColumn(label: Text("Jam Masuk")),
//                   DataColumn(label: Text("Jam Keluar")),
//                   DataColumn(label: Text("Keterangan")),
//                 ],
//                 rows: <DataRow>[
//                   DataRow(
//                     cells: <DataCell>[
//                       DataCell(Text("Frozen Yogurt")),
//                       DataCell(Text("159")),
//                       DataCell(Text("6.0")),
//                       DataCell(Text("4.0")),
//                     ],
//                   ),
//                   DataRow(
//                     cells: <DataCell>[
//                       DataCell(Text("Ice Cream Sandwich")),
//                       DataCell(Text("237")),
//                       DataCell(Text("9.0")),
//                       DataCell(Text("4.3")),
//                     ],
//                   ),
//                   DataRow(
//                     cells: <DataCell>[
//                       DataCell(Text("Eclair")),
//                       DataCell(Text("262")),
//                       DataCell(Text("16.0")),
//                       DataCell(Text("6.0")),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),

//       // body: Container(
//       //   child: ListView(
//       //     physics: ClampingScrollPhysics(),
//       //     children: <Widget>[
//       //       //User
//       //       Padding(
//       //         padding: EdgeInsets.only(top: 5, left: 16),
//       //         child: Text(
//       //           'Daftar Hadir',
//       //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       //         ),
//       //       ),
//       //       Container(
//       //         margin: EdgeInsets.symmetric(horizontal: 12),
//       //         child: Column(
//       //           crossAxisAlignment: CrossAxisAlignment.start,
//       //           children: <Widget>[
//       //             Column(
//       //               children: [
//       //                 const SizedBox(height: 30),
//       //                 DropdownButtonFormField2(
//       //                   decoration: InputDecoration(
//       //                     //Add isDense true and zero Padding.
//       //                     //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
//       //                     isDense: true,
//       //                     contentPadding: EdgeInsets.zero,
//       //                     border: OutlineInputBorder(
//       //                       borderRadius: BorderRadius.circular(15),
//       //                     ),
//       //                     //Add more decoration as you want here
//       //                     //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
//       //                   ),
//       //                   isExpanded: true,
//       //                   hint: const Text(
//       //                     'Select Your Gender',
//       //                     style: TextStyle(fontSize: 14),
//       //                   ),
//       //                   icon: const Icon(
//       //                     Icons.arrow_drop_down,
//       //                     color: Colors.black45,
//       //                   ),
//       //                   iconSize: 30,
//       //                   buttonHeight: 60,
//       //                   buttonPadding:
//       //                       const EdgeInsets.only(left: 20, right: 10),
//       //                   dropdownDecoration: BoxDecoration(
//       //                     borderRadius: BorderRadius.circular(15),
//       //                   ),
//       //                   items: genderItems
//       //                       .map((item) => DropdownMenuItem<String>(
//       //                             value: item,
//       //                             child: Text(
//       //                               item,
//       //                               style: const TextStyle(
//       //                                 fontSize: 14,
//       //                               ),
//       //                             ),
//       //                           ))
//       //                       .toList(),
//       //                   validator: (value) {
//       //                     if (value == null) {
//       //                       return 'Please select gender.';
//       //                     }
//       //                   },
//       //                   onChanged: (value) {
//       //                     //Do something when changing the item if you want.
//       //                   },
//       //                   onSaved: (value) {
//       //                     selectedValue = value.toString();
//       //                   },
//       //                 ),
//       //                 const SizedBox(height: 30)
//       //               ],
//       //             )
//       //           ],
//       //         ),
//       //       ),
//       //       SingleChildScrollView(
//       //         scrollDirection: Axis.horizontal,
//       //         child: DataTable(
//       //           columns: const <DataColumn>[
//       //             DataColumn(
//       //               label: Text(
//       //                 'Tanggal',
//       //               ),
//       //             ),
//       //             DataColumn(
//       //               label: Text(
//       //                 'Jam Masuk',
//       //               ),
//       //             ),
//       //             DataColumn(
//       //               label: Text(
//       //                 'Jam Pulang',
//       //               ),
//       //             ),
//       //             DataColumn(
//       //               label: Text(
//       //                 'Jam Pulang',
//       //               ),
//       //             ),
//       //           ],
//       //           rows: const <DataRow>[
//       //             DataRow(
//       //               cells: <DataCell>[
//       //                 DataCell(Text('Sarah')),
//       //                 DataCell(Text('19')),
//       //                 DataCell(Text('Student')),
//       //               ],
//       //             ),
//       //             DataRow(
//       //               cells: <DataCell>[
//       //                 DataCell(Text('Janine')),
//       //                 DataCell(Text('43')),
//       //                 DataCell(Text('Professor')),
//       //               ],
//       //             ),
//       //             DataRow(
//       //               cells: <DataCell>[
//       //                 DataCell(Text('William')),
//       //                 DataCell(Text('27')),
//       //                 DataCell(Text('Associate Professor')),
//       //               ],
//       //             ),
//       //             DataRow(
//       //               cells: <DataCell>[
//       //                 DataCell(Text('William')),
//       //                 DataCell(Text('27')),
//       //                 DataCell(Text('Associate Professor')),
//       //               ],
//       //             ),
//       //           ],
//       //         ),
//       //       )
//       //     ],
//       //   ),
//       // ),
//     );
//   }
// }

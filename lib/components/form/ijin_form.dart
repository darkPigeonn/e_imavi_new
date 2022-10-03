import 'dart:developer';

import 'package:e_imavi/components/const_color.dart';
import 'package:e_imavi/services/permits_services.dart';
import 'package:e_imavi/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class IjinForm extends StatefulWidget {
  IjinForm({Key? key}) : super(key: key);


  @override
  State<IjinForm> createState() => _IjinFormState();
}

class _IjinFormState extends State<IjinForm> {
  final _startDate = TextEditingController();
  final _endDate = TextEditingController();
  final _reason = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
        return Scaffold(
      body: Stack(
        children: [
          background(),
          SafeArea(
            child: SingleChildScrollView(
              child: Container(

                constraints: BoxConstraints(
                  maxHeight: size.height,
                  maxWidth: size.width,
                ),
                child: Column(
                  children: [
                    Expanded(
                      flex: 5,
                      child: Form(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white
                          ),
                          margin: EdgeInsets.all(20),
                          child: Container(
                            margin: EdgeInsets.all(20),
                            child: ListView(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    "Form Ijin",
                                    style: mStyleTitle,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "Silahkan isi semua form dibawah ini, untuk pengajuan ijin",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: mSubtitle,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: TextField(
                                    controller : _startDate,
                                    // decoration : InputDecoration(
                                    //   icon : Icon(Icons.calendar_today),
                                    //   labelText : "Pilih tanggal mulai ijin"
                                    // ),
                                    decoration: const InputDecoration(

                                      labelText : "Pilih tanggal mulai ijin",

                                      border: OutlineInputBorder(),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red, width: 5)
                                      )
                                    ),
                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101)
                                      );

                                      if (pickedDate != null) {
                                        print(pickedDate);
                                        String formattedDate = DateFormat('dd MMMM yyyy').format(pickedDate);
                                        print(formattedDate);
                                        setState(() {
                                          _startDate.text = formattedDate;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  child: TextField(
                                    controller : _endDate,
                                    // decoration : InputDecoration(
                                    //   icon : Icon(Icons.calendar_today),
                                    //   labelText : "Pilih tanggal mulai ijin"
                                    // ),
                                    decoration: const InputDecoration(

                                    labelText : "Pilih tanggal selesai ijin",
                                    border: OutlineInputBorder(),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red, width: 5)
                                    )
                                  ),

                                    readOnly: true,
                                    onTap: () async {
                                      DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101)
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate = DateFormat('dd MMMM yyyy').format(pickedDate);
                                        setState(() {
                                          _endDate.text = formattedDate;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value != null && value.trim().length < 3) {
                                      return 'This field requires a minimum of 3 characters';
                                    }
                                    return null;
                                  },
                                  maxLines: 5,
                                  controller: _reason,
                                  decoration: const InputDecoration(
                                      labelText: 'Keperluan Ijin ',
                                      border: OutlineInputBorder(),
                                      errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.red, width: 5))),
                                ),

                                ElevatedButton(
                                  onPressed: () async{
                                    if (_reason.text.toString() != '' && _startDate.text.toString() != '' && _endDate.text.toString() != '') {
                                      var dataSend = await PermitsServices().createPermits(_reason.text.toString(), _startDate.text.toString(), _endDate.text.toString());
                                      if (dataSend['code'] == 200) {
                                        EasyLoading.showSuccess('Pengajuan Ijinmu terkirim').then((value) => Navigator.pop(context));
                                      }
                                    } else {
                                      EasyLoading.showError('Isi dengan lengkap!');
                                    }
                                  },
                                  child: Text('Kirim'),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
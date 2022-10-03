import 'dart:developer';
import 'dart:math';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:e_imavi/components/const_color.dart';
import 'package:e_imavi/services/kronik_services.dart';
import 'package:e_imavi/utils/env.dart';
import 'package:e_imavi/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../../services/permits_services.dart';

class KronikForm extends StatefulWidget {
  KronikForm({Key? key}) : super(key: key);

  @override
  State<KronikForm> createState() => _KronikFormState();
}

class _KronikFormState extends State<KronikForm> {
  // stepper
  int _index = 0;

  //klasifikasi
  String? selectedSubjectKronik,
      selectedCharacter,
      selectedType,
      selectedConcern,
      selectedExtendConcern,
      content;

  //Kontent
  final _title = TextEditingController();
  final _what = TextEditingController();
  final _who = TextEditingController();
  final _when = TextEditingController();
  final _where = TextEditingController();
  final _why = TextEditingController();
  final _how = TextEditingController();
  final _note = TextEditingController();

  Future<void> _saveKronik() async {
    Map data = {
      'subject': selectedSubjectKronik,
      'character': selectedCharacter,
      'type': selectedType,
      'concern': selectedConcern,
      'title': _title.text.toString(),
      'content': content
    };
    if (selectedExtendConcern != null) {
      data['extendConcern'] = selectedExtendConcern;
    }

    var dataSend = await KronikService().createKronik(data).then((value) {
      print("value");
      print(value);
      if (value['code'] == 200) {
        EasyLoading.showSuccess(value['message']);
        Navigator.pop(context);
      } else {
        EasyLoading.showError(value['message']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLastStep = _index == getSteps().length - 1;
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        background(),
        SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Form Kronik",
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
                Container(
                  margin: EdgeInsets.all(10),
                  constraints: BoxConstraints(
                    maxHeight: size.height,
                    maxWidth: size.width,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  child: Stepper(
                    controlsBuilder: (context, ControlsDetails details) {
                      return Row(
                        children: [
                          _index > 0
                              ? ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.grey)),
                                  onPressed: details.onStepCancel,
                                  child: const Text('Kembali'),
                                )
                              : Container(),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                              onPressed: details.onStepContinue,
                              child:
                                  Text(isLastStep ? 'Simpan' : 'Selanjutnya'))
                        ],
                      );
                    },
                    currentStep: _index,
                    onStepCancel: () {
                      if (_index > 0) {
                        setState(() {
                          _index -= 1;
                        });
                      }
                    },
                    onStepContinue: () {
                      final isLastStep = _index == getSteps().length - 1;
                      final isReview = _index == getSteps().length - 2;
                      if (isReview) {
                        content =
                            _what.text.toString() +
                            ' ' +
                            _who.text.toString() +
                            ' ' +
                            _when.text.toString() +
                            ' ' +
                            _where.text.toString() +
                            ' ' +
                            _why.text.toString() +
                            ' ' +
                            _how.text.toString();
                      }
                      if (isLastStep) {
                        _saveKronik();
                      } else {
                        // _saveTemp();
                        setState((() => _index += 1));
                      }
                    },
                    onStepTapped: (int index) {
                      setState(() {
                        _index = index;
                      });
                    },
                    steps: getSteps(),
                    type: StepperType.horizontal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Step> getSteps() {
    List<Step> data = [];

    var step0 = Step(
      state: _index > 0 ? StepState.complete : StepState.indexed,
      isActive: _index >= 0,
      title: Text('Klasifikasi'),
      content: Container(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Subjek Kronik'),
              SizedBox(
                height: 5,
              ),
              DropdownSearch<dynamic>(
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                ),
                items: subjectKronik.map((e) => e['label']).toList(),
                selectedItem: "-",
                onChanged: (item) {
                  selectedSubjectKronik = "$item";
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text('Sifat Aktivitas'),
              SizedBox(
                height: 5,
              ),
              DropdownSearch<dynamic>(
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                ),
                items: characterActivities.map((e) => e['label']).toList(),
                selectedItem: "-",
                onChanged: (item) {
                  selectedCharacter = "$item";
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text('Jenis Aktivitas'),
              SizedBox(
                height: 5,
              ),
              DropdownSearch<dynamic>(
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                ),
                items: typeActivities.map((e) => e['label']).toList(),
                selectedItem: "-",
                onChanged: (item) {
                  selectedType = "$item";
                },
              ),
              SizedBox(
                height: 10,
              ),
              Text('Kepentingan'),
              SizedBox(
                height: 5,
              ),
              DropdownSearch<dynamic>(
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                ),
                items: concerns.map((e) => e['label']).toList(),
                selectedItem: "-",
                onChanged: (item) {
                  setState(() {
                    selectedConcern = "$item";
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              selectedConcern == 'Keuskupan Surabaya'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fokus Kepentingan'),
                        SizedBox(
                          height: 5,
                        ),
                        DropdownSearch<dynamic>(
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                          ),
                          items:
                              extendsConcerns.map((e) => e['label']).toList(),
                          selectedItem: "-",
                          onChanged: (item) {
                            selectedExtendConcern = "$item";
                          },
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );

    var step1 = Step(
      state: _index > 1 ? StepState.complete : StepState.indexed,
      isActive: _index >= 1,
      title: Text('Isi 1'),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Judul'),
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
                controller: _title,
                decoration: const InputDecoration(
                    labelText: '...',
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Apa yang terjadi ?'),
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
                controller: _what,
                decoration: const InputDecoration(
                    labelText: '...',
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Siapa yang terlibat ?'),
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
                controller: _who,
                decoration: const InputDecoration(
                    labelText: '...',
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Kapan kejadian tersebut terjadi ?'),
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
                controller: _when,
                decoration: const InputDecoration(
                    labelText: '...',
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Dimana kejadian tersebut terjadi ?'),
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
                controller: _where,
                decoration: const InputDecoration(
                    labelText: '...',
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))),
              ),
            ],
          ),
        ),
      ),
    );

    var step2 = Step(
      state: _index > 2 ? StepState.complete : StepState.indexed,
      isActive: _index >= 2,
      title: Text('Isi 2'),
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mengapa kejadian tersebut terjadi ?'),
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
                controller: _why,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: '...',
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Bagaimana kejadian tersebut terjadi ?'),
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
                controller: _how,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: '...',
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Catatan Tambahan'),
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
                controller: _note,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: '...',
                    border: OutlineInputBorder(),
                    errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 5))),
              ),
            ],
          ),
        ),
      ),
    );
    var step3 = Step(
      state: _index > 3 ? StepState.complete : StepState.indexed,
      isActive: _index >= 3,
      title: Text('Selesai'),
      content: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Detail data yang diinput : '),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text("Subjek Kronik")),
                            Text(" : "),
                            Flexible(
                              child: Text(
                                selectedSubjectKronik.toString(),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text("Sifat Aktivitas")),
                            Text(" : "),
                            Text(selectedCharacter.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text("Jenis Aktivitas")),
                            Text(" : "),
                            Text(selectedType.toString()),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text("Kepentingan")),
                            Text(" : "),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(selectedConcern.toString()),
                                selectedExtendConcern != null
                                    ? Text(selectedExtendConcern!)
                                    : Text('')
                              ],
                            ),
                          ],
                        ),

                        //address
                        Divider(),
                        Text(content.toString()),
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text("Catatan")),
                            Text(" : "),
                            Text(_note.text.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    data = [step0, step1, step2, step3];

    return data.toList();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_imavi/components/form/ijin_form.dart';
import 'package:e_imavi/provider/data_provider.dart';
import 'package:e_imavi/services/permits_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class IjinPage extends ConsumerWidget {
 static var today = new DateTime.now();
  var formatedTanggal = new DateFormat.MMMM().format(today);
  String utcToLocal(date) {
    late String dataReturn = '-';
    print(date);
    if (date != '-') {
      var local = DateTime.parse(date).toLocal();
      dataReturn = DateFormat.yMMMMd().format(local);
    }

    return dataReturn;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future refreshData() async {
      print('refresh');
      ref.refresh(permitsProvider);
    }
    final _listPermits = ref.watch(permitsProvider);

   return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 69, 2, 95),
        title: Text('Riwayat Ijin'),
        actions: [
          IconButton(onPressed: refreshData, icon: Icon(Icons.refresh))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> IjinForm())),
        tooltip: 'Increment',
        backgroundColor: Color.fromARGB(255, 69, 2, 95),
        child: const Icon(Icons.add,),
      ), //
        body: RefreshIndicator(
          onRefresh: refreshData,
          color: Colors.white,
        backgroundColor: Colors.purple,
          child: _listPermits.when(
              data: (_data) {

                return _data.isNotEmpty
                    ? SingleChildScrollView(
                  child: Container(
                      child: Column(
                        children: [
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
                                      "Ijin",
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "Status",
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
                                      flex: 1,
                                      child: Text(
                                        utcToLocal(e.startDatePermit),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                       e.reason,
                                       maxLines: 2,
                                       overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        e.status == 1 ? "Tersejui" : e.status == 99 ? "Ditolak" : "-",
                                        textAlign: TextAlign.center,
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
                      )
                    : Center(
                        child: Text('Belum ada data'),
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
}
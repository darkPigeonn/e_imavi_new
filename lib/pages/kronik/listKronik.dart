import 'package:e_imavi/components/form/kronik_form.dart';
import 'package:e_imavi/pages/kronik/detailKronik.dart';
import 'package:e_imavi/provider/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ListKronik extends ConsumerWidget {
  const ListKronik({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String utcToLocal(date) {
      late String dataReturn = '-';
      print(date);
      if (date != '-') {
        var local = DateTime.parse(date).toLocal();
        dataReturn = DateFormat.yMMMMd().format(local);
      }

      return dataReturn;
    }

    Future refreshData() async {
      print('refresh');
      ref.refresh(kronikProvider);
    }

    final _listKronik = ref.watch(kronikProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 69, 2, 95),
        title: Text('Kronik'),
        actions: [
          IconButton(onPressed: refreshData, icon: Icon(Icons.refresh))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => KronikForm())),
        tooltip: 'Buat Kronik',
        backgroundColor: Color.fromARGB(255, 69, 2, 95),
        child: const Icon(
          Icons.add,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        color: Colors.white,
        backgroundColor: Colors.purple,
        child: _listKronik.when(
            data: (_data) {
              return _data.isNotEmpty
                  ? SingleChildScrollView(
                      child: Container(
                        child: Column(
                          children: [
                            ..._data.map(
                              (e) => Container(
                                color: Colors.white,
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  child: Card(
                                    elevation: 2,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailKronik(dataDetails: e),
                                            ));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              child: Icon(
                                                Icons.book,
                                                size: 50,
                                                color: Color.fromARGB(
                                                    255, 255, 114, 7),
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.75,
                                                  child: Text(
                                                    e.title.toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 2.0)),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Text(
                                                    utcToLocal(e.createdAt),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.black54,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
      ),
    );
  }
}

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/ListRuanganModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminRuanganPage extends StatefulWidget {
  AdminRuanganPage({Key key}) : super(key: key);
  @override
  _AdminRuanganPageState createState() => _AdminRuanganPageState();
}

class _AdminRuanganPageState extends State<AdminRuanganPage> {
  ListRuanganResponseModel listRuanganResponseModel;

  List<Data> ruanganListSearch = List<Data>();

  @override
  void initState() {
    super.initState();

    listRuanganResponseModel = ListRuanganResponseModel();

    Timer.periodic(Duration(seconds: 2), (Timer t) {
      getListRuangan();
      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });
  }

  void getListRuangan() async {
    setState(() {
      print(listRuanganResponseModel.toJson());

      APIService apiService = new APIService();

      apiService.getListRuangan().then((value) async {
        listRuanganResponseModel = value;

        ruanganListSearch = value.data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        centerTitle: true,
        title: Text(
          'Ubah Perangkat Ruangan',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'WorkSansMedium',
              fontWeight: FontWeight.bold),
        ),
        actions: [
          FutureBuilder(
            future: Connectivity().checkConnectivity(),
            builder: (BuildContext context,
                AsyncSnapshot<ConnectivityResult> snapshot) {
              if (snapshot.data == ConnectivityResult.wifi) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.wifi_rounded,
                    color: Colors.green,
                  ),
                );
              } else if (snapshot.data == ConnectivityResult.mobile) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.signal_cellular_4_bar_rounded,
                    color: Colors.green,
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Icon(
                    Icons.signal_cellular_off_rounded,
                    color: Colors.red,
                  ),
                );
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          getListRuangan(),
          Fluttertoast.showToast(
              msg: 'Menyegarkan...',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 14.0)
        },
        child: Icon(Icons.refresh_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      body: listRuanganResponseModel.data == null
          ? Container(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Mohon Tunggu..',
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'WorkSansMedium',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : listRuanganResponseModel.data.isEmpty
              ? Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(25)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Ruangan Kosong',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Cari Ruangan',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            style: const TextStyle(
                                fontFamily: 'WorkSansSemiBold',
                                fontSize: 16.0,
                                color: Colors.black),
                            onChanged: (text) {
                              text = text.toLowerCase();
                              setState(() {
                                ruanganListSearch = listRuanganResponseModel
                                    .data
                                    .where((ruang) {
                                  var namaRuang = ruang.ruang.toLowerCase();
                                  return namaRuang.contains(text);
                                }).toList();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                            itemCount: ruanganListSearch.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(25)),
                                  child: new ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              'Ruang ${ruanganListSearch[index].ruang}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              'Fakultas ${ruanganListSearch[index].fakultas}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'WorkSansMedium',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              'Prodi ${ruanganListSearch[index].prodi}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'WorkSansMedium',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: MaterialButton(
                                                color: Colors.yellow[800],
                                                shape: StadiumBorder(),
                                                padding: EdgeInsets.all(15),
                                                child: Text(
                                                  "Ubah Perangkat",
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          'WorkSansSemiBold',
                                                      fontSize: 14.0,
                                                      color: Colors.white),
                                                ),
                                                onPressed: () async {
                                                  Get.toNamed(
                                                      '/admin/menu/ruangan/detail');

                                                  SharedPreferences
                                                      saveRuangan =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  await saveRuangan.setString(
                                                      'ruang',
                                                      ruanganListSearch[index]
                                                          .ruang);
                                                  await saveRuangan.setString(
                                                      'fakultas',
                                                      ruanganListSearch[index]
                                                          .fakultas);
                                                  await saveRuangan.setString(
                                                      'prodi',
                                                      ruanganListSearch[index]
                                                          .prodi);
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      Get.toNamed('/admin/menu/ruangan/detail');

                                      SharedPreferences saveRuangan =
                                          await SharedPreferences.getInstance();
                                      await saveRuangan.setString('ruang',
                                          ruanganListSearch[index].ruang);
                                      await saveRuangan.setString('fakultas',
                                          ruanganListSearch[index].fakultas);
                                      await saveRuangan.setString('prodi',
                                          ruanganListSearch[index].prodi);
                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
    );
  }
}

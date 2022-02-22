import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/ListBeaconModel.dart';

class AdminTampilListBeacon extends StatefulWidget {
  AdminTampilListBeacon({Key key}) : super(key: key);

  @override
  _AdminTampilListBeaconState createState() => _AdminTampilListBeaconState();
}

class _AdminTampilListBeaconState extends State<AdminTampilListBeacon> {
  ListBeaconResponseModel listBeaconResponseModel;

  List<Data> beaconListSearch = List<Data>();

  bool condition = false;

  @override
  void initState() {
    super.initState();

    listBeaconResponseModel = ListBeaconResponseModel();

    Timer.periodic(Duration(seconds: 2), (Timer t) {
      getListBeacon();
      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });
  }

  getListBeacon() async {
    setState(() {
      print(listBeaconResponseModel.toJson());

      APIService apiService = new APIService();

      apiService.getListBeacon().then((value) async {
        listBeaconResponseModel = value;

        beaconListSearch = value.data;
      });
    });

    return beaconListSearch;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        centerTitle: true,
        title: Text(
          'Tampil Beacon',
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
          getListBeacon(),
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
      body: listBeaconResponseModel.data == null
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
          : listBeaconResponseModel.data.isEmpty
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
                                'Beacon Kosong',
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
                              hintText: 'Cari Beacon',
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
                                beaconListSearch = listBeaconResponseModel.data
                                    .where((beacon) {
                                  var namabeacon =
                                      beacon.namadevice.toLowerCase();
                                  return namabeacon.contains(text);
                                }).toList();
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    // FutureBuilder(
                    //   future: getListBeacon(),
                    //   initialData: beaconListSearch,
                    //   builder:
                    //       (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                    //     if (snapshot.connectionState == ConnectionState.none ||
                    //         snapshot.connectionState == ConnectionState.waiting &&
                    //             !snapshot.hasData) {
                    //       return Center(child: CircularProgressIndicator());
                    //     } else {
                    // return
                    Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                            itemCount: beaconListSearch.length,
                            itemBuilder: (context, index) {
                              // if (beaconListSearch[index].status == 1 ||
                              //     beaconListSearch[index].status == null) {
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
                                              beaconListSearch[index]
                                                  .namadevice,
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              'UUID',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Scrollbar(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: new Text(
                                                  beaconListSearch[index].uuid,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily:
                                                        'WorkSansMedium',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              'Jarak Minimal',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              '${beaconListSearch[index].jarakmin} m',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              'MAJOR',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              '${beaconListSearch[index].major}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              'Minor',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              '${beaconListSearch[index].minor}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'WorkSansMedium',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                              // } else {
                              //   return SizedBox(
                              //     height: 0,
                              //   );
                              // }
                            }),
                      ),
                    )
                    // ),
                  ],
                ),
      //     )
      //   ],
      // ),
    );
  }
}

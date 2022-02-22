import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/ListBeaconModel.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/ListDetailRuanganNamaDeviceModel.dart';
import 'package:presensiblebeacon/MODEL/Ruangan/UbahRuangBeaconModel.dart';
import 'package:presensiblebeacon/UTILS/ProgressHUD.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDetailRuanganPage extends StatefulWidget {
  AdminDetailRuanganPage({Key key}) : super(key: key);

  @override
  _AdminDetailRuanganPageState createState() => _AdminDetailRuanganPageState();
}

class _AdminDetailRuanganPageState extends State<AdminDetailRuanganPage> {
  ListDetailRuanganNamaDeviceResponseModel
      listDetailRuanganNamaDeviceResponseModel;

  ListDetailRuanganNamaDeviceRequestModel
      listDetailRuanganNamaDeviceRequestModel;

  bool isApiCallProcess = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  String ruang = "";
  String fakultas = "";
  String prodi = "";
  String namadevice = "";

  String selectedNamaDevice = "";

  int selectedKolomDevice;

  UbahRuangBeaconRequestModel ubahRuangBeaconRequestModel;

  ListBeaconResponseModel listBeaconResponseModel;

  @override
  void initState() {
    super.initState();

    ubahRuangBeaconRequestModel = UbahRuangBeaconRequestModel();

    listBeaconResponseModel = ListBeaconResponseModel();

    listDetailRuanganNamaDeviceResponseModel =
        ListDetailRuanganNamaDeviceResponseModel();
    listDetailRuanganNamaDeviceRequestModel =
        ListDetailRuanganNamaDeviceRequestModel();

    Timer.periodic(Duration(seconds: 2), (Timer t) {
      // getRuang();
      getListBeacon();
      Future.delayed(Duration(seconds: 5), () {
        t.cancel();
      });
    });

    // getDataNamaDevice();
  }

  Future<void> getRuang() async {
    SharedPreferences saveRuang = await SharedPreferences.getInstance();
    setState(() {
      ruang = saveRuang.getString('ruang');
      fakultas = saveRuang.getString('fakultas');
      prodi = saveRuang.getString('prodi');
    });
  }

  Future<void> getListBeacon() async {
    setState(() {
      APIService apiService = new APIService();
      apiService.getListBeacon().then((value) async {
        listBeaconResponseModel = value;
      });
    });
  }

  getDataNamaDevice() async {
    setState(() {
      listDetailRuanganNamaDeviceRequestModel.ruang = ruang;

      APIService apiService = new APIService();

      apiService
          .postRuanganNamaDevice(listDetailRuanganNamaDeviceRequestModel)
          .then((value) async {
        listDetailRuanganNamaDeviceResponseModel = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: buildUbahIDBeacon(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  // Future<bool> _onBackPressed() async {
  //   SharedPreferences saveRuangan = await SharedPreferences.getInstance();
  //   await saveRuangan.setString('ruang', "");
  //   SharedPreferences saveFakultas = await SharedPreferences.getInstance();
  //   await saveFakultas.setString('fakultas', "");
  //   SharedPreferences saveProdi = await SharedPreferences.getInstance();
  //   await saveProdi.setString('prodi', "");
  //   SharedPreferences saveDevice = await SharedPreferences.getInstance();
  //   await saveDevice.setString('namadevice', "");

  //   Get.back();
  // }

  Widget buildUbahIDBeacon(BuildContext context) {
    getRuang();
    // getListBeacon();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        centerTitle: true,
        title: Text(
          'Ubah Perangkat Ruang',
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
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      body: Column(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Ruang : ${ruang ?? "-"}',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'WorkSansMedium',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Fakultas : ${fakultas ?? "-"}',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'WorkSansMedium',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Program Studi : ${prodi ?? "-"}',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'WorkSansMedium',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Silahkan pilih perangkat',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'WorkSansMedium',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 25, top: 10, bottom: 5),
            child: Align(
              alignment: Alignment.topLeft,
            ),
          ),
          listBeaconResponseModel.data == null
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
                  : Expanded(
                      child: Scrollbar(
                        child: ListView.builder(
                            itemCount: listBeaconResponseModel.data?.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: selectedKolomDevice == index
                                          ? Colors.yellow
                                          : Colors.grey[200],
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
                                              listBeaconResponseModel
                                                  .data[index].namadevice,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: 'WorkSansMedium',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Text(
                                              '${listBeaconResponseModel.data[index].jarakmin} m',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'WorkSansMedium',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        selectedKolomDevice = index;
                                      });

                                      selectedNamaDevice =
                                          listBeaconResponseModel
                                              .data[index].namadevice;

                                      print(selectedNamaDevice);
                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(
                    color: Color.fromRGBO(247, 180, 7, 1),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.all(15),
                    child: Text(
                      "Ubah",
                      style: const TextStyle(
                          fontFamily: 'WorkSansSemiBold',
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      try {
                        print(ubahRuangBeaconRequestModel.toJson());

                        print(ruang);
                        print(selectedNamaDevice);

                        setState(() {
                          isApiCallProcess = true;

                          ubahRuangBeaconRequestModel.ruang = ruang;

                          ubahRuangBeaconRequestModel.namadevice =
                              selectedNamaDevice;
                        });

                        Future.delayed(Duration(seconds: 10), () async {
                          setState(() {
                            isApiCallProcess = false;
                          });

                          Fluttertoast.showToast(
                              msg: 'Silahkan coba kembali',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        });

                        APIService apiService = new APIService();

                        apiService
                            .putUbahRuangBeacon(ubahRuangBeaconRequestModel)
                            .then((value) async {
                          if (value != null) {
                            setState(() {
                              isApiCallProcess = false;
                            });
                          }
                          Get.back();

                          await Fluttertoast.showToast(
                              msg: 'Berhasil mengubah perangkat beacon ruangan',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        });
                      } catch (error) {
                        Fluttertoast.showToast(
                            msg: 'Terjadi kesalahan, silahkan coba lagi',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 14.0);
                      }
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(
                    color: Colors.blue,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                        ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // Text(
                        //   "Segarkan",
                        //   style: const TextStyle(
                        //       fontFamily: 'WorkSansSemiBold',
                        //       fontSize: 18.0,
                        //       color: Colors.white),
                        // ),
                      ],
                    ),
                    onPressed: () => {
                          getListBeacon(),
                          getDataNamaDevice(),
                          Fluttertoast.showToast(
                              msg: 'Menyegarkan...',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 14.0)
                        }),
              ),
            ],
          ),
        ],
      ),
      //     )
      //   ],
      // ),
    );
    // );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

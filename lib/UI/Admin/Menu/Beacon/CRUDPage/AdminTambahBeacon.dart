import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:presensiblebeacon/API/APIService.dart';
import 'package:presensiblebeacon/MODEL/Beacon/TambahBeaconModel.dart';
import 'package:presensiblebeacon/UTILS/ProgressHUD.dart';

class AdminTambahBeacon extends StatefulWidget {
  @override
  _AdminTambahBeaconState createState() => _AdminTambahBeaconState();
}

class _AdminTambahBeaconState extends State<AdminTambahBeacon> {
  var _uuidFieldController = TextEditingController();
  var _namaDeviceFieldController = TextEditingController();
  var _jarakMinFieldController = TextEditingController();
  var _majorFieldController = TextEditingController();
  var _minorFieldController = TextEditingController();

  final FocusNode _uuidFieldFocus = FocusNode();
  final FocusNode _namaDeviceFieldFocus = FocusNode();
  final FocusNode _jarakMinFieldFocus = FocusNode();
  final FocusNode _majorFieldFocus = FocusNode();
  final FocusNode _minorMinFieldFocus = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isApiCallProcess = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  TambahBeaconRequestModel tambahBeaconRequestModel;

  @override
  void initState() {
    super.initState();
    tambahBeaconRequestModel = new TambahBeaconRequestModel();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: buildTambahBeacon(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0,
    );
  }

  Widget buildTambahBeacon(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(23, 75, 137, 1),
          centerTitle: true,
          title: Text(
            'Tambah Beacon',
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
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          onPressed: () => Get.toNamed('/admin/menu/beacon/pindai'),
          label: Text('Pindai',
              style: const TextStyle(
                  fontFamily: 'WorkSansSemiBold',
                  fontSize: 14.0,
                  color: Colors.white)),
          icon: Icon(Icons.search_rounded),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25)),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: globalFormKey,
                      child: Column(
                        children: <Widget>[
                          // MaterialButton(
                          //     color: Colors.yellow[800],
                          //     shape: StadiumBorder(),
                          //     padding: EdgeInsets.all(15),
                          //     child: Text(
                          //       "Pindai Beacon",
                          //       style: const TextStyle(
                          //           fontFamily: 'WorkSansSemiBold',
                          //           fontSize: 18.0,
                          //           color: Colors.white),
                          //     ),
                          //     onPressed: () =>
                          //         Get.toNamed('/admin/menu/beacon/pindai')),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'UUID',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: TextFormField(
                              controller: _uuidFieldController,
                              focusNode: _uuidFieldFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(context, _uuidFieldFocus,
                                    _namaDeviceFieldFocus);
                              },
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              keyboardType: TextInputType.text,
                              onSaved: (input) =>
                                  tambahBeaconRequestModel.uuid = input,
                              validator: (input) => input.length < 1
                                  ? "Tidak boleh kosong"
                                  : null,
                              decoration: new InputDecoration(
                                  hintText:
                                      "ffffffff-1234-aaaa-1a2b-a1b2c3d4e5f6"),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Nama Perangkat',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: TextFormField(
                              controller: _namaDeviceFieldController,
                              focusNode: _namaDeviceFieldFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(context,
                                    _namaDeviceFieldFocus, _jarakMinFieldFocus);
                              },
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              keyboardType: TextInputType.text,
                              onSaved: (input) =>
                                  tambahBeaconRequestModel.namadevice = input,
                              validator: (input) => input.length < 1
                                  ? "Tidak boleh kosong"
                                  : null,
                              decoration: new InputDecoration(
                                  hintText: "Silahkan Isi Nama Perangkat"),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Jarak Minimal',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: TextFormField(
                              controller: _jarakMinFieldController,
                              focusNode: _jarakMinFieldFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(context, _jarakMinFieldFocus,
                                    _majorFieldFocus);
                              },
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              keyboardType: TextInputType.number,
                              onSaved: (input) =>
                                  tambahBeaconRequestModel.jarakmin = input,
                              validator: (input) => input.length < 1
                                  ? "Tidak boleh kosong"
                                  : null,
                              decoration: new InputDecoration(
                                  hintText: "Silahkan Isi Nilai Dalam Meter"),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Major',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: TextFormField(
                              controller: _majorFieldController,
                              focusNode: _majorFieldFocus,
                              onFieldSubmitted: (term) {
                                _fieldFocusChange(context, _majorFieldFocus,
                                    _minorMinFieldFocus);
                              },
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              keyboardType: TextInputType.number,
                              onSaved: (input) =>
                                  tambahBeaconRequestModel.major = input,
                              validator: (input) => input.length < 1
                                  ? "Tidak boleh kosong"
                                  : null,
                              decoration: new InputDecoration(
                                  hintText:
                                      "Silahkan Isi dalam rentang 0 - 65535"),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Minor',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'WorkSansMedium',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                                child: TextFormField(
                              controller: _minorFieldController,
                              focusNode: _minorMinFieldFocus,
                              onFieldSubmitted: (value) {
                                _jarakMinFieldFocus.unfocus();
                              },
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(
                                  fontFamily: 'WorkSansSemiBold',
                                  fontSize: 16.0,
                                  color: Colors.black),
                              keyboardType: TextInputType.number,
                              onSaved: (input) =>
                                  tambahBeaconRequestModel.minor = input,
                              validator: (input) => input.length < 1
                                  ? "Tidak boleh kosong"
                                  : null,
                              decoration: new InputDecoration(
                                  hintText:
                                      "Silahkan Isi dalam rentang 0 - 65535"),
                            )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                                color: Color.fromRGBO(247, 180, 7, 1),
                                shape: StadiumBorder(),
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  "SIMPAN",
                                  style: const TextStyle(
                                      fontFamily: 'WorkSansSemiBold',
                                      fontSize: 18.0,
                                      color: Colors.white),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  try {
                                    if (validateAndSave()) {
                                      print(tambahBeaconRequestModel.toJson());

                                      setState(() {
                                        isApiCallProcess = true;
                                      });

                                      Future.delayed(Duration(seconds: 10),
                                          () async {
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
                                          .postTambahBeacon(
                                              tambahBeaconRequestModel)
                                          .then((value) async {
                                        if (value != null) {
                                          setState(() {
                                            isApiCallProcess = false;
                                          });
                                        }
                                        Get.back();

                                        await Fluttertoast.showToast(
                                            msg: 'Berhasil Menambahkan Beacon',
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 14.0);
                                      });
                                    }
                                  } catch (error) {
                                    Fluttertoast.showToast(
                                        msg:
                                            'Terjadi kesalahan, silahkan coba lagi',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 14.0);
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}

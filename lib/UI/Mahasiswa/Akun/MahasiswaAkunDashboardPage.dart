import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:sk_alert_dialog/sk_alert_dialog.dart';

class MahasiswaAkunDashboardPage extends StatefulWidget {
  MahasiswaAkunDashboardPage({Key key}) : super(key: key);

  @override
  _MahasiswaAkunDashboardPageState createState() =>
      _MahasiswaAkunDashboardPageState();
}

class _MahasiswaAkunDashboardPageState
    extends State<MahasiswaAkunDashboardPage> {
  String npm = "";
  String namamhs = "";

  @override
  void initState() {
    super.initState();
  }

  getDataMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();

    npm = loginMahasiswa.getString('npm');
    namamhs = loginMahasiswa.getString('namamhs');
  }

  @override
  Widget build(BuildContext context) {
    getDataMahasiswa();
    return Scaffold(
      backgroundColor: Color.fromRGBO(23, 75, 137, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(23, 75, 137, 1),
        centerTitle: true,
        title: Text(
          'Akun Saya',
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
            child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () => Get.toNamed('/mahasiswa/dashboard/akun/informasi'),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25)),
                    // decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(22),
                          child: Initicon(
                            text: namamhs,
                            backgroundColor: Colors.grey[400],
                            size: 80,
                          ),
                        ),
                        Center(
                            child: Column(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Scrollbar(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(namamhs,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'WorkSansMedium',
                                          fontSize: 22)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              npm,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'WorkSansMedium',
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ))
                      ],
                    ))),
          ),
          SizedBox(
            height: 8,
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () => Get.toNamed('/tentang'),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_rounded,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Tentang Aplikasi',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'WorkSansMedium',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 14, right: 14, bottom: 14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () {
                        SKAlertDialog.show(
                          context: context,
                          type: SKAlertType.buttons,
                          title: 'KELUAR',
                          message: 'Apakah anda yakin ingin keluar?',
                          okBtnText: 'Ya',
                          okBtnTxtColor: Colors.white,
                          okBtnColor: Colors.red,
                          cancelBtnText: 'Tidak',
                          cancelBtnTxtColor: Colors.white,
                          cancelBtnColor: Colors.grey,
                          onOkBtnTap: (value) async {
                            SharedPreferences autoLogin =
                                await SharedPreferences.getInstance();
                            autoLogin.clear();

                            Get.offAllNamed('/');

                            Fluttertoast.showToast(
                                msg: 'Anda telah keluar',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 14.0);
                          },
                          onCancelBtnTap: (value) {},
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Keluar',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'WorkSansMedium',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MahasiswaInformasiAkunPage extends StatefulWidget {
  MahasiswaInformasiAkunPage({Key key}) : super(key: key);

  @override
  _MahasiswaInformasiAkunPageState createState() =>
      _MahasiswaInformasiAkunPageState();
}

class _MahasiswaInformasiAkunPageState
    extends State<MahasiswaInformasiAkunPage> {
  String npm = "";
  String namamhs = "";
  // String alamat = "";
  String fakultas = "";
  String prodi = "";
  // String pembimbingakademik = "";

  @override
  void initState() {
    super.initState();
  }

  getDataMahasiswa() async {
    SharedPreferences loginMahasiswa = await SharedPreferences.getInstance();
    setState(() {
      npm = loginMahasiswa.getString('npm');
      namamhs = loginMahasiswa.getString('namamhs');
      // alamat = loginMahasiswa.getString('alamat');
      fakultas = loginMahasiswa.getString('fakultas');
      prodi = loginMahasiswa.getString('prodi');
      // pembimbingakademik = loginMahasiswa.getString('pembimbingakademik');
    });
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
            'Informasi Akun',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'WorkSansMedium',
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(25)),
                    // decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(22),
                          // child: ClipRRect(
                          //   borderRadius: BorderRadius.circular(8.0),
                          //   child: Image.asset(
                          //     'person-male'.png,
                          //     height: 150.0,
                          //     width: 100.0,
                          //   ),
                          // ),
                          // child: CircleAvatar(
                          //     backgroundColor: Colors.grey[350],
                          //     radius: 50,
                          //     // child: const Text('NV'),
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(10.0),
                          //       child: Image.asset(
                          //         'person-male'.png,
                          //       ),
                          //     ))
                          // child: AdvancedAvatar(
                          //   name: namamhs,
                          // ),
                          child: Initicon(
                            text: namamhs,
                            backgroundColor: Colors.grey[400],
                            size: 80,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                              child: Column(
                            children: <Widget>[
                              Text('Nama Mahasiswa',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'WorkSansMedium',
                                      fontSize: 22)),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(namamhs,
                                        style: TextStyle(
                                            fontFamily: 'WorkSansMedium',
                                            fontSize: 18)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                'NPM',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'WorkSansMedium',
                                    fontSize: 22),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                npm,
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium', fontSize: 18),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                'Program Studi',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'WorkSansMedium',
                                    fontSize: 22),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                prodi,
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium', fontSize: 18),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Text(
                                'Fakultas',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'WorkSansMedium',
                                    fontSize: 22),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                fakultas,
                                style: TextStyle(
                                    fontFamily: 'WorkSansMedium', fontSize: 18),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              // Text(
                              //   'Alamat',
                              //   style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //       fontFamily: 'WorkSansMedium',
                              //       fontSize: 22),
                              // ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(left: 10, right: 10),
                              //   child: Text(
                              //     alamat,
                              //     style: TextStyle(
                              //         fontFamily: 'WorkSansMedium',
                              //         fontSize: 18),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 16,
                              // ),
                              // Scrollbar(
                              //   child: Center(
                              //     child: Container(
                              //       child: SingleChildScrollView(
                              //         scrollDirection: Axis.horizontal,
                              //         child: Text(
                              //           'Dosen Pembimbing Akademik',
                              //           style: TextStyle(
                              //               fontWeight: FontWeight.bold,
                              //               fontFamily: 'WorkSansMedium',
                              //               fontSize: 22),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 5,
                              // ),
                              // Scrollbar(
                              //   child: Center(
                              //     child: Container(
                              //       child: SingleChildScrollView(
                              //         scrollDirection: Axis.horizontal,
                              //         child: Text(
                              //           pembimbingakademik,
                              //           style: TextStyle(
                              //               fontFamily: 'WorkSansMedium',
                              //               fontSize: 18),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          )),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}

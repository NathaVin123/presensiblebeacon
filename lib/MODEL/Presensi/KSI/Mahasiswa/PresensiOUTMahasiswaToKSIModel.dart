class PresensiOUTMahasiswaToKSIRequestModel {
  int idkelas;
  String npm;
  int pertemuan;
  String tglout;
  String status;

  PresensiOUTMahasiswaToKSIRequestModel(
      {this.idkelas, this.npm, this.pertemuan, this.tglout, this.status});

  factory PresensiOUTMahasiswaToKSIRequestModel.fromJson(
          Map<String, dynamic> json) =>
      PresensiOUTMahasiswaToKSIRequestModel(
          idkelas: json["ID_KELAS"] == null ? null : json['ID_KELAS'] as int,
          npm: json["NPM"] == null ? null : json['NPM'] as String,
          pertemuan:
              json["PERTEMUAN"] == null ? null : json['PERTEMUAN'] as int,
          tglout: json["TGLOUT"] == null ? null : json['TGLOUT'] as String,
          status: json["STATUS"] == null ? null : json['STATUS'] as String);

  Map<String, dynamic> toJson() => {
        "ID_KELAS": idkelas?.toString() == null ? null : idkelas?.toString(),
        "NPM": npm,
        "PERTEMUAN":
            pertemuan?.toString() == null ? null : pertemuan?.toString(),
        "TGLOUT": tglout,
        "STATUS": status
      };
}

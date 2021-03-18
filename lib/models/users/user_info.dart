import 'package:CEPmobile/config/formatdate.dart';
import 'package:intl/intl.dart';

class UserInfo {
  int chiNhanhID;
  String tenChiNhanh;
  String server;
  String group;
  String chucVu;
  String tenNhanVien;
  String displayName;
  String dienThoai;
  String masoql;
  String userMis;
  int toTinDung;
  bool isLock;
  DateTime ngaytao;
  DateTime ngaycapnhat;
  String oid;
  bool changePasswordOnFirstLogon;
  String userName;
  bool isActive;

  UserInfo({
    this.chiNhanhID,
    this.tenChiNhanh,
    this.server,
    this.group,
    this.chucVu,
    this.tenNhanVien,
    this.displayName,
    this.dienThoai,
    this.masoql,
    this.userMis,
    this.toTinDung,
    this.isLock,
    this.ngaytao,
    this.ngaycapnhat,
    this.oid,
    this.changePasswordOnFirstLogon,
    this.userName,
    this.isActive,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      chiNhanhID: json['chiNhanhID'] as int,
      server: json['server'] as String,
      tenChiNhanh: json['tenChiNhanh'] as String,
      group: json['group'] as String,
      chucVu: json['chucVu'] as String,
      tenNhanVien: json['tenNhanVien'] as String,
      displayName: json['displayName'] as String,
      dienThoai: json['dienThoai'] as String,
      masoql: json['masoql'] as String,
      userMis: json['userMis'] as String,
      toTinDung: json['toTinDung'] as int,
      isLock: json['isLock'] as bool,
      ngaytao: FormatDateConstants.convertJsonDateToDateTime(json['ngaytao']),
      ngaycapnhat:FormatDateConstants.convertJsonDateToDateTime(json['ngaycapnhat']),
      oid: json['oid'] as String,
      changePasswordOnFirstLogon: json['changePasswordOnFirstLogon'] as bool,
      userName: json['userName'] as String,
      isActive: json['isActive'] as bool,
    );
  }
}

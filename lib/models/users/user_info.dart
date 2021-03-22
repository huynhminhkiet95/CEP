
class UserInfo {
  int chiNhanhID;
  String tenChiNhanh;
  String chucVu;
  String hoTen;
  String dienThoai;
  String masoql;
  int toTinDung;

  UserInfo({
    this.chiNhanhID,
    this.tenChiNhanh,
    this.chucVu,
    this.hoTen,
    this.dienThoai,
    this.masoql,
    this.toTinDung,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      chiNhanhID: json['ChiNhanhID'] as int,
      tenChiNhanh: json['TenChiNhanh'] as String,
      chucVu: json['ChucVu'] as String,
      hoTen: json['HoTen'] as String,
      dienThoai: json['DienThoai'] as String,
      masoql: json['Masoql'] as String,
      toTinDung: json['ToTinDung'] as int,
    );
  }
}

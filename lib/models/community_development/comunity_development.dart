class ComunityDevelopment {
  List<KhachHang> khachHang;

  ComunityDevelopment({this.khachHang});

  ComunityDevelopment.fromJson(Map<String, dynamic> json) {
    if (json["khachHang"] is List)
      this.khachHang = json["khachHang"] == null
          ? []
          : (json["khachHang"] as List)
              .map((e) => KhachHang.fromJson(e))
              .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.khachHang != null)
      data["khachHang"] = this.khachHang.map((e) => e.toJson()).toList();
    return data;
  }
}

class KhachHang {
  String maKhachHang;
  double chinhanhId;
  double duanId;
  String masoql;
  String cumId;
  String hoTen;
  String thanhVienId;
  String cmnd;
  double gioitinh;
  String ngaysinh;
  String diachi;
  String dienthoai;
  double lanvay;
  String thoigianthamgia;
  double thanhVienThuocDien;
  String maHongheoCanngheo;
  double ngheNghiep;
  String ghiChu;
  bool moHinhNghe;
  double thunhapHangthangCuaho;
  bool coVoChongConLaCnv;
  BHYT bhyt;
  HocBong hocBong;
  MaiNha maiNha;
  PhatTrienNghe phatTrienNghe;
  QuaTet quaTet;

  KhachHang(
      {this.maKhachHang,
      this.chinhanhId,
      this.duanId,
      this.masoql,
      this.cumId,
      this.hoTen,
      this.thanhVienId,
      this.cmnd,
      this.gioitinh,
      this.ngaysinh,
      this.diachi,
      this.dienthoai,
      this.lanvay,
      this.thoigianthamgia,
      this.thanhVienThuocDien,
      this.maHongheoCanngheo,
      this.ngheNghiep,
      this.ghiChu,
      this.moHinhNghe,
      this.thunhapHangthangCuaho,
      this.coVoChongConLaCnv,
      this.bhyt,
      this.hocBong,
      this.maiNha,
      this.phatTrienNghe,
      this.quaTet});

  KhachHang.fromJson(Map<String, dynamic> json) {
    if (json["maKhachHang"] is String) this.maKhachHang = json["maKhachHang"];
    if (json["chinhanhID"] is double) this.chinhanhId = json["chinhanhID"];
    if (json["duanID"] != null) {
      
      this.duanId = json["duanID"] as double;
    }
    if (json["masoql"] is String) this.masoql = json["masoql"];
    if (json["cumID"] is String) this.cumId = json["cumID"];
    if (json["hoTen"] is String) this.hoTen = json["hoTen"];
    if (json["thanhVienID"] is String) this.thanhVienId = json["thanhVienID"];
    if (json["cmnd"] is String) this.cmnd = json["cmnd"];
    if (json["gioitinh"] is double) this.gioitinh = json["gioitinh"];
    if (json["ngaysinh"] is String) this.ngaysinh = json["ngaysinh"];
    if (json["diachi"] is String) this.diachi = json["diachi"];
    if (json["dienthoai"] is String) this.dienthoai = json["dienthoai"];
    if (json["lanvay"] is double) this.lanvay = json["lanvay"];
    if (json["thoigianthamgia"] is String)
      this.thoigianthamgia = json["thoigianthamgia"];
    if (json["thanhVienThuocDien"] is double)
      this.thanhVienThuocDien = json["thanhVienThuocDien"];
    if (json["maHongheoCanngheo"] is String)
      this.maHongheoCanngheo = json["maHongheoCanngheo"];
    if (json["ngheNghiep"] is double) this.ngheNghiep = json["ngheNghiep"];
    if (json["ghiChu"] is String) this.ghiChu = json["ghiChu"];
    if (json["moHinhNghe"] is bool) this.moHinhNghe = json["moHinhNghe"];
    if (json["thunhapHangthangCuaho"] is double)
      this.thunhapHangthangCuaho = json["thunhapHangthangCuaho"];
    if (json["coVoChongConLaCNV"] is bool)
      this.coVoChongConLaCnv = json["coVoChongConLaCNV"];
    if (json["bhyt"] is Map) this.bhyt = json["bhyt"] == null ? null : BHYT.fromJson(json["bhyt"]);
    if (json["hocBong"] is Map) this.hocBong = json["hocBong"] == null ? null : HocBong.fromJson(json["hocBong"]);
    if (json["maiNha"] is Map)
      this.maiNha =
          json["maiNha"] == null ? null : MaiNha.fromJson(json["maiNha"]);
    if (json["phatTrienNghe"] is Map)
      this.phatTrienNghe = json["phatTrienNghe"] == null
          ? null
          : PhatTrienNghe.fromJson(json["phatTrienNghe"]);
    if (json["quaTet"] is Map)
      this.quaTet =
          json["quaTet"] == null ? null : QuaTet.fromJson(json["quaTet"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["maKhachHang"] = this.maKhachHang;
    data["chinhanhID"] = this.chinhanhId;
    data["duanID"] = this.duanId;
    data["masoql"] = this.masoql;
    data["cumID"] = this.cumId;
    data["hoTen"] = this.hoTen;
    data["thanhVienID"] = this.thanhVienId;
    data["cmnd"] = this.cmnd;
    data["gioitinh"] = this.gioitinh;
    data["ngaysinh"] = this.ngaysinh;
    data["diachi"] = this.diachi;
    data["dienthoai"] = this.dienthoai;
    data["lanvay"] = this.lanvay;
    data["thoigianthamgia"] = this.thoigianthamgia;
    data["thanhVienThuocDien"] = this.thanhVienThuocDien;
    data["maHongheoCanngheo"] = this.maHongheoCanngheo;
    data["ngheNghiep"] = this.ngheNghiep;
    data["ghiChu"] = this.ghiChu;
    data["moHinhNghe"] = this.moHinhNghe;
    data["thunhapHangthangCuaho"] = this.thunhapHangthangCuaho;
    data["coVoChongConLaCNV"] = this.coVoChongConLaCnv;
    data["bhyt"] = this.bhyt;
    data["hocBong"] = this.hocBong;
    if (this.maiNha != null) data["maiNha"] = this.maiNha.toJson();
    if (this.phatTrienNghe != null)
      data["phatTrienNghe"] = this.phatTrienNghe.toJson();
    if (this.quaTet != null) data["quaTet"] = this.quaTet.toJson();
    return data;
  }
}

class QuaTet {
  int serverId;
  double nam;
  String maKhachHang;
  double loaiHoNgheo;

  QuaTet({this.serverId, this.nam, this.maKhachHang, this.loaiHoNgheo});

  QuaTet.fromJson(Map<String, dynamic> json) {
    if (json["serverID"] is int) this.serverId = json["serverID"];
    if (json["nam"] is double) this.nam = json["nam"];
    if (json["maKhachHang"] is String) this.maKhachHang = json["maKhachHang"];
    if (json["loaiHoNgheo"] is double) this.loaiHoNgheo = json["loaiHoNgheo"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["serverID"] = this.serverId;
    data["nam"] = this.nam;
    data["maKhachHang"] = this.maKhachHang;
    data["loaiHoNgheo"] = this.loaiHoNgheo;
    return data;
  }
}

class PhatTrienNghe {
  int serverId;
  double nam;
  String maKhachHang;
  String nguoithan;
  double quanHeKhacHang;
  double lyDo;
  String hoancanh;
  double nguyenvongthamgia;
  double nguyenvonghoithao;
  double scCnguyenvong;
  double iecDnguyenvong;
  double reacHnguyenvong;

  PhatTrienNghe(
      {this.serverId,
      this.nam,
      this.maKhachHang,
      this.nguoithan,
      this.quanHeKhacHang,
      this.lyDo,
      this.hoancanh,
      this.nguyenvongthamgia,
      this.nguyenvonghoithao,
      this.scCnguyenvong,
      this.iecDnguyenvong,
      this.reacHnguyenvong});

  PhatTrienNghe.fromJson(Map<String, dynamic> json) {
    if (json["serverID"] is int) this.serverId = json["serverID"];
    if (json["nam"] is double) this.nam = json["nam"];
    if (json["maKhachHang"] is String) this.maKhachHang = json["maKhachHang"];
    if (json["nguoithan"] is String) this.nguoithan = json["nguoithan"];
    if (json["quanHeKhacHang"] is double)
      this.quanHeKhacHang = json["quanHeKhacHang"];
    if (json["lyDo"] is double) this.lyDo = json["lyDo"];
    if (json["hoancanh"] is String) this.hoancanh = json["hoancanh"];
    if (json["nguyenvongthamgia"] is double)
      this.nguyenvongthamgia = json["nguyenvongthamgia"];
    if (json["nguyenvonghoithao"] is double)
      this.nguyenvonghoithao = json["nguyenvonghoithao"];
    if (json["scCnguyenvong"] is double)
      this.scCnguyenvong = json["scCnguyenvong"];
    if (json["iecDnguyenvong"] is double)
      this.iecDnguyenvong = json["iecDnguyenvong"];
    if (json["reacHnguyenvong"] is double)
      this.reacHnguyenvong = json["reacHnguyenvong"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["serverID"] = this.serverId;
    data["nam"] = this.nam;
    data["maKhachHang"] = this.maKhachHang;
    data["nguoithan"] = this.nguoithan;
    data["quanHeKhacHang"] = this.quanHeKhacHang;
    data["lyDo"] = this.lyDo;
    data["hoancanh"] = this.hoancanh;
    data["nguyenvongthamgia"] = this.nguyenvongthamgia;
    data["nguyenvonghoithao"] = this.nguyenvonghoithao;
    data["scCnguyenvong"] = this.scCnguyenvong;
    data["iecDnguyenvong"] = this.iecDnguyenvong;
    data["reacHnguyenvong"] = this.reacHnguyenvong;
    return data;
  }
}

class MaiNha {
  int serverId;
  double nam;
  String maKhachHang;
  double tilephuthuoc;
  double thunhap;
  double taisan;
  double dieukiennhao;
  double quyenSoHuuNha;
  String ghichuhoancanh;
  double cbDexuat;
  double duTruKinhPhi;
  double deXuatHoTro;
  double giaDinhHoTro;
  double tietKiem;
  double tienVay;
  bool giaDinhDongY;
  double cnDexuat;
  String cnDexuatThoigian;
  double cnDexuatSotien;
  double hosodinhkem;

  MaiNha(
      {this.serverId,
      this.nam,
      this.maKhachHang,
      this.tilephuthuoc,
      this.thunhap,
      this.taisan,
      this.dieukiennhao,
      this.quyenSoHuuNha,
      this.ghichuhoancanh,
      this.cbDexuat,
      this.duTruKinhPhi,
      this.deXuatHoTro,
      this.giaDinhHoTro,
      this.tietKiem,
      this.tienVay,
      this.giaDinhDongY,
      this.cnDexuat,
      this.cnDexuatThoigian,
      this.cnDexuatSotien,
      this.hosodinhkem});

  MaiNha.fromJson(Map<String, dynamic> json) {
    if (json["serverID"] is int) this.serverId = json["serverID"];
    if (json["nam"] is double) this.nam = json["nam"];
    if (json["maKhachHang"] is String) this.maKhachHang = json["maKhachHang"];
    if (json["tilephuthuoc"] is double) this.tilephuthuoc = json["tilephuthuoc"];
    if (json["thunhap"] is double) this.thunhap = json["thunhap"];
    if (json["taisan"] is double) this.taisan = json["taisan"];
    if (json["dieukiennhao"] is double) this.dieukiennhao = json["dieukiennhao"];
    if (json["quyenSoHuuNha"] is double)
      this.quyenSoHuuNha = json["quyenSoHuuNha"];
    if (json["ghichuhoancanh"] is String)
      this.ghichuhoancanh = json["ghichuhoancanh"];
    if (json["cbDexuat"] is double) this.cbDexuat = json["cbDexuat"];
    if (json["duTruKinhPhi"] is double) this.duTruKinhPhi = json["duTruKinhPhi"];
    if (json["deXuatHoTro"] is double) this.deXuatHoTro = json["deXuatHoTro"];
    if (json["giaDinhHoTro"] is double) this.giaDinhHoTro = json["giaDinhHoTro"];
    if (json["tietKiem"] is double) this.tietKiem = json["tietKiem"];
    if (json["tienVay"] is double) this.tienVay = json["tienVay"];
    if (json["giaDinhDongY"] is bool) this.giaDinhDongY = json["giaDinhDongY"];
    if (json["cnDexuat"] is double) this.cnDexuat = json["cnDexuat"];
    if (json["cnDexuatThoigian"] is String)
      this.cnDexuatThoigian = json["cnDexuatThoigian"];
    if (json["cnDexuatSotien"] is double)
      this.cnDexuatSotien = json["cnDexuatSotien"];
    if (json["hosodinhkem"] is double) this.hosodinhkem = json["hosodinhkem"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["serverID"] = this.serverId;
    data["nam"] = this.nam;
    data["maKhachHang"] = this.maKhachHang;
    data["tilephuthuoc"] = this.tilephuthuoc;
    data["thunhap"] = this.thunhap;
    data["taisan"] = this.taisan;
    data["dieukiennhao"] = this.dieukiennhao;
    data["quyenSoHuuNha"] = this.quyenSoHuuNha;
    data["ghichuhoancanh"] = this.ghichuhoancanh;
    data["cbDexuat"] = this.cbDexuat;
    data["duTruKinhPhi"] = this.duTruKinhPhi;
    data["deXuatHoTro"] = this.deXuatHoTro;
    data["giaDinhHoTro"] = this.giaDinhHoTro;
    data["tietKiem"] = this.tietKiem;
    data["tienVay"] = this.tienVay;
    data["giaDinhDongY"] = this.giaDinhDongY;
    data["cnDexuat"] = this.cnDexuat;
    data["cnDexuatThoigian"] = this.cnDexuatThoigian;
    data["cnDexuatSotien"] = this.cnDexuatSotien;
    data["hosodinhkem"] = this.hosodinhkem;
    return data;
  }
}

class BHYT {
  int serverId;
  double nam;
  String maKhachHang;
  double mucphibaohiem;
  double dieukienbhyt;
  double tinhtrangsuckhoe;
  String nguoithan;
  double namsinh;
  double quanHeKhachHang;

  BHYT(
      {this.serverId,
      this.nam,
      this.maKhachHang,
      this.mucphibaohiem,
      this.dieukienbhyt,
      this.tinhtrangsuckhoe,
      this.nguoithan,
      this.namsinh,
      this.quanHeKhachHang});

  BHYT.fromJson(Map<String, dynamic> json) {
    if (json["serverID"] is int) this.serverId = json["serverID"];
    if (json["nam"] is double) this.nam = json["nam"];
    if (json["maKhachHang"] is String) this.nam = json["maKhachHang"];
    if (json["mucphibaohiem"] is double) this.nam = json["mucphibaohiem"];
    if (json["dieukienbhyt"] is double) this.nam = json["dieukienbhyt"];
    if (json["tinhtrangsuckhoe"] is double) this.nam = json["tinhtrangsuckhoe"];
    if (json["nguoithan"] is String) this.nam = json["nguoithan"];
    if (json["namsinh"] is double) this.nam = json["namsinh"];
    if (json["quanHeKhachHang"] is double) this.nam = json["quanHeKhachHang"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["serverID"] = this.serverId;
    data["nam"] = this.nam;
    data["maKhachHang"] = this.maKhachHang;
    data["mucphibaohiem"] = this.mucphibaohiem;
    data["dieukienbhyt"] = this.dieukienbhyt;
    data["tinhtrangsuckhoe"] = this.tinhtrangsuckhoe;
    data["nguoithan"] = this.nguoithan;
    data["namsinh"] = this.namsinh;
    data["quanHeKhachHang"] = this.quanHeKhachHang;

    return data;
  }
}

class HocBong {
  int serverID;
  double nam;
  String maKhachHang;
  String hotenhocsinh;
  double namsinh;
  double lop;
  String truonghoc;
  double quanhekhachhang;
  double hocbongQuatang;
  double hocluc;
  bool danhanhocbong; // bool
  double dinhKemHoSo;
  double hoancanhhocsinh;
  String hoancanhgiadinh;
  double mucdich;
  String ghiChu;
  double giatri;

  HocBong(
      {this.serverID,
      this.nam,
      this.maKhachHang,
      this.hotenhocsinh,
      this.namsinh,
      this.lop,
      this.truonghoc,
      this.quanhekhachhang,
      this.hocbongQuatang,
      this.hocluc,
      this.danhanhocbong,
      this.dinhKemHoSo,
      this.hoancanhhocsinh,
      this.hoancanhgiadinh,
      this.mucdich,
      this.ghiChu,
      this.giatri});

  HocBong.fromJson(Map<String, dynamic> json) {
    serverID = json['serverID'];
    nam = json['nam'];
    maKhachHang = json['maKhachHang'];
    hotenhocsinh = json['hotenhocsinh'];
    namsinh = json['namsinh'];
    lop = json['lop'];
    truonghoc = json['truonghoc'];
    quanhekhachhang = json['quanhekhachhang'];
    hocbongQuatang = json['hocbong_Quatang'];
    hocluc = json['hocluc'];
    danhanhocbong = json['danhanhocbong'];
    dinhKemHoSo = json['dinhKemHoSo'];
    hoancanhhocsinh = json['hoancanhhocsinh'];
    hoancanhgiadinh = json['hoancanhgiadinh'];
    mucdich = json['mucdich'];
    ghiChu = json['ghiChu'];
    giatri = json['giatri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['serverID'] = this.serverID;
    data['nam'] = this.nam;
    data['maKhachHang'] = this.maKhachHang;
    data['hotenhocsinh'] = this.hotenhocsinh;
    data['namsinh'] = this.namsinh;
    data['lop'] = this.lop;
    data['truonghoc'] = this.truonghoc;
    data['quanhekhachhang'] = this.quanhekhachhang;
    data['hocbong_Quatang'] = this.hocbongQuatang;
    data['hocluc'] = this.hocluc;
    data['danhanhocbong'] = this.danhanhocbong;
    data['dinhKemHoSo'] = this.dinhKemHoSo;
    data['hoancanhhocsinh'] = this.hoancanhhocsinh;
    data['hoancanhgiadinh'] = this.hoancanhgiadinh;
    data['mucdich'] = this.mucdich;
    data['ghiChu'] = this.ghiChu;
    data['giatri'] = this.giatri;
    return data;
  }
}

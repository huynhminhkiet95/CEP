import 'dart:io';
import 'package:CEPmobile/GlobalUser.dart';
import 'package:CEPmobile/models/community_development/comunity_development.dart';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/models/download_data/historysearchsurvey.dart';
import 'package:CEPmobile/models/download_data/survey_info_history.dart';
import 'package:CEPmobile/models/users/user_info.dart';
import 'package:CEPmobile/models/users/user_role.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  // Create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      //checkColumn();
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "CEP-NhanViendbo.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE KhaoSat("
          "id INTEGER,"
          "ngayXuatDanhSach TEXT,"
          "ngayKhaoSat TEXT,"
          "masoCanBoKhaoSat TEXT,"
          "chinhanhId INTEGER,"
          "duanId INTEGER,"
          "cumId TEXT,"
          "thanhvienId TEXT,"
          "tinhTrangHonNhan TEXT,"
          "trinhDoHocVan TEXT,"
          "khuVuc INTEGER,"
          "lanvay INTEGER,"
          "nguoiTraloiKhaoSat TEXT,"
          "songuoiTrongHo INTEGER,"
          "songuoiCoviecLam INTEGER,"
          "dientichDatTrong INTEGER,"
          "giaTriVatNuoi INTEGER,"
          "dungCuLaoDong INTEGER,"
          "phuongTienDiLai INTEGER,"
          "taiSanSinhHoat INTEGER,"
          "quyenSoHuuNha TEXT,"
          "hemTruocNha INTEGER,"
          "maiNha TEXT,"
          "tuongNha TEXT,"
          "nenNha TEXT,"
          "dienTichNhaTinhTren1Nguoi INTEGER,"
          "dien TEXT,"
          "nuoc TEXT,"
          "mucDichSudungVon TEXT,"
          "soTienCanThiet INTEGER,"
          "soTienThanhVienDaCo INTEGER,"
          "soTienCanVay INTEGER,"
          "thoiDiemSuDungVonvay TEXT,"
          "tongVonDauTu INTEGER,"
          "thuNhapRongHangThang INTEGER,"
          "thuNhapCuaVoChong INTEGER,"
          "thuNhapCuaCacCon INTEGER,"
          "thuNhapKhac INTEGER,"
          "tongChiPhiCuaThanhvien INTEGER,"
          "chiPhiDienNuoc INTEGER,"
          "chiPhiAnUong INTEGER,"
          "chiPhiHocTap INTEGER,"
          "chiPhiKhac INTEGER,"
          "chiTraTienVayHangThang INTEGER,"
          "tichLuyTangThemHangThang INTEGER,"
          "nguonVay1 TEXT,"
          "sotienVay1 INTEGER,"
          "lyDoVay1 TEXT,"
          "thoiDiemTatToan1 TEXT,"
          "bienPhapThongNhat1 TEXT,"
          "nguonVay2 TEXT,"
          "sotienVay2 INTEGER,"
          "lyDoVay2 TEXT,"
          "thoiDiemTatToan2 TEXT,"
          "bienPhapThongNhat2 TEXT,"
          "thanhVienThuocDien TEXT,"
          "maSoHoNgheo TEXT,"
          "hoTenChuHo TEXT,"
          "soTienGuiTietKiemMoiKy INTEGER,"
          "tietKiemBatBuocXinRut INTEGER,"
          "tietKiemTuNguyenXinRut INTEGER,"
          "tietKiemLinhHoatXinRut INTEGER,"
          "thoiDiemRut TEXT,"
          "mucVayBoSung INTEGER,"
          "mucDichVayBoSung TEXT,"
          "ngayVayBoSung TEXT,"
          "ghiChu TEXT,"
          "soTienDuyetChovay INTEGER,"
          "tietKiemDinhHuong INTEGER,"
          "mucDichVay TEXT,"
          "duyetChovayNgay TEXT,"
          "daCapNhatVaoHoSoChovay INTEGER,"
          "tinhTrangNgheo TEXT,"
          "daDuocDuyet INTEGER,"
          "username TEXT,"
          "ngaycapnhat TEXT,"
          "masoCanBoKhaoSatPss INTEGER,"
          "sotienVayLantruoc INTEGER,"
          "thoiGianTaivay INTEGER,"
          "songayNoquahanCaonhat INTEGER,"
          "thoiGianKhaosatGannhat INTEGER,"
          "ngayTatToanDotvayTruoc TEXT,"
          "batBuocKhaosat INTEGER,"
          "conNo INTEGER,"
          "dichVuSgb INTEGER,"
          "moTheMoi INTEGER,"
          "soTienDuyetChoVayCk INTEGER,"
          "gioiTinh INTEGER,"
          "cmnd TEXT,"
          "ngaySinh TEXT,"
          "diaChi TEXT,"
          "thoigianthamgia TEXT,"
          "hoVaTen TEXT,"
          "statusCheckBox INTEGER,"
          "idHistoryKhaoSat INTEGER"
          ")");

      await db.execute("CREATE TABLE historysearchkhaosat_tbl("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "cumID TEXT,"
          "ngayXuatDanhSach TEXT,"
          "username TEXT,"
          "masoql TEXT"
          ")");

      await db.execute("CREATE TABLE metadata_tbl("
          "server_id INTEGER,"
          "group_id TEXT,"
          "group_text TEXT,"
          "item_id TEXT,"
          "item_text TEXT"
          ")");

      await db.execute("CREATE TABLE userinfo_tbl("
          "chiNhanhID INTEGER,"
          "tenChiNhanh TEXT,"
          "chucVu TEXT,"
          "hoTen TEXT,"
          "dienThoai TEXT,"
          "masoql TEXT,"
          "toTinDung INTEGER"
          ")");

      await db.execute("CREATE TABLE userrole_tbl("
          "salary INTEGER,"
          "hPqlnlhc INTEGER,"
          "banTgd INTEGER,"
          "administrator INTEGER,"
          "td INTEGER,"
          "giaoDich INTEGER,"
          "ktv INTEGER,"
          "tq INTEGER,"
          "kiemSoat2 INTEGER,"
          "hHs INTEGER,"
          "hPtckt INTEGER,"
          "gdcn INTEGER,"
          "provisional INTEGER,"
          "ptcd INTEGER,"
          "hPcntt INTEGER,"
          "dataBase INTEGER,"
          "tpkt INTEGER,"
          "chiNhanh INTEGER,"
          "kiemSoat INTEGER,"
          "thionline INTEGER,"
          "tttd INTEGER,"
          "hPqltd INTEGER,"
          "hPhlptd INTEGER,"
          "tptd INTEGER,"
          "upLoad INTEGER,"
          "hPktnb INTEGER"
          ")");

      await db.execute("CREATE TABLE lichsukhaosat_tbl("
          "ngayXuatDanhSach TEXT,"
          "masoCanBoKhaoSat TEXT,"
          "chinhanhId INTEGER,"
          "cumId TEXT,"
          "thanhvienId TEXT,"
          "tinhTrangHonNhan TEXT,"
          "trinhDoHocVan TEXT,"
          "khuVuc INTEGER,"
          "lanvay INTEGER,"
          "nguoiTraloiKhaoSat TEXT,"
          "songuoiTrongHo INTEGER,"
          "songuoiCoviecLam INTEGER,"
          "dientichDatTrong INTEGER,"
          "giaTriVatNuoi INTEGER,"
          "dungCuLaoDong INTEGER,"
          "phuongTienDiLai INTEGER,"
          "taiSanSinhHoat INTEGER,"
          "quyenSoHuuNha TEXT,"
          "hemTruocNha INTEGER,"
          "maiNha TEXT,"
          "tuongNha TEXT,"
          "nenNha TEXT,"
          "dienTichNhaTinhTren1Nguoi INTEGER,"
          "dien TEXT,"
          "nuoc TEXT,"
          "mucDichSudungVon TEXT,"
          "soTienCanThiet INTEGER,"
          "soTienThanhVienDaCo INTEGER,"
          "soTienCanVay INTEGER,"
          "thoiDiemSuDungVonvay TEXT,"
          "tongVonDauTu INTEGER,"
          "thuNhapRongHangThang INTEGER,"
          "thuNhapCuaVoChong INTEGER,"
          "thuNhapCuaCacCon INTEGER,"
          "thuNhapKhac INTEGER,"
          "tongChiPhiCuaThanhvien INTEGER,"
          "chiPhiDienNuoc INTEGER,"
          "chiPhiAnUong INTEGER,"
          "chiPhiHocTap INTEGER,"
          "chiPhiKhac INTEGER,"
          "chiTraTienVayHangThang INTEGER,"
          "tichLuyTangThemHangThang INTEGER,"
          "nguonVay1 TEXT,"
          "sotienVay1 INTEGER,"
          "lyDoVay1 TEXT,"
          "thoiDiemTatToan1 TEXT,"
          "bienPhapThongNhat1 TEXT,"
          "nguonVay2 TEXT,"
          "sotienVay2 INTEGER,"
          "lyDoVay2 TEXT,"
          "thoiDiemTatToan2 TEXT,"
          "bienPhapThongNhat2 TEXT,"
          "thanhVienThuocDien TEXT,"
          "maSoHoNgheo TEXT,"
          "hoTenChuHo TEXT,"
          "soTienGuiTietKiemMoiKy INTEGER,"
          "tietKiemBatBuocXinRut INTEGER,"
          "tietKiemTuNguyenXinRut INTEGER,"
          "tietKiemLinhHoatXinRut INTEGER,"
          "thoiDiemRut TEXT,"
          "mucVayBoSung INTEGER,"
          "mucDichVayBoSung TEXT,"
          "ngayVayBoSung TEXT,"
          "ghiChu TEXT,"
          "soTienDuyetChovay INTEGER,"
          "tietKiemDinhHuong INTEGER,"
          "mucDichVay TEXT,"
          "duyetChovayNgay TEXT,"
          "daCapNhatVaoHoSoChovay INTEGER"
          ")");

      await db.execute("CREATE TABLE customer_cummunity_development("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          "maKhachHang TEXT,"
          "chinhanhID INTEGER,"
          "duanID INTEGER,"
          "masoql TEXT,"
          "cumID TEXT,"
          "hoTen TEXT,"
          "thanhVienID TEXT,"
          "cmnd TEXT,"
          "gioitinh INTEGER,"
          "ngaysinh TEXT,"
          "diachi TEXT,"
          "dienthoai TEXT,"
          "lanvay INTEGER,"
          "thoigianthamgia TEXT,"
          "thanhVienThuocDien INTEGER,"
          "maHongheoCanngheo TEXT,"
          "ngheNghiep INTEGER,"
          "ghiChu TEXT,"
          "moHinhNghe INTEGER,"
          "thunhapHangthangCuaho INTEGER,"
          "coVoChongConLaCNV INTEGER"
          ")");

      await db.execute("CREATE TABLE mainha_cummunity_development("
          "id_khachhang INTEGER,"
          "serverID INTEGER,"
          "nam INTEGER,"
          "maKhachHang TEXT,"
          "tilephuthuoc INTEGER,"
          "thunhap INTEGER,"
          "taisan INTEGER,"
          "dieukiennhao INTEGER,"
          "quyenSoHuuNha INTEGER,"
          "ghichuhoancanh TEXT,"
          "cbDexuat INTEGER,"
          "duTruKinhPhi INTEGER,"
          "deXuatHoTro INTEGER,"
          "giaDinhHoTro INTEGER,"
          "tietKiem INTEGER,"
          "tienVay INTEGER,"
          "giaDinhDongY INTEGER,"
          "cnDexuat INTEGER,"
          "cnDexuatThoigian TEXT,"
          "cnDexuatSotien INTEGER,"
          "hosodinhkem INTEGER"
          ")");

      await db.execute("CREATE TABLE phattriennghe_cummunity_development("
          "id_khachhang INTEGER,"
          "serverID INTEGER,"
          "nam INTEGER,"
          "maKhachHang TEXT,"
          "nguoithan TEXT,"
          "quanHeKhacHang INTEGER,"
          "lyDo INTEGER,"
          "hoancanh TEXT,"
          "nguyenvongthamgia INTEGER,"
          "nguyenvonghoithao INTEGER,"
          "scCnguyenvong INTEGER,"
          "iecDnguyenvong INTEGER,"
          "reacHnguyenvong INTEGER"
          ")");

      await db.execute("CREATE TABLE quatet_cummunity_development("
          "id_khachhang INTEGER,"
          "serverID INTEGER,"
          "nam INTEGER,"
          "maKhachHang TEXT,"
          "loaiHoNgheo INTEGER"
          ")");

      await db.execute("CREATE TABLE bhyt_cummunity_development("
          "id_khachhang INTEGER,"
          "serverID INTEGER,"
          "nam INTEGER,"
          "maKhachHang TEXT,"
          "mucphibaohiem INTEGER,"
          "dieukienbhyt INTEGER,"
          "tinhtrangsuckhoe INTEGER,"
          "nguoithan TEXT,"
          "namsinh INTEGER,"
          "quanHeKhachHang INTEGER"
          ")");

      await db.execute("CREATE TABLE hocbong_cummunity_development("
          "id_khachhang INTEGER,"
          "serverID INTEGER,"
          "nam INTEGER,"
          "maKhachHang TEXT,"
          "hotenhocsinh TEXT,"
          "namsinh INTEGER,"
          "lop INTEGER,"
          "truonghoc TEXT,"
          "quanhekhachhang INTEGER,"
          "hocbongQuatang INTEGER,"
          "hocluc INTEGER,"
          "danhanhocbong INTEGER,"
          "dinhKemHoSo INTEGER,"
          "hoancanhhocsinh INTEGER,"
          "hoancanhgiadinh TEXT,"
          "mucdich INTEGER,"
          "ghiChu TEXT,"
          "giatri INTEGER"
          ")");
    }, onUpgrade: _onUpgrade);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {}
  }

  newKhaoSat(SurveyInfo model) async {
    int rs = 0;
    final db = await database;
    try {
      int checkExistsData = Sqflite.firstIntValue(await db.rawQuery(
          "SELECT COUNT(*) FROM KhaoSat WHERE id=${model.id} and idHistoryKhaoSat= ${model.idHistoryKhaoSat}"));
      if (checkExistsData == 0) {
        String queryString = '''INSERT Into KhaoSat(id,
                                    ngayXuatDanhSach,ngayKhaoSat,
                                    masoCanBoKhaoSat,
                                    chinhanhId,
                                    duanId,
                                    cumId,
                                    thanhvienId,
                                    tinhTrangHonNhan,
                                    trinhDoHocVan,
                                    khuVuc,
                                    lanvay,
                                    nguoiTraloiKhaoSat,
                                    songuoiTrongHo,
                                    songuoiCoviecLam,
                                    dientichDatTrong,
                                    giaTriVatNuoi,
                                    dungCuLaoDong,
                                    phuongTienDiLai,
                                    taiSanSinhHoat,
                                    quyenSoHuuNha,
                                    hemTruocNha,
                                    maiNha,
                                    tuongNha,
                                    nenNha,
                                    dienTichNhaTinhTren1Nguoi,
                                    dien,
                                    nuoc,
                                    mucDichSudungVon,
                                    soTienCanThiet,
                                    soTienThanhVienDaCo,
                                    soTienCanVay,
                                    thoiDiemSuDungVonvay,
                                    tongVonDauTu,
                                    thuNhapRongHangThang,
                                    thuNhapCuaVoChong,
                                    thuNhapCuaCacCon,
                                    thuNhapKhac,
                                    tongChiPhiCuaThanhvien,
                                    chiPhiDienNuoc,
                                    chiPhiAnUong,
                                    chiPhiHocTap,
                                    chiPhiKhac,
                                    chiTraTienVayHangThang,
                                    tichLuyTangThemHangThang,
                                    nguonVay1,
                                    sotienVay1,
                                    lyDoVay1,
                                    thoiDiemTatToan1,
                                    bienPhapThongNhat1,
                                    nguonVay2,
                                    sotienVay2,
                                    lyDoVay2,
                                    thoiDiemTatToan2,
                                    bienPhapThongNhat2,
                                    thanhVienThuocDien,
                                    maSoHoNgheo,
                                    hoTenChuHo,
                                    soTienGuiTietKiemMoiKy,
                                    tietKiemBatBuocXinRut,
                                    tietKiemTuNguyenXinRut,
                                    tietKiemLinhHoatXinRut,
                                    thoiDiemRut,
                                    mucVayBoSung,
                                    mucDichVayBoSung,
                                    ngayVayBoSung,
                                    ghiChu,
                                    soTienDuyetChovay,
                                    tietKiemDinhHuong,
                                    mucDichVay,
                                    duyetChovayNgay,
                                    daCapNhatVaoHoSoChovay,
                                    tinhTrangNgheo,
                                    daDuocDuyet,
                                    username,
                                    ngaycapnhat,
                                    masoCanBoKhaoSatPss,
                                    sotienVayLantruoc,
                                    thoiGianTaivay,
                                    songayNoquahanCaonhat,
                                    thoiGianKhaosatGannhat,
                                    ngayTatToanDotvayTruoc,
                                    batBuocKhaosat,
                                    conNo,
                                    dichVuSgb,
                                    moTheMoi,
                                    soTienDuyetChoVayCk,
                                    gioiTinh,
                                    cmnd,
                                    ngaySinh,
                                    diaChi,
                                    thoigianthamgia,
                                    hoVaTen,
                                    statusCheckBox,
                                    idHistoryKhaoSat)
                VALUES (${model.id},
                        "${model.ngayXuatDanhSach}",
                        "${model.ngayKhaoSat}",
                        "${model.masoCanBoKhaoSat}",
                        ${model.chinhanhId},
                        ${model.duanId},
                        "${model.cumId}",
                        "${model.thanhvienId}",
                        "${model.tinhTrangHonNhan}",
                        "${model.trinhDoHocVan}",
                        ${model.khuVuc},
                        ${model.lanvay},
                        "${model.nguoiTraloiKhaoSat}",
                        ${model.songuoiTrongHo},
                        ${model.songuoiCoviecLam},
                        ${model.dientichDatTrong},
                        ${model.giaTriVatNuoi},
                        ${model.dungCuLaoDong},
                        ${model.phuongTienDiLai},
                        ${model.taiSanSinhHoat},
                        "${model.quyenSoHuuNha}",
                        ${model.hemTruocNha},
                        "${model.maiNha}",
                        "${model.tuongNha}",
                        "${model.nenNha}",
                        ${model.dienTichNhaTinhTren1Nguoi},
                        "${model.dien}",
                        "${model.nuoc}",
                        "${model.mucDichSudungVon}",
                        ${model.soTienCanThiet},
                        ${model.soTienThanhVienDaCo},
                        ${model.soTienCanVay},
                        "${model.thoiDiemSuDungVonvay}",
                        ${model.tongVonDauTu},
                        ${model.thuNhapRongHangThang},
                        ${model.thuNhapCuaVoChong},
                        ${model.thuNhapCuaCacCon},
                        ${model.thuNhapKhac},
                        ${model.tongChiPhiCuaThanhvien},
                        ${model.chiPhiDienNuoc},
                        ${model.chiPhiAnUong},
                        ${model.chiPhiHocTap},
                        ${model.chiPhiKhac},
                        ${model.chiTraTienVayHangThang},
                        ${model.tichLuyTangThemHangThang},
                        "${model.nguonVay1}",
                        ${model.sotienVay1},
                        "${model.lyDoVay1}",
                        "${model.thoiDiemTatToan1}",
                        "${model.bienPhapThongNhat1}",
                        "${model.nguonVay2}",
                        ${model.sotienVay2},
                        "${model.lyDoVay2}",
                        "${model.thoiDiemTatToan2}",
                        "${model.bienPhapThongNhat2}",
                        "${model.thanhVienThuocDien}",
                        "${model.maSoHoNgheo}",
                        "${model.hoTenChuHo}",
                        ${model.soTienGuiTietKiemMoiKy},
                        ${model.tietKiemBatBuocXinRut},
                        ${model.tietKiemTuNguyenXinRut},
                        ${model.tietKiemLinhHoatXinRut},
                        "${model.thoiDiemRut}",
                        ${model.mucVayBoSung},
                        "${model.mucDichVayBoSung}",
                        "${model.ngayVayBoSung}",
                        "${model.ghiChu}",
                        ${model.soTienDuyetChovay},
                        ${model.tietKiemDinhHuong},
                        "${model.mucDichVay}",
                        "${model.duyetChovayNgay}",
                        ${model.daCapNhatVaoHoSoChovay},
                        "${model.tinhTrangNgheo}",
                        ${model.daDuocDuyet},
                        "${model.username}",
                        "${model.ngaycapnhat}",
                        "${model.masoCanBoKhaoSatPss}",
                        ${model.sotienVayLantruoc},
                        ${model.thoiGianTaivay},
                        ${model.songayNoquahanCaonhat},
                        ${model.thoiGianKhaosatGannhat},
                        "${model.ngayTatToanDotvayTruoc}",
                        ${model.batBuocKhaosat},
                        ${model.conNo},
                        ${model.dichVuSgb},
                        ${model.moTheMoiBool},
                        ${model.soTienDuyetChoVayCk},
                        ${model.gioiTinh},
                        "${model.cmnd}",
                        "${model.ngaySinh}",
                        "${model.diaChi}",
                        "${model.thoigianthamgia}",
                        "${model.hoVaTen}",
                        "0",
                        ${model.idHistoryKhaoSat}
                        )''';
        print(queryString);
        rs = await db.rawInsert(queryString);
      }
      return rs;
    } on Exception catch (ex) {
      print(ex);
      // only executed if error is of type Exception
    } catch (error) {
      // executed for errors of all types other than Exception
    }
  }

  updateKhaoSatById(SurveyInfo model) async {
    int rs = 0;
    final db = await database;
    try {
      int rsDelete =
          await db.rawDelete('DELETE FROM KhaoSat WHERE id = ${model.id}');
      int checkExistsData = Sqflite.firstIntValue(await db.rawQuery(
          "SELECT COUNT(*) FROM KhaoSat WHERE id=${model.id} and idHistoryKhaoSat= ${model.idHistoryKhaoSat}"));
      if (checkExistsData == 0) {
        String queryString = '''INSERT Into KhaoSat(id,
                                    ngayXuatDanhSach,ngayKhaoSat,
                                    masoCanBoKhaoSat,
                                    chinhanhId,
                                    duanId,
                                    cumId,
                                    thanhvienId,
                                    tinhTrangHonNhan,
                                    trinhDoHocVan,
                                    khuVuc,
                                    lanvay,
                                    nguoiTraloiKhaoSat,
                                    songuoiTrongHo,
                                    songuoiCoviecLam,
                                    dientichDatTrong,
                                    giaTriVatNuoi,
                                    dungCuLaoDong,
                                    phuongTienDiLai,
                                    taiSanSinhHoat,
                                    quyenSoHuuNha,
                                    hemTruocNha,
                                    maiNha,
                                    tuongNha,
                                    nenNha,
                                    dienTichNhaTinhTren1Nguoi,
                                    dien,
                                    nuoc,
                                    mucDichSudungVon,
                                    soTienCanThiet,
                                    soTienThanhVienDaCo,
                                    soTienCanVay,
                                    thoiDiemSuDungVonvay,
                                    tongVonDauTu,
                                    thuNhapRongHangThang,
                                    thuNhapCuaVoChong,
                                    thuNhapCuaCacCon,
                                    thuNhapKhac,
                                    tongChiPhiCuaThanhvien,
                                    chiPhiDienNuoc,
                                    chiPhiAnUong,
                                    chiPhiHocTap,
                                    chiPhiKhac,
                                    chiTraTienVayHangThang,
                                    tichLuyTangThemHangThang,
                                    nguonVay1,
                                    sotienVay1,
                                    lyDoVay1,
                                    thoiDiemTatToan1,
                                    bienPhapThongNhat1,
                                    nguonVay2,
                                    sotienVay2,
                                    lyDoVay2,
                                    thoiDiemTatToan2,
                                    bienPhapThongNhat2,
                                    thanhVienThuocDien,
                                    maSoHoNgheo,
                                    hoTenChuHo,
                                    soTienGuiTietKiemMoiKy,
                                    tietKiemBatBuocXinRut,
                                    tietKiemTuNguyenXinRut,
                                    tietKiemLinhHoatXinRut,
                                    thoiDiemRut,
                                    mucVayBoSung,
                                    mucDichVayBoSung,
                                    ngayVayBoSung,
                                    ghiChu,
                                    soTienDuyetChovay,
                                    tietKiemDinhHuong,
                                    mucDichVay,
                                    duyetChovayNgay,
                                    daCapNhatVaoHoSoChovay,
                                    tinhTrangNgheo,
                                    daDuocDuyet,
                                    username,
                                    ngaycapnhat,
                                    masoCanBoKhaoSatPss,
                                    sotienVayLantruoc,
                                    thoiGianTaivay,
                                    songayNoquahanCaonhat,
                                    thoiGianKhaosatGannhat,
                                    ngayTatToanDotvayTruoc,
                                    batBuocKhaosat,
                                    conNo,
                                    dichVuSgb,
                                    moTheMoi,
                                    soTienDuyetChoVayCk,
                                    gioiTinh,
                                    cmnd,
                                    ngaySinh,
                                    diaChi,
                                    thoigianthamgia,
                                    hoVaTen,
                                    statusCheckBox,
                                    idHistoryKhaoSat)
                VALUES (${model.id},
                        "${model.ngayXuatDanhSach}",
                        "${model.ngayKhaoSat}",
                        "${model.masoCanBoKhaoSat}",
                        ${model.chinhanhId},
                        ${model.duanId},
                        "${model.cumId}",
                        "${model.thanhvienId}",
                        "${model.tinhTrangHonNhan}",
                        "${model.trinhDoHocVan}",
                        ${model.khuVuc},
                        ${model.lanvay},
                        "${model.nguoiTraloiKhaoSat}",
                        ${model.songuoiTrongHo},
                        ${model.songuoiCoviecLam},
                        ${model.dientichDatTrong},
                        ${model.giaTriVatNuoi},
                        ${model.dungCuLaoDong},
                        ${model.phuongTienDiLai},
                        ${model.taiSanSinhHoat},
                        "${model.quyenSoHuuNha}",
                        ${model.hemTruocNha},
                        "${model.maiNha}",
                        "${model.tuongNha}",
                        "${model.nenNha}",
                        ${model.dienTichNhaTinhTren1Nguoi},
                        "${model.dien}",
                        "${model.nuoc}",
                        "${model.mucDichSudungVon}",
                        ${model.soTienCanThiet},
                        ${model.soTienThanhVienDaCo},
                        ${model.soTienCanVay},
                        "${model.thoiDiemSuDungVonvay}",
                        ${model.tongVonDauTu},
                        ${model.thuNhapRongHangThang},
                        ${model.thuNhapCuaVoChong},
                        ${model.thuNhapCuaCacCon},
                        ${model.thuNhapKhac},
                        ${model.tongChiPhiCuaThanhvien},
                        ${model.chiPhiDienNuoc},
                        ${model.chiPhiAnUong},
                        ${model.chiPhiHocTap},
                        ${model.chiPhiKhac},
                        ${model.chiTraTienVayHangThang},
                        ${model.tichLuyTangThemHangThang},
                        "${model.nguonVay1}",
                        ${model.sotienVay1},
                        "${model.lyDoVay1}",
                        "${model.thoiDiemTatToan1}",
                        "${model.bienPhapThongNhat1}",
                        "${model.nguonVay2}",
                        ${model.sotienVay2},
                        "${model.lyDoVay2}",
                        "${model.thoiDiemTatToan2}",
                        "${model.bienPhapThongNhat2}",
                        "${model.thanhVienThuocDien}",
                        "${model.maSoHoNgheo}",
                        "${model.hoTenChuHo}",
                        ${model.soTienGuiTietKiemMoiKy},
                        ${model.tietKiemBatBuocXinRut},
                        ${model.tietKiemTuNguyenXinRut},
                        ${model.tietKiemLinhHoatXinRut},
                        "${model.thoiDiemRut}",
                        ${model.mucVayBoSung},
                        "${model.mucDichVayBoSung}",
                        "${model.ngayVayBoSung}",
                        "${model.ghiChu}",
                        ${model.soTienDuyetChovay},
                        ${model.tietKiemDinhHuong},
                        "${model.mucDichVay}",
                        "${model.duyetChovayNgay}",
                        ${model.daCapNhatVaoHoSoChovay},
                        "${model.tinhTrangNgheo}",
                        ${model.daDuocDuyet},
                        "${model.username}",
                        "${model.ngaycapnhat}",
                        "${model.masoCanBoKhaoSatPss}",
                        ${model.sotienVayLantruoc},
                        ${model.thoiGianTaivay},
                        ${model.songayNoquahanCaonhat},
                        ${model.thoiGianKhaosatGannhat},
                        "${model.ngayTatToanDotvayTruoc}",
                        ${model.batBuocKhaosat},
                        ${model.conNo},
                        ${model.dichVuSgb},
                        ${model.moTheMoiBool},
                        ${model.soTienDuyetChoVayCk},
                        ${model.gioiTinh},
                        "${model.cmnd}",
                        "${model.ngaySinh}",
                        "${model.diaChi}",
                        "${model.thoigianthamgia}",
                        "${model.hoVaTen}",
                        "0",
                        ${model.idHistoryKhaoSat}
                        )''';
        print(queryString);
        rs = await db.rawInsert(queryString);
      }
      return rs;
    } on Exception catch (ex) {
      print(ex);
      // only executed if error is of type Exception
    } catch (error) {
      // executed for errors of all types other than Exception
    }
  }

  getKhaoSat(int id) async {
    final db = await database;
    var res = await db.query("KhaoSat", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? SurveyInfo.fromMap(res.first) : Null;
  }

  getAllKhaoSat() async {
    final db = await database;
    var res = await db.query("KhaoSat", orderBy: "id ASC");
    List<SurveyInfo> list =
        res.isNotEmpty ? res.map((c) => SurveyInfo.fromMap(c)).toList() : [];
    return list;
  }

  deleteKhaoSatByIdHistorySearch(int idHistorySearch) async {
    final db = await database;
    try {
      await db.rawDelete(
          'DELETE FROM KhaoSat WHERE idHistoryKhaoSat = ${idHistorySearch}');
      await db.rawDelete(
          'DELETE FROM historysearchkhaosat_tbl WHERE id = ${idHistorySearch}');
    } on Exception catch (ex) {
      print(ex);
      // only executed if error is of type Exception
    } catch (error) {
      // executed for errors of all types other than Exception
    }
  }

  deleteKhaoSatById(int id) async {
    final db = await database;
    try {
      await db.rawDelete('DELETE FROM KhaoSat WHERE id = ${id}');
    } on Exception catch (ex) {
      print(ex);
      // only executed if error is of type Exception
    } catch (error) {
      // executed for errors of all types other than Exception
    }
  }

  newLichSuKhaoSat(SurveyInfoHistory model) async {
    int rs = 0;
    final db = await database;
    try {
      int checkExistsData = Sqflite.firstIntValue(await db.rawQuery(
          "SELECT COUNT(*) FROM lichsukhaosat_tbl WHERE thanhvienId='${model.thanhvienId}'"));
      if (checkExistsData == 0) {
        String queryString = '''INSERT Into lichsukhaosat_tbl(ngayXuatDanhSach,
																masoCanBoKhaoSat,
																chinhanhId,
																cumId,
																thanhvienId,
																tinhTrangHonNhan,
																trinhDoHocVan,
																khuVuc,
																lanvay,
																nguoiTraloiKhaoSat,
																songuoiTrongHo,
																songuoiCoviecLam,
																dientichDatTrong,
																giaTriVatNuoi,
																dungCuLaoDong,
																phuongTienDiLai,
																taiSanSinhHoat,
																quyenSoHuuNha,
																hemTruocNha,
																maiNha,
																tuongNha,
																nenNha,
																dienTichNhaTinhTren1Nguoi,
																dien,
																nuoc,
																mucDichSudungVon,
																soTienCanThiet,
																soTienThanhVienDaCo,
																soTienCanVay,
																thoiDiemSuDungVonvay,
																tongVonDauTu,
																thuNhapRongHangThang,
																thuNhapCuaVoChong,
																thuNhapCuaCacCon,
																thuNhapKhac,
																tongChiPhiCuaThanhvien,
																chiPhiDienNuoc,
																chiPhiAnUong,
																chiPhiHocTap,
																chiPhiKhac,
																chiTraTienVayHangThang,
																tichLuyTangThemHangThang,
																nguonVay1,
																sotienVay1,
																lyDoVay1,
																thoiDiemTatToan1,
																bienPhapThongNhat1,
																nguonVay2,
																sotienVay2,
																lyDoVay2,
																thoiDiemTatToan2,
																bienPhapThongNhat2,
																thanhVienThuocDien,
																maSoHoNgheo,
																hoTenChuHo,
																soTienGuiTietKiemMoiKy,
																tietKiemBatBuocXinRut,
																tietKiemTuNguyenXinRut,
																tietKiemLinhHoatXinRut,
																thoiDiemRut,
																mucVayBoSung,
																mucDichVayBoSung,
																ngayVayBoSung,
																ghiChu,
																soTienDuyetChovay,
																tietKiemDinhHuong,
																mucDichVay,
																duyetChovayNgay,
																daCapNhatVaoHoSoChovay)
                VALUES (
                        "${model.ngayXuatDanhSach}",
                        "${model.masoCanBoKhaoSat}",
                        ${model.chinhanhId},
                        "${model.cumId}",
                        "${model.thanhvienId}",
                        "${model.tinhTrangHonNhan}",
                        "${model.trinhDoHocVan}",
                        ${model.khuVuc},
                        ${model.lanvay},
                        "${model.nguoiTraloiKhaoSat}",
                        ${model.songuoiTrongHo},
                        ${model.songuoiCoviecLam},
                        ${model.dientichDatTrong},
                        ${model.giaTriVatNuoi},
                        ${model.dungCuLaoDong},
                        ${model.phuongTienDiLai},
                        ${model.taiSanSinhHoat},
                        "${model.quyenSoHuuNha}",
                        ${model.hemTruocNha},
                        "${model.maiNha}",
                        "${model.tuongNha}",
                        "${model.nenNha}",
                        ${model.dienTichNhaTinhTren1Nguoi},
                        "${model.dien}",
                        "${model.nuoc}",
                        "${model.mucDichSudungVon}",
                        ${model.soTienCanThiet},
                        ${model.soTienThanhVienDaCo},
                        ${model.soTienCanVay},
                        "${model.thoiDiemSuDungVonvay}",
                        ${model.tongVonDauTu},
                        ${model.thuNhapRongHangThang},
                        ${model.thuNhapCuaVoChong},
                        ${model.thuNhapCuaCacCon},
                        ${model.thuNhapKhac},
                        ${model.tongChiPhiCuaThanhvien},
                        ${model.chiPhiDienNuoc},
                        ${model.chiPhiAnUong},
                        ${model.chiPhiHocTap},
                        ${model.chiPhiKhac},
                        ${model.chiTraTienVayHangThang},
                        ${model.tichLuyTangThemHangThang},
                        "${model.nguonVay1}",
                        ${model.sotienVay1},
                        "${model.lyDoVay1}",
                        "${model.thoiDiemTatToan1}",
                        "${model.bienPhapThongNhat1}",
                        "${model.nguonVay2}",
                        ${model.sotienVay2},
                        "${model.lyDoVay2}",
                        "${model.thoiDiemTatToan2}",
                        "${model.bienPhapThongNhat2}",
                        "${model.thanhVienThuocDien}",
                        "${model.maSoHoNgheo}",
                        "${model.hoTenChuHo}",
                        ${model.soTienGuiTietKiemMoiKy},
                        ${model.tietKiemBatBuocXinRut},
                        ${model.tietKiemTuNguyenXinRut},
                        ${model.tietKiemLinhHoatXinRut},
                        "${model.thoiDiemRut}",
                        ${model.mucVayBoSung},
                        "${model.mucDichVayBoSung}",
                        "${model.ngayVayBoSung}",
                        "${model.ghiChu}",
                        ${model.soTienDuyetChovay},
                        ${model.tietKiemDinhHuong},
                        "${model.mucDichVay}",
                        "${model.duyetChovayNgay}",
                        ${model.daCapNhatVaoHoSoChovay}
                                                )''';
        print(queryString);
        rs = await db.rawInsert(queryString);
      }
      return rs;
    } on Exception catch (ex) {
      print(ex);
      // only executed if error is of type Exception
    } catch (error) {
      // executed for errors of all types other than Exception
    }
  }

  getAllLichSuKhaoSat() async {
    final db = await database;
    var res = await db.query("lichsukhaosat_tbl");
    List<SurveyInfoHistory> list = res.isNotEmpty
        ? res.map((c) => SurveyInfoHistory.fromMap(c)).toList()
        : [];
    return list;
  }

  newHistorySearchKhaoSat(String cumID, String ngayXuatDanhSach,
      String username, String masoql) async {
    int id = 0;
    final db = await database;
    try {
      int checkExistsData = Sqflite.firstIntValue(await db.rawQuery(
          "SELECT COUNT(*) FROM historysearchkhaosat_tbl WHERE cumID='${cumID}' and username = '${username}' and ngayXuatDanhSach = '${ngayXuatDanhSach}'"));
      if (checkExistsData == 0) {
        String queryString =
            '''INSERT Into historysearchkhaosat_tbl(cumID,ngayXuatDanhSach,username,masoql)
                VALUES ("${cumID}",
                        "${ngayXuatDanhSach}",
                        "${username}",
                        "${masoql}"
                        )''';
        await db.rawInsert(queryString);
      }
      List<Map> list = await db.query("historysearchkhaosat_tbl",
          columns: ["id"],
          where: "cumID = ? and username = ?",
          whereArgs: [cumID, username],
          limit: 1);
      var a = list.first;
      id = a["id"];
      return id;
    } on Exception catch (ex) {
      print(ex);
      // only executed if error is of type Exception
    } catch (error) {
      // executed for errors of all types other than Exception
    }
  }

  getAllHistorySearchKhaoSat() async {
    final db = await database;
    var res = await db.query("historysearchkhaosat_tbl",
        where: "username = ?", whereArgs: [globalUser.getUserName]);
    List<HistorySearchSurvey> list = res.isNotEmpty
        ? res.map((c) => HistorySearchSurvey.fromMap(c)).toList()
        : [];
    return list;
  }

  newMetaDataForTBD(List<ComboboxModel> comboboxList) async {
    final db = await database;
    try {
      await db.rawDelete('DELETE FROM metadata_tbl');
      for (var item in comboboxList) {
        String queryString =
            '''INSERT Into metadata_tbl(server_id,group_id,group_text,item_id,item_text)
                VALUES ("${item.serverId}",
                        "${item.groupId}",
                        "${item.groupText}",
                        "${item.itemId}",
                        "${item.itemText}"
                        )''';
        db.rawInsert(queryString);
      }
    } on Exception catch (ex) {
      print(ex);
      // only executed if error is of type Exception
    } catch (error) {
      // executed for errors of all types other than Exception
    }
  }

  getAllMetaDataForTBD() async {
    final db = await database;
    var res = await db.query("metadata_tbl");
    List<ComboboxModel> list =
        res.isNotEmpty ? res.map((c) => ComboboxModel.fromMap(c)).toList() : [];
    return list;
  }

  newUserInfo(UserInfo userInfo) async {
    final db = await database;
    try {
      await db.rawDelete('DELETE FROM userinfo_tbl');

      String queryString =
          '''INSERT Into userinfo_tbl(chiNhanhID,tenChiNhanh,chucVu,hoTen,dienThoai,masoql,toTinDung)
              VALUES (${userInfo.chiNhanhID},
                      "${userInfo.tenChiNhanh}",
                      "${userInfo.chucVu}",
                      "${userInfo.hoTen}",
                      "${userInfo.dienThoai}",
                      "${userInfo.masoql}",
                      ${userInfo.toTinDung}
                      )''';
      db.rawInsert(queryString);
    } on Exception catch (ex) {
      print(ex);
      // only executed if error is of type Exception
    } catch (error) {
      // executed for errors of all types other than Exception
    }
  }

  getUserInfo() async {
    final db = await database;
    var res = await db.query("userinfo_tbl");
    UserInfo userInfo =
        res.isNotEmpty ? res.map((c) => UserInfo.fromMap(c)).first : null;
    return userInfo;
  }

  newUserRole(UserRole userRole) async {
    final db = await database;
    try {
      await db.rawDelete('DELETE FROM userrole_tbl');

      String queryString =
          '''INSERT Into userrole_tbl(salary,hPqlnlhc,banTgd,administrator,td,giaoDich,ktv,tq,kiemSoat2,hHs,hPtckt,gdcn,provisional,ptcd,hPcntt,dataBase,tpkt,chiNhanh,kiemSoat,thionline,tttd,hPqltd,hPhlptd,tptd,upLoad,hPktnb)
              VALUES (${userRole.salary},
                      ${userRole.hPqlnlhc},
                      ${userRole.banTgd},
                      ${userRole.administrator},
                      ${userRole.td},
                      ${userRole.giaoDich},
                      ${userRole.ktv},
                      ${userRole.tq},
                      ${userRole.kiemSoat2},
                      ${userRole.hHs},
                      ${userRole.hPtckt},
                      ${userRole.gdcn},
                      ${userRole.provisional},
                      ${userRole.ptcd},
                      ${userRole.hPcntt},
                      ${userRole.dataBase},
                      ${userRole.tpkt},
                      ${userRole.chiNhanh},
                      ${userRole.kiemSoat},
                      ${userRole.thionline},
                      ${userRole.tttd},
                      ${userRole.hPqltd},
                      ${userRole.hPhlptd},
                      ${userRole.tptd},
                      ${userRole.upLoad},
                      ${userRole.hPktnb}
                      )''';
      db.rawInsert(queryString);
    } on Exception catch (ex) {
      print(ex);
      // only executed if error is of type Exception
    } catch (error) {
      // executed for errors of all types other than Exception
    }
  }

  getUserRole() async {
    final db = await database;
    var res = await db.query("userrole_tbl");
    UserRole userInfo =
        res.isNotEmpty ? res.map((c) => UserRole.fromMap(c)).first : null;
    return userInfo;
  }

  newCommunityDevelopment(List<KhachHang> listCustomer) async {
    int rs = 0;
    final db = await database;
    try {
      for (var item in listCustomer) {
        int checkExistsData = Sqflite.firstIntValue(await db
            .rawQuery('''SELECT COUNT(*) FROM customer_cummunity_development " +
              "WHERE maKhachHang='${item.maKhachHang}' and chinhanhID=${item.chinhanhId} and masoql='${item.masoql}' and cumID= '${item.cumId}' '''));
        if (checkExistsData != 0) {
          String queryString = '''INSERT Into customer_cummunity_development(
                                    maKhachHang,
                                    chinhanhID,
                                    duanID,
                                    masoql,
                                    cumID,
                                    hoTen,
                                    thanhVienID,
                                    cmnd,
                                    gioitinh,
                                    ngaysinh,
                                    diachi,
                                    dienthoai,
                                    lanvay,
                                    thoigianthamgia,
                                    thanhVienThuocDien,
                                    maHongheoCanngheo,
                                    ngheNghiep,
                                    ghiChu,
                                    moHinhNghe,
                                    thunhapHangthangCuaho,
                                    coVoChongConLaCNV
                                    )
                VALUES ("${item.maKhachHang}",
                        "${item.chinhanhId}",
                        ${item.duanId},
                        "${item.masoql}",
                        "${item.cumId}",
                        "${item.hoTen}",
                        "${item.thanhVienId}",
                        "${item.cmnd}",
                        ${item.gioitinh},
                        "${item.ngaysinh}",
                        "${item.diachi}",
                        "${item.dienthoai}",
                        ${item.lanvay},
                        "${item.thoigianthamgia}",
                        ${item.thanhVienThuocDien},
                        "${item.maHongheoCanngheo}",
                        ${item.ngheNghiep},
                        "${item.ghiChu}",
                        ${item.moHinhNghe},
                        ${item.thunhapHangthangCuaho},
                        ${item.coVoChongConLaCnv}
                        )
                       ''';
          queryString += '''
                  INSERT Into mainha_cummunity_development(
                                    id_khachhang,
                                    serverID,
                                    nam,
                                    maKhachHang,
                                    tilephuthuoc,
                                    thunhap,
                                    taisan,
                                    dieukiennhao,
                                    quyenSoHuuNha,
                                    ghichuhoancanh,
                                    cbDexuat,
                                    duTruKinhPhi,
                                    deXuatHoTro,
                                    giaDinhHoTro,
                                    tietKiem,
                                    tienVay,
                                    giaDinhDongY,
                                    cnDexuat,
                                    cnDexuatThoigian,
                                    cnDexuatSotien,
                                    hosodinhkem
                                    )
                VALUES (last_insert_rowid(),
                        ${item.maiNha.serverId},
                        ${item.maiNha.nam},
                        "${item.maiNha.maKhachHang}",
                        ${item.maiNha.tilephuthuoc},
                        ${item.maiNha.thunhap},
                        ${item.maiNha.taisan},
                        ${item.maiNha.dieukiennhao},
                        ${item.maiNha.quyenSoHuuNha},
                        "${item.maiNha.ghichuhoancanh}",
                        ${item.maiNha.cbDexuat},
                        ${item.maiNha.duTruKinhPhi},
                        ${item.maiNha.deXuatHoTro},
                        ${item.maiNha.giaDinhHoTro},
                        ${item.maiNha.tietKiem},
                        ${item.maiNha.tienVay},
                        ${item.maiNha.giaDinhDongY},
                        ${item.maiNha.cnDexuat},
                        "${item.maiNha.cnDexuatThoigian}",
                        ${item.maiNha.cnDexuatSotien},
                        ${item.maiNha.hosodinhkem}
                        )
          ''';

          print(queryString);
          rs = await db.rawInsert(queryString);
        }
      }

      return rs;
    } on Exception catch (ex) {
      print(ex);
      // only executed if error is of type Exception
    } catch (error) {
      // executed for errors of all types other than Exception
    }
  }

  dropDataBase() async {
    final db = await database;
    await db.execute("DROP DATABASE TestDB.db");
  }

//   Future<void> dropTableIfExistsThenReCreate() async {

//     //here we get the Database object by calling the openDatabase method
//     //which receives the path and onCreate function and all the good stuff
//     Database db = await openDatabase(path,onCreate: ...);

//     //here we execute a query to drop the table if exists which is called "tableName"
//     //and could be given as method's input parameter too
//     await db.execute("DROP TABLE IF EXISTS tableName");

//     //and finally here we recreate our beloved "tableName" again which needs
//     //some columns initialization
//     await db.execute("CREATE TABLE tableName (id INTEGER, name TEXT)");

// }

}

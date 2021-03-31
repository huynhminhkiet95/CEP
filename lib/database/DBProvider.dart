import 'dart:io';
import 'package:CEPmobile/models/download_data/comboboxmodel.dart';
import 'package:CEPmobile/models/download_data/survey_info.dart';
import 'package:CEPmobile/models/download_data/historysearchsurvey.dart';
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
    String path = join(documentsDirectory.path, "CEP3dbo.db");
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

      await db.execute("CREATE TABLE HistorySearchKhaoSat("
          "id INTEGER,"
          "cumID TEXT,"
          "ngayXuatDanhSach TEXT,"
          "username TEXT,"
          "masoql TEXT"
          ")");

      await db.execute("CREATE TABLE metadata_tbd("
          "server_id INTEGER,"
          "group_id TEXT,"
          "group_text TEXT,"
          "item_id TEXT,"
          "item_text TEXT"
          ")");
    });
  }
  // void _onUpgrade(Database db, int oldVersion, int newVersion) {
  //   if (oldVersion < newVersion) {
  //     db.execute("ALTER TABLE Client ADD COLUMN last_name1 TEXT;");
  //   }
  // }

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
                        ${model.moTheMoi},
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
    var res = await db.query("KhaoSat");
    List<SurveyInfo> list =
        res.isNotEmpty ? res.map((c) => SurveyInfo.fromMap(c)).toList() : [];
    return list;
  }

  newHistorySearchKhaoSat(String cumID, String ngayXuatDanhSach,
      String username, String masoql) async {
    int id = 0;
    final db = await database;
    try {
      int checkExistsData = Sqflite.firstIntValue(await db.rawQuery(
          "SELECT COUNT(*) FROM HistorySearchKhaoSat WHERE cumID='${cumID}' and username = '${username}'"));

      if (checkExistsData == 0) {
        String queryString =
            '''INSERT Into HistorySearchKhaoSat(id,cumID,ngayXuatDanhSach,username,masoql)
                VALUES ("${id}",
                        "${cumID}",
                        "${ngayXuatDanhSach}",
                        "${username}",
                        "${masoql}"
                        )''';
        print(queryString);
        await db.rawInsert(queryString);
        id = checkExistsData + 1;
      } else {
        id = checkExistsData;
      }
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
    var res = await db.query("HistorySearchKhaoSat");
    List<HistorySearchSurvey> list = res.isNotEmpty
        ? res.map((c) => HistorySearchSurvey.fromMap(c)).toList()
        : [];
    return list;
  }

  newMetaDataForTBD(List<ComboboxModel> comboboxList) async {
    final db = await database;
    try {
      await db.rawDelete('DELETE FROM metadata_tbd');
      for (var item in comboboxList) {
        String queryString =
          '''INSERT Into metadata_tbd(server_id,group_id,group_text,item_id,item_text)
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
    var res = await db.query("metadata_tbd");
    List<ComboboxModel> list = res.isNotEmpty
        ? res.map((c) => ComboboxModel.fromMap(c)).toList()
        : [];
    return list;
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

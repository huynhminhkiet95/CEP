import 'dart:io';
import 'package:CEPmobile/models/comon/activity.dart';
import 'package:CEPmobile/models/comon/notification.dart';
import 'package:CEPmobile/models/comon/triprecordModel.dart';
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

  checkColumn() async {
    final db = await database;
    // try {
    //   var res = await db.rawQuery('SELECT isRead FROM Notification LIMIT 0');
    //   if (res.isNotEmpty) {
    //     await db.execute(
    //       "ALTER TABLE Notification ADD COLUMN isRead INTEGER DEFAULT 0;",
    //     );
    //   }
    // } catch (exception) {
    //   await db.execute(
    //     "ALTER TABLE Notification ADD COLUMN isRead INTEGER DEFAULT 0;",
    //   );
    // }
    try {
      // var res = await db.rawQuery('SELECT issuedate FROM Notification LIMIT 0');
      // if (res.isNotEmpty) {
      //   await db.execute(
      //     "ALTER TABLE Notification ADD COLUMN issuedate INTEGER;",
      //   );
      // }
      //await db.rawQuery('SELECT fleetid FROM Notification LIMIT 0');
    } catch (exception) {
      // await db.execute(
      //   "ALTER TABLE Notification ADD COLUMN issuedate INTEGER;",
      // );
      //  await db.execute(
      //     "ALTER TABLE Notification ADD COLUMN fleetid INTEGER;",
      //   );
    }
    await db.execute(
      "CREATE TABLE IF NOT EXISTS TripRecord(id INTEGER PRIMARY KEY,route TEXT DEFAULT '', memo  TEXT DEFAULT '');",
    );
    await db.execute(
      "CREATE TABLE IF NOT EXISTS Activity(id INTEGER PRIMARY KEY, type INTEGER DEFAULT 0, pickupPlace TEXT DEFAULT '', returnPlace TEXT DEFAULT '', activity  TEXT DEFAULT '', createdate TEXT);",
    );
  }

  initDB() async {
    // Get the location of our app directory. This is where files for our app,
    // and only our app, are stored. Files in this directory are deleted
    // when the app is deleted.
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String path = join(documentsDir.path, 'app.db');

    return await openDatabase(path, version: 1, onOpen: (db) async {},
        onCreate: (Database db, int version) async {
      // Create the note table
      await db.execute(
        "CREATE TABLE Notification(id INTEGER PRIMARY KEY, type INTEGER, message TEXT DEFAULT '', platform TEXT, createdate TEXT, issuedate INTEGER, itemCode  TEXT DEFAULT '', fleetid  TEXT DEFAULT '', userid  TEXT DEFAULT '', isRead INTEGER DEFAULT 0);",
      );
      await db.execute(
        "CREATE TABLE TripRecord(id INTEGER PRIMARY KEY,route TEXT DEFAULT '', memo  TEXT DEFAULT '');",
      );
    });
  }

  //Querry database
  newNotification(NotificationModel newData) async {
    final db = await database;
    var date = DateTime.now().millisecondsSinceEpoch;
    var res = await db.rawInsert(
        "INSERT Into Notification (id,type,message,platform,createdate,issuedate,itemCode)"
        " VALUES (${newData.id},${newData.type},${newData.message},${newData.platform},${newData.createdate},$date),${newData.id})");
    return res;
  }

  insertNotification(NotificationModel newData) async {
    final db = await database;
    var res = await db.insert("Notification", newData.toMap());
    return res;
  }

  newClient(NotificationModel newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Notification");
    int id = table.first["id"] == null ? 1 : table.first["id"];
    //insert to the table using the new id
    var date = DateTime.now().millisecondsSinceEpoch;
    var raw = await db.rawInsert(
        "INSERT Into Notification (id,type,message,platform,issuedate,createdate,itemCode,fleetid,userid)"
        " VALUES (?,?,?,?,?,?,?,?,?)",
        [
          id,
          newClient.type,
          newClient.message,
          newClient.platform,
          newClient.createdate,
          date,
          newClient.id,
          newClient.id,
          newClient.receiver
        ]);
    return raw;
  }

  getNotificationItem(int id) async {
    final db = await database;
    var res = await db.query("Notification", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? NotificationModel.fromJson(res.first) : Null;
  }

  getAllNotifications(String userid) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM Notification where userid = '$userid' Order by createdate desc");
    List<NotificationModel> list = res.isNotEmpty
        ? res.map((c) => NotificationModel.fromJson(c)).toList()
        : [];
    return list;
  }

  getAllNotificationsBlank() async {
    final db = await database;
    var res = await db.query("Notification");
    List<NotificationModel> list = res.isNotEmpty
        ? res.map((c) => NotificationModel.fromJson(c)).toList()
        : [];
    return list;
  }

  getNotificationsbytype() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Notification WHERE type=1");
    List<NotificationModel> list = res.isNotEmpty
        ? res.toList().map((c) => NotificationModel.fromJson(c))
        : null;
    return list;
  }

  getNotificationNotRead(String userid) async {
    final db = await database;
    var res = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT count(*) FROM Notification WHERE userid = '$userid' and isRead<>1"));
    return res;
  }

  getNotificationBookNotRead(String userid) async {
    final db = await database;
    var res = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT count(*) FROM Notification WHERE userid = '$userid' and isRead<>1 and type = 0"));
    return res;
  }

  updateNotification(NotificationModel newClient) async {
    final db = await database;
    var res = await db.update("Notification", newClient.toMap(),
        where: "id = ?", whereArgs: [newClient.id]);
    return res;
  }

  updatestatusNotification(int id) async {
    final db = await database;
    var raw =
        await db.rawUpdate("UPDATE Notification set isRead = 1 where id = $id");
    return raw;
  }

  Future<void> deleteNotification(int id) async {
    final db = await database;
    await db.delete(
      'Notification',
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteNotifications() async {
    final db = await database;
    await db.delete(
      'Notification',
    );
  }

  //Save triprecord
  insertTriprecord(String route, String memo) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM TripRecord");
    int id = table.first["id"] == null ? 1 : table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into TripRecord (id,route,memo)"
        " VALUES (?,?,?)",
        [id, route, memo]);
    return raw;
  }

  getAllTripReCord() async {
    final db = await database;
    var res = await db.query("TripRecord", limit: 10);
    List<TriprecordModel> list = res.isNotEmpty
        ? res.map((c) => TriprecordModel.fromJson(c)).toList()
        : [];
    return list;
  }

  //Save Activity
  insertActivity(ActivityModel data) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Activity");
    int id = table.first["id"] == null ? 1 : table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Activity (id,type,pickupPlace,returnPlace,createdate,activity,userId)"
        " VALUES (?,?,?,?,?,?,?)",
        [
          id,
          data.type,
          data.pickupPlace,
          data.returnPlace,
          data.createdate,
          data.activity,
          data.userId
        ]);
    return raw;
  }

  getActivity() async {
    final db = await database;
    var res = await db.query("Activity");
    List<ActivityModel> list = res.isNotEmpty
        ? res.map((c) => ActivityModel.fromJson(c)).toList()
        : [];
    return list;
  }

  getActivitybyDate(String datefrom, String dateto) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM Activity WHERE createdate => '$datefrom' and createdate <= '$dateto'");
    List<ActivityModel> list = res.isNotEmpty
        ? res.map((c) => ActivityModel.fromJson(c)).toList()
        : [];
    return list;
  }
}

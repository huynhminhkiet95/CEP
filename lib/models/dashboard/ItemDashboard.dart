import 'package:flutter/material.dart';

class ItemDashBoard {
  String title;
  String img;
  IconData icon;
  // Icons.download_rounded
  ItemDashBoard({this.title, this.img, this.icon});

  static List<ItemDashBoard> getItemDashboard() {
    List<ItemDashBoard> list = new List<ItemDashBoard>();
    list.add(new ItemDashBoard(
        title: "Khảo Sát", img: "assets/dashboard/survey.png", icon : Icons.library_books ));
    list.add(new ItemDashBoard(
        title: "Thu Nợ", img: "assets/dashboard/credit-hover.png" , icon : Icons.attach_money));
    list.add(new ItemDashBoard(
        title: "Tư Vấn Tiết Kiệm", img: "assets/dashboard/saving-hover.png", icon : Icons.record_voice_over_outlined));
    list.add(new ItemDashBoard(
        title: "Phát Triển Cộng Đồng",
        img: "assets/dashboard/develop-hover.png", icon : Icons.people_rounded));
    list.add(new ItemDashBoard(
        title: "Thống Kê", img: "assets/dashboard/statistical-analysis.png", icon : Icons.insert_chart_outlined));
    list.add(new ItemDashBoard(
        title: "Tải Xuống",
        img: "assets/dashboard/document-download-outline.png", icon : Icons.download_rounded));
    return list;
  }

  static List<ItemDashBoard> getItemMenuDefault() {
    List<ItemDashBoard> list = new List<ItemDashBoard>();
    list.add(new ItemDashBoard(
        title: "Xóa Dữ Liệu", img: "", icon : Icons.delete_forever_rounded ));
    list.add(new ItemDashBoard(
        title: "Settings", img: "assets/dashboard/credit-hover.png" , icon : Icons.settings));
    list.add(new ItemDashBoard(
        title: "Đăng Xuất", img: "assets/dashboard/credit-hover.png" , icon : Icons.logout));
   
    return list;
  }

}

//  Items item1 =
//       new Items(title: "Khảo Sát", img: "assets/dashboard/survey.png");

//   Items item2 = new Items(
//     title: "Thu Nợ",
//     img: "assets/dashboard/credit-hover.png",
//   );
//   Items item3 = new Items(
//     title: "Tư Vấn Tiết Kiệm",
//     img: "assets/dashboard/saving-hover.png",
//   );
//   Items item4 = new Items(
//     title: "Phát Triển Cộng Đồng",
//     img: "assets/dashboard/develop-hover.png",
//   );
//   Items item5 = new Items(
//     title: "Thống Kê",
//     img: "assets/dashboard/statistical-analysis.png",
//   );
//   Items item6 = new Items(
//     title: "Tải Xuống",
//     img: "assets/dashboard/document-download-outline.png",
//   );

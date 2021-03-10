// import 'package:flutter/material.dart';
// import 'package:iglsmobile/conf%C3%ACg/colors.dart';
// import 'package:iglsmobile/models/comon/StdCode.dart';

// typedef void SelectValueCallBack(String foo);

// class CustomTextFormF extends StatelessWidget {
//   final String title;
//   final initialValue;
//   final SelectValueCallBack selectValueCallBack;
//   const StdCodeDropDown({Key key,this.selectValueCallBack}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Padding(
//       padding: EdgeInsets.all(5),
//       child: new Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       mainAxisSize:MainAxisSize.min,
//       children: <Widget>[
//         new Expanded(
//           flex: 3,
//           child: Text(title,style: TextStyle(color: ColorConstants.yellowColor,fontStyle: FontStyle.normal ),),
//         ),
//         new Expanded(
//           flex: 7,
//           child: DropdownButton<String>(
//                     isExpanded: true,
//                     value:stdcodes.length > 0 ? defaultValue: "",
//                     onChanged: (String newValue) async {
//                       selectValueCallBack(newValue);
//                     },
//                     items: stdcodes.map<DropdownMenuItem<String>>(
//                             (StdCode value) {
//                       return new DropdownMenuItem<String>(
//                         value: value.codeId,
//                         child: FittedBox(
//                           fit: BoxFit.cover,
//                           child: Text(
//                             value.codeDesc,
//                             style:
//                                 TextStyle(fontSize: 14.0,color: ColorConstants.yellowColor),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ) ,
//         )
//       ],
//     ),
//     ),
//     );
//   }
// }
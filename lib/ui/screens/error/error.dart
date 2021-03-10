import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(

        child: Column(
          children: <Widget>[
            Icon(
             Icons.cloud_off,
             size: 200,
             

            ),
            Divider(height: 6,),
            Text("Can't load search result", style: TextStyle(color: Colors.black45,fontSize: 19),),
            Divider(height: 6,),
            RaisedButton(onPressed: (){
              
            }, child: Text("TRY AGAIN",),color: Colors.green,textColor: Colors.white,)
           
          ],
        ),
      ),
    );
  }
}
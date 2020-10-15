import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/util/Constant.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';


class Dialogs {
  static Future<void>
  showLoadingDialog(BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  //backgroundColor: Colors.black54,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10,),
                        Text(POSTING_WAIT,style: TextStyle(color: Colors.blueAccent),)
                      ]),
                    )
                  ]));
        });
  }
  static Future<void>
  showGeneralDialog(BuildContext context, GlobalKey key,String Keep_changes) async {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        content: new Text(Keep_changes),
        actions: <Widget>[
          new FlatButton(
              child: Text("OK",style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }

}


/*class internet {
  static Future<void>
  showLoadingDialog(BuildContext context, GlobalKey key) async {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text(NETWORK_CONNECTION_ERROR),
        //content: new Text("User doesn't found?"),
        actions: <Widget>[
          new FlatButton(
              child: Text("ok",style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
        ],
      ),
    );
  }
}*/

class BouncyPageRoute extends PageRouteBuilder{
  final Widget widget;

  BouncyPageRoute({this.widget})
      :super(
      transitionDuration: Duration(seconds: 1),
      transitionsBuilder: (BuildContext context,
          Animation<double> animation,
          Animation<double> secAnimation,
          Widget child){
        animation = CurvedAnimation(
            parent: animation, curve: Curves.elasticInOut);
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },

      pageBuilder: (BuildContext context,Animation<double>animation,
          Animation<double> secAnimation){
        return widget;
      }
  );
}

/*var _connectionStatus = 'Unknown';
Connectivity connectivity;
StreamSubscription<ConnectivityResult> subscription;

 class Internet_Connectivity {
   //_connectionStatus,connectivity,subscription)  {
   static Future<void>
   connect()  {
     connectivity = new Connectivity();
     print(2);
     subscription =
         connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
           _connectionStatus = result.toString();
           print(3);

           print(_connectionStatus);
           if (result == ConnectivityResult.wifi ||
               result == ConnectivityResult.mobile) {

             //checkstatus(_connectionStatus);
           }
           else {
             return result;
             //checkstatus(_connectionStatus);
           }
         });
   }
 }*/

/*Future<String> Internet_Connectivity() async {
   // static Future<void>

   var result = await Connectivity().checkConnectivity();
   print(result);
   print(result.toString());
   return String(result);//result.toString();
 }

 Inter() async
{
  var result = await Connectivity().checkConnectivity();
  return result;
}*/



/*
String _networkStatus1 = '';

Connectivity connectivity = Connectivity();

 checkConnectivity1() async  {
  var connectivityResult = await connectivity.checkConnectivity();
 // String rohit = connectivityResult.toString();
  //print(rohit);
  print(connectivityResult);
  String conn = getConnectionValue(connectivityResult);
  return conn;
  /*setSte(() {
    _networkStatus1 = 'Check Connection:: ' + conn;
  });*/
}

// Method to convert the connectivity to a string value
String getConnectionValue(var connectivityResult) {
  String status = '';
  switch (connectivityResult) {
    case ConnectivityResult.mobile:
      status = 'Mobile';
      break;
    case ConnectivityResult.wifi:
      status = 'Wi-Fi';
      break;
    case ConnectivityResult.none:
      status = 'None';
      break;
    default:
      status = 'None';
      break;
  }
  print(connectivityResult);
  print(2);
  print(status);
  return status;
}


*/
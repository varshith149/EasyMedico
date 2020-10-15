//multi_image_picker: ^3.0.14
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/Views/Login_view.dart';
import 'package:flutter_app2/Views/Prescription_view.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:device_id/device_id.dart';
import 'package:connectivity/connectivity.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      //routes: <String, WidgetBuilder>{
      //'/login_view': (BuildContext context) => new MyAp()
      //},
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*GlobalKey<NavigatorState> _key = GlobalKey();

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5),()=> Navigator.push(context,MaterialPageRoute(builder: (context){
      return MyAp();
    }
    )));
 }*/


  /*Future<bool> _onBackPressed() {
   //Navigator.of(context).pop();

   return showDialog(
     context: context,
     builder: (context) => new AlertDialog(
       title: new Text('Are you sure?'),
       content: new Text('Do you want to exit an App'),
       actions: <Widget>[
         new FlatButton(
           child: Text("NO"),
           onPressed: () => Navigator.pop(context,false),
         ),
         new FlatButton(
           child: Text("Yes"),
           onPressed: () => Navigator.pop(context,true),
         ),
       ],
     ),
   ) ??
       false;
 }*/

  bool togg;
  String deviceID;
  String User_loggedIn;
  String result ='';



  @override
  void initState() {
    super.initState();
   // Rememberme(togg);
  }


  void getDeviceID() async {
    String deviceId = await DeviceId.getID;
    deviceID = '$deviceId';
   // print('Device ID is $deviceId');
  }


  Rememberme(bool togg) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("DEVICE_ID", deviceID);
    final bool toggleValue = sharedPreferences.getBool('Islogin');
    //print("toggle value from main dart");
    //print(toggleValue);
    setState(() {
      togg = toggleValue;
    });
   // print(togg);

    if (togg == true ) {
      User_loggedIn = 'Prescription Screen';
    }
    else {
      User_loggedIn = 'Sign In';
    }

  }

 /* device() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString("Internet_Result", result);
  }*/

/*Future<bool> _onBackPressed() {
  //Navigator.of(context).pop();
  return showDialog(
    context: context,
    builder: (context) => new AlertDialog(
      title: new Text('Are you sure?'),
      content: new Text('Do you want to exit an App'),
      actions: <Widget>[
        new FlatButton(
          child: Text("NO"),
          onPressed: () => Navigator.pop(context,false),
        ),
        new FlatButton(
          child: Text("Yes"),
          onPressed: () => Navigator.pop(context,true),
        ),
      ],
    ),
  ) ??
      false;
}
*/
  @override
  void dispose() {
  //  subscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    getDeviceID();
    // device();
    Rememberme(togg);
    return SplashScreen(
      seconds: 2,
      backgroundColor: Colors.white,

      image: Image.asset('Images/Logo_easymedico.png'),
      loaderColor: Colors.white,
      photoSize: 150,
      navigateAfterSeconds: User_loggedIn == 'Prescription Screen' ? Landingscreen() : MyAp(),

      loadingText: Text('Your Health Our Care..!',
        style: TextStyle(
            fontSize: 30,
            color: Colors.green
        ),
      ),
    );
  }


  void checkstatus(String resultval) {
    setState(() {
      result = resultval;
    });
  }
}



// Akkarleni Sodhi
/*WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.red),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 50,
                                  child: Icon(
                                    Icons.medical_services,
                                    color: Colors.green,
                                    size: 50,
                                  ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(top: 10.0)
                              ),
                              Text(
                                "EasyMedico",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                    Expanded(
                        flex:1,
                      child: Column(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Padding(
                              padding: EdgeInsets.only(top:20),
                          ),
                          Text("E-PHARMACY",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],

            ),

      ),
    );

  }}*/











/*
      body: Center(
        child: Text('Hello Amigos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text('click'),
        backgroundColor: Colors.red,
      ),
    ),
  ));
}
*/







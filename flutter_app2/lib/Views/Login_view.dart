import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app2/util/Util_file.dart';
//import 'package:flutter_app/Model/Login_model.dart';
import 'package:flutter_app2/Views/Prescription_view.dart';
import 'package:flutter_app2/Views/Signup_view.dart';
import 'package:flutter_app2/Views/Forgot_password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_app2/main.dart';
import 'package:flutter_app2/util/Constant.dart';
//import 'package:flutter_app2/util/SizeConfig.dart';


class MyAp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Easy Medico',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),//new BasicCounterPresenter(), title: 'Sign In'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  //final CounterPresenter presenter;

  //MyHomePage(this.presenter, {Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> /*implements CounterView*/ {
  //GlobalKey<NavigatorState> _key = GlobalKey();
  // final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
 // final Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;

  String _email;
  String _password;
 // Position _currentPosition;
 // String _currentAddress;


bool idontknow;
  String deviceID;
  String result = '';
  bool toggleValue = false;
  bool _isLoading = false;



  /* var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    print(1);
    connectivity = new Connectivity();
    print(1);
    subscription =
            connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _connectionStatus = result.toString();
    print(100);
      print(_connectionStatus);
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        checkstatus(_connectionStatus);
        //_getCurrentLocation();

      }
    else
      {
          checkstatus(_connectionStatus);
      }
    });
    //this.widget.presenter.counterView = this as CounterView;
  }*/

  @override
  void dispose() {
     //subscription.cancel();
    super.dispose();
  }


  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();


   Future<bool> _onBackPressed() {
  /* if(context != null)
     {
       print(1);
       Navigator.pop(context,true);
     }*/
    SystemNavigator.pop();
   //exit(0);

   }

bool emailvalid;
  @override
  Widget build(BuildContext context) {
    checkConnectivity1();
    return WillPopScope(
        onWillPop: ()// => SystemNavigator.pop(),
         async {
        _onBackPressed();
          return true;
        },
        child: new Scaffold(
        appBar: AppBar(
            title: Text(APPBAR_SIGNIN,//widget.title,
                style: TextStyle(fontSize: 25)
            ),
            leading: new IconButton(
              icon: new
              Icon(Icons.arrow_back),
              onPressed: () =>  SystemNavigator.pop(),// exit(0),
            ),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(236, 85, 156, 1)
        ),
        body: SingleChildScrollView(
            child: //_isLoading ? Center(child: CircularProgressIndicator()) :
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /* Container(
                    child: Stack(
                    children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0,65, 0.0, 0.0),
                      child: Text(
                            'Easymedico',
                             style: TextStyle(
                              fontSize: 50,fontWeight: FontWeight.bold, color: Colors.black)
                                 ),
                            )
                                       ],
                                ),
                          ),*/
                  Container (
                      padding: EdgeInsets.fromLTRB(15, 60, 15,0 ),
                      child: Form(
                        key: _formKey,

                        child: Column(
                            children: <Widget>[
                              TextFormField(
                                style:
                                TextStyle(fontSize: 22.0, color: Color.fromRGBO(100, 100, 100, 1)),
                                controller: emailController,
                                decoration: InputDecoration(
                                  //contentPadding: EdgeInsets.all(30),
                                    labelText: EMAIL,
                                    labelStyle: TextStyle(
                                        fontFamily:'Montserrat',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(97, 97, 97, 1)
                                    ),
                                    focusedBorder: UnderlineInputBorder(

                                        borderSide: BorderSide(color: Colors.blue)
                                    )
                                ),
                                validator: (String val) =>
                                //!val.contains('@') ? EMAIL_ERROR :null,
                               // onSaved: (val) => _email=val,
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null: EMAIL_ERROR,
                                onSaved: (val) => _email=val,
                              ),
                              SizedBox(height: 5.0),
                              TextFormField(

                                style:
                                TextStyle(fontSize: 22.0, color: Color.fromRGBO(100, 100, 100, 1)),
                                controller: passwordController,
                                decoration: InputDecoration(
                                  //contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  labelText: PASSWORD,
                                  labelStyle: TextStyle(
                                      fontFamily:'Montserrat',
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(97, 97, 97, 1)
                                  ),

                                ),
                                validator: (val)  =>
                                val.length<6 ? PASSWORD_ERROR :null,
                                onSaved: (val) => _password=val,
                                obscureText: true,
                              ),


                              SizedBox(height: 20.0),
                              Container(
                                  alignment: Alignment(1.0,0.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(context,
                                          BouncyPageRoute(widget: resetPage()));
                                    },
                                    child: Text(
                                      FORGET_PASSWORD,
                                      style: TextStyle(
                                        fontFamily:'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color.fromRGBO(99, 99, 99, 1),
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  )
                              ),

                            ]
                        ),
                        //   onWillPop: _onBackPressed,
                      )
                  ),

                  SizedBox(height: 40.0),
                  Row(
                      mainAxisAlignment : MainAxisAlignment.start,
                      children :<Widget>[
                        SizedBox(width: 10),
                        Text(
                          REMEMBER_ME,
                          style: TextStyle(fontFamily: 'Montserrat',fontSize: 20),

                        ),

                        SizedBox(width: 5.0),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 100),
                          height: 25,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: toggleValue ? Color.fromRGBO(4, 154, 232, 1) : Color.fromRGBO(4, 154,232, 1)
                          ),
                          child: Stack(
                            children: <Widget>[
                              AnimatedPositioned(
                                  duration: Duration(milliseconds: 100),
                                  top: 1,
                                  left: toggleValue ? 25.0 : 0.0,
                                  right: toggleValue ? 0 : 25,
                                  child: InkWell(
                                    onTap: togglebutton,
                                    child: AnimatedSwitcher(
                                      duration: Duration(milliseconds: 100),
                                      transitionBuilder:
                                          (Widget child, Animation<double> animation){
                                        return RotationTransition(
                                            child: child , turns: animation);
                                      },
                                      child: toggleValue ? Icon(Icons.check_circle,color: Colors.green,size: 25,
                                          key:UniqueKey()
                                      ) : Icon(Icons.check_circle, color: Colors.redAccent,size: 25,
                                        key: UniqueKey(),
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),

                      ]
                  ),


                  SizedBox(height: 40.0),
                  FlatButton(
                    child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 40,
                      child: Material(

                        borderRadius: BorderRadius.circular(0.0),
                        //shadowColor: Colors.greenAccent,
                        color: Color.fromRGBO(4, 154, 232, 1),
                        elevation: 7.0,
                        child: InkWell(
                          onTap: () {
                            if(!_formKey.currentState.validate()){
                              return;
                            }
                            _formKey.currentState.save();
                            setState(() {
                              _isLoading = true;
                            });
                            //  circle();
                          //  String result = checkConnectivity1();
                            result == 'None' ?   Dialogs.showGeneralDialog(context, _keyLoader,NETWORK_CONNECTION_ERROR) :
                            SignIn(emailController.text, passwordController.text,/*_currentPosition.latitude,_currentPosition.longitude,_currentAddress*/);
                            //Navigator.push(context, MaterialPageRoute(builder: (context) {
                            //return pass();
                          },
                          child: Center(
                            child: Text(
                              LOGIN_BUTTON,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 10),
                  //if(_isLoading == true)
                  //circle(),
                  // Center(child: CircularProgressIndicator()),
                  SizedBox(height:70.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        DONT_HAVE_ACCOUNT,
                        style: TextStyle(fontFamily: 'Montserrat',fontSize: 20),
                      ),
                      SizedBox(width: 5.0),
                      InkWell(
                        onTap: ()  {
                          Navigator.push(
                              context,BouncyPageRoute(widget: SignupPage())
                            //MaterialPageRoute(builder: (context) {
                            //return SignupPage();
                            //}
                          );//);
                        },
                        child: Text(
                          REGISTER,
                          style: TextStyle(
                              color: Color.fromRGBO(99, 99, 99, 1),
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                  /*  Container (
                              child: Form(
                              child: Column(
                              children: <Widget>[
                              TextFormField(
                              decoration: InputDecoration(
                              labelText: _viewModel?.counter.toString(),
                              labelStyle: Theme.of(context).textTheme.display1,
            )
            )
            ]
            )
            )
            ),*/


                ]),
          ),


        /* floatingActionButton: new FloatingActionButton(
              onPressed: () => this.widget.presenter.onButton1Clicked(),
              tooltip: 'Increment',
              child: new Icon(Icons.add),
            ),*/
      )
    );
  }



  Future<void> SignIn( email, pass,/*Latitude,Longitude,Address,device_id*/) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String deviceID = sharedPreferences.getString('DEVICE_ID');

    Dialogs.showLoadingDialog(context, _keyLoader);

    Map<String,String> headers = {'Content-Type':'application/json','Authorization': Token};
    final msg = jsonEncode({"EMAIL_ID":email,"PASSWORD":pass,"DEVICE_ID":deviceID});
    //'latitude': Latitude,'longitude': Longitude,'Address' : Address,'device_id': device_id

    var jsonResponse = null;
    try {
      var response = await http.post(URL+'Login/',
        headers: headers,
        body:msg,
      ).timeout(const Duration(seconds: 30));


    //  print(response.statusCode);
      if(response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
       // Dialogs.showGeneralDialog(context, _keyLoader, "login Post method called 11");
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
         if(jsonResponse['RESPONSE_CODE']==200) {
        sharedPreferences.setBool("Islogin", toggleValue);
        sharedPreferences.setString('EMAIL_ID', email);
        sharedPreferences.setInt('USER_ID', jsonResponse['ID']);
        idontknow = false;
        sharedPreferences.setBool("Problem", idontknow);

        Navigator.push(
            context,BouncyPageRoute(widget: Landingscreen()));
           }
         else if(jsonResponse['RESPONSE_CODE']==201 || jsonResponse['RESPONSE_CODE'] ==202){
       Dialogs.showGeneralDialog(context, _keyLoader,jsonResponse['RESPONSE_MESSAGE']);
        }
         else{
         Dialogs.showGeneralDialog(context, _keyLoader,SERVER_ERROR);
        }
      }
      else {
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      //  Dialogs.showGeneralDialog(context, _keyLoader, "login Post method called 22");

        Dialogs.showGeneralDialog(context, _keyLoader,USER_NOT_FOUND);

       // print(response.body);
      }
    } on TimeoutException catch (_) {
 //     print('timeout');
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      Dialogs.showGeneralDialog(context, _keyLoader,CONNECTION_TIMEOUT);
    }
  }

/*    circle() async {
     if(_isLoading == true)
      return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.black,
        actions: <Widget>[

        Center(heightFactor: 2,child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CircularProgressIndicator(),
          Text('worst maxxxxxxx',style: TextStyle(color: Colors.black),)
        ])),
      ],
      ),
        );
  }                      */




  togglebutton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }

  /*void checkstatus(String resultval) async {
    SharedPreferences NetPreference = await SharedPreferences.getInstance();
    setState(() {
        result = resultval;
      });
    NetPreference.setString("NetResult", result);
    }*/

  Connectivity connectivity = Connectivity();

  void checkConnectivity1() async {
    var connectivityResult = await connectivity.checkConnectivity();
    var conn = getConnectionValue(connectivityResult);
    setState(() {
      result =  conn;
      //  print(result);
    });
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
    /* default:
        status = 'None';
        break;*/
    }
    return status;
  }
 /* _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {

      setState(() {
        _currentPosition = position;
      });
//    print(_currentPosition);
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }*/



}

import 'dart:async';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_app2/Model/Model.dart';
import 'package:flutter_app2/Views/Login_view.dart';
import 'package:flutter_app2/Views/Prescription_view.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:flutter_app2/util/Constant.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_app2/util/Util_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}



class _SignupPageState extends State<SignupPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  bool toggleValue = false;
  bool from_Signup = false;



  String _email;
  String _password;
 // Position _currentPosition;
  String _currentAddress;
  List _BranchCode = [
    '601','602','603','604','605','606','607','608','609','610','611','612','613','614','615',
    '616','617','618','619','620','621','622','623','624','625','626','627','628','629','630'
  ];
  String _BCodeValue;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  String result = '';
 // bool status_GPS = false;
  StreamSubscription<LocationData> subscription;



  @override
  void initState() {
    super.initState();
    getlocation();
  }

  void getlocation()async{
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        await Dialogs.showGeneralDialog(context, _keyLoader,ENABLE_LOCATION);
        _serviceEnabled = await location.requestService();
        if(!_serviceEnabled){
            return;
          }
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }


    _locationData = await location.getLocation();
    subscription = location. onLocationChanged.listen((LocationData currentLocation) {
      _locationData = currentLocation;
        _getAddressFromLatLng();
      //print(currentLocation);
    });
      //print(_locationData);
     // _getAddressFromLatLng();
  }


 /* var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

       checkstatus(result);
   connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _connectionStatus = result.toString();
          print(1);
          print(_connectionStatus);
          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            checkstatus(_connectionStatus);
            _getCurrentLocation();

          }
          else
          {
            checkstatus(_connectionStatus);
          }
        });*/
    //this.widget.presenter.counterView = this as CounterView;
 // }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<bool> _onBackPressed() {

    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    checkConnectivity1();
   // _check_GPS_connectivity();
   // if(status_GPS==true)
   // {
      //print(1);
      //_getCurrentLocation();
   // }

//_getCurrentLocation();
    //checkstatus(result);
    return  new Scaffold(
        appBar: AppBar(
            title: Text(APPBAR_SIGNUP, style: TextStyle(fontSize: 25),),
            centerTitle: true,
            backgroundColor: Color.fromRGBO(236, 85, 156, 1)
        ),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container (
                  padding: EdgeInsets.fromLTRB(15, 40, 15, 0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          children: <Widget>[
                            TextFormField(
                              //controller: emailController,
                              style:
                              TextStyle(fontSize: 22.0, color: Color.fromRGBO(100, 100, 100, 1)),
                              controller: emailController,
                              decoration: InputDecoration(
                                  labelText: EMAIL,
                                  labelStyle: TextStyle(
                                      fontFamily:'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Color.fromRGBO(97, 97, 97, 1)
                                  )
                              ),
                              validator: (String val) =>
                              RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null: EMAIL_ERROR,
                              onSaved: (val) => _email=val,
                              //!val.contains('@') ? EMAIL_ERROR :null,
                              //onSaved: (val) => _email=val,

                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              style:
                              TextStyle(fontSize: 22.0,color: Color.fromRGBO(100, 100, 100, 1)),
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: USERNAME,
                                  labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Color.fromRGBO(97, 97, 97, 1)
                                )
                              ),
                              validator: (val) =>
                                val.length<4 ? USERNAME_ERROR :null,

                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              //controller: passwordController,
                              style:
                              TextStyle(fontSize: 22.0, color: Color.fromRGBO(100, 100, 100, 1)),
                              controller: passwordController,
                              decoration: InputDecoration(
                                  labelText: PASSWORD,
                                  labelStyle: TextStyle(
                                      fontFamily:'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Color.fromRGBO(97, 97, 97, 1)
                                  )
                              ),
                              validator: (val)  =>
                              val.length<6 ? PASSWORD_ERROR :null,
                              onSaved: (val) => _password=val,
                              obscureText: true,
                            ),
                            SizedBox(height: 10.0),
                            TextFormField(
                              style:
                              TextStyle(fontSize: 22.0, color: Color.fromRGBO(100, 100, 100, 1)),
                              decoration: InputDecoration(
                                  labelText: CONFIRM_PASSWORD,
                                  labelStyle: TextStyle(
                                      fontFamily:'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Color.fromRGBO(97, 97, 97, 1)
                                  )
                              ),
                              validator: (val) {
                                if(val != passwordController.text)
                                  return 'it should match with Password';
                                return null;
                              },
                              obscureText: true,
                            ),
                            SizedBox(height: 20.0),
                             Padding(
                               padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                                child: DropdownButtonFormField(

                                  hint: Text('Select Branch Code *',
                                    style: TextStyle(color: Color.fromRGBO(97,97,97,1),fontWeight: FontWeight.bold,fontSize: 22,fontFamily: 'Montserrat'),
                           /*         decoration: InputDecoration(
                                      labelText: "Select Branch Code *",
                                        labelStyle: TextStyle(
                                            fontFamily:'Montserrat',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                            color: Color.fromRGBO(97, 97, 97, 1)
                                        )
                                    ),
                                    validator: (val)  =>
                                    val.length==2 ? null:BRANCHCODE_ERROR, */
                                  ),
                                  dropdownColor: Colors.blueGrey,
                                  elevation: 5,
                                  icon: Icon(Icons.arrow_drop_down),
                                  iconSize: 36.0,
                                  isExpanded: true,
                                  value: _BCodeValue,
                                  style: TextStyle(color: Colors.black, fontSize: 22.0),
                                  onChanged: (value){
                                    setState(() {
                                      _BCodeValue = value;
                                    });
                                  },
                                    validator: (val)=>
                                    val!=null ? null:BRANCHCODE_ERROR,
                                  items: _BranchCode.map((value){
                                    return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),);
                                }).toList()
                          ),
                              ),

                        ]
                      )
                  ),
                ),
                SizedBox(height: 32),

                //    _user == null ? Container() :
                //   Text("The user ${_user.email},is created successfully"),


                SizedBox(height: 40.0),
                Container(
                  height: 40.0,
                  width: 150,
                  child: Material(
                    borderRadius: BorderRadius.circular(0.0),
                    shadowColor: Colors.greenAccent,
                    color: Color.fromRGBO(4, 154, 232, 1),
                    elevation: 7.0,
                    child: InkWell(
                      onTap: () async {
                        if(!_formKey.currentState.validate()){
                          return;
                        }
                        _formKey.currentState.save();
                       // print(1);
                      //  _getCurrentLocation();



                        /*if(status_GPS==false)
                          {
                          Dialogs.showGeneralDialog(context, _keyLoader,ENABLE_LOCATION);
                          return ;
                        }*/
                       /* else{
                          _getCurrentLocation();
                        }*/
                       // String result = checkConnectivity1();
                        if(_locationData != null && _currentAddress!=null){//.latitude!=null || _currentPosition.longitude!=null) {
                          result == 'None' ? Dialogs.showGeneralDialog(
                              context, _keyLoader, NETWORK_CONNECTION_ERROR) :
                          createUser(
                              emailController.text, passwordController.text,
                              usernameController.text,
                              _BCodeValue,
                              _locationData.latitude.toStringAsPrecision(6),
                              _locationData.longitude.toStringAsPrecision(6),
                              _currentAddress);
                        }
                        else
                          {
                            Dialogs.showGeneralDialog(context, _keyLoader, LOCATION_NOT_FOUND);
                            return;
                          }
                        //final UserModel user = await createUser(email, password);//_currentPosition.latitude,
                        //_currentPosition.longitude,_currentAddress);

                        //   setState(() {
                        //     _user = user;
                        //   });


                        //Navigator.push(context, MaterialPageRoute(builder: (context) {
                        //return pass();
                      },
                      child: Center(
                        child: Text(
                          SIGNUP_BUTTON,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ),
                  ),
                ),



              ]

          ),
        )

    );

  }


  Future<void> createUser(String email, String password,String Username,String Branchcode, //) async{
            String Latitude,String Longitude,String Address) async{
  //_getCurrentLocation();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("Islogin", toggleValue);
    sharedPreferences.setBool("Signup", from_Signup);
    Dialogs.showLoadingDialog(context, _keyLoader);
    final String deviceID = sharedPreferences.getString('DEVICE_ID');
    final String apiUrl = URL+'Signup/';
   // print(deviceID);

    Map<String,String> headers = {'Content-Type':'application/json','Authorization': Token};
    final msg = jsonEncode({"EMAIL_ID":email,"PASSWORD":password,
      "USERNAME": Username,
      "BRANCHCODE": Branchcode,
      "LATITUDE": Latitude,//_currentPosition.latitude.toStringAsPrecision(4),
      "LONGITUDE" : Longitude, //_currentPosition.longitude.toStringAsPrecision(4),
      "ADDRESS" : Address,
      "DEVICE_ID":deviceID});
    try {
      final response = await http.post(apiUrl,
          headers: headers,
        body: msg,
      ).timeout(const Duration(seconds: 30));
 //     print(response.body);
 //     print(response.headers);
 //     print(response);
 //     print(response.statusCode);

      if (response.statusCode == 200) {
        //response.body ={"ID": "78", "EMAIL_ID": "test@123", "RESPONSE_CODE":"200" , "RESPONSE_MESSAGE": "Record Created Successfully"};
        final responseString = response.body;//'''{"ID": 78, "EMAIL_ID": "test@123", "RESPONSE_CODE":200 , "RESPONSE_MESSAGE": "Record Created Successfully"}'''; //response.body;
        //final
        Map parsedJson = json.decode(responseString);

        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        if (parsedJson['RESPONSE_CODE'] == 200) {
      //    print('Success');
          sharedPreferences.setString('EMAIL_ID', email);
          sharedPreferences.setInt('USER_ID', parsedJson['ID']);
         // Dialogs.showGeneralDialog(context, _keyLoader, parsedJson['REPONSE_MESSAGE']);
          Navigator.push(
              context, BouncyPageRoute(widget: Landingscreen()));
        }
        else if (parsedJson['RESPONSE_CODE'] == 201) {
      //    print('Failed');
          //show alert dialog with Email_ID already exists
          Dialogs.showGeneralDialog(context, _keyLoader,parsedJson['RESPONSE_MESSAGE']);
        }
        else
          {
            Dialogs.showGeneralDialog(
                context, _keyLoader, SERVER_ERROR);
          }
        //return  //userModelFromJson(responseString);
      }
      else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Dialogs.showGeneralDialog(
            context, _keyLoader, SERVER_ERROR);
      }
    } on TimeoutException catch (_) {
   //   print('timeout');
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      Dialogs.showGeneralDialog(context, _keyLoader,CONNECTION_TIMEOUT);
    }
  }

//  String _networkStatus1 = '';

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


/*  void checkstatus(String resultval) async {
    SharedPreferences NetPreference = await SharedPreferences.getInstance();
    print(result);
    result = NetPreference.getString('NetResult');
    print(100);
    print(result);
    //setState(() {
      //result = resultval;
    //});
  }*/

 /* _getCurrentLocation() {
    Geolocator().getCurrentPosition().timeout(Duration(seconds: 10)).then((
        Position position) {
    //getting position without problems
    //geolocator
      //  .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        //.then((Position position) {
      print(position);
      setState(() {
        // print('asdfgh');
        _currentPosition = position;
        print(_currentPosition);
      });
      _getAddressFromLatLng();

    }).catchError((error) {
      if (error is TimeoutException) {
        Geolocator().getLastKnownPosition().then((position) {
          //getting last known position
          //print(position);
        }).catchError((error) {
          //handle the exception
        });
      } else {
        //handle the exception
      }
    });
  }*/


   // print(11);
    /*geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
       // print('asdfgh');
        _currentPosition = position;
      });
  //print(_currentPosition);
      _getAddressFromLatLng();
    }).catchError((e) {
      print('abccc');
      print(e);
    });
  }*/

  _check_GPS_connectivity() async{
   //status_GPS = await Geolocator().isLocationServiceEnabled() ;
  // print(status_GPS);
  /* if (status_GPS) {
     print('nice1');
     /*geolocator
         .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
         .then((Position position) {
       setState(() {
         _currentPosition = position;
       });
       // print(_currentPosition);

       _getAddressFromLatLng();*/
     }).catchError((e) {
       print(e);
     });*/
   }// else {
     //print('perfect2');
     //Dialogs.showGeneralDialog(context, _keyLoader, ENABLE_LOCATION);
   //}

  //}

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _locationData.latitude, _locationData.longitude);

      Placemark place = p[0];
 // print(place);
      setState(() {
        _currentAddress =
        "${place.name},${place.subLocality},${place.locality},${place.thoroughfare},${place.subAdministrativeArea},${place.administrativeArea}, ${place.postalCode}, ${place.country}";
       // print(_currentAddress);
      });
    } catch (e) {
     // print(e);
    }
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app2/util/Constant.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_app2/util/Util_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app2/Views/Login_view.dart';



class resetPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}


class _SignupPageState extends State<resetPage> {
  //GlobalKey<NavigatorState> _key = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();


  String _email;
  String result = '';
  final TextEditingController emailController = TextEditingController();




  var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
 //   print(1);
    //result = Internet_Connectivity.connect() as String;
     connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _connectionStatus = result.toString();

       //   print(_connectionStatus);
          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            checkstatus(_connectionStatus);

          }
          else
          {
            checkstatus(_connectionStatus);
          }
        });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(APPBAR_FORGET_PASSWORD, style: TextStyle(fontSize: 25),),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(236, 85,156,1),
        ),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container (
                          padding: EdgeInsets.fromLTRB(15, 100, 15, 0),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                style:
                                TextStyle(fontSize: 22.0, color: Color.fromRGBO(100, 100, 100, 1)),
                                controller: emailController,
                                decoration: InputDecoration(
                                    labelText: EMAIL,
                                    labelStyle: TextStyle(
                                        fontFamily:'Montserrat',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromRGBO(97, 97, 97, 1)
                                    )
                                  //focusedBorder: UnderlineInputBorder(
                                  //borderSide: BorderSide(color: Colors.green)
                                  //)
                                ),
                                validator: (String val) =>
                               RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null: EMAIL_ERROR,
                                onSaved: (val) => _email=val,
                                //  !val.contains('@') ? EMAIL_ERROR :null,
                              //  onSaved: (val) => _email=val,
                              ),
                              SizedBox(height:55.0),
                              FlatButton(
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 150,
                                  height: 40,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(0.0),
                                    shadowColor: Colors.greenAccent,
                                    color: Color.fromRGBO(4, 154, 232, 1),
                                    elevation: 7.0,
                                    child: InkWell(
                                      onTap: () {
                                        if(!_formKey.currentState.validate()){
                                          return;
                                        }
                                        _formKey.currentState.save();
                                        //String result = checkConnectivity1();
                                        result == 'ConnectivityResult.none' ? Dialogs.showGeneralDialog(context, _keyLoader,NETWORK_CONNECTION_ERROR) :
                                        Send_password(emailController.text);
                                      },
                                      child: Center(
                                        child: Text(
                                          SUBMIT_BUTTON,
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
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                ),
              ]
          ),
        )
    );
  }

  void checkstatus(String resultval) {
    setState(() {
      result = resultval;
    });
  }



  Future<void> Send_password(email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String deviceID = sharedPreferences.getString('DEVICE_ID');

    Dialogs.showLoadingDialog(context, _keyLoader);

    Map<String,String> headers = {'Content-Type':'application/json','Authorization': Token};
    final msg = jsonEncode({"EMAIL_ID":email,"DEVICE_ID":deviceID});

    var jsonResponse = null;
    try {
      var response = await http.post(URL+'Forgot_password/',
        headers: headers,
        body:msg,
      ).timeout(const Duration(seconds: 30));

      if(response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
          Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
           if(jsonResponse['RESPONSE_CODE']==200) {
             await Dialogs.showGeneralDialog(
                 context, _keyLoader, jsonResponse['RESPONSE_MESSAGE']);
            Navigator.pop(context,true);
             // Navigator.push(
              //   context, BouncyPageRoute(widget: MyAp()));
           }
            else if(jsonResponse['RESPONSE_CODE']==201){
       Dialogs.showGeneralDialog(context, _keyLoader,jsonResponse['RESPONSE_MESSAGE']);
        }
         else{
         Dialogs.showGeneralDialog(context, _keyLoader,SERVER_ERROR);
        }
     }

      else {
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
        Dialogs.showGeneralDialog(context, _keyLoader,SERVER_ERROR);

       // print(response.body);
      }
    } on TimeoutException catch (_) {
     // print('timeout');
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      Dialogs.showGeneralDialog(context, _keyLoader,CONNECTION_TIMEOUT);
    }
  }


}

//written in appbar
/*
leading: new IconButton(
icon: new
Icon(Icons.arrow_back),
onPressed: () {
Navigator.of(context).pushNamed('/view_component');
}),*/




import 'dart:convert';
import 'dart:io'as Io;
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app2/Views/Login_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_app2/util/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_app2/util/Util_file.dart';
import 'package:intl/intl.dart';


class Landingscreen extends StatefulWidget {
  @override
  _prescription createState() => _prescription();
}

class _prescription extends State<Landingscreen> {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();


  static const _popItem= <String>[
    "Logout"
  ];

  static List<PopupMenuItem<String>> _pop = _popItem.map((String val)=>
      PopupMenuItem<String>(
        value: val,
        child: Text(val),
      )
  ).toList();
  String value;

  File imagefile;
  String result = '';
  String theimagepath;
  ImagePicker picker = ImagePicker();
  var pickerfile;

  _openGallery(BuildContext context) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    //  pickerfile= await picker.getImage(source: ImageSource.gallery);
    theimagepath = picture.path.toString();
    //_imageFile = imageFile;

  /*  print('theimagepath just below');
    print(theimagepath);
    final bytes = Io.File(theimagepath).readAsBytesSync();
    String img64 = base64Encode(bytes);
 //   print('bytes'+bytes.toString().substring(100,3000));

   // var encoded = Uri.encodeComponent(img64);
    //var encoded = Uri.encodeFull(img64);
   // print(encoded);
   // var decoded = Uri.decodeFull(encoded);
    final decodedBytes = base64Decode(img64);

    var file = Io.File("/storage/emulated/0/Android/data/com.example.flutter_app2/files/Pictures/decode.png");
    file.writeAsBytesSync(decodedBytes);
   // image_picker694842140
   // /9j/4AAQSkZJRgABAQAAAQABAAD/
    print('img64:   '+img64);
  //  print(img64.substring(0,));
   // var _imageFile = Io.File(pickerfile.path);
  //  print(_imageFile);*/
    this.setState(() {
      imagefile = picture;//file;//_imageFile  ;
    });
    Navigator.of(context).pop();
  }
  /*var picture = await MultiImagePicker.pickImages(maxImages: 5,enableCamera: true);
    this.setState(() {
      imageFile = picture as File;
    });
    Navigator.of(context).pop();
  }*/

  _openCamera(BuildContext context) async{
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    //pickerfile = await picker.getImage(source: ImageSource.camera);
    theimagepath = picture.path.toString();
    //_imageFile = imageFile;

   /* print('theimagepath just below');
    print(theimagepath);
    String img64 = base64Encode(Io.File(theimagepath).readAsBytesSync());
    //print('bytes'+bytes.toString());
    final decodedBytes = base64Decode(img64);

    var file = Io.File("/storage/emulated/0/Android/data/com.example.flutter_app2/files/Pictures/decode.png");
    file.writeAsBytesSync(decodedBytes);

    print('img64:   '+img64);
   // print(img64.substring(0,2000));
    var _imageFile = Io.File(pickerfile.path);
  print(_imageFile);*/
    this.setState(() {
      imagefile = picture;//file;//_imageFile  ;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context){
    return showDialog(context: context, builder: (BuildContext context)
    {
      return AlertDialog(
        title: Text('Choose one'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Gallery'),
                onTap: (){
                  _openGallery(context);
                  /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Multi_Images();
                  }
                  ));                */},
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text('Camera'),
                onTap: (){
                  _openCamera(context);
                },
              )
            ],

          ),
        ),
      );
    });
  }

  Widget _decideImageView(){
    /*return FutureBuilder<File>(
      future: imagefile ,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Image.file(snapshot.data,width: 500,height: 500,);

          /*return Flexible(
            child: Image.file(
              snapshot.data,
              fit: BoxFit.fill,
            ),
          );*/
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Image.asset('Images/Default_image.jpg',width: 300,height: 400);
        }
      },
    );*/
    final _height = MediaQuery.of(context).size.height-
        MediaQuery.of(context).padding.top-
        kToolbarHeight;
    final width = MediaQuery.of(context).size.width;

    if(imagefile == null){
      return Image.asset('Images/Default_image.jpg',width: width,height: _height*0.85);
    }
    else{
 //      String base64Image = base64Encode(imagefile.readAsBytesSync());
  //     print(base64Image);
    //   Uint8List image = base64Decode(base64Image);


     // return Image.memory(decoded,height: _height*0.85,width: width);
     // print(imagefile);
      return Image.file(imagefile,width:width ,height: _height*0.85,);
    }
  }
  //String fileName = imagefile.path.split("/").last;


 /* var _connectionStatus = 'Unknown';
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;

  @override
  void initState() {
    super.initState();
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
          _connectionStatus = result.toString();

          print(_connectionStatus);
          if (result == ConnectivityResult.wifi ||
              result == ConnectivityResult.mobile) {
            checkstatus(_connectionStatus);

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

  Future<bool> _onBackPressed() async {
    await solvingproblem();

    SystemNavigator.pop();
    //exit(0);
  }

  Future<void> solvingproblem() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool idontknow = sharedPreferences.getBool('Problem');
    idontknow = true;
    sharedPreferences.setBool("Problem", idontknow);
    bool from_Signup = sharedPreferences.getBool('Signup');
    from_Signup = true;
    sharedPreferences.setBool('Signup', from_Signup);
  }


  @override
  Widget build(BuildContext context) {
    checkConnectivity1();


    return WillPopScope(
      onWillPop: ()async {
        _onBackPressed();
        return true;
      },
      child: new Scaffold(
        appBar: AppBar(
          title: Text(APPBAR_PRESCRIPTION,style: TextStyle(fontSize: 18),),
          backgroundColor: Color.fromRGBO(236, 85, 156, 1),
          actions: <Widget>[
            PopupMenuButton(
                onSelected: (String val){

                  //String result = checkConnectivity1();
                  result == 'None' ? Dialogs.showGeneralDialog(context, _keyLoader,NETWORK_CONNECTION_ERROR) :
                  logout_check();
                },
                itemBuilder: (BuildContext context) => _pop
            )
          ],
          leading: new IconButton(
            icon: new
            Icon(Icons.arrow_back),
            onPressed: () {//=> SystemNavigator.pop(),//exit(0),
              _onBackPressed();
              return true;
          }),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(height: 10),
                  _decideImageView(),
                  SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Container(
                            height: 40,
                            width: 150,
                            child: Material(
                              borderRadius: BorderRadius.circular(0),
                              color: Color.fromRGBO(4, 154, 232, 1),
                              elevation: 7.0,

                              child: InkWell(
                                  onTap: () {
                                    _showChoiceDialog(context);
                                  },
                                  child: Center(
                                    child: Text(CAPTURE_BUTTON,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),),
                                  )
                              ),
                            ),
                          ),
                        ),
                        //Expanded(
                        //child: buildGridView(),
                        //),
                        SizedBox(height: 5),
                        FlatButton(
                          child: Container(
                            //alignment: Alignment.center,
                            height: 40,
                            width: 140,
                            child: Material(
                              borderRadius: BorderRadius.circular(0.0),
                              color: Color.fromRGBO(4, 154, 232, 1),
                              elevation: 7.0,
                              child: InkWell(
                                  onTap: () {
                                   // String result = checkConnectivity1();
                                    if(imagefile==null)
                                      {
                                        Dialogs.showGeneralDialog(context, _keyLoader, SELECT_IMAGE);
                                      }
                                    else {
                                      result == 'None' ? Dialogs
                                          .showGeneralDialog(
                                          context, _keyLoader,
                                          NETWORK_CONNECTION_ERROR) :
                                      Upload(imagefile);
                                    }},
                                  child: Center(
                                    child: Text(UPLOAD_BUTTON,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),),
                                  )
                              ),
                            ),
                          ),
                        ),
                      ]
                  )

                ],
              ),
            ),
          ),
        ),

      ),
    );
  }

  Future<void> logout_check() async {
    //print(idontknow);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Dialogs.showLoadingDialog(context, _keyLoader);

    final int ID = sharedPreferences.getInt('USER_ID');
    //print(ID);
    final String email = sharedPreferences.getString('EMAIL_ID');
    final String deviceID = sharedPreferences.getString('DEVICE_ID');
    bool toggleValue = sharedPreferences.getBool('Islogin');
    bool togglevalue_attime_oflogin = toggleValue;
    bool from_Signup = sharedPreferences.getBool('Signup');
    //print(from_Signup);
    bool idontknow = sharedPreferences.getBool('Problem');
    //print(idontknow);
   //print(ID);
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': Token
    };
    final msg = jsonEncode({"USER_ID": ID,"EMAIL_ID": email ,"DEVICE_ID": deviceID});

    var jsonResponse = null;
    try {
      var response = await http.post(URL +'Logout/',
        headers: headers,
        body: msg,
      ).timeout(const Duration(seconds: 30));
      //print(response.statusCode);
      if (response.statusCode == 200) {

        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();

        jsonResponse = json.decode(response.body);
        if(jsonResponse['RESPONSE_CODE']==200) {
          toggleValue = false; //!toggleValue;
          print(toggleValue);
          sharedPreferences.setBool("Islogin", toggleValue);
          //clearSession();
          if (togglevalue_attime_oflogin == false) {
           // print('22');
            if(from_Signup==false)
              {
               // print(1);
                Navigator.pop(context,true);
                from_Signup= true;
                sharedPreferences.setBool('Signup',from_Signup);
              }
            Navigator.pop(context, true);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyAp()));
          }
          else {
            print('33');
            // Navigator.push(
            //   context, BouncyPageRoute(widget: MyAp()));
            if(idontknow==false)
              {
                print(idontknow);
                Navigator.pop(context,true);
              }
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MyAp()),);
          }
       }

        else {
        Dialogs.showGeneralDialog(
               context, _keyLoader, SERVER_ERROR);
        }
      }
      else {
        Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
        Dialogs.showGeneralDialog(context, _keyLoader,SERVER_ERROR);
      }
    } on TimeoutException catch (_) {
      //print('timeout');
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      Dialogs.showGeneralDialog(context, _keyLoader,CONNECTION_TIMEOUT);
    }
  }


  Future<void> Upload(imagefile) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final int ID = sharedPreferences.getInt('USER_ID');
    //print(ID);
    final String deviceID = sharedPreferences.getString('DEVICE_ID');
    String filename = imagefile.path.split('/').last;
    //print(filename);

    final bytes = Io.File(theimagepath).readAsBytesSync();
    String img64 = base64Encode(bytes);
    //print('bytes'+bytes.toString().substring(0,3000));

   // var base64_uriencoded = Uri.encodeFull(img64);
    //print(img64);

    final DateTime now = DateTime.now();
    //print(now);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    String time = "${now.hour}:${now.minute}:${now.second}";
    //print(formatted);
    //print(time);
//    I/flutter (25138): 6049c0f9-8615-4394-a61f-981215517fc11935719123.jpg
    Dialogs.showLoadingDialog(context, _keyLoader);

    Map<String,String> headers = {'Content-Type':'application/json','Authorization':Token};
    final msg = jsonEncode({"USER_ID":ID,"DEVICE_ID":deviceID,"Image_Name":filename,
      "Image_URL":img64,"IMAGE_UPLOAD_DATE":formatted,"IMAGE_UPLOAD_TIME":time});

    var jsonResponse = null;
    try {
      var response = await http.post(URL+'Upload_prescription/',
        headers: headers,
        body:msg,
      ).timeout(const Duration(seconds: 40));
//print(msg);
  //print(response.body);
  //print(response.statusCode);
      if(response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
        //print(jsonResponse['RESPONSE_CODE']);
         if(jsonResponse['RESPONSE_CODE']==200)
         {
           await Dialogs.showGeneralDialog(
               context, _keyLoader, jsonResponse['RESPONSE_MESSAGE']);
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Landingscreen()));

           // Navigator.push(
            //   context,BouncyPageRoute(widget: Landingscreen()));
         }
         else if(jsonResponse['RESPONSE_CODE']==201)
         {
             Dialogs.showGeneralDialog(
                 context, _keyLoader, jsonResponse['RESPONSE_MESSAGE']);
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
      //print('timeout');
      Navigator.of(_keyLoader.currentContext,rootNavigator: true).pop();
      Dialogs.showGeneralDialog(context, _keyLoader,CONNECTION_TIMEOUT);
    }
  }

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
/*

  void checkstatus(String resultval) {
    setState(() {
      result = resultval;
    });
  }*/
}


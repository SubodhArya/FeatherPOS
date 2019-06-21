import 'dart:core';
import 'package:poslogin/registration.dart';

import 'menu.dart';
import 'package:flutter/material.dart';
import 'customerDetails.dart';
import 'employeeDetails.dart';
import 'productDetails.dart';
import 'ticketing.dart';
import 'ticketing_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'registration.dart';
void main() async{
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'POS Light',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    routes: <String, WidgetBuilder>{
      PosHome.routeName: (context) => PosHome(),
      // Page1.routeName: (context) => Page1()
    },
    initialRoute: PosHome.routeName,
    onGenerateRoute: (RouteSettings settings) {
      var page;
      String routeName = settings.name;
      switch (routeName) {
        case Menu.routeName:
          page = Menu(
            username: settings.arguments,
          );
          return MaterialPageRoute(builder: (context) => page);
          break;
        case Registration.routeName:
          page = Registration(
            //data: settings.arguments,
          );
          return MaterialPageRoute(builder: (context) => page);
          break;

        case CustomerDetails.routeName:
          page = CustomerDetails(
            title : settings.arguments,
          );
          return MaterialPageRoute(builder: (context) => page);
          break;
        case ProductDetails.routeName:
          page = ProductDetails(
            title : settings.arguments,
          );
          return MaterialPageRoute(builder: (context) => page);
          break;
        case EmployeeDetails.routeName:
          page = EmployeeDetails(
            title : settings.arguments,
          );
          return MaterialPageRoute(builder: (context) => page);
          break;
        case Ticketing.routeName:
          page = Ticketing(
            title : settings.arguments,
          );
          return MaterialPageRoute(builder: (context) => page);
          break;
        case TicketingDetail.routeName:
          page = TicketingDetail(
            title : settings.arguments,
          );
          return MaterialPageRoute(builder: (context) => page);
          break;
      }
    },
  ));
}

class PosHome extends StatefulWidget {
  static const String routeName = "/";//come here
  @override
  _PosHomeState createState() => _PosHomeState();
}

class _PosHomeState extends State<PosHome> {
  bool _progressBarActive = false;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  String _username;
  String _merchantID;
  String _employeeID;
  String _password;
  /*Map<String, String> body = {
    'username': tgh_email,
    'password': _password,
  };*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  printSomeValues(){

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

  void _submit(){
     final form = formKey.currentState;
     if(form.validate()){
       setState(() {
         _progressBarActive=true;
       });
       form.save();
       performLogin();
     }
  }
  performLogin() async{
    //requestLoginAPI(context, _email, _password);
    Map<String,dynamic> ret= await loginAPI(context,_username,_password);
    print(ret);
    if(ret['designation']!=null) {
      setState(() {
        _progressBarActive=false;
      });
     // Navigator.pushNamed(context, Menu.routeName,
       //   arguments: _email);
      _merchantID=ret['merchantId'].toString();
      _employeeID=ret['employeeId'].toString();
      Navigator.push(context, new MaterialPageRoute(
          builder: (context){
            return Menu(username:_username,merchantId: _merchantID,designation:ret['designation'],organization: ret['organization'],name: ret['name'],employeeId: _employeeID,);
          }
      ));
      formKey.currentState.reset();
    }
    else{
      setState(() {
        _progressBarActive=false;
      });
      showDialogSingleButton(context, "Unable to Login", "You may have supplied an invalid 'Username' / 'Password' combination. Please try again or contact your support representative.", "OK");

    }
    /* final snackbar = new SnackBar(
      content: new Text('Email: $_email, Password: $_password'),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);*/
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        leading: IconButton(
          icon: new Icon(Icons.home),
          onPressed: (){
            print('nothing');
          },
        ),
        title: new Text('POS Login'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple ,
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            children: <Widget>[
              new Image.asset('images/ncr.png'),
             /* new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Merchant ID',
                  hintText: 'Enter merchant ID',
                ),
                //validator: (val)=> !val.contains('@')?'Invalid email':null,
                onSaved: (val)=>_merchantID=val,
                initialValue: null,
              ),*/
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter valid user name',
                ),
                //validator: (val)=> !val.contains('@')?'Invalid email':null,
                onSaved: (val)=>_username=val,
                initialValue: null,
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),
                validator: (val)=>val.length<6?'Password too short':null,
                onSaved: (val)=>_password=val,
                obscureText: true,
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0,20.0,0.0,0.0),
              ),
              _progressBarActive==true?new LinearProgressIndicator(): RaisedButton(
                color: Colors.green,
                child: new Text('Login'),
                onPressed: _submit,
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              ),
              new Text("New Business?  Register Now",textAlign: TextAlign.center,style: new TextStyle(
                fontSize: 15.0,)
              ),
              RaisedButton(
                color: Colors.red,
                child: new Text('Register'),
                onPressed: (){
                  Navigator.pushNamed(context, Registration.routeName);
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
              ),
            ],
          ),
        ) ,
      )
    );
  }

}

/* Map<String, String> body = {
  'username': 'username',
  'password': 'password',
};*/
Future<Map<String,dynamic>> loginAPI(BuildContext context,String username,String password) async {
  //String apiurl='https://jsonplaceholder.typicode.com/posts';
  String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Employee/ValidateLogin';
  http.Response response= await http.post(
      apiurl,
      body:jsonEncode( {
        "Username" : username,
        "Password" : password,
      }),
      headers: {
        'Content-type' : 'application/json',
        'Accept': 'application/json',
      }
  );
  if (response.statusCode == 200) {
    return json.decode(response.body);
  }
  else{
    showDialogSingleButton(context, "Unable to Login", "You may have supplied an invalid 'Username' / 'Password' combination. Please try again or contact your support representative.", "OK");
  }

}
void showDialogSingleButton(BuildContext context, String title, String message, String buttonLabel) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(buttonLabel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

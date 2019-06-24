import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/ticket.dart';
import 'utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Registration extends StatefulWidget {
  static const String routeName = "/registration";

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  String _name;
  String _email;
  String _username;
  String _password;
  String _confirmpassword;
  String _organisation;
  String _address;
  String _phone;
  bool _progressBarActive=false;
  var registrationFormKey = new GlobalKey<FormState>();
  var registrationScaffoldKey = new GlobalKey<ScaffoldState>();

  void _submit(){
    final form = registrationFormKey.currentState;
    if(form.validate()){
      setState(() {
        _progressBarActive=true;
      });
      form.save();
      performRegistration();
    }
  }

  performRegistration() async{
    //requestLoginAPI(context, _email, _password);
    print(_email);

      Map<String,dynamic> ret= await registerAPI(context,_name,_organisation,_email,_address,_phone,_username,_password);
      print(ret);
      if (ret != null) {
        setState(() {
          _progressBarActive = false;
        });
        showDialogSingleButton(context, "Congrats!",
            "You are now succesfully registered with merchantID ${ret['id']}.",
            "OK");

        // Navigator.pushNamed(context, Menu.routeName,
        //   arguments: _email);
        registrationFormKey.currentState.reset();
      }
      else {
        setState(() {
          _progressBarActive = false;
        });
        showDialogSingleButton(context, "Unable to Login",
            "You may have supplied an invalid or used combination. Please try again or contact your support representative.",
            "OK");
      }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register here'),
      ),
      body: new Padding(
        padding: EdgeInsets.all(20.0),
        child: new Form(
          key: registrationFormKey,
          child: new ListView(
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Name",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length==0) {
                    return "Name should be valid";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                onSaved: (val)=>_name=val,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Email",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length==0 || !val.contains('@') || !val.contains('.')) {
                    return "Email should be valid";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                onSaved: (val)=>_email=val,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Organisation Name",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length==0) {
                    return "Organisation cannot be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_organisation=val,
              ),

              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),

              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Address",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length<6) {
                    return " Address should be genuine";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_address=val,
              ),

              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),

              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Phone Number",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length<10) {
                    return "Phone number Not Valid";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.phone,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_phone=val,
              ),

              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),

              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Enter Username you want to register with ",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length==0) {
                    return "Username cant be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_username=val,
              ),

              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),

              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Password",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length<6) {
                    return "Weak password";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_password=val,
                obscureText: true,
              ),

             /* new Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),*/

              /*new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Confirm Password",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length<6) {
                    return "Weak Password";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_confirmpassword=val,
                obscureText: true,
              ), */

              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),

              _progressBarActive==true?new LinearProgressIndicator():RaisedButton(
                color: Colors.white30,
                child: new Text('Sign up now'),
                onPressed: (){
                 _submit();
                },
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                splashColor: Colors.purple,
              ),

            ],
          ),
        ),
      ), //
    );
  }
}
Future<Map<String,dynamic>> registerAPI(BuildContext context,String name,String organization,String email,String address, String phone,String username,String password) async {
  //String apiurl='https://jsonplaceholder.typicode.com/posts';
  String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Merchant/Merchant';
  http.Response response= await http.post(
      apiurl,
      body:jsonEncode( {

          "Name":name,
          "Organization": organization,
          "Address": address,
          "Phone": phone,
          "Email": email,
          "Username": username,
          "Password": password,

      }),
      headers: {
        'Content-type' : 'application/json',
        'Accept': 'application/json',
      }
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    return json.decode(response.body);

    //showDialogSingleButton(context, "Succesfully Registered", "Your merchant is is ${res['merchantId']} ", "OK");

  }
  else{
    showDialogSingleButton(context, "Unable to Register", "Please try again or contact your support representative.", "OK");
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


//empaddition
/*
{
	"Name": "Reddy1",
	"Dateofjoining": "",
	"Phone": "7899877656",
	"Email": "reddy@reddy1.com",
	"Designationid": 2,
	"Username": "reddy1",
	"Password": "reddy",
	"Salary": 12000
}
 */
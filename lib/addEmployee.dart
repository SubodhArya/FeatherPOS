import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poslogin/ticketing_detail.dart';
import 'models/ticket.dart';
import 'utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/ticket.dart';
import 'utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class AddEmployee extends StatefulWidget {
  final String title;
  final String merchantId;
  AddEmployee({this.title,this.merchantId});
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  String _name;
  String _email;
  String _dateofjoining;
  String _designationId;
  int _salary;
  String _username;
  String _password;
  String _phone;
  bool _progressBarActive=false;
  var employeeFormKey = new GlobalKey<FormState>();
  var employeeScaffoldKey = new GlobalKey<ScaffoldState>();
  void _submit(){
    final form = employeeFormKey.currentState;
    if(form.validate()){
      setState(() {
        _progressBarActive=true;
      });
      form.save();
      performEmployeeAddition();
    }
  }
  performEmployeeAddition() async{
    //requestLoginAPI(context, _email, _password);
    print(_email);

    Map<String,dynamic> ret= await addEmployeeAPI(context,_name,_dateofjoining,_phone,_email,_username,_password,_salary,widget.merchantId);
    print(ret);
    if (ret['employeeId'] != null && ret['employeeId'] != 0) {
      setState(() {
        _progressBarActive = false;
      });
      showDialogSingleButton(context, "Congrats!",
          " Employee succesfully registered with employeeId ${ret['employeeId']}  and merchantID ${ret['merchantId']}.",
          "OK");

      // Navigator.pushNamed(context, Menu.routeName,
      //   arguments: _email);
      employeeFormKey.currentState.reset();
    }
    else {
      setState(() {
        _progressBarActive = false;
      });
      showDialogSingleButton(context, "Unable to Add",
          "You may have supplied an invalid or used combination. Please try again or contact your support representative.",
          "OK");
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Employee here'),
      ),
      body: new Padding(
        padding: EdgeInsets.all(20.0),
        child: new Form(
          key: employeeFormKey,
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
                  labelText: "Date of Joining",
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
                    return "Date cannot be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_dateofjoining=val,
              ),

              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),

              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Salary",
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
                    return " Salary should be genuine";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_salary=int.parse(val),
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
                  labelText: " Employee Username ",
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



              new Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),

              _progressBarActive==true?new LinearProgressIndicator():RaisedButton(
                color: Colors.white30,
                child: new Text('Add now'),
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

Future<Map<String,dynamic>> addEmployeeAPI(BuildContext context,String name,String dateofJoin, String phone, String email,String username,String password ,int salary,String merchantID) async {
  //String apiurl='https://jsonplaceholder.typicode.com/posts';
  String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Employee/AddEmployee/${merchantID}';
  http.Response response= await http.post(
      apiurl,
      body:jsonEncode( {

        "Name": name,
        "Dateofjoining": "",
        "Phone": phone,
        "Email": email,
        "Designationid": 2,
        "Username": username,
        "Password": password,
        "Salary": salary

      }),
      headers: {
        'Content-type' : 'application/json',
        'Accept': 'application/json',
      }
  );
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

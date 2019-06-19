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

class AddCategory extends StatefulWidget {
  final String title;
  final String merchantId;
  AddCategory({this.title,this.merchantId});
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  String _name;
  String _description;
  bool _progressBarActive=false;
  var categoryFormKey = new GlobalKey<FormState>();
  var categoryScaffoldKey = new GlobalKey<ScaffoldState>();
  void _submit(){
    final form = categoryFormKey.currentState;
    if(form.validate()){
      setState(() {
        _progressBarActive=true;
      });
      form.save();
      performCategoryAddition();
    }
  }
  performCategoryAddition() async{
    //requestLoginAPI(context, _email, _password);


    Map<String,dynamic> ret= await addCategoryAPI(context,_name,_description,widget.merchantId);
    print(ret);
    if ( ret['categoryId'] != 0 && ret['categoryId'] != null) {
      setState(() {
        _progressBarActive = false;
      });
      showDialogSingleButton(context, "Congrats!",
          " Category succesfully added with categoryId ${ret['categoryId']}  for merchantID ${ret['merchantId']}.",
          "OK");

      // Navigator.pushNamed(context, Menu.routeName,
      //   arguments: _email);
      categoryFormKey.currentState.reset();
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
    return  Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: new Padding(
        padding: EdgeInsets.all(20.0),
        child: new Form(
          key: categoryFormKey,
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
                  labelText: "Description",
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
                    return "Description cannot be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_description=val,
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



Future<Map<String,dynamic>> addCategoryAPI(BuildContext context,String name,String description,String merchantID) async {
  //String apiurl='https://jsonplaceholder.typicode.com/posts';
  //String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Employee/AddEmployee/${merchantID}';
  String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Category/AddCategory/${merchantID}';
  http.Response response= await http.post(
      apiurl,
      body:jsonEncode( {

        "Name": name,
        "Description" : description
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

/*
{ response body
    "categoryId": 2,
    "name": "shampoos",
    "description": "contains all types of shampoos",
    "merchantId": 1
}
 */
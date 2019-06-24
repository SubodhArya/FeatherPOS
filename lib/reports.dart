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
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';




class ReportDate extends StatefulWidget {
  String merchantId;
  ReportDate({this.merchantId});
  @override
  _ReportDateState createState() => _ReportDateState();
}

class _ReportDateState extends State<ReportDate> {

  DateTime _initialdate = DateTime.now();
  DateTime _finaldate = DateTime.now();

  String _categorySelected='Products Report';
  Future<Null> _selectInitialDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _initialdate,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2020));
    if(picked != null && picked !=_initialdate){
      print("dateSelected: ${_initialdate.toString()}");
      setState(() {
        _initialdate=picked;
      });
    }
    
  }
  Future<Null> _selectFinalDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _finaldate,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2020));
    if(picked != null && picked !=_finaldate){
      print("dateSelected: ${_finaldate.toString()}");
      setState(() {
        _finaldate=picked;
      });
    }

  }




  @override
  Widget build(BuildContext context) {
    List<String> categoryNames=['Products Report','Employee Comission'];
    print(categoryNames.length);
    return Scaffold(
      appBar: new AppBar(
        title: Text('Reporting'),
      ),
      body: new Container(
        padding: new EdgeInsets.all(15.0),
        child: new Column(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(20.0),
              child:Row(
                  children: <Widget>[
                  Text("Select Initial date :    ",style: new TextStyle(fontSize: 15.0),),

              new RaisedButton(
                child: new Text('Selected ${getDate(_initialdate.day, _initialdate.month,_initialdate.year)}'),
                onPressed: (){
                  _selectInitialDate(context);
                },

              ),
            ],
            ),
      ),
            new Padding(
              padding: EdgeInsets.all(20.0),
              child:Row(
                children: <Widget>[
                  Text("Select Final date :    ",style: new TextStyle(fontSize: 15.0),),

                  new RaisedButton(
                    child: new Text('Selected ${getDate(_finaldate.day, _finaldate.month,_finaldate.year)}'),
                    onPressed: (){
                      _selectFinalDate(context);
                    },

                  ),
                ],
              ),
            ),
            new Padding(
              padding: EdgeInsets.all(15.0),
              child: new Container(
                child: ListTile(
                  title: DropdownButton(
                    items: categoryNames.map((String dropDownStringItem){
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text('$dropDownStringItem'),
                      );
                    }).toList() ,
                    value: _categorySelected,
                    onChanged: (valueSelectedHere){
                      setState(() {
                        debugPrint('User Selected $valueSelectedHere');
                        //updateQuantityAsInt(valueSelected);
                        _categorySelected=valueSelectedHere;
                      });
                    },
                  ),
                ),
              )
            ),
            new Expanded(
              child: updateCategoryWidget(_categorySelected,widget.merchantId,getDate(_initialdate.day, _initialdate.month,_initialdate.year),getDate(_finaldate.day, _finaldate.month,_finaldate.year),
            ),
            )

    ]
    ),
    ),
    );

}
}

String getDate(int day,int month,int year){
  String ret="$year-";
  if(month<10){
    ret = ret+'0$month-';
  }
  else{
    ret = ret+'0$month-';
  }
  if(day<10){
    ret =ret + '0$day';
  }
  else{
    ret = ret +"$day";
  }
  return ret;
}


Widget updateCategoryWidget(String category,String merchantID,String startdate,String enddate){
  print(startdate);
  print(enddate);
  print(merchantID);
  if(category=='Products Report') {
    print("prosuct rep categ");
    return new FutureBuilder(
      future: getProductReportDetails(merchantID,startdate,enddate),

      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        print("here snap ");
        print("its ${snapshot.data} ");
        //where we get all json data, set up widgets
        if (snapshot.hasData) {
          // print('hello');
          List<dynamic> content = snapshot.data;
          return new Container(
            child: new ListView.builder(
              itemCount: content.length,
              itemBuilder: (BuildContext context, int position) {
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: new ListTile(
                    leading: new CircleAvatar(
                      backgroundColor: Colors.white,
                      child: new Text(' id: ${content[position]['productId']}',
                        style: new TextStyle(
                          fontSize: 13.0,
                        ),),
                    ),
                    title: new Text(
                        "${content[position]['productName']}"),
                    subtitle: new Text(
                        "PROFIT: ${content[position]['profit']}"),

                  ),

                );
              },
            ),
          );
        }
        else {
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }
      },
    );
  }
  else{
    return new FutureBuilder(
      future: employeeReportDetails(merchantID,startdate,enddate),

      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        print("here snap ");
        print("its ${snapshot.data} ");
        //where we get all json data, set up widgets
        if (snapshot.hasData) {
          // print('hello');
          List<dynamic> content = snapshot.data;
          return new Container(
            child: new ListView.builder(
              itemCount: content.length,
              itemBuilder: (BuildContext context, int position) {
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: new ListTile(
                    title: new Text(
                        "${content[position]['employeeName']}"),
                    subtitle: new Text(
                        " ProductName : ${content[position]['productName']} Total Comission:  ${content[position]['totalComission']}  Quantity sold: ${content[position]['quantity']}"),
                    trailing: new CircleAvatar(
                      backgroundColor: Colors.lightGreenAccent,
                      child: new Text(
                          '${content[position]['quantityRemaining']}'),
                    ),

                  ),

                );
              },
            ),
          );
        }
        else {
          return new Center(
            child: new CircularProgressIndicator(),
          );
        }
      },
    );

  }


}

Future<List<dynamic>> getProductReportDetails(String merchantID,String startdate,String enddate) async {
  //String apiurl='https://jsonplaceholder.typicode.com/posts';
  print("called prod rep");
  String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Reporting/Reporting/$merchantID';
  http.Response response= await http.post(apiurl,  headers: {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  },body: jsonEncode({
    "startDate": startdate,
    "endDate": enddate,
  }));
  print(response.statusCode);
  if (response.statusCode == 200) {
     print("success response ok");
    // List<Employee> emplist = [];
    var jsonData = json.decode(response.body);
    print(jsonData);
    return json.decode(response.body);
  }
  print(response.statusCode);
  print("here 2 ");
  print(json.decode(response.body));
  return json.decode(response.body);
}




Future<List<dynamic>> employeeReportDetails(String merchantID,String startdate,String enddate) async {
  //String apiurl='https://jsonplaceholder.typicode.com/posts';
  String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Reporting/EmployeeReporting/$merchantID';
  http.Response response= await http.post(apiurl,  headers: {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  },body: jsonEncode({
    "startDate": startdate,
    "endDate": enddate,
  }));
  if (response.statusCode == 200) {

    // List<Employee> emplist = [];
    var jsonData = json.decode(response.body);
    print(jsonData);
    return json.decode(response.body);
  }
  print("here 2 ");
  print(json.decode(response.body));
  return json.decode(response.body);
}
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

class Billing extends StatefulWidget {
  final String merchantId;
  final String employeeId;
  final List<Ticket> ticketList;
  Billing({this.merchantId,this.employeeId,this.ticketList});
  @override
  _BillingState createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  String _customerEmail;
  bool _progressBarActive=false;
  var customerFormKey = new GlobalKey<FormState>();
  var customerScaffoldKey = new GlobalKey<ScaffoldState>();
  DatabaseHelper databaseHelper = new DatabaseHelper();
  void truncate() async{
    print(("calling trunc"));
    int result = await databaseHelper.truncateTicketList();
  }


  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,true);
      },
      child: Scaffold(
          appBar: new AppBar(
            title: new Text("BILLING SCREEN"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context,true);
              },
            ),
          ),
          body: new Column(
            children: <Widget>[
              sendTicketWidget(widget.ticketList,widget.merchantId,widget.employeeId),
            ],
          )
      ),
    );
  }
  Widget sendTicketWidget(List<Ticket> ticklist,String merchantId,String employeeId){
    return FutureBuilder(
      future: sendTicket(ticklist,merchantId,employeeId),
      builder: (BuildContext context, AsyncSnapshot<Map<String,dynamic>> snapshot){
        print('snap: ${snapshot.data}');
        if(snapshot.hasData){
          Map<String,dynamic> content = snapshot.data;
          truncate();
          return new Container(
            padding: EdgeInsets.all(15.0),
            child: new ListTile(
              dense: true,
              title: Text("Ticket Generated with TicketID: ${content["ticketId"]}" , style: new TextStyle(
                  fontSize: 15.0,fontStyle: FontStyle.italic
              ),),
              leading: Icon(Icons.receipt),
              subtitle: Text("Pay ₹ ${content["totalCost"]} at counter"),
            ),
          );
        }
        else{
          return new Center(
            child: CircularProgressIndicator(),
          );
        }
      },

    );
  }

}



Future<Map<String,dynamic>> sendTicket(List<Ticket> ticklist,String merchantId,String employeeId) async{
  double totalCost=0;
  for(int i=0;i<ticklist.length;i++){
    totalCost=totalCost+ticklist[i].subtotal;
  }
  List<dynamic> ticketContract = new List<dynamic>();
  for(int i=0;i<ticklist.length;i++){
    ticketContract.add(ticklist[i].toTicketMap());
  }
  print(ticketContract);
  Map<String,dynamic> body ={
    "TotalCost": totalCost,
    "ticketContract": jsonEncode((ticketContract)),
   };
  String passBody = "{   \"TotalCost\": $totalCost , \"ticketContract\": ${jsonEncode(ticketContract)} } " ;
  print("tc jencided ${jsonEncode((ticketContract))}");
  print("pass $passBody");
  print("body $body");
  String apiurl ="https://webapplication220190616025624.azurewebsites.net/Ticket/Ticket/$merchantId/$employeeId";
  http.Response response = await http.post(apiurl,  headers: {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  },body: passBody);
  if (response.statusCode == 200) {
    print("success response");
    // List<Employee> emplist = [];
    var jsonData = json.decode(response.body);
    print(jsonData);
    return json.decode(response.body);
  }
  print("here 2 ");
  print(json.decode(response.body));
  return json.decode(response.body);
}


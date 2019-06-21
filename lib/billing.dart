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



class Billing extends StatefulWidget {
  final String merchantId;
  final String employeeId;
  final String organization;
  final List<Ticket> ticketList;
  String username = 'subbusummu@gmail.com';
  String password = 'password';
  Billing({this.merchantId,this.employeeId,this.ticketList,this.organization});
  @override
  _BillingState createState() => _BillingState();
}

class _BillingState extends State<Billing> {
  String _customerEmail;
  bool _progressBarActive=false;
  bool loading = true;
  var customerFormKey = new GlobalKey<FormState>();
  var customerScaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String,dynamic> content = new Map<String,dynamic>();
  DatabaseHelper databaseHelper = new DatabaseHelper();
  @override
  void initState() {
    // TODO: implement initState
    sendTicket(widget.ticketList,widget.merchantId, widget.employeeId);
    
    super.initState();
  }
  void truncate() async{
    print(("calling trunc"));
    int result = await databaseHelper.truncateTicketList();
  }

  void sendEmail() async{
    String username = 'subbusummu@gmail.com';
    String password = 'Imvk@rya18!';

    final smtpServer = gmail(username, password);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = new SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    print("called");
    print(printTicket(widget.ticketList,widget.organization));

    final message = new Message()
      ..from = new Address(username, 'Subodh')
      ..recipients.add('$_customerEmail')
      ..subject = ' Purchase Receipt at ${widget.organization}:: ${new DateTime.now()}'
      ..text = ' ${printTicket(widget.ticketList,widget.organization)}'
      ..html = " ${printTicket(widget.ticketList,widget.organization)}";

    // Use [catchExceptions]: true to prevent [send] from throwing.
    // Note that the default for [catchExceptions] will change from true to false
    // in the future!
    final sendReports = await send(message, smtpServer, catchExceptions: false);
    if(sendReports.length!=0){
      setState(() {
        _progressBarActive = false;
      });
      showDialogSingleButton(context, "Success", "The Billing receipt is now mailed to customer ", "OK");
    }

  }

  void _submit(){
    final form = customerFormKey.currentState;
    if(form.validate()){
      setState(() {
        _progressBarActive=true;
      });
      form.save();
      sendEmail();
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context,true);
      },
      child: Scaffold(
          appBar: new AppBar(
            title: new Text(" ${widget.organization} BILLING SCREEN"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context,true);
              },
            ),
          ),
          body: new Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
              ),
              //sendTicketWidget(widget.ticketList,widget.merchantId,widget.employeeId),
              loading? CircularProgressIndicator(): new Container(
                    padding: EdgeInsets.all(15.0),
                    child: new ListTile(
                      dense: true,
                      title: Text("Ticket Generated with TicketID: ${content["ticketId"]}" , style: new TextStyle(
                          fontSize: 15.0,fontStyle: FontStyle.italic
                      ),),
                      leading: Icon(Icons.receipt),
                      subtitle: Text("Pay ₹ ${content["totalCost"]} at counter"),
                    ),
                  ),

              Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),
              Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),
              Text("Send Receipt to Customer",style: new TextStyle(
                fontSize: 16.0,
              ),),
              Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),
              Padding(
                padding: new EdgeInsets.all(15.0),
                child: Form(
                  key: customerFormKey,
                  child: Column(
                    children: <Widget>[
                      new TextFormField(
                        decoration: new InputDecoration(
                          labelText: " Customer Email",
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
                        onSaved: (val)=>_customerEmail=val,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),

                      new Padding(
                        padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
                      ),
                      _progressBarActive==true?new LinearProgressIndicator():RaisedButton(
                        color: Colors.purpleAccent,
                        child: new Text('Send'),
                        onPressed: (){
                          _submit();
                        },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                        splashColor: Colors.purple,
                      ),

                    ],
                  ),
                ),
              ),
              


            ],
          )
      ),
    );
  }
 /* Widget sendTicketWidget(List<Ticket> ticklist,String merchantId,String employeeId){
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
  }*/
  void sendTicket(List<Ticket> ticklist,String merchantId,String employeeId) async{
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
    print("tc jencoded ${jsonEncode((ticketContract))}");
    print("pass $passBody");
    print("body $body");
    String apiurl ="https://webapplication220190616025624.azurewebsites.net/Ticket/Ticket/$merchantId/$employeeId";
    http.Response response = await http.post(apiurl,  headers: {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    },body: passBody);
    if (response.statusCode == 200) {
      print("success response");
      setState(() {
        loading=false;
      });
      truncate();

      var jsonData = json.decode(response.body);
      print(jsonData);
      content= json.decode(response.body);
    }
    print("here 2 ");
    print(json.decode(response.body));
    //return json.decode(response.body);
  }

}
String printTicket(List<Ticket> ticklist , String org){
  String ret="<h1> <B> $org  </B></h1>  \n <h1> <B> RECEIPT OF PURCHASE </B></h1>";
  double totalCost=0;
  for(int i=0;i<ticklist.length;i++){
    totalCost=totalCost+ticklist[i].subtotal;
    ret = ret + "<br><B><I> ${ticklist[i].productname} </I> </B> :  ${ticklist[i].quantity} , <B><I>Unit Cost</B></I>: ${ticklist[i].rate} ,<B><I>Sub Total</B></I> ₹ ${ticklist[i].subtotal}<br>";
  }
   ret= ret +"<br> <h4> Total Cost: $totalCost </h4> ";
  return ret;
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
final AsyncMemoizer _memoizer = AsyncMemoizer();
 */
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
    print(printTicket(widget.ticketList,widget.organization,widget.employeeId,content['ticketId']));

    final message = new Message()
      ..from = new Address(username, 'Subodh')
      ..recipients.add('$_customerEmail')
      ..subject = ' Purchase Receipt at ${widget.organization}:: ${new DateTime.now()}'
      ..text = ' ${printTicket(widget.ticketList,widget.organization,widget.employeeId,content['ticketId'])}'
      ..html = " ${printTicket(widget.ticketList,widget.organization,widget.employeeId,content['ticketId'])}";

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

    print(response.statusCode);
    print(json.decode(response.body));
    //return json.decode(response.body);
  }

}

String printTicket(List<Ticket> ticklist , String org , String empId,int ticketId) {
  String ret = '<html><head><link href=\"//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css\" rel=\"stylesheet\" id=\"bootstrap-css\">\n '
      "<script src=\"//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js\"></script>\n"
      "<script src=\"//code.jquery.com/jquery-1.11.1.min.js\"></script>\n"
      '  </head><body>';
  ret = ret + "<div class=\"container\">\n"
      "    <div class=\"row\">\n"
      "        <div class=\"well col-xs-10 col-sm-10 col-md-6 col-xs-offset-1 col-sm-offset-1 col-md-offset-3\">\n"
      "            <div class=\"row\">\n"
      "                <div class=\"col-xs-6 col-sm-6 col-md-6\">\n"
      "                    <address>\n"
      "                        <strong>$org</strong>\n"
      "                        <br>\n"
      "                        Employee id : $empId\n"
      "                        <br>\n"
      "                    </address>\n"
      "                </div>\n"
      "                <div class=\"col-xs-6 col-sm-6 col-md-6 text-right\">\n"
      "                    <p>\n"
      "                        <em>Date: ${new DateTime.now()}</em>\n"
      "                    </p>\n"
      "                    <p>\n"
      "                        <em>Receipt #: $ticketId </em>\n"
      "                    </p>\n"
      "                </div>\n"
      "            </div>\n"
      "            <div class=\"row\">\n"
      "                <div class=\"text-center\">\n"
      "                    <h1>Receipt</h1>\n"
      "                </div>\n"
      "                </span>\n"
      "                <table class=\"table table-hover\">\n"
      "                    <thead>\n"
      "                        <tr>\n"
      "                            <th>Product</th>\n "
      "                            <th>#</th>\n"
      "                            <th class=\"text-center\">Price</th>\n"
      "                            <th class=\"text-center\">Total</th>\n"
      "                        </tr>\n"
      "                    </thead>"
      " <tbody>";


  /*String ret = "<head><style>#invoice-POS{\n"
     "  box-shadow: 0 0 1in -0.25in rgba(0, 0, 0, 0.5);\n"
     "  padding:2mm;\n"
     "  margin: 0 auto;\n"
     "  width: 44mm;\n"
     "  background: #FFF;\n"
     "  \n"
     "  \n"
     "::selection {background: #f31544; color: #FFF;}\n"
     "::moz-selection {background: #f31544; color: #FFF;}\n"
     "h1{\n"
     "  font-size: 1.5em;\n"
     "  color: #222;\n"
     "}\n"
     "h2{font-size: .9em;}\n"
     "h3{\n"
     "  font-size: 1.2em;\n"
     "  font-weight: 300;\n"
     "  line-height: 2em;\n"
     "}\n"
     "p{\n"
     "  font-size: .7em;\n"
     "  color: #666;\n"
     "  line-height: 1.2em;\n"
     "}\n"
     " \n"
     "#top, #mid,#bot{ /* Targets all id with 'col-' */\n"
     "  border-bottom: 1px solid #EEE;\n"
     "}\n"
     "\n"
     "#top{min-height: 100px;}\n"
     "#mid{min-height: 80px;} \n"
     "#bot{ min-height: 50px;}\n"
     "\n"
     "#top .logo{\n"
     "  //float: left;\n"
     "\theight: 60px;\n"
     "\twidth: 60px;\n"
     "\tbackground: url(http://michaeltruong.ca/images/logo1.png) no-repeat;\n"
     "\tbackground-size: 60px 60px;\n"
     "}\n"
     ".clientlogo{\n"
     "  float: left;\n"
     "\theight: 60px;\n"
     "\twidth: 60px;\n"
     "\tbackground: url(http://michaeltruong.ca/images/client.jpg) no-repeat;\n"
     "\tbackground-size: 60px 60px;\n"
     "  border-radius: 50px;\n"
     "}\n"
     ".info{\n"
     "  display: block;\n"
     "  //float:left;\n"
     "  margin-left: 0;\n"
     "}\n"
     ".title{\n"
     "  float: right;\n"
     "}\n"
     ".title p{text-align: right;} \n"
     "table{\n"
     "  width: 100%;\n"
     "  border-collapse: collapse;\n"
     "}\n"
     "td{\n"
     "  //padding: 5px 0 5px 15px;\n"
     "  //border: 1px solid #EEE\n"
     "}\n"
     ".tabletitle{\n"
     "  //padding: 5px;\n"
     "  font-size: .5em;\n"
     "  background: #EEE;\n"
     "}\n"
     ".service{border-bottom: 1px solid #EEE;}\n"
     ".item{width: 24mm;}\n"
     ".itemtext{font-size: .5em;}\n"
     "\n"
     "#legalcopy{\n"
     "  margin-top: 5mm;\n"
     "}\n"
     "\n"
     "  \n"
     "  \n"
     "}</style></head><body>"
     "\n"
     "  <div id=\"invoice-POS\">\n"
     "    \n"
     "    <center id=\"top\">\n"
     "      <div class=\"logo\"></div>\n"
     "      <div class=\"info\"> \n"
     "        <h2>$org</h2>\n"
     "      </div><!--End Info-->\n"
     "    </center><!--End InvoiceTop-->\n"
     "    \n"
     "    <div id=\"mid\">\n"
     "      <div class=\"info\">\n"
     "        <h2>Contact Info</h2>\n"
     "        <p> \n"
     " \n"
     "            Employee id  : $empId</br>\n"
     "           \n"
     "        </p>\n"
     "      </div>\n"
     "    </div><!--End Invoice Mid-->\n"
     "    \n"
     "    <div id=\"bot\">\n"
     "\n"
     "\t\t\t\t\t<div id=\"table\">\n"
     "\t\t\t\t\t\t<table>\n"
     "\t\t\t\t\t\t\t<tr class=\"tabletitle\">\n"
     "\t\t\t\t\t\t\t\t<td class=\"item\"><h2>Item</h2></td>\n"
     "\t\t\t\t\t\t\t\t<td class=\"Hours\"><h2>Qty</h2></td>\n"
     "\t\t\t\t\t\t\t\t<td class=\"Rate\"><h2>Unit Cost</h2></td>\n"
     "\t\t\t\t\t\t\t\t<td class=\"Rate\"><h2>Sub Total</h2></td>\n"
     "\t\t\t\t\t\t\t</tr>"; */


  // String ret="<h1> <B> $org  </B></h1>  \n <h1> <B> RECEIPT OF PURCHASE </B></h1>";
  double totalCost = 0;
  for (int i = 0; i < ticklist.length; i++) {
    totalCost = totalCost + ticklist[i].subtotal;
    ret = ret + "<tr>\n"
        "                            <td class=\"col-md-9\"><em>${ticklist[i]
        .productname} </em></h4></td>\n"
        "                            <td class=\"col-md-1\" style=\"text-align: center\"> ${ticklist[i]
        .quantity} </td>\n"
        "                            <td class=\"col-md-1 text-center\"> ₹ ${ticklist[i]
        .rate}</td>\n"
        "                            <td class=\"col-md-1 text-center\"> ₹ ${ticklist[i]
        .subtotal}</td>\n"
        "                        </tr>";
    // ret = ret + "<br><B><I> ${ticklist[i].productname} </I> </B> :  ${ticklist[i].quantity} , <B><I>Unit Cost</B></I>: ${ticklist[i].rate} ,<B><I>Sub Total</B></I> ₹ ${ticklist[i].subtotal}<br>";ret =
    /* ret = ret + "<tr class=\"service\">\n"
        "\t\t\t\t\t\t\t\t<td class=\"tableitem\"><p class=\"itemtext\"> ${ticklist[i].productname}</p></td>\n"
        "\t\t\t\t\t\t\t\t<td class=\"tableitem\"><p class=\"itemtext\">${ticklist[i].quantity}</p></td>\n"
        "\t\t\t\t\t\t\t\t<td class=\"tableitem\"><p class=\"itemtext\"></p>₹ ${ticklist[i].rate}</td>\n"
        "\t\t\t\t\t\t\t\t<td class=\"tableitem\"><p class=\"itemtext\"></p>₹ ${ticklist[i].subtotal}</td>\n"
        "\t\t\t\t\t\t\t</tr>"; */
  }
    // ret= ret +"<br> <h4> Total Cost: $totalCost </h4> ";
    ret = ret + "<tr>\n"
        "                            <td>   </td>\n"
        "                            <td>   </td>\n"
        "                            <td class=\"text-right\"><h4><strong>Total: </strong></h4></td>\n"
        "                            <td class=\"text-center text-danger\"><h4><strong>$totalCost</strong></h4></td>\n"
        "                        </tr>";
    ret = ret + "</tbody>\n"
        "                </table>\n"
        "            </div>\n"
        "        </div>\n"
        "    </div> </body>";
    /*ret = ret + "<tr class=\"tabletitle\">\n"
      "\t\t\t\t\t\t\t\t<td></td>\n"
      "\t\t\t\t\t\t\t\t<td class=\"Rate\"><h2>Total</h2></td>\n"
      "\t\t\t\t\t\t\t\t<td class=\"payment\"><h2>$totalCost</h2></td>\n"
      "\t\t\t\t\t\t\t</tr>\n"
      "\n"
      "\t\t\t\t\t\t</table>\n"
      "\t\t\t\t\t</div><!--End Table-->\n"
      "\n"
      "\t\t\t\t\t<div id=\"legalcopy\">\n"
      "\t\t\t\t\t\t<p class=\"legal\"><strong>Thank you for your business!</strong>  \n"
      "\t\t\t\t\t\t</p>\n"
      "\t\t\t\t\t</div>\n"
      "\n"
      "\t\t\t\t</div><!--End InvoiceBot-->\n"
      "  </div><!--End Invoice-->\n"
      ""; */
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poslogin/models/ticketJson.dart';
import 'models/ticket.dart';
import 'utils/database_helper.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/ticketJson.dart';
class TicketingDetail extends StatefulWidget {
  final Ticket ticket;
  final String title;
  final String merchantId;
  TicketingDetail({this.ticket,this.title,this.merchantId});
  static const String routeName = "/ticketingdetail";
  @override
  _TicketingDetailState createState() => _TicketingDetailState(
    this.ticket,this.title
  );
}

class _TicketingDetailState extends State<TicketingDetail> {

  static var _quantityList =[1,2,3,4,5,6,7,8,9,10];
  DatabaseHelper helper = new DatabaseHelper();
  String appBarTitle;
  Ticket ticket;
  _TicketingDetailState(this.ticket,this.appBarTitle);

  int quantity=1;
  TextEditingController  productController = TextEditingController();
  TextEditingController  rateController = TextEditingController();
  TextEditingController  subtotalController = TextEditingController();
  bool loading = true;
  static List<TicketJson> tickets = new List<TicketJson>();
  AutoCompleteTextField searchTextField;
  SimpleAutoCompleteTextField textField;
  GlobalKey<AutoCompleteTextFieldState<TicketJson>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<TicketJson>> key1= new GlobalKey();
  TicketJson selectedTicketJson;
  void getAllProductDetails(String merchantID) async {
    //String apiurl='https://jsonplaceholder.typicode.com/posts';
    String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Product/AllProduct/$merchantID';
    http.Response response= await http.get(apiurl,  headers: {
      'Content-type' : 'application/json',
      'Accept': 'application/json',
    });
    if (response.statusCode == 200) {
       tickets= loadTickets((response.body));
       setState(() {
         loading=false;
       });
       print(tickets.length);
       print(tickets[0].rate);
    }
    else{
      print("error getting users");
    }
  }

 static List<TicketJson> loadTickets (String jsonString){
    print("json string $jsonString");

    final parsed = json.decode(jsonString).cast<Map<String,dynamic>>();
    //print(parsed.map<Ticket>((json)=>Ticket.fromMapObject(json)).toList());
    return parsed.map<TicketJson>((json)=>TicketJson.fromJson(json)).toList();


 }

  @override
  void initState() {
    // TODO: implement initState
    getAllProductDetails(widget.merchantId);
    super.initState();
  }

  Widget that(TicketJson t){

    return Padding(
      child: ListTile(
        title: Text(t.productName) ,
        trailing: new Text("${t.rate}"),
      ),
      padding:EdgeInsets.all(8.0)
    ) ;



  }
  @override
  Widget build(BuildContext context) {
    productController.text=ticket.productname;
    rateController.text='${ticket.rate}';
    subtotalController.text = '${ticket.subtotal}';

    TextStyle textStyle = Theme.of(context).textTheme.title;
    return WillPopScope(

     onWillPop:(){
       moveToLastScreen();
     },
     child:Scaffold(
      appBar: new AppBar(
        title: new Text('${widget.title}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            moveToLastScreen();
          },
        ),
      ), //here

      body: Padding(
        padding: EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0),
        child: ListView(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
              ),
               loading?LinearProgressIndicator():
               searchTextField= AutoCompleteTextField<TicketJson>(
                key: key,
                 suggestions: tickets ,
                 style: TextStyle(color:Colors.black , fontSize: 16.0),
                 decoration: InputDecoration(
                   contentPadding: EdgeInsets.fromLTRB(10.0,30.0,10.0,20.0),
                   hintText: "Search Product",
                   hintStyle: TextStyle(color: Colors.black),
                   suffixIcon: new Icon(Icons.search)
                 ),
                itemFilter: (item,query){
                  return item.productName.toLowerCase().startsWith(query.toLowerCase());
                },
                 itemSorter: (a,b){
                   return a.productName.compareTo(b.productName);
                 },

                 itemSubmitted: (item){
                  print("calling");
                  selectedTicketJson = item;
                  setState(() {
                    quantity = ticket.quantity;
                    ticket.productname=selectedTicketJson.productName;
                    ticket.rate=selectedTicketJson.rate;
                    ticket.subtotal = selectedTicketJson.rate * quantity;
                    //ticket.subtotal= quantity * ticket.rate;
                  });

                 },
                 itemBuilder: (context,item){
                   //ui for autocomplete
                   return that(item);
                 },
               ),
           // ),

            new Padding(
               padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
                child: TextField(
                         controller: productController,
                        style: textStyle,
                        onChanged: (valueText){
                           updateProductName();
                          debugPrint('Something has been changed in text');

                        },
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          labelStyle: textStyle,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          )

                        ),
                      ),
            ),
            ListTile(
              title: DropdownButton(
                items: _quantityList.map((int dropDownIntItem){
                  return DropdownMenuItem<int>(
                    value: dropDownIntItem,
                    child: Text('$dropDownIntItem'),
                  );
                }).toList() ,
                style: textStyle ,
                value: getQuantity(ticket.quantity),
                onChanged: (valueSelected){
                  setState(() {
                    quantity=valueSelected;
                    ticket.quantity=quantity;
                    ticket.subtotal= ticket.rate * quantity;
                    debugPrint('User Selected $valueSelected');
                    updateQuantityAsInt(valueSelected);
                  });
                },
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
              child: TextField(
                controller: rateController,
                style: textStyle,
                onChanged: (valueText){
                  updateRate();
                  ticket.subtotal= selectedTicketJson.rate * quantity;
                  debugPrint('Something has been changed in text');
                  //updateRate();
                },
                decoration: InputDecoration(
                    labelText: 'Rs. Rate/unit',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )

                ),
              ),
            ),
            new Padding(
              padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
              child: TextField(
                controller: subtotalController,
                style: textStyle,
                onChanged: (valueText){
                  updatesubtotal();
                  debugPrint('Something has been changed in text');
                },
                decoration: InputDecoration(
                    labelText: 'Sub total',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )

                ),
              ),
            ),

            Padding(
              padding:  EdgeInsets.only(top: 15.0,bottom: 15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text('Save',textScaleFactor: 1.5,),
                      onPressed: (){
                        setState(() {
                          debugPrint('clickd on saved');
                          _save();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorDark,
                      textColor: Theme.of(context).primaryColorLight,
                      child: Text('Delete',textScaleFactor: 1.5,),
                      onPressed: (){
                        setState(() {
                          debugPrint('clck on deleted');
                          _delete();
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),

      ),  // body ends
    ));
  }
  moveToLastScreen(){
    Navigator.pop(context,true);
  }

  void updateQuantityAsInt(int value){
    if(value>0)
    ticket.quantity=value;
    }

  int getQuantity(int value){
    return _quantityList[value-1];
  }

  void updateProductName(){
   // productController.text= selectedTicketJson.productName;
    ticket.productname=productController.text;
  }
  void updateRate(){
    //ticket.rate=  getPriceFromTicketJsonList(tickets);
    //rateController.text=selectedTicketJson.rate.toString();
    ticket.rate = selectedTicketJson.rate;
  }
  void updatesubtotal(){
    ticket.subtotal= getSubTotal();
  }
  //to save in a db

  void _delete() async{
    moveToLastScreen();
    //deleting new ticket came here by pressing floating action button
    if(ticket.id==null){
      _showAlertDialog('status', 'No item was deleted');
      return;
    }
    int result= await helper.deleteTicket((ticket.id));
    if(result!=0){
      _showAlertDialog('Status','item deleted succesfully');
    }else{
      _showAlertDialog('Status',' Error deleting item');
    }

    //deleting already saved item by edit ticket
  }




  void _save() async{
    moveToLastScreen();

    ticket.date= DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(ticket.id!=null){ //update
      result= await helper.updateTicket(ticket);
    }else{//new item insertion
       result =await helper.insertTicket(ticket);
    }
    if(result!=0){
      _showAlertDialog('Status','item saved succesfully');
    }else{
      _showAlertDialog('Status',' Problem saving item');
    }
  }

  void _showAlertDialog(String title, String msg){
    AlertDialog alertDialog = new AlertDialog(
      title: Text(title),
      content: Text(msg),
    );
    showDialog(
        context: context,
        builder: (_)=>alertDialog
    );
  }

  double getPriceFromTicketJsonList(List<TicketJson> ticketsjsonList){
     for (var i in ticketsjsonList){
       if(i.productName.compareTo(productController.text)==0){
         print(i.rate);
         return i.rate;
       }
    }
     return 0.0;
  }

  double getSubTotal(){

     return quantity*selectedTicketJson.rate;
  }

}


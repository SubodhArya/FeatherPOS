import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/ticket.dart';
import 'utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:intl/intl.dart';
class TicketingDetail extends StatefulWidget {
  final Ticket ticket;
  final String title;
  TicketingDetail({this.ticket,this.title});
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

  int quantity;
  TextEditingController  productController = TextEditingController();
  TextEditingController  rateController = TextEditingController();
  TextEditingController  subtotalController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    productController.text=ticket.productname;
    rateController.text='${ticket.rate}';


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
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0),
        child: ListView(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
              child: TextField(
                controller: productController,
                style: textStyle,
                onChanged: (valueText){
                  debugPrint('Something has been changed in text');
                  updateProductName();
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
                  debugPrint('Something has been changed in text');
                  updateRate();
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

      ),
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
    ticket.productname=productController.text;
  }
  void updateRate(){
    ticket.rate= int.parse(rateController.text);
  }
  void updatesubtotal(){
    ticket.subtotal= int.parse(subtotalController.text);
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
}

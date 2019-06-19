import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poslogin/ticketing_detail.dart';
import 'models/ticket.dart';
import 'utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';


/*class Ticketing extends StatelessWidget {
  static const String routeName = "/ticketing";
  final String title;
  Ticketing({this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(' Ticketing Details'),
      ),
      body: new Center(
        child: new Text('Ticketing Details '),
      ),
    );
  }
}
*/
class Ticketing extends StatefulWidget {
  static const String routeName = "/ticketing";
  final String title;
  Ticketing({this.title});
  @override
  _TicketingState createState() => _TicketingState();
}

class _TicketingState extends State<Ticketing> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Ticket> ticketList;
  int count =0;
  @override
  Widget build(BuildContext context) {
    if(ticketList==null){
      ticketList= List<Ticket>();
      updateListView();
    }
    return Scaffold(
      appBar: new AppBar(
        title: new Text(' Ticketing Details'),
      ),
      body: getTicketsListView(),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          navigateToDetail(Ticket('',0 ,1,0,0 ,'' ),'Add Details');
          /*debugPrint('FAB Clicked');
          Navigator.pushNamed(context, TicketingDetail.routeName,arguments: 'Add Details'); */
        },
        tooltip: 'Add item' ,
        child: Icon(Icons.add),
      ),
    );
  }


  void navigateToDetail(Ticket ticket,String title) async{
   // Navigator.pushNamed(context, TicketingDetail.routeName,arguments: ticket,title);
     bool result=await Navigator.push(context, new MaterialPageRoute(
      builder: (context){
        return TicketingDetail(ticket: ticket,title: title,);
      }
    ));
     if(result==true){
       updateListView();
     }
  }
  //for colors based on quantity in each tile
  Color getQuantityColor(int quantity){
    switch(quantity){
      case 1:
         return Colors.lightGreenAccent;
      break;
      case 2:
        return Colors.lightGreenAccent;
        break;
      case 3:
        return Colors.lightGreenAccent;
        break;
      case 4:
        return Colors.lightGreenAccent;
        break;
      case 5:
        return Colors.lightGreenAccent;
        break;
      case 6:
        return Colors.yellow;
        break;
      case 7:
        return Colors.yellow;
        break;
      case 8:
        return Colors.yellow;
        break;
      case 9:
        return Colors.yellow;
        break;
      case 10:
        return Colors.yellow;
        break;
    }
  }

 //to delete a list item

  void _delete(BuildContext context,Ticket ticket) async{
    int result = await databaseHelper.deleteTicket(ticket.id);
    if (result!=0){
      _showSnackBar(context,'Node deleted succesfully');
      updateListView();
    }
  }
  void _showSnackBar(BuildContext context,String message){
    final snackBar= SnackBar(content: Text(message),);
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initialiseDatabase();
    dbFuture.then((database){
      Future<List<Ticket>> ticketListFuture = databaseHelper.getTicketList();
      ticketListFuture.then((ticketList){
        setState(() {
          this.ticketList=ticketList;
          this.count=ticketList.length;
        });
      });
    });
  }



  ListView getTicketsListView(){
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return new ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0 ,
          child: new ListTile(
            leading: new CircleAvatar(
              backgroundColor: getQuantityColor(this.ticketList[position].quantity),
              child: new Text('${this.ticketList[position].quantity}'),
            ),
            title: new Text('${this.ticketList[position].productname}',style: titleStyle,),
            subtitle: new Text(' unit rate : ${this.ticketList[position].rate}   subtotal: ${this.ticketList[position].subtotal}'),
            trailing: GestureDetector(
              child:  new Icon(Icons.delete,color:Colors.grey),
              onTap: (){
                _delete(context, ticketList[position]);
              },
            ),
            onTap:(){
              navigateToDetail(this.ticketList[position],'Edit Details');
             // debugPrint('pressed tile');
              //Navigator.pushNamed(context, TicketingDetail.routeName,arguments: 'Edit Details');

            },
          ),
        );
      },
    );
  }


}

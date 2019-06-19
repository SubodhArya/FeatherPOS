import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as providerpath;
import '../models/ticket.dart';

class DatabaseHelper{
  static DatabaseHelper _databaaseHelper; //singleton dbhelper
  static Database _database;
  String ticketTable ='ticket_table';
  String colId='id';
  String colProductId ='productid';
  String colProductName ='productname';
  String colQuantity='quantity';
  String colRate ='rate';
  String colSubTotal='subtotal';
  String colDate= 'date';
  DatabaseHelper._createInstance();
  factory DatabaseHelper(){
    if(_databaaseHelper==null)
    _databaaseHelper=DatabaseHelper._createInstance();
    return _databaaseHelper;
  }
  Future<Database> get database async{
    if(_database==null){
      _database = await initialiseDatabase();
    }
    return _database;

  }

  Future<Database> initialiseDatabase() async{
    final directory= await providerpath.getApplicationDocumentsDirectory();
    String path = directory.path + 'tickets.db';
    //create db at this path
    var ticketsDatabase = openDatabase(path,version: 1,onCreate: _createDb );
    return ticketsDatabase;
  }

  void _createDb(Database db,int newVersion) async{
    await db.execute('CREATE TABLE $ticketTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colProductName TEXT, $colQuantity INTEGER,'
         '$colProductId INTEGER, $colRate INTEGER,$colSubTotal INTEGER,$colDate TEXT)');

  }
  //FETCHing dta from db
  Future<List<Map<String,dynamic>>> getTicketMapList() async{
    Database db= await this.database;
    // var result = await db.rawQuery('Select * from $ticketTable order by $colQuantity asc');
    // the abv by using raw sql u can also use built in query functions
    var result = db.query(ticketTable,orderBy: '$colQuantity ASC');
    return result;
  }
  //  Insertions
  Future<int> insertTicket(Ticket ticket) async{
     Database db = await this.database;
     var result = await db.insert(ticketTable, ticket.toMap());
     return result;
  }
  //UPDATE
  Future<int> updateTicket(Ticket ticket) async{
    Database db = await this.database;
    var result = await db.update(ticketTable, ticket.toMap(),where: '$colId =?',whereArgs: [ticket.id]);
    return result;
  }
  //DELETE
  Future<int> deleteTicket(int id) async{
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $ticketTable  WHERE $colId=$id ');
    return result;
  }
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT (*) FROM $ticketTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }
  //get map list from db and convert it into Ticket List  List<Ticket>
  Future<List<Ticket>> getTicketList() async{
    var ticketMapList = await getTicketMapList();
    int count = ticketMapList.length;
    List<Ticket> ticketList = List<Ticket>();
    for(int i=0;i<count;i++){
      ticketList.add(Ticket.fromMapObject(ticketMapList[i]));
    }
    return ticketList;
  }
}
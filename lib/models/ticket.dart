//id productname  qnt rate subtotal

class Ticket{
  int _id;
  String _productname;
  int _productid;
  int _quantity;
  double _rate;
  double _subtotal;
  String _date;
  Ticket(this._productname,this._productid,this._quantity,this._rate,this._subtotal,this._date);
  Ticket.withId(this._id,this._productid,this._productname,this._quantity,this._rate,this._subtotal,this._date);
  int get id=>_id;
  String get productname=>_productname;
  String get date => _date;
  double get rate=>_rate;
  double get subtotal=>_subtotal;
  int get quantity=>_quantity;

  set productname(String newProductname){
    this._productname=newProductname;
  }
  set date(String newDate){
    this._date=newDate;
  }
  set rate(double newRate){
    this._rate=newRate;
  }
  set productid(int newproductid){
    this._productid=newproductid;
  }
  set id(int newId){
    this._id=newId;
  }
  set subtotal(double newsubtotal){
    this._subtotal=newsubtotal;
  }
  set quantity(int newquantity){
    this._quantity=newquantity;
  }

  //Convrt a ticket obj to maap obj because sqlflite accepts only map obj
  Map<String, dynamic> toMap(){
    var map=Map<String,dynamic>();
    if(id!=null) {
      map['id'] = _id;
    }
    map['productid']=_productid;
    map['productname']=_productname;
    map['quantity']=_quantity;
    map['rate']=_rate;
    map['subtotal']=_subtotal;
    map['date']=_date;
    return map;
  }
  //Extracting ticket obj from map obj
  Ticket.fromMapObject(Map<String, dynamic> map){
    this._productid=map['productid'];
    this._id=map['id'];
    this._date=map['date'];
    this._subtotal=map['subtotal'];
    this._quantity=map['quantity'];
    this._rate=map['rate'];
    this._productname=map['productname'];
  }

  Map<String,dynamic> toTicketMap(){
    var map=Map<String,dynamic>();
    map['ProductId']=_productid;
    map['Quantity']=_quantity;
    map['Price']=rate;
    map['SubTotal']=subtotal;
    return map;
  }



}
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

class AddProduct extends StatefulWidget {
  final String title;
  final String merchantId;
  AddProduct({this.title,this.merchantId});
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String _productName;
  int _unitCost;
  int _sellingPrice;
  int _comission;
  int _rating;
  String _modifiedUser;
  int _quantityRemaining;
  int _categoryId;
  String _categorySelected;
  int _categoryIntVal;
  bool _progressBarActive=false;
  var productFormKey = new GlobalKey<FormState>();
  var productScaffoldKey = new GlobalKey<ScaffoldState>();
  void _submit(){
    final form = productFormKey.currentState;
    if(form.validate()){
      setState(() {
        _progressBarActive=true;
      });
      form.save();
      performProductAddition();
    }
  }
  performProductAddition() async{
    //requestLoginAPI(context, _email, _password);
    //print(_email);

    Map<String,dynamic> ret= await addProductAPI(context,_productName,_unitCost,_sellingPrice,_comission,_rating,_modifiedUser,_quantityRemaining,_categoryIntVal,widget.merchantId);
    print(ret);
    if (ret['productId'] != null && ret['productId'] != 0) {
      setState(() {
        _progressBarActive = false;
      });
      showDialogSingleButton(context, "Congrats!",
          " Product succesfully added with  productId ${ret['categoryId']} categoryId ${ret['categoryId']}  and merchantID ${ret['merchantId']}.",
          "OK");

      // Navigator.pushNamed(context, Menu.routeName,
      //   arguments: _email);
      productFormKey.currentState.reset();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product here'),
      ),
      body: new Container(
        padding: EdgeInsets.all(20.0),
        child: new Form(
          key: productFormKey,
          child: new ListView(
            children: <Widget>[
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Product Name",
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
                onSaved: (val)=>_productName=val,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
              Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Unit Cost",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if(val.length==0 ) {
                    return "Unit Price should be valid";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                onSaved: (val)=>_unitCost=int.parse(val),
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
               Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),
              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Selling Price",
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
                    return "Selling Price cannot be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_sellingPrice=int.parse(val),
              ),

               Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),

              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Comission",
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
                    return " Comission should not be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_comission=int.parse(val),
              ),

               Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),

              new TextFormField(
                decoration: new InputDecoration(
                  labelText: "Existing Rating",
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
                    return "Rating Not Valid";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.number,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_rating=int.parse(val),
              ),

               Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),

              new TextFormField(
                decoration: new InputDecoration(
                  labelText: " Quantity Remaining ",
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
                    return "Quantity cant be empty";
                  }else{
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
                onSaved: (val)=>_quantityRemaining=int.parse(val),
              ),

               Padding(
                padding: new EdgeInsets.fromLTRB(0.0,15.0,0.0,0.0),
              ),

              new Text("Select Category",style: new TextStyle(fontSize: 20.0),),

              //DROPDOWN HERE
              new FutureBuilder(
                future: getCategoryDetails(widget.merchantId),

                builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
                  print("here snap ");
                  print("its ${snapshot.data} ");
                  //where we get all json data, set up widgets
                  if(snapshot.hasData) {
                    // print('hello');
                    List<dynamic> content = snapshot.data;
                    List<String> categoryNames=[];
                    List<int> categoryIds=[];
                    for(int i=0;i<content.length;i++){
                      categoryNames.add(content[i]['name']);
                      categoryIds.add(content[i]['categoryId']);
                    }
                    return new Container(
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
                    int index=categoryNames.indexOf(_categorySelected);
                    _categoryIntVal=categoryIds[index];
                    });
                    },
                    ),
                    ),
                      );}

                  else{
                    return new Center(
                      child: new CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Padding(
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

Future<Map<String,dynamic>> addProductAPI(BuildContext context,String productName,int unitCost, int sellingPrice, int comission,int rating,String modifiedUser ,int quantityRemaining,int categoryId,String merchantID) async {
  //String apiurl='https://jsonplaceholder.typicode.com/posts';
  String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Product/AddProduct/${merchantID}';
  http.Response response= await http.post(
      apiurl,
      body:jsonEncode( {

        "ProductName": productName,
        "UnitCost": unitCost,
        "SellingPrice": sellingPrice,
        "Comission": comission,
        "Rating": rating,
        "ModifiedUser": modifiedUser,
        "QuantityRemaining": quantityRemaining,
        "CategoryID": categoryId

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

Future<List<dynamic>> getCategoryDetails(String merchantID) async {
  //String apiurl='https://jsonplaceholder.typicode.com/posts';
  String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Category/AllCategory/$merchantID';
  http.Response response= await http.get(apiurl,  headers: {
    'Content-type' : 'application/json',
    'Accept': 'application/json',
  });
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


/*Widget updateCategoryWidget(String merchantID){
  return new FutureBuilder(
    future: getCategoryDetails(merchantID),

    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
      print("here snap ");
      print("its ${snapshot.data} ");
      //where we get all json data, set up widgets
      if(snapshot.hasData) {
        // print('hello');
        List<dynamic> content = snapshot.data;
        List<String> categoryNames=[];
        List<int> categoryIds=[];
        for(int i=0;i<content.length;i++){
          categoryNames.add(content[i]['name']);
          categoryIds.add(content[i]['categoryId']);
        }
        return new Container(
          child: new ListView.builder(
            itemCount: content.length,
            itemBuilder: (BuildContext context, int position) {
             return ListTile(
               title: DropdownButton(
                 items: categoryNames.map((String dropDownStringItem){
                   return DropdownMenuItem<String>(
                     value: dropDownStringItem,
                     child: Text('$dropDownStringItem'),
                   );
                 }).toList() ,
                 value: getQuantity(ticket.quantity),
                 onChanged: (valueSelected){
                   setState(() {
                     debugPrint('User Selected $valueSelected');
                     updateQuantityAsInt(valueSelected);
                   });
                 },
               ),
             ),
            },
          ),
        );
      }
      else{
        return new Center(
          child: new CircularProgressIndicator(),
        );
      }
    },
  );


}*/

/*
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
 */
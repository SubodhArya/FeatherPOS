import 'package:flutter/material.dart';
import 'dart:core' ;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:poslogin/addProduct.dart';



class ProductDetails extends StatefulWidget {
  static const String routeName = "/productdetails";
  final String title;
  final String merchantId;
  ProductDetails({this.title,this.merchantId});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String _categorySelected;
  int _categoryIntVal;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Product Details'),
      ),
      body: new Column(
        children: <Widget>[
          Padding( padding: EdgeInsets.all(15.0),),
          new RaisedButton(
            child: new Text('Select Category to display products',style: new TextStyle(fontSize: 20.0),),
            elevation: 2.0,
            color: Colors.lime,
            textColor: Colors.white,
            onPressed: ()=>debugPrint('pressed'),
          ),
          Padding( padding: EdgeInsets.all(15.0),),
          new FutureBuilder(
            future: getCategoryDetails(widget.merchantId),

            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
              print("here snap ");
              print("its ${snapshot.data} ");
              //where we get all json data, set up widgets
              if(snapshot.hasData) {
                // print('hello');
                List<dynamic> content = snapshot.data;
                List<String> categoryNames=['All'];
                List<int> categoryIds=[0];
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


          Padding( padding: EdgeInsets.all(15.0),),

          new Expanded(
            child: updateCategoryWidget(_categoryIntVal,widget.merchantId),
          ),
        ],
      ),
      /*new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //dropdown here using future builder
          /*new FutureBuilder(
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


          Padding( padding: EdgeInsets.all(15.0),), */

          updateCategoryWidget(widget.merchantId),
        ],
      ),*/
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          //debugPrint('fab print');
          Navigator.push(context, new MaterialPageRoute(
              builder: (context){
                // print("m id ${widget.merchantId}");
                return AddProduct(title: "hello",merchantId: widget.merchantId);
              }
          ));
        },
        tooltip: 'Add Category',
        child: Icon(Icons.add),
      ),

    );
  }
}


Widget updateCategoryWidget(int categoryID,String merchantID){
  if(categoryID==0) {
    return new FutureBuilder(
      future: getAllProductDetails(merchantID),

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
                      backgroundColor: Colors.yellow,
                      child: new Text(' id: ${content[position]['productId']}',
                        style: new TextStyle(
                          fontSize: 13.0,
                        ),),
                    ),
                    title: new Text(
                        "${content[position]['productName']}"),
                    subtitle: new Text(
                        " UnitPrice : ${content[position]['unitCost']} Selling Price:  ${content[position]['unitCost']}  Rating: ${content[position]['rating']}"),
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
  else{
    return new FutureBuilder(
      future: getCategoryWiseProductDetails(merchantID,categoryID),

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
                      backgroundColor: Colors.yellow,
                      child: new Text(' id: ${content[position]['productId']}',
                        style: new TextStyle(
                          fontSize: 13.0,
                        ),),
                    ),
                    title: new Text(
                        "${content[position]['productName']}"),
                    subtitle: new Text(
                        " UnitPrice : ${content[position]['unitCost']} Selling Price:  ${content[position]['unitCost']}  Rating: ${content[position]['rating']}"),
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


Future<List<dynamic>> getAllProductDetails(String merchantID) async {
  //String apiurl='https://jsonplaceholder.typicode.com/posts';
  String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Product/AllProduct/$merchantID';
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

Future<List<dynamic>> getCategoryWiseProductDetails(String merchantID,int categoryID) async {
  //String apiurl='https://jsonplaceholder.typicode.com/posts';
  String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Product/GetAllProductsOfCategory/$merchantID/$categoryID';
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













/*
[
    {
        "productId": 1,
        "productName": "Santoor",
        "unitCost": 50,
        "sellingPrice": 70,
        "comission": 5,
        "rating": 5,
        "createdDate": "2019-06-16T18:17:30.967",
        "modifiedDate": "2019-06-16T18:17:30.97",
        "modifiedUser": "vishnu",
        "categoryId": 1,
        "merchantId": 1,
        "quantityRemaining": 12
    },
    {
        "productId": 2,
        "productName": "dove",
        "unitCost": 70,
        "sellingPrice": 80,
        "comission": 4,
        "rating": 4,
        "createdDate": "2019-06-17T06:13:14.653",
        "modifiedDate": "2019-06-17T06:13:14.653",
        "modifiedUser": "vishnu",
        "categoryId": 1,
        "merchantId": 1,
        "quantityRemaining": 19
    }
]
 */
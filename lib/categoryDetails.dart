import 'dart:core' ;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/employeeList.dart';
import 'models/Employee.dart';
import 'package:poslogin/addCategory.dart';

class CategoryDetails extends StatefulWidget {
  static const String routeName = "/employeedetails";
  final String title;
  final String merchantId;
  CategoryDetails({this.title,this.merchantId});

  @override
  _CategoryDetailsState createState() => _CategoryDetailsState();
}

class _CategoryDetailsState extends State<CategoryDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(' Category Details'),
      ),
      body: new Container(
        child: updateCategoryWidget(widget.merchantId),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          //debugPrint('fab print');
          Navigator.push(context, new MaterialPageRoute(
              builder: (context){
                // print("m id ${widget.merchantId}");
                return AddCategory(title: "hello",merchantId: widget.merchantId);
              }
          ));
        },
        tooltip: 'Add Category',
        child: Icon(Icons.add),
      ),

    );
  }
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


Widget updateCategoryWidget(String merchantID){
  return new FutureBuilder(
    future: getCategoryDetails(merchantID),

    builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
      print("here snap ");
      print("its ${snapshot.data} ");
      //where we get all json data, set up widgets
      if(snapshot.hasData) {
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
                    child: new Text('Id: ${content[position]['categoryId']}',
                      style: new TextStyle(
                        fontSize: 13.0,
                      ),),
                  ),
                  title: new Text(
                      "${content[position]['name']}"),
                  subtitle: new Text("${content[position]['description']}"),

                ),

              );
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


}

/* response body
[
    {
        "categoryId": 1,
        "name": "Soaps",
        "description": "All kinds of soaps",
        "merchantId": 1
    },
    {
        "categoryId": 2,
        "name": "shampoos",
        "description": "contains all types of shampoos",
        "merchantId": 1
    }
]
 */
import 'dart:core' ;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/employeeList.dart';
import 'models/Employee.dart';
import 'package:poslogin/addEmployee.dart';
import 'package:poslogin/employeeDetails.dart';

/*
class EmployeeDetails extends StatelessWidget {
  static const String routeName = "/employeedetails";
  final String title;
  EmployeeDetails({this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(' Employee Details'),
      ),
      body: new Center(
        child: new Text('Emp Details '),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          debugPrint('fab print');
        },
        tooltip: 'Add Employee',
        child: Icon(Icons.add),
      ),
    );
  }
}
*/

class EmployeeDetails extends StatefulWidget {
  static const String routeName = "/employeedetails";
  final String title;
  final String merchantId;

  EmployeeDetails({this.title,this.merchantId});
  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  @override


  void navigateToDetail(String title) async{
    print(widget.merchantId);
     Navigator.push(context, new MaterialPageRoute(
        builder: (context){
          return AddEmployee(title: title,);
        }
    ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(' Employee Details'),
      ),
      body: new Container(
        child: updateEmpWidget(widget.merchantId),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){
          //debugPrint('fab print');
          Navigator.push(context, new MaterialPageRoute(
              builder: (context){
               // print("m id ${widget.merchantId}");
                return AddEmployee(title: "hello",merchantId: widget.merchantId);
              }
          ));
        },
        tooltip: 'Add Employee',
        child: Icon(Icons.add),
      ),

    );
  }

}



Future<List<dynamic>> getEmployeeDetails(String merchantID) async {
  //String apiurl='https://jsonplaceholder.typicode.com/posts';
  String apiurl= 'https://webapplication220190616025624.azurewebsites.net/Employee/AllEmployee/$merchantID';
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

Widget updateEmpWidget(String merchantID){
  return new FutureBuilder(
    future: getEmployeeDetails(merchantID),

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
                    backgroundColor: Colors.lightGreenAccent,
                    child: new Text('${content[position]['employeeId']}'),
                  ),
                  title: new Text(
                      "${content[position]['employeeName']} : ${content[position]['userName'] }"),
                  subtitle: new Text("${content[position]['emailId']}"),

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
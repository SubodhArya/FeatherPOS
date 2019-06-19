import 'package:flutter/material.dart';


class CustomerDetails extends StatelessWidget {
  static const String routeName = "/customerdetails";
  final String title;
  CustomerDetails({this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Customer Details'),
      ),
      body: new Center(
        child: new Text('Custoer details '),
      ),
    );
  }
}

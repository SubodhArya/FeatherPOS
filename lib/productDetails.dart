import 'package:flutter/material.dart';


class ProductDetails extends StatelessWidget {
  static const String routeName = "/productdetails";
  final String title;
  ProductDetails({this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text(' Product Details'),
      ),
      body: new Center(
        child: new Text('Product Details '),
      ),
    );
  }
}

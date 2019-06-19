import 'package:flutter/material.dart';
import 'package:poslogin/main.dart';
import 'customerDetails.dart';
import 'employeeDetails.dart';
import 'productDetails.dart';
import 'ticketing.dart';
import 'categoryDetails.dart';
class Menu extends StatelessWidget {
  static const String routeName = "/menu";

  final String username;
  final String merchantId;
  final String designation;
  Menu({this.username,this.merchantId,this.designation});

  @override
  Widget build(BuildContext context) {
    if (designation.compareTo('Manager')==0 ){
      return Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome $username',
            style: new TextStyle(
              fontSize: 15.0,
            ),),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text("$username"),
                accountEmail: new Text("$designation"),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child:  new Text('${username[0]}',style: new TextStyle(
                      fontSize: 40.0
                  ),),
                ),

              ),
              new ListTile(
                  title: new Text('Category Details'),
                  trailing: new Icon(Icons.category),
                  onTap: () {
                    Navigator.of(context).pop();
                    //Navigator.of(context).pushNamed(ProductDetails.routeName);
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) {
                          return CategoryDetails(
                            title: "Employee details", merchantId: merchantId,);
                        }
                    ));
                  }),
              new Divider(),
              new ListTile(
                  title: new Text('Product Details'),
                  trailing: new Icon(Icons.shopping_basket),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(ProductDetails.routeName);
                  }),
              new Divider(),
              new ListTile(
                  title: new Text('Employee Details'),
                  trailing: new Icon(Icons.people),
                  onTap: () {
                    Navigator.of(context).pop();
                    //Navigator.of(context).pushNamed(EmployeeDetails.routeName);
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) {
                          return EmployeeDetails(
                            title: "Employee details", merchantId: merchantId,);
                        }
                    ));
                  }
              ),
              new Divider(),
              new ListTile(
                  title: new Text('Ticketing'),
                  trailing: new Icon(Icons.add_shopping_cart),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(Ticketing.routeName);
                  }
              ),
              new Divider(),
              new ListTile(
                  title: new Text('Customer Details'),
                  trailing: new Icon(Icons.person),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(CustomerDetails.routeName);
                  }
              ),
              new Divider(),
              new ListTile(
                title: new Text('Logout'),
                trailing: new Icon(Icons.power_settings_new),
                onTap: () {
                  Navigator.of(context).pushNamed(PosHome.routeName);
                },
              ),

              new Divider(),
              new ListTile(
                title: new Text('Close'),
                trailing: new Icon(Icons.close),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),

            ],
          ),
        ),
        body: new Container(
          child: new Center(
            child: new Text("Menu Page"),
          ),
        ),
      ); //
  }
    else{

      return Scaffold(
        appBar: new AppBar(
          title: new Text('Welcome $username',
            style: new TextStyle(
              fontSize: 15.0,
            ),),
          backgroundColor: Colors.deepPurple,
          centerTitle: true,
        ),
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text("$username"),
                accountEmail: new Text("$designation"),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.white,
                  child: new Text('${username[0]}',style: new TextStyle(
                    fontSize: 40.0
                  ),),
                ),

              ),
             /* new ListTile(
                  title: new Text('Product Details'),
                  trailing: new Icon(Icons.shopping_basket),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(ProductDetails.routeName);
                  }),
              new Divider(),
              new ListTile(
                  title: new Text('Employee Details'),
                  trailing: new Icon(Icons.people),
                  onTap: () {
                    Navigator.of(context).pop();
                    //Navigator.of(context).pushNamed(EmployeeDetails.routeName);
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) {
                          return EmployeeDetails(
                            title: "Employee details", merchantId: merchantId,);
                        }
                    ));
                  }
              ),
              new Divider(), */
              new ListTile(
                  title: new Text('Ticketing'),
                  trailing: new Icon(Icons.add_shopping_cart),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(Ticketing.routeName);
                  }
              ),
              new Divider(),
              /*
              new ListTile(
                  title: new Text('Customer Details'),
                  trailing: new Icon(Icons.person),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(CustomerDetails.routeName);
                  }
              ),
              new Divider(),*/
              new ListTile(
                title: new Text('Logout'),
                trailing: new Icon(Icons.power_settings_new),
                onTap: () {
                  //Navigator.of(context).pushNamed(PosHome.routeName);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),

              new Divider(),
              new ListTile(
                title: new Text('Close'),
                trailing: new Icon(Icons.close),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),

            ],
          ),
        ),
        body: new Container(
          child: new Center(
            child: new Text("Menu Page"),
          ),
        ),
      ); //
    }
    return new Container();
  }
}

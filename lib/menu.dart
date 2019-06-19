import 'package:flutter/material.dart';
import 'package:poslogin/main.dart';
import 'customerDetails.dart';
import 'employeeDetails.dart';
import 'productDetails.dart';
import 'ticketing.dart';
import 'categoryDetails.dart';
class Menu extends StatelessWidget {
  static const String routeName = "/menu";
  //final String organisation;
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
                    //Navigator.of(context).pushNamed(ProductDetails.routeName);
                    Navigator.push(context, new MaterialPageRoute(
                        builder: (context) {
                          return ProductDetails(
                            title: "Employee details", merchantId: merchantId,);
                        }
                    ));
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
        body:new ListView(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(15.0),
            ),

            new Center(
              child: new FlatButton(
                child: new Text("Use the Menu icon for Navigation "),

                onPressed: (){},
                color: Colors.grey,
              ),
            ),

            new Padding(
              padding: EdgeInsets.all(15.0),
            ),
            new Center(
              child: new Image.asset('images/feather.png'),
            ),
            new Padding(
              padding: EdgeInsets.all(15.0),
            ),
            new Center(
              child: new Text("Feather App©",style: new TextStyle(fontWeight: FontWeight.w800),),
            ),
            new Padding(
              padding: EdgeInsets.all(15.0),
            ),
            new Center(
              child: new Text("In Association with ",style: new TextStyle(fontWeight: FontWeight.w500),),
            ),
            new Padding(
              padding: EdgeInsets.all(15.0),
            ),
            new Center(
              child: new Image.asset('images/ncr.png'),
            ),

          ],
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
        body:new ListView(
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(15.0),
            ),

            new Center(
              child: new FlatButton(
                child: new Text("Use the Menu icon for Navigation "),

                onPressed: (){},
                color: Colors.grey,
              ),
            ),

            new Padding(
              padding: EdgeInsets.all(15.0),
            ),
            new Center(
              child: new Image.asset('images/feather.png'),
            ),
            new Padding(
              padding: EdgeInsets.all(15.0),
            ),
            new Center(
              child: new Text("Feather App©",style: new TextStyle(fontWeight: FontWeight.w800),),
            ),
            new Padding(
              padding: EdgeInsets.all(15.0),
            ),
            new Center(
              child: new Text("In Association with ",style: new TextStyle(fontWeight: FontWeight.w500),),
            ),
            new Padding(
              padding: EdgeInsets.all(15.0),
            ),
            new Center(
              child: new Image.asset('images/ncr.png'),
            ),

          ],
        ),
      ); //
    }
    return new Container();
  }
}

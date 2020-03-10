import 'package:flutter/material.dart';
import 'package:ultimax2/Tabs/Message_borad.dart';
import 'package:ultimax2/Tabs/Private_Message.dart';

void main() => runApp(new MediaQuery(
    data: new MediaQueryData(), child: new MaterialApp(home: new MyApp())));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: _MyHomePageState(),
    );
  }
}

class _MyHomePageState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        color: Colors.red,
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              backgroundColor: Colors.blue,
              appBar: AppBar(
                elevation: 10,
                backgroundColor: Colors.blue,
                bottom: TabBar(
                  indicatorColor: Colors.yellow,
                  labelColor: Colors.yellowAccent,
                  tabs: [
                    Tab(
                      child: Text(
                        "Message Board",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Private Message",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                  ],
                ),
                title: Text("Ultimax Alert",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.yellowAccent)),
                centerTitle: true,
              ),
              body: TabBarView(
                children: <Widget>[Message_board(), Private_Message()],
              ),
//              drawer: Drawer(
//                  elevation: 22.0,
//                  child: ListView(
//                    children: <Widget>[
//                      UserAccountsDrawerHeader(
//                        arrowColor: Colors.lightGreen,
//                        accountName: Text("BSP USSD Options"),
//                      ),
//                      ListTile(
//                        title: Text("Seller Page"),
//                        trailing: Icon(Icons.account_box),
//                        onTap: () {
////                        Navigator.of(context).pop();
//                          Navigator.of(context).push(MaterialPageRoute(
//                              builder: (BuildContext context) => Seller()));
//                        },
//                      ),
//                      ListTile(
//                        title: Text("Add Account"),
//                        trailing: Icon(Icons.playlist_add),
//
//                        onTap: (){
//                          Navigator.of(context).push(MaterialPageRoute(
//                              builder: (BuildContext context) => AddAcc()));
//                        },
//                      ),
//                    ],
//                  )),
//              floatingActionButton: FabAlert(),
            )));
  }
}

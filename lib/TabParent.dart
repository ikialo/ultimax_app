import 'package:flutter/material.dart';

class  TabParent extends StatefulWidget {
  @override
  Tabparent_State createState() => Tabparent_State();
}

// ignore: camel_case_types
class Tabparent_State extends State<TabParent> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.chat)),
                Tab(icon: Icon(Icons.notifications_active)),
                Tab(icon: Icon(Icons.call)),
              ],
            ),
          ),

        ),



    );
  }
}

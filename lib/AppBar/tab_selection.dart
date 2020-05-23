import 'package:flutter/material.dart';
import 'package:ultimax2/AppBar/report_tab.dart';
import 'package:ultimax2/Tabs/CallNumbers.dart';
import 'package:ultimax2/Tabs/Chat.dart';
import 'package:ultimax2/Tabs/Ultimax_Notificaiton.dart';


class TabSelection extends StatelessWidget {
  final String peerId;
  final String peerAvatar;

  var primaryColor = Colors.blue;

  TabSelection({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color black = Colors.black;

    return MaterialApp(
        color: Colors.red,
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
              backgroundColor: black,
              appBar: AppBar(
                elevation: 10,
                backgroundColor: black,
                title: Text("ULTIMAX ALERT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                        , fontFamily: "HANDGOTN")),
                centerTitle: true,
                bottom: TabBar(
                  unselectedLabelColor: Colors.white,
                  indicatorColor: Colors.blueAccent,
                  labelColor: Colors.blue,
                  tabs: [
                    Tab(icon: Icon(Icons.notifications_active)),
                    Tab(icon: Icon(Icons.chat)),

                    Tab(icon: Icon(Icons.edit)),
                    Tab(icon: Icon(Icons.call)),
                  ],
                ),
              ),
              body: TabBarView(
                children: [

                  Notification_alert(),
                  Chat(
                    peerId: peerId,
                    peerAvatar: peerAvatar,
                  ),
                  Report(),
                  Numbers_Call(),

                ],
              ),
            )));
  }
}

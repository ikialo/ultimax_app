import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimax2/Tabs/CallNumbers.dart';
import 'package:ultimax2/Tabs/Chat.dart';
import 'package:ultimax2/Tabs/ReportPage.dart';
import 'package:ultimax2/Tabs/Ultimax_Notificaiton.dart';

import '../providerClass.dart';


class TabSelection extends StatelessWidget {
  final String peerId;
  final String peerAvatar;

  var primaryColor = Colors.blue;


  TabSelection({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color black = Colors.black;


    var changeTitle = Provider.of<ChangeTitle>(context);

    print("title: "+changeTitle.getTitle());


    return MaterialApp(
        color: Colors.red,
        home: DefaultTabController(
            length: 4,
            child: Scaffold(
              backgroundColor: black,
              appBar: AppBar(
                elevation: 10,
                backgroundColor: black,
                title:  Text("ALert",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                          , fontFamily: "HANDGOTN")),
//                title: Consumer<ChangeTitle> (builder: (BuildContext context, ChangeTitle value, Widget child) {
//
//                  print("this title: "+value.getTitle());
//                  return  Text(value.getTitle(),
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          color: Colors.white
//                          , fontFamily: "HANDGOTN"));
//                },),
//

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
                  Report( peerId: peerId,
                    peerAvatar: peerAvatar,),
                  Numbers_Call(),

                ],
              ),
            )));
  }
}

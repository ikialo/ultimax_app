import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ultimax2/Tabs/CallNumbers.dart';
import 'package:ultimax2/Tabs/Chat.dart';
import 'package:ultimax2/Tabs/ReportPage.dart';
import 'package:ultimax2/Tabs/Ultimax_Notificaiton.dart';

import '../providerClass.dart';



class TabSelection extends StatefulWidget {
  var peerId;

  var peerAvatar;

  TabSelection({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  _TabSelectionState createState() => _TabSelectionState();
}

class _TabSelectionState extends State<TabSelection> with TickerProviderStateMixin{


  _TabSelectionState({Key key, @required this.peerId, @required this.peerAvatar});
  final String peerId;
  final String peerAvatar;

  final List<String> _tabs = ["Alert", "Forum", "Report", "Contacts"
  ];
  String _myHandler ;
  TabController _controller ;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initialise();
  }

  void initialise(){
    _controller = new TabController(length:4 , vsync: this);
    _myHandler = _tabs[0];
    _controller.addListener(_handleSelected);
  }
  void _handleSelected() {
    setState(() {
      _myHandler= _tabs[_controller.index];
    });
  }

  var primaryColor = Colors.blue;




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
                title:  Text(_myHandler,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )),
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
                  controller: _controller,
                  tabs: [
                    Tab(icon: Icon(Icons.notifications_active)),
                    Tab(icon: Icon(Icons.chat)),
                    Tab(icon: Icon(Icons.edit)),
                    Tab(icon: Icon(Icons.call)),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _controller,
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

//class TabSelection extends StatelessWidget {
//  final String peerId;
//  final String peerAvatar;
//
//  final List<String> _tabs = ["Alert", "Forum", "Report", "Contacts"
//  ];
//  String _myHandler ;
//  TabController _controller ;
//
//
//
//
//
//  void initialise(){
//    _controller = new TabController(length: 2, vsync: this);
//    _myHandler = _tabs[0];
//    _controller.addListener(_handleSelected);
//  }
//  void _handleSelected() {
//    setState(() {
//      _myHandler= _tabs[_controller.index];
//    });
//  }
//
//  var primaryColor = Colors.blue;
//
//
//  TabSelection({Key key, @required this.peerId, @required this.peerAvatar})
//      : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    Color black = Colors.black;
//
//
//    var changeTitle = Provider.of<ChangeTitle>(context);
//
//    print("title: "+changeTitle.getTitle());
//
//
//    return MaterialApp(
//        color: Colors.red,
//        home: DefaultTabController(
//            length: 4,
//            child: Scaffold(
//              backgroundColor: black,
//              appBar: AppBar(
//                elevation: 10,
//                backgroundColor: black,
//                title:  Text("ALert",
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          color: Colors.white
//                          , fontFamily: "HANDGOTN")),
////                title: Consumer<ChangeTitle> (builder: (BuildContext context, ChangeTitle value, Widget child) {
////
////                  print("this title: "+value.getTitle());
////                  return  Text(value.getTitle(),
////                      style: TextStyle(
////                          fontWeight: FontWeight.bold,
////                          color: Colors.white
////                          , fontFamily: "HANDGOTN"));
////                },),
////
//
//                centerTitle: true,
//                bottom: TabBar(
//                  unselectedLabelColor: Colors.white,
//                  indicatorColor: Colors.blueAccent,
//                  labelColor: Colors.blue,
//                  tabs: [
//                    Tab(icon: Icon(Icons.notifications_active)),
//                    Tab(icon: Icon(Icons.chat)),
//                    Tab(icon: Icon(Icons.edit)),
//                    Tab(icon: Icon(Icons.call)),
//                  ],
//                ),
//              ),
//              body: TabBarView(
//                children: [
//
//                  Notification_alert(),
//                  Chat(
//                    peerId: peerId,
//                    peerAvatar: peerAvatar,
//                  ),
//                  Report( peerId: peerId,
//                    peerAvatar: peerAvatar,),
//                  Numbers_Call(),
//
//                ],
//              ),
//            )));
//  }
//}

import 'package:flutter/material.dart';
import 'package:mor_release/account/details_report.dart';
import 'package:mor_release/account/new_report.dart';
import 'package:mor_release/account/ratio_member.dart';
import 'package:mor_release/account/report.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/track/track.invoice.dart';
import 'package:mor_release/track/track.order.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';

class ReportTabs extends StatelessWidget {
  final AppBar _appBar = AppBar(
    leading: Container(),
    bottomOpacity: 0.0,
    backgroundColor: Colors.pink[900],
    elevation: 20,
    ///////////////////////Top Tabs Navigation Widget//////////////////////////////
    title: TabBar(
      indicatorColor: Colors.grey[900],
      indicatorWeight: 6,
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: <Widget>[
        Tab(
          icon: Icon(
            GroovinMaterialIcons.account_check,
            size: 32.0,
            color: Colors.white,
          ),
        ),
        Tab(
          icon: Icon(
            GroovinMaterialIcons.account_plus,
            color: Colors.greenAccent[400],
            size: 32.0,
          ),
        ),
        Tab(
          icon: Icon(
            GroovinMaterialIcons.account_star,
            size: 32.0,
            color: Colors.yellow,
          ),
        ),
        Tab(
          icon: Icon(
            GroovinMaterialIcons.account_network,
            size: 32.0,
            color: Colors.lightBlue[200],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0), child: _appBar),
          body: TabBarView(
            children: <Widget>[
              Report(model.userInfo.distrId, model.settings.apiUrl),
              NewReport(model.userInfo.distrId, model.settings.apiUrl),
              RatioReport(model.userInfo.distrId, model.settings.apiUrl),
              DetailsReport(model.userInfo.distrId, model.settings.apiUrl),
              // ExpansionTileSample() // SwitchPage(ItemsPage()),
              //OrderPage(), //SwitchPage(OrderPage()),
              //ProductList(),
            ],
          ),
          /* bottomNavigationBar: BottomNavigationBar(
            currentIndex: 0,
            items: [
              BottomNavigationBarItem(
                  title: new Text('Account'),
                  icon: new Icon(Icons.account_box)),
              BottomNavigationBarItem(
                  icon: new Icon(Icons.mail), title: new Text('Messages')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text('Profile'))
            ],
          ),*/
        ),
      );
    });
  }
/*new BottomNavigationBarItem(
        title: new Text('Home'),
        icon: new Stack(
          children: <Widget>[
            new Icon(Icons.home),
            new Positioned(  // draw a red marble
              top: 0.0,
              right: 0.0,
              child: new Icon(Icons.brightness_1, size: 8.0, 
                color: Colors.redAccent),
            )
          ]
        ),
      )*/

}

import 'package:flutter/material.dart';
import 'package:mor_release/account/details_report.dart';
import 'package:mor_release/account/new_report.dart';
import 'package:mor_release/account/ratio_member.dart';
import 'package:mor_release/account/report.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';

import 'bonus_history.dart';

class ReportInit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('');
  }
}

class ReportTabs extends StatelessWidget {
  final AppBar _appBar = AppBar(
    bottomOpacity: 0.0,
    backgroundColor: Colors.pink[900],
    elevation: 20,
    ///////////////////////Top Tabs Navigation Widget//////////////////////////////
    title: TabBar(
      indicatorColor: Colors.yellow[300],
      indicatorWeight: 6,
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: <Widget>[
        Tab(
          icon: Icon(
            GroovinMaterialIcons.account_check,
            size: 32.0,
            color: Colors.purple[200],
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
        Tab(
          icon: Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned(
                right: 3,
                child: IconButton(
                  onPressed: () {},

                  //BonusHistory(model.userInfo.distrId, model.settings.apiUrl),
                  icon: Icon(
                    GroovinMaterialIcons.file_document,
                    size: 31.0,
                    color: Colors.white38,
                  ),
                ),
              ),
              Positioned(
                  bottom: 5,
                  left: 9,
                  child: Icon(
                    GroovinMaterialIcons.history,
                    size: 25.0,
                    color: Colors.pink[50],
                  )),
            ],
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
        length: 5,
        child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0), child: _appBar),
          body: TabBarView(
            children: <Widget>[
              Report(model.userInfo.distrId, model.settings.apiUrl),
              NewReport(model.userInfo.distrId, model.settings.apiUrl),
              RatioReport(model.userInfo.distrId, model.settings.apiUrl),
              DetailsReport(model.userInfo.distrId, model.settings.apiUrl),
              BonusHistory(model.userInfo.distrId, model.settings.apiUrl),

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
}

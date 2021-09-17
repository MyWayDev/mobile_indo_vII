// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/widgets/color_loader_2.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class BonusHistory extends StatefulWidget {
  final String userId;
  final String apiUrl;
  BonusHistory(this.userId, this.apiUrl);

  State<StatefulWidget> createState() {
    return _BonusHistory();
  }
}

@override
class _BonusHistory extends State<BonusHistory> {
  List<DistrBonus> _distrBonusDesrvList = [];
  List<DistrBonus> searchResult = [];
  TextEditingController controller = new TextEditingController();

  bool _isloading = false;

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

  bool veri = false;
  //int _courier;
  User _nodeData;
  int _sum;
  void resetVeri() {
    veri = false;
  }

  @override
  void initState() {
    _sum = 0;
    _nodeData = null;
    distrBonusHistory(widget.userId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _bonusSum() {
    _distrBonusDesrvList.forEach((b) => _sum += b.bonus.toInt());

    return _sum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,

      //drawer: Container(),
      floatingActionButton: FloatingActionButton(
        elevation: 21.5,
        backgroundColor: Colors.transparent,
        //foregroundColor: Colors.transparent,
        onPressed: () {
          // memberDetailsReportSummary(widget.userId);
          distrBonusHistory(widget.userId);
        },
        child: Icon(
          Icons.refresh,
          size: 32,
          color: Colors.grey[200],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

      body: ModalProgressHUD(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 58,
                color: Theme.of(context).primaryColorLight,
                child: Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.search,
                      size: 22.0,
                    ),
                    title: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "",
                        border: InputBorder.none,
                      ),
                      // style: TextStyle(fontSize: 18.0),
                      onChanged: onSearchTextChanged,
                    ),
                    trailing: IconButton(
                      alignment: AlignmentDirectional.centerEnd,
                      icon: Icon(Icons.cancel, size: 20.0),
                      onPressed: () {
                        controller.clear();
                        onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
              Card(
                  color: Colors.white70,
                  child: ListTile(
                      trailing: Text(' Total : ${_bonusSum().toString()}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      title: Text(
                          ' Deserved Bonuses : ${_distrBonusDesrvList.length}',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)))),
              buildDetailsReport(context),
            ]),
        inAsyncCall: _isloading,
        opacity: 0.6,
        progressIndicator: ColorLoader2(),
      ),
    );
  }

  Future<List<DistrBonus>> distrBonusHistory(String distrId) async {
    isloading(true);
    _distrBonusDesrvList = [];

    final response = await http.get('${widget.apiUrl}/bonus_history/$distrId');
    if (response.statusCode == 200) {
      final _bonus = json.decode(response.body) as List;
      _distrBonusDesrvList =
          _bonus.map((e) => DistrBonus.fromJsonHistory(e)).toList();
    }
    _distrBonusDesrvList
        .forEach((m) => print('${m.distrId}' + ' ' + '${m.bonus}'));
    isloading(false);
    return _distrBonusDesrvList;
  }

  Widget buildDetailsReport(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Expanded(
          child: searchResult.length != 0 ||
                  controller.text.isNotEmpty //members.isNotEmpty

              ? ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (context, i) {
                    return Card(
                      elevation: 15,
                      color: Colors.white70,
                      child: ListTile(
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('${searchResult[i].distrId}'),
                            Text(
                              '${searchResult[i].period}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                                searchResult[i].name.length >= 14
                                    ? searchResult[i].name.substring(0, 14) +
                                        '..'
                                    : searchResult[i].name,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white60))
                          ],
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                                'Bp Pribadi: ${searchResult[i].bonus.toInt()}'),
                          ],
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text('${searchResult[i].accountId}',
                                style: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.bold)),
                            Text('${searchResult[i].branch}',
                                style: TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : _distrBonusDesrvList.isNotEmpty
                  ? ListView.builder(
                      itemCount: _distrBonusDesrvList.length,
                      itemBuilder: (context, i) {
                        return Card(
                          elevation: 13,
                          color: _distrBonusDesrvList[i].status == '1'
                              ? Colors.white
                              : Colors.white10,
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text('${_distrBonusDesrvList[i].period}'),
                                Text('${_distrBonusDesrvList[i].distrId}'),
                                Text(
                                    _distrBonusDesrvList[i].name.length >= 14
                                        ? _distrBonusDesrvList[i]
                                                .name
                                                .substring(0, 14) +
                                            '..'
                                        : _distrBonusDesrvList[i].name,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black))
                              ],
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                    'Bp Pribadi: ${_distrBonusDesrvList[i].bonus.toInt()}'),
                              ],
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('${_distrBonusDesrvList[i].accountId}',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold)),
                                Text('${_distrBonusDesrvList[i].branch}',
                                    style: TextStyle(fontSize: 13)),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Container());
    });
  }

  onSearchTextChanged(String text) {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _distrBonusDesrvList.forEach((item) {
      if (item.name.toLowerCase().contains(text.toLowerCase()) ||
          item.distrId.contains(text)) searchResult.add(item);
    });
    setState(() {});
  }
}

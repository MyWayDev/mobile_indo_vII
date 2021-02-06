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

class DetailsReport extends StatefulWidget {
  final String userId;
  final String apiUrl;
  DetailsReport(this.userId, this.apiUrl);

  State<StatefulWidget> createState() {
    return _DetailsReport();
  }
}

@override
class _DetailsReport extends State<DetailsReport> {
  List<Member> members;
  List<Member> searchResult = [];
  TextEditingController controller = new TextEditingController();
  bool _isloading = false;

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

  bool veri = false;

  @override
  void initState() {
    memberDetailsReportSummary(widget.userId);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      //drawer: Container(),
      floatingActionButton: FloatingActionButton(
        elevation: 21.5,
        backgroundColor: Colors.transparent,
        //foregroundColor: Colors.transparent,
        onPressed: () {
          memberDetailsReportSummary(widget.userId);
        },
        child: Icon(
          Icons.refresh,
          size: 32,
          color: Colors.black38,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,

      body: ModalProgressHUD(
        child: Column(children: <Widget>[
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
          buildDetailsReport(context),
        ]),
        inAsyncCall: _isloading,
        opacity: 0.6,
        progressIndicator: ColorLoader2(),
      ),
    );
  }

  Future<List<Member>> memberDetailsReportSummary(String distrid) async {
    members = [];
    isloading(true);
    http.Response response =
        await http.get('${widget.apiUrl}/report_details/$distrid');
    if (response.statusCode == 200) {
      final _summary = json.decode(response.body) as List;
      members = _summary.map((m) => Member.formJsonDetails(m)).toList();
    }
    isloading(false);
    members.forEach((m) => print('${m.distrId}'));
    return members;
  }

  Widget buildDetailsReport(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Expanded(
          child: searchResult.length != 0 || controller.text.isNotEmpty //
              ? ListView.builder(
                  itemCount: searchResult.length,
                  itemBuilder: (context, i) {
                    return Card(
                          color: Colors.blue[100],
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text('${searchResult[i].distrId}'),
                                Text(
                                    searchResult[i].name.length >= 14
                                        ? searchResult[i]
                                                .name
                                                .substring(0, 14) +
                                            '..'
                                        : searchResult[i].name,
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue[600])),
                                Text('${searchResult[i].areaName}',
                                    style: TextStyle(fontSize: 13)),
                              ],
                            ),
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                members[i].grpCount != 0
                                    ? Text(
                                        'Jumlah Leader: ${searchResult[i].grpCount.toString()}',
                                        style: TextStyle(fontSize: 13))
                                    : Text(''),
                                Text('${searchResult[i].ratio}%',
                                    style: TextStyle(fontSize: 13)),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  searchResult[i].sponsorName.length >= 14
                                      ? searchResult[i]
                                          .sponsorName
                                          .substring(0, 14)
                                      : searchResult[i].sponsorName,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text('${searchResult[i].sponsorId}',
                                    style: TextStyle(fontSize: 13))
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                //  Row(children: <Widget>[],),
                                Text(
                                    'Bp Pribadi : ${searchResult[i].perBp.toInt().toString()}',
                                    style: TextStyle(fontSize: 13)),
                                Text(
                                    'Bp Grup : ${searchResult[i].grpBp.toInt().toString()}',
                                    style: TextStyle(fontSize: 13)),
                                Text(
                                    'Bp Total : ${searchResult[i].totBp.toInt().toString()}',
                                    style: TextStyle(fontSize: 13))
                              ],
                            ),
                          ),
                        ) ??
                        '';
                  },
                )
              : members.isNotEmpty
                  ? ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, i) {
                        return Card(
                              color: Colors.blue[100],
                              child: ListTile(
                                leading: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text('${members[i].distrId}'),
                                    Text(
                                        members[i].name.length >= 14
                                            ? members[i].name.substring(0, 14) +
                                                '..'
                                            : members[i].name,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue[600])),
                                    Text('${members[i].areaName}',
                                        style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                                title: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    members[i].grpCount != 0
                                        ? Text(
                                            'Jumlah Leader: ${members[i].grpCount.toString()}',
                                            style: TextStyle(fontSize: 13))
                                        : Text(''),
                                    Text('${members[i].ratio}%',
                                        style: TextStyle(fontSize: 13)),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      members[i].sponsorName.length >= 14
                                          ? members[i]
                                              .sponsorName
                                              .substring(0, 14)
                                          : members[i].sponsorName,
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text('${members[i].sponsorId}',
                                        style: TextStyle(fontSize: 13))
                                  ],
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    //  Row(children: <Widget>[],),
                                    Text(
                                        'Bp Pribadi : ${members[i].perBp.toInt().toString()}',
                                        style: TextStyle(fontSize: 13)),
                                    Text(
                                        'Bp Grup : ${members[i].grpBp.toInt().toString()}',
                                        style: TextStyle(fontSize: 13)),
                                    Text(
                                        'Bp Total : ${members[i].totBp.toInt().toString()}',
                                        style: TextStyle(fontSize: 13))
                                  ],
                                ),
                              ),
                            ) ??
                            '';
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

    members.forEach((item) {
      if (item.name.toLowerCase().contains(text.toLowerCase()) ||
          item.distrId.contains(text) ||
          item.sponsorId.contains(text) ||
          item.sponsorName.contains(text)) searchResult.add(item);
    });
    setState(() {});
  }
// One entry in the multilevel list displayed by this app.
}

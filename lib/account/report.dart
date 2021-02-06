// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/widgets/color_loader_2.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class Report extends StatefulWidget {
  final String userId;
  final String apiUrl;
  Report(this.userId, this.apiUrl);

  State<StatefulWidget> createState() {
    return _Report();
  }
}

@override
class _Report extends State<Report> {
  Member member;

  TextEditingController distrController = new TextEditingController();
  bool _isloading = false;

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

  bool veri = false;
  //int _courier;
  User _nodeData;

  void resetVeri() {
    distrController.clear();
    veri = false;
  }

  @override
  void initState() {
    distrController.addListener(() {
      setState(() {});
    });
    _nodeData = null;
    memberReportSummary(widget.userId);
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
      floatingActionButton: FloatingActionButton(
        elevation: 21.5,
        backgroundColor: Colors.transparent,
        //foregroundColor: Colors.transparent,
        onPressed: () {
          distrController.text.length <= 8 || !veri
              ? memberReportSummary(widget.userId)
              : memberReportSummary(_nodeData.distrId);
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
        child: Padding(
          padding: EdgeInsets.only(top: 28),
          child: Container(
            child: buildReport(context),
          ),
        ),
        inAsyncCall: _isloading,
        opacity: 0.6,
        progressIndicator: ColorLoader2(),
      ),
    );
  }

  Future<Member> memberReportSummary(String distrid) async {
    isloading(true);
    http.Response response =
        await http.get('${widget.apiUrl}/distrrepsummary/$distrid');
    if (response.statusCode == 200) {
      List _summary = json.decode(response.body);
      member = Member.formJson(_summary[0]);
    }
    isloading(false);
    return member;
  }

  Widget buildReport(BuildContext context) {
    Flushbar flushbar(String flush) {
      return Flushbar(
        messageText: Text('',
            style: TextStyle(fontSize: 15, color: Colors.limeAccent[100])),
        isDismissible: true,
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        mainButton: FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.close,
            color: Colors.amber,
          ),
        ),
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        title: flush,
        message: '',
        icon: Icon(GroovinMaterialIcons.heart_pulse,
            color: Colors.red[400], size: 72),
        boxShadows: [
          BoxShadow(
            color: Colors.red[800],
            offset: Offset(0.0, 2.0),
            blurRadius: 3.0,
          )
        ],
      );
    }

    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return SingleChildScrollView(
        child: Column(children: <Widget>[
          model.userInfo.isleader
              ? ListTile(
                  contentPadding: EdgeInsets.only(left: 8),
                  leading:
                      Icon(Icons.vpn_key, size: 25.0, color: Colors.pink[500]),
                  title: TextFormField(
                    textAlign: TextAlign.center,
                    controller: distrController,
                    enabled: !veri ? true : false,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Masukkan ID member',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  trailing: IconButton(
                    icon: !veri && distrController.text.length > 0
                        ? Icon(
                            Icons.check,
                            size: 30.0,
                            color: Colors.blue,
                          )
                        : distrController.text.length > 0
                            ? Icon(
                                Icons.close,
                                size: 28.0,
                                color: Colors.grey,
                              )
                            : Container(),
                    color: Colors.pink[900],
                    onPressed: () async {
                      if (distrController.text == 'sari') {
                        flushbar(model.settings.flush).show(context);
                      } else {
                        if (!veri) {
                          veri = await model.leaderVerification(
                              distrController.text.padLeft(8, '0'));
                          if (veri) {
                            _nodeData = await model
                                .nodeJson(distrController.text.padLeft(8, '0'));
                            _nodeData.distrId == '00000000'
                                ? resetVeri()
                                : distrController.text =
                                    _nodeData.distrId + '  ' + _nodeData.name;
                            memberReportSummary(_nodeData.distrId);
                          } else {
                            resetVeri();
                            memberReportSummary(widget.userId);
                          }
                        } else {
                          resetVeri();
                          memberReportSummary(widget.userId);
                        }
                      }
                    },
                    splashColor: Colors.pink,
                  ),
                )
              : Container(),
          member != null
              ? Card(
                  color: Colors.grey,
                  child: ListTile(
                      trailing: Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Column(
                          children: <Widget>[
                            Text("Pembaruan terakhir"),
                            Text(
                              '${member.lastUpdate.substring(0, 5)}',
                              style: TextStyle(color: Colors.pink[900]),
                            ),
                          ],
                        ),
                      ),
                      title: Icon(
                        Icons.access_time,
                        size: 28,
                        color: Colors.pink[900],
                      ),
                      leading: Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Column(
                          children: <Widget>[
                            Text("Pembaruan berikutnya"),
                            Text(
                              '${member.nextUpdate.substring(0, 5)}',
                              style: TextStyle(color: Colors.pink[900]),
                            ),
                          ],
                        ),
                      )))
              : Container(),
          member != null
              ? Card(
                  color: Colors.lime[100],
                  child: ListTile(
                    title: Text(
                      '${member.name}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.pink[900]),
                    ),
                  ))
              : Container(),
          member != null
              ? Card(
                    child: ListTile(
                      // leading: Text('${member.name}'),
                      title: member.ratio != 0
                          ? Text('${member.ratio.toInt().toString()}%')
                          : Text(''),
                      subtitle: member.grpCount != 0
                          ? Text(""
                              '${member.grpCount.toInt().toString()} : Jumlah leader')
                          : Text(''),
                      trailing: Column(
                        children: <Widget>[
                          //  Row(children: <Widget>[],),
                          Text(
                              'Bp pribadi : ${member.perBp.toInt().toString()}'),
                          Text('Bp grup : ${member.grpBp.toInt().toString()}')
                        ],
                      ),
                    ),
                  ) ??
                  ''
              : Container()
        ]),
      );
    });
  }
}

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/pages/order/widgets/disrtBonusList.dart';
import 'package:mor_release/scoped/connected.dart';

class BonusDeduct extends StatefulWidget {
  final MainModel model;
  BonusDeduct(this.model, {Key key}) : super(key: key);

  @override
  _BonusDeductState createState() => _BonusDeductState();
}

class _BonusDeductState extends State<BonusDeduct> {
  TextEditingController controller = new TextEditingController();
  User _nodeData;
  bool isTyping;
  bool veri = false;
  bool _isloading = false;
  DistrBonus _userBonus;
  List<DistrBonus> _userBonusList;
  final _formatBonus = new NumberFormat("#,###,###");

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

  void getTyping(MainModel model) {
    setState(() {
      model.isTypeing = isTyping;
    });
  }

  void resetVeri() {
    controller.clear();
    setState(() {
      veri = false;
      _isloading = false;
    });
  }

  final Map<String, dynamic> _orderFormData = {
    'id': null,
    'areaId': null,
    'name': null,
  };
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 33),
          child: Container(height: 34.0, child: bonusDesrvList(context)
              /*RaisedButton(
              onPressed: () async {
                _userBonus = await widget.model
                    .distrBonus(widget.model.userInfo.distrId);
                DistrBonus userBonus = DistrBonus(
                    distrId: _userBonus.distrId,
                    name: widget.model.userInfo.name,
                    status: _userBonus.status,
                    bonus: _userBonus.bonus);
                if (_userBonus != null) {
                  !widget.model.getDistrBonus(widget.model.userInfo.distrId) &&
                          userBonus != null &&
                          userBonus.bonus > 0
                      ? showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (_) => Dialog(
                            elevation: 21,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Container(
                              height: 95,
                              child: Center(
                                child: ListTile(
                                  title: Column(children: <Widget>[
                                    Text(
                                      int.parse(userBonus.distrId).toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.pink[900]),
                                    ),
                                    Text(
                                      userBonus.name,
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(_formatBonus.format(userBonus.bonus) +
                                        ' ' +
                                        'Rp'),
                                  ]),
                                  leading: IconButton(
                                      icon: Icon(
                                        Icons.check,
                                        size: 30,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        widget.model.distrBonusList
                                            .add(userBonus);
                                        Navigator.of(context).pop();
                                      }),
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.close,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Bonus Sudah Terpakai'),
                          ),
                        );
                } else {
                  showDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text('Bonus Sudah Terpakai'),
                    ),
                  );
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              padding: EdgeInsets.all(2.0),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.pink[800], Colors.purple[800]],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Stack(children: <Widget>[
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: 250.0, minHeight: 34.0),
                    alignment: Alignment.bottomRight,
                    child: widget.model.distrBonusList.isNotEmpty
                        ? Text(
                            _formatBonus.format(
                                    widget.model.distrBonusDeductTotal()) +
                                ' ' +
                                'Rp' +
                                ' ',
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold),
                          )
                        : Container(),
                  ),
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: 250.0, minHeight: 34.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Pemotongan Bonus..",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: 100.0, minHeight: 34.0),
                    alignment: Alignment.topLeft,
                    child: widget.model.distrBonusList.isNotEmpty
                        ? BadgeIconButton(
                            itemCount: widget.model.distrBonusList.length,
                            icon: Icon(
                              GroovinMaterialIcons.cash,
                              color: Colors.white,
                              size: 27.5,
                            ),
                            badgeColor: Colors.green,
                            badgeTextColor: Colors.white,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => DistrBonusList(),
                              );
                            },
                          )
                        : Container(),
                  ),
                ]),
              ),
            ),*/
              ),
        ),
      ],
    );
  }

  Widget bonusDesrvList(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isloading,
      opacity: 0.3,
      progressIndicator: LinearProgressIndicator(),
      child: RaisedButton(
        onPressed: () async {
          _userBonusList =
              await widget.model.distrBonusDesrv(widget.model.userInfo.distrId);
          /* DistrBonus userBonus = DistrBonus(
              distrId: _userBonus.distrId,
              name: widget.model.userInfo.name,
              status: _userBonus.status,
              bonus: _userBonus.bonus);
          if (_userBonus != null) {
            !widget.model.getDistrBonus(widget.model.userInfo.distrId) &&
                    userBonus != null &&
                    userBonus.bonus > 0*/
          _userBonusList.isNotEmpty
              ? showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Color(0xFF303030),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      content: Container(
                        width: 165,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(
                          padding: EdgeInsets.only(left: 1, right: 1),
                          height: 355,
                          width: 65,
                          child: Scrollbar(
                              child: ListView.builder(
                                  itemCount: _userBonusList.length,
                                  itemBuilder: (context, i) {
                                    return ElevatedButton(
                                      style: _userBonusList[i].status == '1'
                                          ? ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.purple),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              overlayColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.grey),
                                            )
                                          : ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.grey),
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              overlayColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.grey),
                                            ),
                                      onPressed: _userBonusList[i].status == '1'
                                          ? () {
                                              widget.model.distrBonusList
                                                  .add(_userBonusList[i]);
                                              Navigator.of(context).pop();
                                            }
                                          : null,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              _formatBonus.format(
                                                      _userBonusList[i].bonus) +
                                                  ' ' +
                                                  'Rp',
                                              style: TextStyle(fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  })),
                        ),
                      ),
                    );
                  })
              : showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Bonus Sudah Terpakai'),
                  ),
                );
          /*} else {
            showDialog(
              barrierDismissible: true,
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Bonus Sudah Terpakai'),
              ),R
            );
          }*/
        },
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(2.0),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink[800], Colors.purple[800]],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Stack(children: <Widget>[
            Container(
              constraints: BoxConstraints(maxWidth: 250.0, minHeight: 34.0),
              alignment: Alignment.bottomRight,
              child: widget.model.distrBonusList.isNotEmpty
                  ? Text(
                      _formatBonus
                              .format(widget.model.distrBonusDeductTotal()) +
                          ' ' +
                          'Rp' +
                          ' ',
                      style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold),
                    )
                  : Container(),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 250.0, minHeight: 34.0),
              alignment: Alignment.center,
              child: Text(
                "Pemotongan Bonus..",
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxWidth: 100.0, minHeight: 34.0),
              alignment: Alignment.topLeft,
              child: widget.model.distrBonusList.isNotEmpty
                  ? BadgeIconButton(
                      itemCount: widget.model.distrBonusList.length,
                      icon: Icon(
                        GroovinMaterialIcons.cash,
                        color: Colors.white,
                        size: 27.5,
                      ),
                      badgeColor: Colors.green,
                      badgeTextColor: Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => DistrBonusList(),
                        );
                      },
                    )
                  : Container(),
            ),
          ]),
        ),
      ),
    );
  }
  /* Widget nodeDialog(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isloading,
      opacity: 0.3,
      progressIndicator: LinearProgressIndicator(),
      child: Flex(
        mainAxisSize: MainAxisSize.min,
        direction: Axis.vertical,
        children: <Widget>[
          Dialog(
            backgroundColor: Colors.blueGrey[300],
            elevation: 21,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              width: 120,
              height: 60,
              child: ListTile(
                leading:
                    Icon(Icons.vpn_key, size: 24.0, color: Colors.pink[500]),
                title: TextFormField(
                  textAlign: TextAlign.center,
                  controller: controller,
                  enabled: !veri ? true : false,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'أدخل رقم العضو',
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => value.isEmpty
                      ? 'كود المنتج فارغ !!'
                      : RegExp('[0-9]').hasMatch(value)
                          ? null
                          : 'كود المنتج غير صحيح !!',
                  onSaved: (String value) {
                    _orderFormData['id'] = value.padLeft(8, '0');
                  },
                ),
                trailing: IconButton(
                  icon: !veri //&& controller.text.length > 0
                      ? Icon(
                          Icons.check,
                          size: 30.0,
                          color: Colors.blue[600],
                        )
                      : controller.text.length > 0
                          ? Icon(
                              Icons.close,
                              size: 24.0,
                              color: Colors.grey,
                            )
                          : Container(),
                  color: Colors.pink[900],
                  onPressed: () async {
                    isloading(true);
                    if (!veri) {
                      veri = await widget.model
                          .leaderVerification(controller.text.padLeft(8, '0'));
                      if (veri) {
                        _nodeData = await widget.model.nodeJson(
                          controller.text.padLeft(8, '0'),
                        );
                        print('_nodeData.distrId:${_nodeData.distrId}');
                        _nodeData.distrId == '00000000'
                            ? resetVeri()
                            : controller.text =
                                _nodeData.distrId + '    ' + _nodeData.name;

                        if (_nodeData.distrId == '00000000') {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (_) => nodeDialog(context));
                        } else {
                          Navigator.of(context).pop();
                          setState(() {
                            widget.model.bulkDistrId = _nodeData.distrId;
                          });

                          _userBonus =
                              await widget.model.distrBonus(_nodeData.distrId);
                          if (_userBonus != null) {
                            DistrBonus userBonus = DistrBonus(
                                distrId: _userBonus.distrId,
                                name: _nodeData.name,
                                bonus: _userBonus.bonus);
                            !widget.model.getDistrBonus(_nodeData.distrId) &&
                                    userBonus != null &&
                                    userBonus.bonus > 0
                                ? showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (_) => Dialog(
                                          elevation: 21,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          child: Container(
                                            height: 95,
                                            child: Center(
                                              child: ListTile(
                                                title:
                                                    Column(children: <Widget>[
                                                  Text(
                                                    int.parse(userBonus.distrId)
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Colors.pink[900]),
                                                  ),
                                                  Text(
                                                    userBonus.name,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(_formatBonus
                                                      .format(userBonus.bonus)),
                                                ]),
                                                leading: IconButton(
                                                    icon: Icon(
                                                      Icons.check,
                                                      size: 30,
                                                      color: Colors.green,
                                                    ),
                                                    onPressed: () {
                                                      widget
                                                          .model.distrBonusList
                                                          .add(userBonus);

                                                      Navigator.of(context)
                                                          .pop();
                                                    }),
                                                trailing: IconButton(
                                                  icon: Icon(
                                                    Icons.close,
                                                    size: 30,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                : showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text(
                                              'صرف المكافأة غير متاح حاليا'),
                                        ));
                            resetVeri();
                          } else
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('صرف المكافأة غير متاح حاليا'),
                              ),
                            );
                          resetVeri();
                        }
                      } else {
                        resetVeri();
                      }
                    } else {
                      resetVeri();
                    }
                    isloading(false);
                  },
                  splashColor: Colors.pink,
                ),
              ),
            ),
          ),
          // BackOrderList(),
        ],
      ),
    );
  }*/
}

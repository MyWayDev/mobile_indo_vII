import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/pages/const.dart';
import 'package:mor_release/pages/profile/album.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/widgets/color_loader_2.dart';

class NodeEdit extends StatefulWidget {
  final MainModel model;
  NodeEdit(this.model, {Key key}) : super(key: key);

  @override
  _NodeEditState createState() => _NodeEditState();
}

class _NodeEditState extends State<NodeEdit> {
  TextEditingController cName; //done
  TextEditingController cAddress; //done
  TextEditingController cDistrId; //done
  TextEditingController cPersonalId;
  TextEditingController cTelePhone; //done
  TextEditingController cEmail;
  TextEditingController cBirthDate;
  TextEditingController cBanKAccountNumber; //done
  TextEditingController cBankAccountName;
  TextEditingController cTaxNumber; //done
  TextEditingController cAreaName;
  TextEditingController cAreaId;
  TextEditingController cServiceCenter;
  TextEditingController cheld;

  final FocusNode focusName = new FocusNode();
  final FocusNode focusDistrId = new FocusNode();
  final FocusNode focusPersonalId = new FocusNode();
  final FocusNode focusTelephone = new FocusNode();
  final FocusNode fcousEmail = new FocusNode();
  final FocusNode fcousBirth = new FocusNode();
  final FocusNode focusAreaName = new FocusNode();
  final FocusNode focusAreaId = new FocusNode();
  final FocusNode focusAccountName = new FocusNode();
  final FocusNode focusAddress = new FocusNode();
  final FocusNode focusBankAccount = new FocusNode();
  final FocusNode focusTaxNumber = new FocusNode();
  final FocusNode focusHeld = new FocusNode();
  final FocusNode focusServiceCenter = new FocusNode();

  TextEditingController distrController = new TextEditingController();

  final FocusNode focusDistrController = new FocusNode();

  bool _isloading = false;

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

  bool isChanged = false;
  bool veri = false;
  //int _courier;
  NewMember _nodeData;
  MemberSO _memberSO;

  void resetVeri() {
    distrController.clear();
    cDistrId.clear();
    cName.clear();
    cAddress.clear();
    cEmail.clear();
    cBirthDate.clear();
    cBanKAccountNumber.clear();
    cTaxNumber.clear();
    cTelePhone.clear();
    cPersonalId.clear();
    cBankAccountName.clear();
    cAreaName.clear();
    cServiceCenter.clear();
    isSwitched = false;
    veri = false;
    isChanged = false;
  }

  Future<MemberSO> getMemberSO(String distrId) async {
    final _response = await http
        .get('${widget.model.settings.apiUrl}/get_initial_so/$distrId');
    if (_response.statusCode == 200) {
      final responseData = await json.decode(_response.body);
      _memberSO = MemberSO.fromJson(responseData);
      setState(() {});
      print(_memberSO.soId);
    } else {
      _memberSO = null;
      print('member SO ?');
      setState(() {});
    }
    return _memberSO;
  }

  @override
  void initState() {
    distrController.addListener(() {
      setState(() {});
    });
    //_nodeData = null;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool isSwitched = false;
  bool _isSwitched() {
    setState(() {
      _nodeData.held == '1' ? isSwitched = false : isSwitched = true;
    });
    return isSwitched;
  }

  Future<String> _saveNodeEdit(NewMember nodeData) async {
    isloading(true);
    String msg;
    print(nodeData.editMemberEncode(nodeData));
    Response response =
        await nodeData.editPost(nodeData, widget.model.settings.apiUrl);
    if (response.statusCode == 200) {
      resetVeri();
    }
    response.statusCode == 200 ? msg = 'Updated :)' : msg = 'Failed';
    print(response.statusCode);
    isloading(false);
    setState(() {
      isChanged = false;
    });
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 30,
        clipBehavior: Clip.none,
        child: Stack(fit: StackFit.expand, children: [
          Positioned(
            top: 1,
            right: 8,
            child: Icon(
              Icons.add,
              size: 18,
            ),
          ),
          Positioned(
              bottom: 8,
              left: 2,
              right: 2,
              child: Icon(
                Icons.photo_album,
                size: 32,
              ))
        ]),
        backgroundColor: Colors.pink[500],
        onPressed: () => _profileAlbumBottomSheet(context),
      ),
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text('Edit Member'),
      ),
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        child: buildVeri(context),
        inAsyncCall: _isloading,
        opacity: 0.6,
        progressIndicator: ColorLoader2(),
      ),
    );
  }

  Widget buildVeri(BuildContext context) {
    return SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        reverse: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.only(left: 15),
              leading: Icon(Icons.vpn_key, size: 25.0, color: Colors.pink[500]),
              title: TextFormField(
                focusNode: focusDistrController,
                textAlign: TextAlign.center,
                controller: distrController,
                enabled: !veri ? true : false,
                style: TextStyle(
                    fontSize: 14.5,
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
                        color: Colors.lightBlue,
                      )
                    : distrController.text.length > 0
                        ? Icon(
                            GroovinMaterialIcons.close,
                            size: 24.0,
                            color: Colors.blueGrey,
                          )
                        : Container(),
                color: Colors.pink[900],
                onPressed: () async {
                  isloading(true);
                  if (!veri) {
                    veri = true;
                    // await widget.model
                    //  .leaderVerification(distrController.text.padLeft(8, '0'));
                    if (veri) {
                      _nodeData = await widget.model
                          .nodeEdit(distrController.text.padLeft(8, '0'));
                      getMemberSO(_nodeData.distrId);
                      setState(() {
                        cAreaName =
                            TextEditingController(text: _nodeData.areaName);
                        cServiceCenter = TextEditingController(
                            text: _nodeData.serviceCenter);
                        cDistrId =
                            TextEditingController(text: _nodeData.distrId);
                        cName = TextEditingController(text: _nodeData.name);
                        cAddress =
                            TextEditingController(text: _nodeData.address);
                        cBanKAccountNumber = TextEditingController(
                            text: _nodeData.bankAccountNumber);
                        cTaxNumber =
                            TextEditingController(text: _nodeData.taxNumber);
                        cTelePhone =
                            TextEditingController(text: _nodeData.telephone);
                        cPersonalId =
                            TextEditingController(text: _nodeData.personalId);
                        cBankAccountName = TextEditingController(
                            text: _nodeData.bankAccoutName);
                        cBirthDate =
                            TextEditingController(text: _nodeData.birthDate);
                        cEmail = TextEditingController(text: _nodeData.email);
                        _isSwitched();
                      });

                      setState(() {});
                      _nodeData.distrId == '00000000'
                          ? resetVeri()
                          : distrController.text =
                              _nodeData.distrId + '  ' + _nodeData.name;
                      isloading(false);
                    } else {
                      resetVeri();
                      isloading(false);
                    }
                  } else {
                    resetVeri();
                    isloading(false);
                  }
                },
                splashColor: Colors.pink,
              ),
            ),
            ListTile(
                leading: Container(
                  child: Text(
                    'Birth Date',
                    style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey),
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
                title: Container(
                  child: Theme(
                      data: Theme.of(context)
                          .copyWith(primaryColor: primaryColor),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        enabled: veri,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'BirthDate',
                          contentPadding: EdgeInsets.all(3.0),
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        controller: cBirthDate,
                        onChanged: (value) {
                          setState(() {
                            _nodeData.birthDate = value;
                            isChanged = true;
                          });
                        },
                        focusNode: fcousBirth,
                      )),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                ),
                trailing: Switch(
                  inactiveTrackColor:
                      veri ? Colors.red[200] : Colors.transparent,
                  activeTrackColor: Colors.green[200],
                  value: isSwitched,
                  onChanged: (bool value) {
                    setState(() {
                      isSwitched = value;
                      isSwitched ? _nodeData.held = '0' : _nodeData.held = '1';
                      isChanged = true;
                    });
                  },
                  activeThumbImage:
                      veri ? AssetImage('assets/images/check.jpg') : null,
                  inactiveThumbImage:
                      veri ? AssetImage('assets/images/xmark.png') : null,
                )),
            Container(
              child: Theme(
                data: Theme.of(context).copyWith(primaryColor: primaryColor),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                  enabled: veri,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    contentPadding: EdgeInsets.all(1.0),
                    hintStyle: TextStyle(color: greyColor),
                  ),
                  controller: cName,
                  onChanged: (value) {
                    setState(() {
                      _nodeData.name = value;
                      isChanged = true;
                    });
                  },
                  focusNode: focusName,
                ),
              ),
              margin: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 5),
            ),
            Container(
              child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                          child: Column(children: <Widget>[
                        Container(
                          child: Text(
                            'Personal Id',
                            style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          //  margin: EdgeInsets.only(left: 30.0),
                        ),
                        TextFormField(
                          enabled: veri,
                          style: TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Personal Id',
                            contentPadding: EdgeInsets.all(3.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: cPersonalId,
                          onChanged: (value) {
                            setState(() {
                              _nodeData.personalId = value;
                              isChanged = true;
                            });
                          },
                          focusNode: focusPersonalId,
                        ),
                      ])),
                      Padding(padding: EdgeInsets.all(10)),
                      Expanded(
                          child: Column(children: <Widget>[
                        Container(
                          child: Text(
                            'Telephone',
                            style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          // margin: EdgeInsets.only(left: 30.0),
                        ),
                        TextFormField(
                          enabled: veri,
                          style: TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Telephone',
                            contentPadding: EdgeInsets.all(3.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: cTelePhone,
                          onChanged: (value) {
                            setState(() {
                              _nodeData.telephone = value;
                              isChanged = true;
                            });
                          },
                          focusNode: focusTelephone,
                        )
                      ]))
                    ]),
                  ])),
              margin: EdgeInsets.only(left: 30.0, right: 5.0, bottom: 5),
            ),
            Container(
              child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: Column(children: <Widget>[
                    Row(children: <Widget>[
                      Expanded(
                          child: Column(children: <Widget>[
                        Container(
                          child: Text(
                            'Address',
                            style: TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          margin: EdgeInsets.only(left: 5.0),
                        ),
                        TextFormField(
                          enabled: veri,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Address',
                            contentPadding: EdgeInsets.all(3.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: cAddress,
                          onChanged: (value) {
                            setState(() {
                              _nodeData.address = value;
                              isChanged = true;
                            });
                          },
                          focusNode: focusAddress,
                        ),
                      ])),
                      Padding(padding: EdgeInsets.all(10)),
                      Expanded(
                          child: Column(children: <Widget>[
                        Container(
                          child: Text(
                            'email',
                            style: TextStyle(
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          margin: EdgeInsets.only(left: 5.0),
                        ),
                        TextFormField(
                          enabled: veri,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'email',
                            contentPadding: EdgeInsets.all(3.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: cEmail,
                          onChanged: (value) {
                            setState(() {
                              _nodeData.email = value;
                              isChanged = true;
                            });
                          },
                          focusNode: fcousEmail,
                        ),
                      ]))
                    ])
                  ])),
              margin: EdgeInsets.only(left: 20.0, right: 5.0),
            ),
            ListTile(
              leading: Container(
                child: Text(
                  'Area / Branch',
                  style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
                margin: EdgeInsets.only(left: 15.0),
              ),
              title: Container(
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: TextFormField(
                    enabled: false,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Area',
                      contentPadding: EdgeInsets.all(3.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cAreaName,
                    onChanged: (value) {
                      setState(() {
                        _nodeData.areaName = value;
                      });
                    },
                    focusNode: focusAreaName,
                  ),
                ),
                margin: EdgeInsets.only(left: 50.0, right: 30.0),
              ),
              subtitle: Container(
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: TextFormField(
                    enabled: false,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Branch',
                      contentPadding: EdgeInsets.all(3.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cServiceCenter,
                    onChanged: (value) {
                      setState(() {
                        _nodeData.serviceCenter = value;
                      });
                    },
                  ),
                ),
                margin: EdgeInsets.only(left: 50.0, right: 30.0, bottom: 5),
              ),
            ),
            ListTile(
              leading: Container(
                child: Text(
                  'Bank Account / Name',
                  style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                margin: EdgeInsets.only(left: 15.0),
              ),
              title: Container(
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: TextFormField(
                    enabled: veri,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Bank Account',
                      contentPadding: EdgeInsets.all(5.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cBanKAccountNumber,
                    onChanged: (value) {
                      setState(() {
                        _nodeData.bankAccountNumber = value;
                        isChanged = true;
                      });
                    },
                    focusNode: focusBankAccount,
                  ),
                ),
                margin: EdgeInsets.only(left: 1.0, right: 30.0),
              ),
              subtitle: Container(
                child: Theme(
                  data: Theme.of(context).copyWith(primaryColor: primaryColor),
                  child: TextFormField(
                    enabled: veri,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Account Name',
                      contentPadding: EdgeInsets.all(3.0),
                      hintStyle: TextStyle(color: greyColor),
                    ),
                    controller: cBankAccountName,
                    onChanged: (value) {
                      setState(() {
                        _nodeData.bankAccoutName = value;
                        isChanged = true;
                      });
                    },
                    focusNode: focusAccountName,
                  ),
                ),
                margin: EdgeInsets.only(left: 1.0, right: 30.0),
              ),
            ),
            Container(
              child: Text(
                'Tax Number',
                style: TextStyle(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              margin: EdgeInsets.only(left: 30.0),
            ),
            Container(
              child: Theme(
                data: Theme.of(context).copyWith(primaryColor: primaryColor),
                child: TextFormField(
                  enabled: veri,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Tax Number',
                    hintStyle: TextStyle(color: greyColor, fontSize: 12),
                  ),
                  controller: cTaxNumber,
                  onChanged: (value) {
                    setState(() {
                      _nodeData.taxNumber = value;
                      isChanged = true;
                    });
                  },
                  focusNode: focusTaxNumber,
                ),
              ),
              margin: EdgeInsets.only(left: 30.0, right: 30.0),
            ),
            Padding(
              padding: EdgeInsets.all(5),
            ),
            veri
                ? ButtonBar(
                    mainAxisSize: MainAxisSize.max,
                    alignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      isChanged
                          ? RaisedButton(
                              elevation: 11,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(21.0)),
                              child: Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.green[700],
                              onPressed: () async {
                                String _msg = await _saveNodeEdit(_nodeData);
                                showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                          title: Text(_msg),
                                          actions: <Widget>[
                                            FlatButton(
                                              highlightColor:
                                                  Colors.greenAccent,
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Colors.red[400],
                                                      width: 2.5,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              color: Colors.white,
                                              child: Text(
                                                'Close',
                                                style: TextStyle(
                                                    color: Colors.red[900],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                          ],
                                        ));
                              },
                            )
                          : Container(),
                      RaisedButton(
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21.0)),
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.yellow[100]),
                          ),
                          color: Colors.red[900],
                          disabledColor: Colors.blueGrey[200],
                          onPressed: _memberSO != null
                              ? () => showDialog(
                                    context: context,
                                    builder: (context) => ModalProgressHUD(
                                      child: Container(
                                          child: AlertDialog(
                                        elevation: 15,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(21.0)),
                                        title: Text(
                                          'Confirm Delete ?',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        content: Text(
                                          'Member: ${_nodeData.distrId}',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                        actions: <Widget>[
                                          FlatButton(
                                            highlightColor: Colors.greenAccent,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color:
                                                        Colors.greenAccent[400],
                                                    width: 2.5,
                                                    style: BorderStyle.solid),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            color: Colors.white,
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  color: Colors.green[900],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                          SizedBox(
                                            width: 21,
                                          ),
                                          FlatButton(
                                              colorBrightness: Brightness.light,
                                              highlightColor:
                                                  Colors.redAccent[400],
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color:
                                                          Colors.redAccent[400],
                                                      width: 2.5,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              color: Colors.white,
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.pink[900],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () async {
                                                String _deleteMsg;
                                                // Navigator.of(context).pop();
                                                isloading(true);
                                                _deleteMsg =
                                                    await deleteMemberSO();
                                                isloading(false);
                                                showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                          title:
                                                              Text(_deleteMsg),
                                                          actions: <Widget>[
                                                            FlatButton(
                                                                highlightColor:
                                                                    Colors
                                                                        .greenAccent,
                                                                shape: RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        color: Colors.red[
                                                                            400],
                                                                        width:
                                                                            2.5,
                                                                        style: BorderStyle
                                                                            .solid),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            50)),
                                                                color: Colors
                                                                    .white,
                                                                child: Text(
                                                                  'Close',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .red[
                                                                          900],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                onPressed: () {
                                                                  resetVeri();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                }),
                                                          ],
                                                        ));
                                              }),
                                        ],
                                      )),
                                      inAsyncCall: _isloading,
                                      opacity: 0.6,
                                      progressIndicator: ColorLoader2(),
                                    ),
                                  )
                              : null)
                    ],
                  )
                : Container(),
          ],
        ));
  }

  Future<String> deleteMemberSO() async {
    String _msg = '';
    http.Response response = await http.post(
        '${widget.model.settings.apiUrl}/delete_distr/${_nodeData.distrId}/${_memberSO.soId}/${_nodeData.serviceCenter}/${_memberSO.soType}/${_nodeData.serviceCenter}');
    if (response.statusCode == 200) {
      _msg = 'Deleted';
    } else {
      _msg = 'Error';
    }
    return _msg;
  }

  void _profileAlbumBottomSheet(context) {
    showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.white70,
        elevation: 26,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return ProfileAlbum(
            model: widget.model,
            idPhotoUrl: widget.model.userInfo.idPhotoUrl,
            taxPhotoUrl: widget.model.userInfo.taxPhotoUrl,
            bankPhotoUrl: widget.model.userInfo.bankPhotoUrl,
          );
        });
  }
}

class MemberSO {
  String soId;
  String soType;

  MemberSO({
    this.soId,
    this.soType,
  });
  toJson() {
    return {"DOC_ID": soId, "SO_INV_TYPE": soType};
  }

  factory MemberSO.fromJson(Map<String, dynamic> json) {
    return MemberSO(
        soId: json['DOC_ID'] ?? '', soType: json['SO_INV_TYPE'] ?? '');
  }

  String memberSOToJson(MemberSO memberSO) {
    final dyn = memberSO.toJson();
    return json.encode(dyn);
  }
}

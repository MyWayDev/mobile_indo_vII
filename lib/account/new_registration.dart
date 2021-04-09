import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/area.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/pages/order/widgets/areaDropdown.dart';
import 'package:mor_release/pages/order/widgets/shipmentArea.dart';
import 'package:mor_release/pages/order/widgets/storeFloat.dart';
import 'package:mor_release/pages/profile/bankDropdown.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/widgets/color_loader_2.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:mor_release/pages/profile/album.dart';
import 'package:intl/intl.dart';

class NewReg extends StatefulWidget {
  final MainModel model;

  NewReg(this.model);
  //final List<Area> areas;
  // NewMemberPage(this.areas);
  State<StatefulWidget> createState() {
    return _NewReg();
  }
}

//final FirebaseDatabase dataBase = FirebaseDatabase.instance;
@override
class _NewReg extends State<NewReg> {
  final String path = 'flamelink/environments/indoStage/content/region/en-US/';
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final TextEditingController controller = new TextEditingController();
  final _newMemberFormKey = GlobalKey<FormState>();
  final doubleFormat = new NumberFormat("####.##");
  final formatter = new NumberFormat("#,###");

  final NewMember _newMemberForm = NewMember(
    serviceCenter: null,
    sponsorId: null, //* Form value
    familyName: null, //* empty
    name: null, //*Form value
    personalId: null, //*Form value
    birthDate: '', //*Form value
    email: '', //*Form value
    telephone: null, //*Form value
    address: null, //*Form value
    areaId: '', //*Form value
    bankAccoutName: null, //*Form value
    bankAccountNumber: null, //*Form value
    taxNumber: null, //*Form value
    bankId: null, //*Form value
    rate: 0, //*CR DOCS POPUP value
    shipmentCompany: '', //*CR DOCS POPUP value
  );

  AutovalidateMode _autoValidateMode;

  DateTime selected;
  User _nodeData;
  bool _loading = false;
  bool validData = false;
  bool veri = false;
  bool _isloading = false;

  @override
  void initState() {
    _autoValidateMode = AutovalidateMode.onUserInteraction;
    widget.model.areaDropDownValue =
        AreaPlace(areaId: '', areaName: '', shipmentPlace: '', spName: '');
    widget.model.bankDropDownValue = Bank(bankId: '', bankName: '');
    super.initState();
  }

  @override
  void dispose() {
    widget.model.newRegcourierFee = 0;
    widget.model.areaDropDownValue =
        AreaPlace(areaId: '', areaName: '', shipmentPlace: '');
    widget.model.bankDropDownValue = Bank(bankId: '', bankName: '');

    if (_newMemberFormKey.currentState != null)
      _newMemberFormKey.currentState.reset();
    controller.dispose();
    super.dispose();
  }

  isloading(bool i) {
    if (mounted) {
      setState(() {
        _isloading = i;
      });
    }
  }

  resetVeri() {
    controller.clear();
    if (mounted) {
      setState(() {
        veri = false;
        _isloading = false;
      });
    }
  }

  _showDateTimePicker(String userId) async {
    selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));
    // locale: Locale('fr'));
    if (mounted) {
      setState(() {});
    }
  }

  _profileAlbumBottomSheet(context, MainModel model) {
    showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.white70,
        elevation: 26,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return ProfileAlbum(
            model: model,
            idPhotoUrl: model.userInfo.idPhotoUrl,
            taxPhotoUrl: model.userInfo.taxPhotoUrl,
            bankPhotoUrl: model.userInfo.bankPhotoUrl,
          );
        });
  }

  bool validateAndSave(String userId, String sc) {
    //final form = _newMemberFormKey.currentState;
    isloading(true);
    _newMemberForm.birthDate =
        DateFormat('yyyy-MM-dd').format(selected).toString();
    _newMemberForm.email = userId;
    _newMemberForm.areaId = 'getplace(placeSplit.first).areaId';
    _newMemberForm.serviceCenter = sc;
    if (mounted) {
      setState(() {
        validData = _newMemberFormKey.currentState.validate();
      });
    }
    // isloading(true);
    print('valide entry $validData');
    _newMemberFormKey.currentState.save();

    print('${_newMemberForm.sponsorId}:${_newMemberForm.birthDate}');
    isloading(false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          floatingActionButton: FloatingActionButton.extended(
              onPressed: null,
              label: StoreFloat(model),
              isExtended: true,
              elevation: 30,
              backgroundColor: Colors.transparent),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
          body: ModalProgressHUD(
            child: buildRegForm(context),
            inAsyncCall: _isloading,
            opacity: 0.6,
            progressIndicator: ColorLoader2(),
          ),
        );
      },
    );
  }

  Widget buildRegForm(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          floatingActionButton: veri
              ? FloatingActionButton(
                  mini: true,
                  elevation: 30,
                  clipBehavior: Clip.hardEdge,
                  child: Stack(fit: StackFit.expand, children: [
                    Positioned(
                      top: 2,
                      right: 4.5,
                      child: Icon(
                        Icons.add,
                        size: 11,
                      ),
                    ),
                    Positioned(
                        bottom: 8,
                        left: 2,
                        right: 2,
                        child: Icon(
                          Icons.photo_album,
                          size: 24,
                        ))
                  ]),
                  backgroundColor: Colors.pink[500],
                  onPressed: () => _profileAlbumBottomSheet(context, model),
                )
              : null,
          body: Container(
            child: Form(
              autovalidateMode: AutovalidateMode.disabled,
              key: _newMemberFormKey,
              child: ListView(
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.all(6.0),
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints.expand(height: 700, width: 600),
                        child: SingleChildScrollView(
                          primary: true,
                          child: Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                ListTile(
                                  contentPadding: EdgeInsets.only(left: 6),
                                  leading: Icon(Icons.vpn_key,
                                      size: 25.0, color: Colors.pink[500]),
                                  title: TextFormField(
                                    textAlign: TextAlign.center,
                                    controller: controller,
                                    enabled: !veri ? true : false,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText: ' Masukkan ID sponsor',
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400]),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) => value.isEmpty
                                        ? 'Code is Empty !!'
                                        : RegExp('[0-9]').hasMatch(value)
                                            ? null
                                            : 'invalid code !!',
                                    onSaved: (_) {
                                      _newMemberForm.sponsorId =
                                          _nodeData.distrId;
                                    },
                                  ),
                                  trailing: IconButton(
                                    icon: !veri && controller.text.length > 0
                                        ? Icon(
                                            Icons.check,
                                            size: 30.0,
                                            color: Colors.blue,
                                          )
                                        : controller.text.length > 0
                                            ? Icon(
                                                Icons.close,
                                                size: 28.0,
                                                color: Colors.grey,
                                              )
                                            : Container(),
                                    color: Colors.pink[900],
                                    onPressed: () async {
                                      isloading(true);
                                      if (!veri) {
                                        veri = await model.leaderVerification(
                                            controller.text.padLeft(8, '0'));
                                        if (veri) {
                                          _nodeData = await model.nodeJson(
                                              controller.text.padLeft(8, '0'));
                                          _nodeData.distrId == '00000000'
                                              ? resetVeri()
                                              : controller.text =
                                                  _nodeData.distrId +
                                                      ' ' +
                                                      _nodeData.name;
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
                                ModalProgressHUD(
                                    inAsyncCall: _loading,
                                    opacity: 0.6,
                                    progressIndicator: ColorLoader2(),
                                    child: veri
                                        ? Container(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      flex: 1,
                                                      child: TextFormField(
                                                        autovalidateMode:
                                                            _autoValidateMode,
                                                        decoration: InputDecoration(
                                                            labelStyle:
                                                                TextStyle(
                                                                    fontSize:
                                                                        13),
                                                            labelText: 'Nama',
                                                            contentPadding:
                                                                EdgeInsets.all(
                                                                    1.0),
                                                            icon: Icon(
                                                                GroovinMaterialIcons
                                                                    .format_title,
                                                                color:
                                                                    Colors.pink[
                                                                        500])),
                                                        validator: (value) {
                                                          if (value.length <
                                                              6) {
                                                            return 'Nama anggota tidak valid';
                                                          } else
                                                            return null;
                                                        },
                                                        keyboardType:
                                                            TextInputType.text,
                                                        onSaved:
                                                            (String value) {
                                                          _newMemberForm.name =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 16,
                                                          left: 13,
                                                          right: 13),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 1),
                                                            child:
                                                                selected == null
                                                                    ? Text(
                                                                        'Tanggal lahir',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Colors.grey[700]),
                                                                      )
                                                                    : Text(''),
                                                          ),
                                                          RawMaterialButton(
                                                            child: Icon(
                                                              GroovinMaterialIcons
                                                                  .calendar_check,
                                                              size: 24.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            shape:
                                                                CircleBorder(),
                                                            highlightColor:
                                                                Colors
                                                                    .pink[500],
                                                            elevation: 8,
                                                            fillColor: Colors
                                                                .pink[500],
                                                            onPressed: () {
                                                              _showDateTimePicker(
                                                                  model.userInfo
                                                                      .distrId);
                                                            },
                                                            splashColor: Colors
                                                                .pink[900],
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(top: 2),
                                                              child: selected !=
                                                                      null
                                                                  ? Text(DateFormat(
                                                                          'yyyy-MM-dd')
                                                                      .format(
                                                                          selected)
                                                                      .toString())
                                                                  : Center(
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            22,
                                                                        width:
                                                                            138,
                                                                        child: TextFormField(
                                                                            decoration: InputDecoration(
                                                                              border: InputBorder.none,
                                                                            ),
                                                                            autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                            validator: (value) {
                                                                              value = '';
                                                                              /*selected ==
                                                                              null
                                                                          ? selected
                                                                              .toString()
                                                                          : '';*/

                                                                              if (value.isEmpty || value == '') {
                                                                                return 'silahkan pilih birth Date';
                                                                              } else
                                                                                return null;
                                                                            }),
                                                                      ),
                                                                    )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Wrap(
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Flexible(
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                                fontSize: 13.5),
                                                            autovalidateMode:
                                                                _autoValidateMode,
                                                            decoration: InputDecoration(
                                                                labelStyle:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                labelText:
                                                                    'Nomor tanda pengenal',
                                                                filled: true,
                                                                fillColor: Colors
                                                                    .transparent,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            4.0),
                                                                icon: Icon(
                                                                    Icons
                                                                        .assignment_ind,
                                                                    color: Colors
                                                                            .pink[
                                                                        500])),
                                                            validator: (value) {
                                                              if (value.length <
                                                                      16 ||
                                                                  value.length >
                                                                      16) {
                                                                return 'masukkan 16 angka';
                                                              } else
                                                                return null;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            onSaved:
                                                                (String value) {
                                                              _newMemberForm
                                                                      .personalId =
                                                                  value;
                                                            },
                                                          ),
                                                        ),
                                                        Flexible(
                                                          fit: FlexFit.tight,
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                                fontSize: 13.5),
                                                            autovalidateMode:
                                                                _autoValidateMode,
                                                            decoration:
                                                                InputDecoration(
                                                                    labelStyle: TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                    labelText:
                                                                        'Nomor telepon',
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .transparent,
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            2.0),
                                                                    icon: Icon(
                                                                      Icons
                                                                          .phone,
                                                                      color: Colors
                                                                              .pink[
                                                                          500],
                                                                    )),
                                                            validator: (value) {
                                                              if (value.length <
                                                                  10) {
                                                                return 'minimal 10 angka';
                                                              } else
                                                                return null;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .numberWithOptions(
                                                                        signed:
                                                                            true),
                                                            onSaved:
                                                                (String value) {
                                                              _newMemberForm
                                                                      .telephone =
                                                                  value;
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 212,
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                                fontSize: 13.5),
                                                            autovalidateMode:
                                                                _autoValidateMode,
                                                            maxLines: 7,
                                                            decoration:
                                                                InputDecoration(
                                                                    labelStyle: TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                    labelText:
                                                                        'Alamat',
                                                                    filled:
                                                                        true,
                                                                    fillColor:
                                                                        Colors
                                                                            .transparent,
                                                                    contentPadding:
                                                                        EdgeInsets.all(
                                                                            2.0),
                                                                    icon: Icon(
                                                                      GroovinMaterialIcons
                                                                          .home,
                                                                      color: Colors
                                                                              .pink[
                                                                          500],
                                                                    )),
                                                            validator: (value) {
                                                              if (value.length <
                                                                  9) {
                                                                return 'tulis alamat lengkap';
                                                              } else
                                                                return null;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .streetAddress,
                                                            onSaved:
                                                                (String value) {
                                                              _newMemberForm
                                                                      .address =
                                                                  value;
                                                            },
                                                          ),
                                                        ),
                                                        Icon(Icons.location_on,
                                                            color: Colors
                                                                .pink[500],
                                                            size: 22),
                                                        Expanded(
                                                          child: Wrap(
                                                            children: [
                                                              AreaDropdown(
                                                                model,
                                                                isInsert: true,
                                                              ),
                                                              Container(
                                                                  height: 22,
                                                                  child: TextFormField(
                                                                      decoration: InputDecoration(
                                                                        border:
                                                                            InputBorder.none,
                                                                      ),
                                                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                      validator: (value) {
                                                                        value = widget
                                                                            .model
                                                                            .areaDropDownValue
                                                                            .shipmentPlace;

                                                                        if (value.isEmpty ||
                                                                            value ==
                                                                                '') {
                                                                          return '    silahkan pilih area';
                                                                        } else
                                                                          return null;
                                                                      }))
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 212,
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            fontSize: 13.5),
                                                        autovalidateMode:
                                                            _autoValidateMode,
                                                        decoration:
                                                            InputDecoration(
                                                                labelStyle:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                labelText:
                                                                    'Nama Pemilik Rekening',
                                                                filled: true,
                                                                fillColor: Colors
                                                                    .transparent,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            2.0),
                                                                icon: Icon(
                                                                  GroovinMaterialIcons
                                                                      .account,
                                                                  color: Colors
                                                                          .pink[
                                                                      500],
                                                                )),
                                                        validator: (value) {
                                                          if (value.length <
                                                              3) {
                                                            return 'tulis nama lengkap';
                                                          } else
                                                            return null;
                                                        },
                                                        keyboardType:
                                                            TextInputType.text,
                                                        onSaved:
                                                            (String value) {
                                                          _newMemberForm
                                                                  .bankAccoutName =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                    Icon(
                                                        GroovinMaterialIcons
                                                            .bank,
                                                        color: Colors.pink[500],
                                                        size: 19),
                                                    Expanded(
                                                        child: Wrap(
                                                      children: [
                                                        BankDropdown(
                                                          model,
                                                          isInsert: true,
                                                        ),
                                                        Container(
                                                            height: 22,
                                                            child:
                                                                TextFormField(
                                                                    decoration:
                                                                        InputDecoration(
                                                                      border: InputBorder
                                                                          .none,
                                                                    ),
                                                                    autovalidateMode:
                                                                        AutovalidateMode
                                                                            .onUserInteraction,
                                                                    validator:
                                                                        (value) {
                                                                      print(
                                                                          'bankId=>${widget.model.bankDropDownValue.bankId}');
                                                                      value = widget
                                                                          .model
                                                                          .bankDropDownValue
                                                                          .bankId;

                                                                      if (value
                                                                              .isEmpty ||
                                                                          value ==
                                                                              null ||
                                                                          value ==
                                                                              '') {
                                                                        return '    silahkan pilih bank';
                                                                      } else
                                                                        return null;
                                                                    }))
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            fontSize: 13.5),
                                                        autovalidateMode:
                                                            _autoValidateMode,
                                                        decoration:
                                                            InputDecoration(
                                                          labelStyle: TextStyle(
                                                              fontSize: 13),
                                                          labelText:
                                                              'Nomor Rekening',
                                                          filled: true,
                                                          fillColor: Colors
                                                              .transparent,
                                                          contentPadding:
                                                              EdgeInsets.only(
                                                                  top: 0.0),
                                                          icon: Icon(
                                                            GroovinMaterialIcons
                                                                .numeric,
                                                            color: Colors
                                                                .pink[500],
                                                          ),
                                                        ),
                                                        //!fix
                                                        validator: (value) {
                                                          if (value.length <
                                                              10) {
                                                            return 'minimal 10 angka';
                                                          } else
                                                            return null;
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onSaved:
                                                            (String value) {
                                                          _newMemberForm
                                                                  .bankAccountNumber =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            fontSize: 13.5),
                                                        autovalidateMode:
                                                            _autoValidateMode,
                                                        decoration:
                                                            InputDecoration(
                                                                labelStyle:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                labelText:
                                                                    'NPWP',
                                                                filled: true,
                                                                fillColor: Colors
                                                                    .transparent,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            0.0),
                                                                icon: Icon(
                                                                  GroovinMaterialIcons
                                                                      .tag_text_outline,
                                                                  color: Colors
                                                                          .pink[
                                                                      500],
                                                                )),
                                                        validator: (value) {
                                                          if (value.length <
                                                                  15 ||
                                                              value.length >
                                                                  15) {
                                                            return 'masukkan 15 angka';
                                                          }

                                                          return null;
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onSaved:
                                                            (String value) {
                                                          _newMemberForm
                                                                  .taxNumber =
                                                              value;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container()),
                                model.newRegcourierFee > 0 && validData
                                    ? Container(
                                        height: 16,
                                        child: ListTile(
                                          title: Text(
                                            'Courier Fee',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                            // textDirection: TextDirection.rtl,
                                          ),
                                          trailing: Text(
                                            formatter.format(
                                                    model.newRegcourierFee > 0
                                                        ? model.newRegcourierFee
                                                        : 0) +
                                                ' Rp ',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          leading: Icon(
                                            GroovinMaterialIcons.truck,
                                            size: 22,
                                            color: Colors.black,
                                          ),
                                        ))
                                    : Container(),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 16),
                                ),
                                validData
                                    ? Container(
                                        height: 16,
                                        child: ListTile(
                                          title: Text(
                                            'Membership Fee',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Text(
                                            formatter.format(double.tryParse(
                                                    model.settings.catCode)) +
                                                ' Rp',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          leading: Icon(
                                            GroovinMaterialIcons.account_plus,
                                            size: 22,
                                            color: Colors.black,
                                          ),
                                        ))
                                    : Container(),
                                Padding(padding: EdgeInsets.only(bottom: 22)),
                                validData
                                    ? Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          widget.model.newRegcourierFee > 0 &&
                                                  model.docType == 'CR'
                                              ? Expanded(
                                                  flex: 1,
                                                  child: RawMaterialButton(
                                                    fillColor:
                                                        Colors.tealAccent[400],
                                                    splashColor:
                                                        Colors.pink[500],
                                                    constraints: BoxConstraints(
                                                        maxWidth: 45,
                                                        maxHeight: 45),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30.0)),
                                                    child: Container(
                                                      height: 34,
                                                      child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Icon(
                                                              GroovinMaterialIcons
                                                                  .cash_multiple,
                                                              size: 24,
                                                              color: Color(
                                                                  0xFF303030),
                                                            ),
                                                            Text(
                                                              'Total',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                              // textDirection: TextDirection.rtl,
                                                            ),
                                                            Text(
                                                              formatter.format(model
                                                                          .newRegcourierFee +
                                                                      double.tryParse(model
                                                                          .settings
                                                                          .catCode)) +
                                                                  ' Rp ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.2,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ]),
                                                    ),
                                                    onPressed: () {},
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      )
                                    : Container(),
                                veri
                                    ? Container(
                                        child: RawMaterialButton(
                                            constraints: BoxConstraints(
                                                minWidth: 40, minHeight: 40),
                                            splashColor: Color(0xFF303030),
                                            shape: CircleBorder(),
                                            highlightColor: Colors.pink[500],
                                            elevation: 8,
                                            fillColor: model.docType == 'CR'
                                                ? Color(0xFF303030)
                                                : Colors.green,
                                            child: Icon(
                                              model.docType == 'CR'
                                                  ? GroovinMaterialIcons.truck
                                                  : Icons.check,
                                              color: Colors.amber,
                                              size: 27,
                                            ),
                                            onPressed: () async {
                                              if (validData) {
                                                model.newRegcourierFee = 0;
                                                model.docType == 'CR'
                                                    ? showDialog(
                                                        context: context,
                                                        builder: (_) {
                                                          return ShipmentPlace(
                                                            model: model,
                                                            memberId: model
                                                                .userInfo
                                                                .distrId,
                                                            isEdit: true,
                                                            isNewMember: true,
                                                          );
                                                        })
                                                    : Container();
                                              } else {
                                                _autoValidateMode =
                                                    AutovalidateMode.always;
                                                showDialog(
                                                    context: context,
                                                    child: AlertDialog(
                                                      title: Text("Your Title"),
                                                      content: Text(
                                                          '${_newMemberFormKey.currentState.validate()}'),
                                                    ));
                                              }
                                              //* add save Funcion

                                              /*
                                                        //!fix
                                                         String msg = '';
                                            if (validateAndSave(
                                                model.userInfo.distrId,
                                                model.setStoreId)) {
                                              msg = await saveNewMember(
                                                  model.settings.apiUrl,
                                                  model.userInfo.distrId,
                                                  model.docType,
                                                  model.shipmentAddress,
                                                  model.setStoreId);
                                              showReview(context, msg);

                                              _newMemberFormKey.currentState
                                                  .reset();

                                              PaymentInfo(model)
                                                  .flushAction(context)
                                                  .show(context);*/
                                            }

                                            //  s

                                            //_newMemberFormKey.currentState.reset();

                                            ))
                                    : Container()
                              ])),
                        ),
                      )),
                ],
              ),
            ), //this line
          ));
    });
  }

  String errorM = '';
  Future<String> saveNewMember(String user, String docType, String storeId,
      String apiUrl, String address) async {
    //  print('docType:$docType:storeId:$storeId');
    Id body;
    String msg;
    isloading(true);
    //  print(_newMemberForm.postNewMemberToJson(_newMemberForm));
    Response response = await _newMemberForm.newMemberCreatePost(
        apiUrl,
        _newMemberForm,
        user,
        '', //!getplace(placeSplit.first).shipmentPlace,
        '', //!getplace(placeSplit.first).spName,
        docType,
        address, //_newMemberForm.address,
        storeId);
    if (response.statusCode == 201) {
      body = Id.fromJson(json.decode(response.body));
      msg = body.id;
      print("body.id${body.id}");
    } else {
      msg = "Kesalahan menyimpan data";
    }
    print(response.statusCode);
    print(msg);
    isloading(false);

    return msg;
  }

  Future<bool> showReview(BuildContext context, String msg) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              height: 110.0,
              width: 110.0,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        ' Member ID baru: $msg ',
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.pink[900],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/bottomnav', (_) => false);
                    },
                    child: Container(
                      height: 35.0,
                      width: 35.0,
                      color: Colors.white,
                      child: Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  /*  SearchableDropdown(
                                                                      underline:
                                                                          Divider(
                                                                        color: Colors
                                                                            .transparent,
                                                                      ),
                                                                      isExpanded:
                                                                          true,
                                                                      //style: TextStyle(fontSize: 12),
                                                                      hint:
                                                                          Text(
                                                                        'Area',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      iconEnabledColor:
                                                                          Colors
                                                                              .pink[200],
                                                                      iconDisabledColor:
                                                                          Colors
                                                                              .grey,
                                                                      items:
                                                                          places,
                                                                      value:
                                                                          selectedValue,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          selectedValue =
                                                                              value;
                                                                          placeSplit =
                                                                              selectedValue.split('\ ');
                                                                        });
                                                                      },
                                                                    ) SearchableDropdown(
                                                                underline:
                                                                    Divider(
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                searchHint:
                                                                    Text(
                                                                  'Select or Type Bank Name',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                isExpanded:
                                                                    true,
                                                                //style: TextStyle(fontSize: 12),
                                                                hint: Center(
                                                                  child: Text(
                                                                    bankName,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),

                                                                iconEnabledColor:
                                                                    Colors.pink[
                                                                        200],
                                                                iconDisabledColor:
                                                                    Colors.grey,
                                                                items: bankList,
                                                                value:
                                                                    selectedBank,

                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    selectedBank =
                                                                        value;
                                                                    bankSplit =
                                                                        selectedBank
                                                                            .split('\ ');
                                                                    print(bankSplit
                                                                        .first);
                                                                    _newMemberForm
                                                                            .bankId =
                                                                        bankSplit
                                                                            .first;

                                                                    /*isChanged =
                                                                    true;*/
                                                                  });
                                                                },
                                                              ),*/
/*
  void _regPressed() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (validateAndSave()) {
      await initlegacyData(_registrationFormData['userId'])
          .catchError((e) => '');
      await fireData(_registrationFormData['userId']).catchError((e) => '');
      if (!_legacyDataExits || _fireDataExits) {
        errorM = 'wrong code';
        print('legacyDataExits:$_legacyDataExits');
        print('fireDataExits:$_fireDataExits');
        isloading(false);
        print(errorM);
      } else {
        print('legacyDataExits:$_legacyDataExits');
        print('fireDataExits:$_fireDataExits');
        errorM = 'Good to GO';
        print(errorM);
        validateAndSubmit();
      }
    }
        TextFormField(
                        decoration: InputDecoration(
                            labelText: 'ID sponsor',
                            contentPadding: EdgeInsets.all(8.0),
                            icon: Icon(Icons.vpn_key, color: Colors.pink[500])),
                        //autocorrect: true,
                        autofocus: true,
                        //autovalidate: true,
                        // initialValue: '00000000',
                        validator: (value) => value.isEmpty
                            ? 'ID member !!'
                            : RegExp('[0-9]').hasMatch(value)
                                ? null
                                : 'ID member !!',

                        keyboardType: TextInputType.number,
                        onSaved: (String value) {
                          _newMemberFormData['sponsorId'] =
                              value.padLeft(8, '0');
                        },
                      ),
  }*/
}

class Id {
  String id;

  Id({this.id});

  factory Id.fromJson(Map<String, dynamic> json) {
    return Id(id: json['id']);
  }
}

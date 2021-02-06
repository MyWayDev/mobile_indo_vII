import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/area.dart';
import 'package:mor_release/models/courier.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/pages/order/widgets/payment.dart';
import 'package:mor_release/pages/order/widgets/shipmentArea.dart';
import 'package:mor_release/pages/order/widgets/storeFloat.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/widgets/color_loader_2.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:http/http.dart' as http;
import 'package:mor_release/pages/profile/album.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

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
  DateTime selected;
  String path = 'flamelink/environments/indoStage/content/region/en-US/';
  FirebaseDatabase database = FirebaseDatabase.instance;
  TextEditingController controller = new TextEditingController();

  final GlobalKey<FormState> _newMemberFormKey = GlobalKey<FormState>();
  List<Bank> banks;
  List<DropdownMenuItem> bankList = [];
  String bankName = '';
  String selectedBank;
  var bankSplit;
  List<DropdownMenuItem> items = [];
  List<DropdownMenuItem> places = [];
  String selectedValue;
  String placeValue;
  var areaSplit;
  var placeSplit;
  List<Courier> couriers = [];
  bool _loading = false;

  void getBanks() async {
    banks = [];
    final response =
        await http.get('${widget.model.settings.apiUrl}/get_bank_info/');

    if (response.statusCode == 200) {
      final _banks = json.decode(response.body) as List;
      banks = _banks.map((s) => Bank.json(s)).toList();
      //areaPlace.forEach((a) => print(a.spName));
    } else {
      banks = [];
    }

    if (banks.isNotEmpty) {
      for (var t in banks) {
        String sValue = "${t.bankId}" + " " + "${t.bankName}";
        bankList.add(
          DropdownMenuItem(
              child: Center(
                child: Text(
                  sValue,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              value: sValue),
        );
      }
      bankName = 'Philih Nama Bank';
    }
  }

  @override
  void initState() {
    getPlaces();
    getBanks();
    //  getAreas();
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.model.newRegcourierFee = 0;
    controller.dispose();
    super.dispose();
  }

  _showDateTimePicker(String userId) async {
    selected = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));
    // locale: Locale('fr'));
    setState(() {});
  }

  //final model = MainModel();
  void getAreas() async {
    DataSnapshot snapshot = await database.reference().child(path).once();

    Map<dynamic, dynamic> _areas = snapshot.value;
    List list = _areas.values.toList();
    List<Region> fbRegion = list.map((f) => Region.json(f)).toList();

    if (snapshot.value != null) {
      for (var t in fbRegion) {
        String sValue = "${t.regionId}" + " " + "${t.name}";
        items.add(
          DropdownMenuItem(
              child: Text(
                sValue,
                style: TextStyle(fontSize: 11),
              ),
              value: sValue),
        );
      }
    }
  }

  AreaPlace getplace(String id) {
    AreaPlace place;
    place = areaPlace.firstWhere((p) => p.shipmentPlace == id);
    print(
        'shipmentPlace:${place.shipmentPlace}:spName${place.spName}:areaId:${place.areaId}');
    return place;
  }

  List<AreaPlace> areaPlace;
  void getPlaces() async {
    areaPlace = [];
    final response = await http
        .get('${widget.model.settings.apiUrl}/get_all_shipment_places/');
    if (response.statusCode == 200) {
      final _shipmentArea = json.decode(response.body) as List;
      areaPlace = _shipmentArea.map((s) => AreaPlace.json(s)).toList();
      //areaPlace.forEach((a) => print(a.spName));
    } else {
      areaPlace = [];
    }

    if (areaPlace.isNotEmpty) {
      for (var t in areaPlace) {
        String sValue = "${t.shipmentPlace}" + " " + "${t.spName}";
        places.add(
          DropdownMenuItem(
              child: Text(
                sValue,
                style: TextStyle(fontSize: 12),
              ),
              value: sValue),
        );
      }
    }
  }

  final NewMember _newMemberForm = NewMember(
    serviceCenter: null,
    sponsorId: null, //* Form value
    familyName: null, //* empty
    name: null, //*Form value
    personalId: null, //*Form value
    birthDate: null, //*Form value
    email: null, //*Form value
    telephone: null, //*Form value
    address: null, //*Form value
    areaId: null, //*Form value
    bankAccoutName: null, //*Form value
    bankAccountNumber: null, //*Form value
    taxNumber: null, //*Form value
    bankId: null, //*Form value
    rate: 0, //*CR DOCS POPUP value
    shipmentCompany: null, //*CR DOCS POPUP value
  );

  Area stateValue;

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
    controller.clear();
    setState(() {
      veri = false;
      _isloading = false;
    });
  }

  void _profileAlbumBottomSheet(context, MainModel model) {
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

  final doubleFormat = new NumberFormat("####.##");
  final formatter = new NumberFormat("#,###");
  bool validData;
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  bool validateAndSave(String userId, String sc) {
    final form = _newMemberFormKey.currentState;
    isloading(true);
    if (form.validate() && selected != null && placeSplit.first != null) {
      _newMemberForm.birthDate =
          DateFormat('yyyy-MM-dd').format(selected).toString();
      _newMemberForm.email = userId;
      _newMemberForm.areaId = getplace(placeSplit.first).areaId;
      _newMemberForm.serviceCenter = sc;
      setState(() {
        validData = true;
      });
      // isloading(true);
      print('valide entry $validData');
      _newMemberFormKey.currentState.save();

      print('${_newMemberForm.sponsorId}:${_newMemberForm.birthDate}');
      isloading(false);
      return true;
    }
    isloading(false);
    return false;
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
                                                            AutovalidateMode
                                                                .onUserInteraction,
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
                                                          String _msg;
                                                          value.length < 6
                                                              ? _msg =
                                                                  'Nama anggota tidak valid'
                                                              : _msg = null;
                                                          return _msg;
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 25,
                                                                right: 25),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right: 1),
                                                              child: selected ==
                                                                      null
                                                                  ? Text(
                                                                      'Tanggal lahir')
                                                                  : Text(''),
                                                            ),
                                                            RawMaterialButton(
                                                              child: Icon(
                                                                GroovinMaterialIcons
                                                                    .calendar_check,
                                                                size: 24.0,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              shape:
                                                                  CircleBorder(),
                                                              highlightColor:
                                                                  Colors.pink[
                                                                      500],
                                                              elevation: 8,
                                                              fillColor: Colors
                                                                  .pink[500],
                                                              onPressed: () {
                                                                _showDateTimePicker(
                                                                    model
                                                                        .userInfo
                                                                        .distrId);
                                                              },
                                                              splashColor:
                                                                  Colors.pink[
                                                                      900],
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
                                                                  : Text(''),
                                                            ),
                                                          ],
                                                        )),
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
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            decoration: InputDecoration(
                                                                labelStyle:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                labelText:
                                                                    'Nomor tanda pengenal',
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
                                                              String _msg;
                                                              value.length <= 16
                                                                  ? _msg =
                                                                      'error !'
                                                                  : _msg = null;
                                                              return _msg;
                                                            },
                                                            autocorrect: true,
                                                            textCapitalization:
                                                                TextCapitalization
                                                                    .sentences,
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
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
                                                                AutovalidateMode
                                                                    .onUserInteraction,
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
                                                              String _msg;
                                                              value.length < 8
                                                                  ? _msg =
                                                                      ' خطأ فى حفظ  الهاتف'
                                                                  : _msg = null;
                                                              return _msg;
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
                                                        Flexible(
                                                          flex: 1,
                                                          fit: FlexFit.tight,
                                                          child: TextFormField(
                                                            style: TextStyle(
                                                                fontSize: 13.5),
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            maxLines: 6,
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
                                                              String _msg;
                                                              value.length < 9
                                                                  ? _msg =
                                                                      'Error'
                                                                  : _msg = null;
                                                              return _msg;
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .text,
                                                            onSaved:
                                                                (String value) {
                                                              _newMemberForm
                                                                      .address =
                                                                  value;
                                                            },
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 126,
                                                          child: Row(children: <
                                                              Widget>[
                                                            Container(
                                                              width: 32,
                                                              child: Icon(
                                                                  Icons
                                                                      .add_location,
                                                                  color: Colors
                                                                          .pink[
                                                                      500]),
                                                            ),
                                                            Flexible(
                                                                fit: FlexFit
                                                                    .tight,
                                                                child:
                                                                    SearchableDropdown(
                                                                  underline:
                                                                      Divider(
                                                                    color: Colors
                                                                        .transparent,
                                                                  ),
                                                                  isExpanded:
                                                                      true,
                                                                  //style: TextStyle(fontSize: 12),
                                                                  hint: Text(
                                                                    'Area',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  iconEnabledColor:
                                                                      Colors.pink[
                                                                          200],
                                                                  iconDisabledColor:
                                                                      Colors
                                                                          .grey,
                                                                  items: places,
                                                                  value:
                                                                      selectedValue,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      selectedValue =
                                                                          value;
                                                                      placeSplit =
                                                                          selectedValue
                                                                              .split('\ ');
                                                                    });
                                                                  },
                                                                ))
                                                          ]), /* Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SearchableDropdown(
                                                  hint: Text('region'),
                                                  icon: Icon(
                                                    Icons
                                                        .arrow_drop_down_circle,
                                                    size: 28,
                                                  ),
                                                  iconEnabledColor:
                                                      Colors.pink[200],
                                                  iconDisabledColor:
                                                      Colors.grey,
                                                  items: items,
                                                  value: selectedValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedValue = value;
                                                      areaSplit = selectedValue
                                                          .split('\ ');
                                                      _newMemberForm.areaId =
                                                          areaSplit.first;

                                                      print(
                                                          'split:${_newMemberForm.areaId}');
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),*/
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                TextFormField(
                                                  style:
                                                      TextStyle(fontSize: 13.5),
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration: InputDecoration(
                                                      labelStyle: TextStyle(
                                                          fontSize: 13),
                                                      labelText:
                                                          'Bank Account Name',
                                                      filled: true,
                                                      fillColor:
                                                          Colors.transparent,
                                                      contentPadding:
                                                          EdgeInsets.all(2.0),
                                                      icon: Icon(
                                                        GroovinMaterialIcons
                                                            .account,
                                                        color: Colors.pink[500],
                                                      )),
                                                  validator: (value) {
                                                    String _msg;
                                                    value.length < 3
                                                        ? _msg =
                                                            'Name is too short'
                                                        : _msg = null;
                                                    return _msg;
                                                  },
                                                  keyboardType:
                                                      TextInputType.text,
                                                  onSaved: (String value) {
                                                    _newMemberForm
                                                        .bankAccoutName = value;
                                                  },
                                                ),
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: TextFormField(
                                                        style: TextStyle(
                                                            fontSize: 13.5),
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        decoration:
                                                            InputDecoration(
                                                                labelStyle:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            13),
                                                                labelText:
                                                                    'Bank Account Number',
                                                                filled: true,
                                                                fillColor: Colors
                                                                    .transparent,
                                                                contentPadding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            2.0),
                                                                icon: Icon(
                                                                  GroovinMaterialIcons
                                                                      .numeric,
                                                                  color: Colors
                                                                          .pink[
                                                                      500],
                                                                )),
                                                        /*  validator: (value) {
                                              String _msg;
                                              value.length < 16
                                                  ? _msg =
                                                      'Account# is too short'
                                                  : _msg = null;
                                              return _msg;
                                            },*/
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
                                                    Container(
                                                      width: 155,
                                                      child: Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                                primaryColor:
                                                                    Colors
                                                                        .pink),
                                                        child: Container(
                                                            child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Container(
                                                              width: 32,
                                                              child: Icon(
                                                                  GroovinMaterialIcons
                                                                      .bank,
                                                                  color: Colors
                                                                          .pink[
                                                                      500]),
                                                            ),
                                                            Flexible(
                                                                fit: FlexFit
                                                                    .tight,
                                                                child:
                                                                    SearchableDropdown(
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
                                                                            FontWeight.bold),
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
                                                                      Colors
                                                                          .grey,
                                                                  items:
                                                                      bankList,
                                                                  value:
                                                                      selectedBank,

                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
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
                                                                ))
                                                          ],
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                TextFormField(
                                                  style:
                                                      TextStyle(fontSize: 13.5),
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration: InputDecoration(
                                                      labelStyle: TextStyle(
                                                          fontSize: 13),
                                                      labelText: 'Tax Number',
                                                      filled: true,
                                                      fillColor:
                                                          Colors.transparent,
                                                      contentPadding:
                                                          EdgeInsets.all(2.0),
                                                      icon: Icon(
                                                        GroovinMaterialIcons
                                                            .tag_text_outline,
                                                        color: Colors.pink[500],
                                                      )),
                                                  /*  validator: (value) {
                                              String _msg;
                                              value.length < 12
                                                  ? _msg = 'Tax is too short'
                                                  : _msg = null;
                                              return _msg;
                                            },*/
                                                  keyboardType:
                                                      TextInputType.number,
                                                  onSaved: (String value) {
                                                    _newMemberForm.taxNumber =
                                                        value;
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container()),
                                model.newRegcourierFee > 0
                                    ? Container(
                                        height: 16,
                                        child: ListTile(
                                          title: Text(
                                            'Courier Fee',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                            // textDirection: TextDirection.rtl,
                                          ),
                                          trailing: Text(
                                            formatter.format(
                                                    model.newRegcourierFee > 0
                                                        ? model.newRegcourierFee
                                                        : 0) +
                                                ' Rp ',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          leading: Icon(
                                            GroovinMaterialIcons.truck,
                                            size: 22,
                                            color: Colors.black,
                                          ),
                                        ))
                                    : Container(),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 3),
                                ),
                                veri
                                    ? Container(
                                        height: 16,
                                        child: ListTile(
                                          title: Text(
                                            'Membership Fee',
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Text(
                                            formatter.format(double.tryParse(
                                                    model.settings.catCode)) +
                                                ' Rp',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          leading: Icon(
                                            GroovinMaterialIcons.account_plus,
                                            size: 22,
                                            color: Colors.black,
                                          ),
                                        ))
                                    : Container(),
                                Padding(padding: EdgeInsets.only(bottom: 22)),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    widget.model.newRegcourierFee > 0 &&
                                            model.docType == 'CR'
                                        ? Expanded(
                                            flex: 1,
                                            child: RawMaterialButton(
                                              fillColor: Colors.tealAccent[400],
                                              splashColor: Colors.pink[500],
                                              constraints: BoxConstraints(
                                                  maxWidth: 45, maxHeight: 45),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
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
                                                        color: Colors.white,
                                                      ),
                                                      Text(
                                                        'Total',
                                                        style: TextStyle(
                                                            fontSize: 12.5,
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
                                                            fontSize: 12.2,
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
                                    veri
                                        ? Container(
                                            child: RawMaterialButton(
                                                constraints: BoxConstraints(
                                                    minWidth: 34,
                                                    minHeight: 34),
                                                splashColor: Colors.amber,
                                                shape: CircleBorder(),
                                                highlightColor:
                                                    Colors.pink[500],
                                                elevation: 8,
                                                fillColor: model.docType == 'CR'
                                                    ? Colors.amber
                                                    : Colors.green,
                                                child: Icon(
                                                  model.docType == 'CR'
                                                      ? GroovinMaterialIcons
                                                          .truck
                                                      : Icons.check,
                                                  color: Colors.white,
                                                  size: 27,
                                                ),
                                                onPressed: () async {
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
                                                      : Container(); //* add save Funcion

                                                  /*  String msg = '';
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
                                        : Container(),
                                  ],
                                )
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
        getplace(placeSplit.first).shipmentPlace,
        getplace(placeSplit.first).spName,
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

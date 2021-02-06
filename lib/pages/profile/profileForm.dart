import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mor_release/models/area.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_dropdown/searchable_dropdown.dart';
import '../const.dart';

class ProfileForm extends StatefulWidget {
  final MainModel model;
  ProfileForm(this.model, {Key key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  NewMember _memberEditData = new NewMember();
  List<Bank> banks;
  List<DropdownMenuItem> bankList = [];
  String bankName = '';
  String selectedBank;
  var bankSplit;

  //done
  TextEditingController cAddress; //done
  TextEditingController cTelePhone; //done
  TextEditingController cBanKAccountNumber; //done
  TextEditingController cBankAccountName;
  TextEditingController cTaxNumber; //done

  final FocusNode focusTelephone = new FocusNode();
  final FocusNode focusAccountName = new FocusNode();
  final FocusNode focusAddress = new FocusNode();
  final FocusNode focusBankAccount = new FocusNode();
  final FocusNode focusTaxNumber = new FocusNode();

  bool _isloading = false;

  void isloading(bool i) {
    setState(() {
      widget.model.isloading = i;
    });
  }

  bool isChanged = false;
  bool veri = false;

  void resetVeri() {
    cAddress.clear();
    cBanKAccountNumber.clear();
    cTaxNumber.clear();
    cTelePhone.clear();
    cBankAccountName.clear();

    veri = false;
    isChanged = false;
  }

  String getBankName() {
    var bL = bankList;
    String bLString = '';
    if (_memberEditData.bankId != '') {
      bLString = bL
          .firstWhere((b) =>
              b.value.toString().split('\ ').first == _memberEditData.bankId)
          .value
          .toString();
    } else {
      bLString = 'Bank';
    }

    return bLString;
  }

  void getBanks() async {
    banks = [];
    final response =
        await http.get('http://34.101.79.170:5000/api/get_bank_info/');
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
      bankName = getBankName();
    }
  }

  @override
  void initState() {
    _memberEditData = widget.model.nodeEditData;
    getBanks();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /*void updateFormData() {
    focusNodeNickname.unfocus();
    focusNodeAboutMe.unfocus();

    setState(() {
      isLoading = true;
    });
    FirebaseDatabase.instance
        .reference()
        .child('indoDb/users/en-US/$id')
        .update({
      'name': name,
      'areaId': areaId,
    }).then((data) async {
      //await prefs.setString('name', name);
      // await prefs.setString('areaId', areaId);
      // await prefs.setString('idPhotoUrl', idPhotoUrl);
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Theme(
                data: Theme.of(context).copyWith(primaryColor: Colors.pink),
                child: SearchableDropdown(
                  searchHint: Text(
                    'Select or Type Bank Name',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  isExpanded: true,
                  //style: TextStyle(fontSize: 12),
                  hint: Center(
                    child: Text(
                      bankName,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),

                  iconEnabledColor: Colors.pink[200],
                  iconDisabledColor: Colors.grey,
                  items: bankList,
                  value: selectedBank,

                  onChanged: (value) {
                    setState(() {
                      selectedBank = value;
                      bankSplit = selectedBank.split('\ ');
                      print(bankSplit.first);
                      _memberEditData.bankId = bankSplit.first;

                      isChanged = true;
                    });
                  },
                )),
            margin:
                EdgeInsets.only(left: 85.0, right: 85.0, bottom: 10, top: 8),
          ),
          Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 16),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    width: 120,
                    child: Text(
                      'Bank Account Number',
                      style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    // margin: EdgeInsets.only(left: 5.0),
                  ),
                ),
                Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: primaryColor),
                        child: TextFormField(
                          // enabled: veri,
                          initialValue: _memberEditData.bankAccountNumber,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'Account Name',
                            contentPadding: EdgeInsets.all(3.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: cBanKAccountNumber,
                          onChanged: (value) {
                            setState(() {
                              _memberEditData.bankAccountNumber = value;
                              isChanged = true;
                            });
                          },
                          focusNode: focusBankAccount,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 1.0, right: 30.0),
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 16),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    width: 120,
                    child: Text(
                      'Bank Account Name Holder',
                      style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                    // margin: EdgeInsets.only(left: 5.0),
                  ),
                ),
                Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(primaryColor: primaryColor),
                        child: TextFormField(
                          // enabled: veri,
                          initialValue: _memberEditData.bankAccoutName,
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
                              _memberEditData.bankAccoutName = value;
                              isChanged = true;
                            });
                          },
                          focusNode: focusAccountName,
                        ),
                      ),
                      margin: EdgeInsets.only(left: 1.0, right: 30.0),
                    )),
              ],
            ),
          ]),
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
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: primaryColor),
                          ),
                          //  margin: EdgeInsets.only(left: 30.0),
                        ),
                        TextFormField(
                          initialValue: _memberEditData.address,
                          maxLines: 8,
                          enabled: true,
                          style: TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Address',
                            contentPadding: EdgeInsets.all(3.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: cAddress,
                          onChanged: (value) {
                            setState(() {
                              _memberEditData.address = value;
                              isChanged = true;
                            });
                          },
                          focusNode: focusAddress,
                        ),
                      ]),
                    ),
                    Padding(padding: EdgeInsets.all(5)),
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
                        textAlign: TextAlign.center,
                        initialValue: _memberEditData.telephone,
                        enabled: true,
                        style: TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Telephone',
                          contentPadding: EdgeInsets.all(3.0),
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        controller: cTelePhone,
                        onChanged: (value) {
                          setState(() {
                            _memberEditData.telephone = value;
                            isChanged = true;
                          });
                        },
                        focusNode: focusTelephone,
                      )
                    ]))
                  ]),
                ])),
            margin:
                EdgeInsets.only(left: 15.0, right: 30.0, bottom: 10, top: 10),
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
            margin: EdgeInsets.only(left: 0.0, top: 15),
          ),
          Container(
            child: Theme(
              data: Theme.of(context).copyWith(primaryColor: primaryColor),
              child: TextFormField(
                textAlign: TextAlign.center,
                initialValue: _memberEditData.taxNumber,
                enabled: true,
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
                    getBankName();
                    _memberEditData.taxNumber = value;
                    isChanged = true;
                  });
                },
                focusNode: focusTaxNumber,
              ),
            ),
            margin: EdgeInsets.only(left: 80.0, right: 80.0),
          ),
          buttonBar(context)
        ]);
    /*
      inAsyncCall: _isloading,
      opacity: 0.6,
      progressIndicator: ColorLoader2(),
    );*/
  }

  Widget buttonBar(BuildContext context) {
    return ButtonBar(
      mainAxisSize: MainAxisSize.max,
      alignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        isChanged
            ? Container(
                child: RaisedButton(
                  elevation: 11,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  child: Icon(Icons.check_circle),
                  color: Colors.green[700],
                  onPressed: () async {
                    String _msg = await _saveNodeEdit(_memberEditData);
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(_msg),
                              actions: <Widget>[
                                FlatButton(
                                  highlightColor: Colors.greenAccent,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.red[400],
                                          width: 2.5,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(50)),
                                  color: Colors.white,
                                  child: Text(
                                    'Close',
                                    style: TextStyle(
                                        color: Colors.red[900],
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ));
                  },
                ),
                width: 200)
            : Container(),
      ],
    );
  }

  Future<String> _saveNodeEdit(NewMember memberEditData) async {
    isloading(true);
    String msg;
    print(memberEditData.editMemberEncode(memberEditData));
    Response response = await memberEditData.editPost(
        memberEditData, widget.model.settings.apiUrl);
    if (response.statusCode == 200) {
      //2033243 resetVeri();
    }
    response.statusCode == 200 ? msg = 'Updated :)' : msg = 'Failed';
    print(response.statusCode);
    isloading(false);
    setState(() {
      isChanged = false;
    });
    return msg;
  }
}

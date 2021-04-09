import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/pages/profile/bankDropdown.dart';
import 'package:mor_release/scoped/connected.dart';
import '../const.dart';

class ProfileForm extends StatefulWidget {
  final MainModel model;
  ProfileForm(this.model, {Key key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  NewMember _memberEditData = new NewMember();

  TextEditingController cAddress; //done
  TextEditingController cTelePhone; //done
  TextEditingController cBanKAccountNumber; //done
  TextEditingController cBankAccountName;
  TextEditingController cTaxNumber;

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

  bool _veri = false;

  void _resetVeri() {
    cAddress.clear();
    cBanKAccountNumber.clear();
    cTaxNumber.clear();
    cTelePhone.clear();
    cBankAccountName.clear();

    _veri = false;
    widget.model.isBankChanged = false;
  }

  bool _validPhotoInput(NewMember memberEditData, User userInfo) {
    bool _valid = false;
    print(memberEditData.taxNumber + '=>' + userInfo.taxPhotoUrl);
    memberEditData.taxNumber != '' && userInfo.taxPhotoUrl == ''
        ? _valid = false
        : _valid = true;
    return _valid;
  }

  void resetControllers() {
    cAddress.text = _memberEditData.address;
    cBanKAccountNumber.text = _memberEditData.bankAccountNumber;
    cBankAccountName.text = _memberEditData.bankAccoutName;
    cTaxNumber.text = _memberEditData.taxNumber;
    cTelePhone.text = _memberEditData.telephone;
  }

  @override
  void initState() {
    _memberEditData = widget.model.nodeEditData;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          BankDropdown(widget.model),
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
                      'No. Rekening',
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
                          // enabled: _veri,
                          initialValue: _memberEditData.bankAccountNumber,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: '',
                            contentPadding: EdgeInsets.all(3.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: cBanKAccountNumber,
                          onChanged: (value) {
                            setState(() {
                              _memberEditData.bankAccountNumber = value;
                              widget.model.isBankChanged = true;
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
                      'Nama Pemilik Rekening',
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
                          // enabled: _veri,
                          initialValue: _memberEditData.bankAccoutName,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: '',
                            contentPadding: EdgeInsets.all(3.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: cBankAccountName,
                          onChanged: (value) {
                            setState(() {
                              _memberEditData.bankAccoutName = value;
                              widget.model.isBankChanged = true;
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
                            'Alamat Lengkap',
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
                            hintText: '',
                            contentPadding: EdgeInsets.all(3.0),
                            hintStyle: TextStyle(color: greyColor),
                          ),
                          controller: cAddress,
                          onChanged: (value) {
                            setState(() {
                              _memberEditData.address = value;
                              widget.model.isBankChanged = true;
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
                          'No. Telepon',
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
                          hintText: '',
                          contentPadding: EdgeInsets.all(3.0),
                          hintStyle: TextStyle(color: greyColor),
                        ),
                        controller: cTelePhone,
                        onChanged: (value) {
                          setState(() {
                            _memberEditData.telephone = value;
                            widget.model.isBankChanged = true;
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
              'NPWP',
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
                  hintText: '',
                  hintStyle: TextStyle(color: greyColor, fontSize: 12),
                ),
                controller: cTaxNumber,
                onChanged: (value) {
                  setState(() {
                    //getBankName();
                    _memberEditData.taxNumber = value;
                    widget.model.isBankChanged = true;
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
        widget.model.isBankChanged
            ? Container(
                child: RaisedButton(
                  elevation: 11,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  child: Icon(Icons.check_circle),
                  color: Colors.green[700],
                  onPressed: () async {
                    _memberEditData.bankId = widget.model.nodeEditData.bankId;
                    String _msg = '';
                    _msg =
                        _validPhotoInput(_memberEditData, widget.model.userInfo)
                            ? await _saveNodeEdit(_memberEditData)
                            : _msg = 'Please Add TaxId Photo';
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
      //2033243 reset_veri();
    }
    response.statusCode == 200 ? msg = 'Updated :)' : msg = 'Failed';
    print(response.statusCode);
    isloading(false);
    setState(() {
      widget.model.isBankChanged = false;
    });
    return msg;
  }
}

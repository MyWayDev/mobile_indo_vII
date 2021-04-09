import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mor_release/models/area.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/scoped/connected.dart';

class BankDropdown extends StatefulWidget {
  final MainModel model;
  final bool isInsert;
  BankDropdown(this.model, {Key key, this.isInsert = false}) : super(key: key);

  @override
  _BankDropdownState createState() => _BankDropdownState();
}

class _BankDropdownState extends State<BankDropdown> {
  List<Bank> banks;

  @override
  void initState() {
    getBanks();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _ibank(String _bank) {
    int _index;
    if (_bank.length > 1) {
      var i = banks.where((b) => b.bankId == _bank);
      _index = banks.indexOf(i.first);
    }
    /*else {
      _index = 0;
    }*/

    return _index;
  }

  NewMember userData(NewMember _userData) {
    return widget.model.nodeEditData;
  }

  void getBanks() async {
    banks = [];
    final response = await http
        .get('https://mywayindoapi.azurewebsites.net/api/get_bank_info/');
    if (response.statusCode == 200) {
      final _banks = json.decode(response.body) as List;
      banks = _banks.map((s) => Bank.json(s)).toList();
    } else {
      banks = [];
    }
  }

  Widget _customPopupItemBuilder(
      BuildContext context, Bank item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
      child: ListTile(
        selected: isSelected,
        title: Center(
          child: Text(
            item.bankName != null ? item.bankName : '',
            style: TextStyle(fontSize: 13),
          ),
        ),
        //Icon(GroovinMaterialIcons.bank, color: Colors.pink[900]),
      ),
    );
  }

  Widget _customDropDown(
      BuildContext context, Bank item, String itemDesignation) {
    return Container(
      child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Center(
            child: Text(item.bankId,
                style: TextStyle(color: Colors.black12, fontSize: 11)),
          ),
          subtitle: Center(
            child: Text(
              item.bankName != null ? item.bankName : '',
              style: TextStyle(fontSize: 11, color: Colors.black87),
            ),
          )),
    );
  }

  DropdownSearch _dDSearch() {
    return DropdownSearch<Bank>(
        mode: Mode.BOTTOM_SHEET,
        maxHeight: 450,
        compareFn: (Bank i, Bank s) => i.bankId == s.bankId,
        autoFocusSearchBox: true,
        showAsSuffixIcons: true,
        validator: (Bank b) => b.bankId == null || b.bankId == '' ? '' : null,
        //showClearButton: true,
        dropdownButtonBuilder: (_) => Padding(
              padding: const EdgeInsets.only(right: 0.0),
              child: const Icon(
                Icons.arrow_drop_down,
                size: 24,
                color: Colors.black,
              ),
            ),
        dropdownSearchDecoration: InputDecoration(filled: false, border: null),
        searchBoxDecoration: InputDecoration(icon: Icon(Icons.search)),
        showSearchBox: true,
        showSelectedItem: true,
        items: banks,
        hint: " ",
        itemAsString: (Bank banks) => banks.bankName,
        //selectedItem: defaultSelected,
        //popupItemDisabled: (Bank s) => s.bankId,
        selectedItem: mounted
            ? banks.isNotEmpty &&
                    widget.model.bankDropDownValue.bankId != '-' &&
                    widget.model.bankDropDownValue.bankId != null &&
                    widget.model.bankDropDownValue.bankId.isNotEmpty
                ? banks[_ibank(widget.model.bankDropDownValue.bankId)]
                : Bank(bankId: '', bankName: 'Pilih Bank')
            : null,
        dropdownBuilder: _customDropDown,
        popupItemBuilder: _customPopupItemBuilder,
        onChanged: (Bank bank) {
          print(bank.bankId);

          widget.model.bankDropDownValue.bankId = bank.bankId;
          widget.model.isBankChanged =
              true; //?check this line of code for editdata form related issues
        });
    //selectedItem: banks[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(flex: 3, fit: FlexFit.loose, child: _dDSearch())
            ],
          )
        ]),
      ),
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 8),
    );
  }
}

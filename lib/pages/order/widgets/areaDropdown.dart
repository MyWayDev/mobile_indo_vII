import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mor_release/models/area.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:blinking_text/blinking_text.dart';

class AreaDropdown extends StatefulWidget {
  final MainModel model;
  final bool isInsert;
  const AreaDropdown(this.model, {Key key, this.isInsert = false})
      : super(key: key);

  @override
  _AreaDropdownState createState() => _AreaDropdownState();
}

class _AreaDropdownState extends State<AreaDropdown> {
  List<AreaPlace> areas;
  bool _isLoading = true;
  @override
  void initState() {
    getPlaces();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int _iArea(String _area) {
    int _index;
    if (_area.length > 1) {
      var i = areas.where((b) => b.shipmentPlace == _area);
      _index = areas.indexOf(i.first);
    }
    /*else {
      _index = 0;
    }*/

    return _index;
  }

  void getPlaces() async {
    areas = [];
    final response = await http
        .get('${widget.model.settings.apiUrl}/get_all_shipment_places/');
    if (response.statusCode == 200) {
      final _shipmentArea = json.decode(response.body) as List;
      areas = _shipmentArea.map((s) => AreaPlace.json(s)).toList();
      _isLoading = false;
      //areas.forEach((a) => print(a.spName));
    } else {
      // areas = [];
    }
    // areas.forEach((a) => print(a.shipmentPlace));
  }

  Widget _customPopupItemBuilder(
      BuildContext context, AreaPlace item, bool isSelected) {
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
            item.spName != null ? item.spName : '',
            style: TextStyle(fontSize: 13),
          ),
        ),
        //leading: Icon(GroovinMaterialIcons.bank, color: Colors.pink[900]),
      ),
    );
  }

  Widget _customDropDown(
      BuildContext context, AreaPlace item, String itemDesignation) {
    return _isLoading
        ? Container(child: LinearProgressIndicator())
        : Container(
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Center(
                  child: Text(item.shipmentPlace,
                      style: TextStyle(color: Colors.black12, fontSize: 11))),
              subtitle: Center(
                child: Center(
                  child: Text(
                    item.spName != null ? item.spName : '',
                    style: TextStyle(fontSize: 11, color: Colors.black87),
                  ),
                ),
              ),
            ),
          );
  }

  AreaPlace defaultSelected =
      AreaPlace(shipmentPlace: '', spName: 'Pilih Area');
  DropdownSearch _dDSearch() {
    return DropdownSearch<AreaPlace>(
        mode: Mode.BOTTOM_SHEET,
        maxHeight: 450,
        autoFocusSearchBox: true,
        showAsSuffixIcons: true,
        compareFn: (AreaPlace i, AreaPlace s) =>
            i.shipmentPlace == s.shipmentPlace,
        // autoFocusSearchBox: true,
        //showAsSuffixIcons: true,
        validator: (AreaPlace b) =>
            b.shipmentPlace.isEmpty || b.shipmentPlace == null ? "" : null,
        //showClearButton: true,
        dropdownButtonBuilder: (_) => !_isLoading
            ? Padding(
                padding: const EdgeInsets.only(right: 0.0),
                child: const Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                  color: Colors.black,
                ),
              )
            : BlinkText(
                'Memuat Data',
                style: TextStyle(fontSize: 12.0, color: Colors.orange[700]),
                endColor: Colors.pink[500],
              ),
        dropdownSearchDecoration: InputDecoration(filled: false, border: null),
        searchBoxDecoration: InputDecoration(icon: Icon(Icons.search)),
        showSearchBox: true,
        showSelectedItem: true,
        items: areas, // ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
        hint: " ",
        itemAsString: (AreaPlace areas) => areas.spName,

        //popupItemDisabled: (Bank s) => s.bankId,
        selectedItem: defaultSelected,
        dropdownBuilder: _customDropDown,
        popupItemBuilder: _customPopupItemBuilder,
        onChanged: (AreaPlace area) {
          if (mounted) {
            setState(() {
              defaultSelected = area;
              widget.model.areaDropDownValue = area;
            });
          }
          print('areaId: ${widget.model.areaDropDownValue.areaId}' +
              ' areaName:' +
              '${widget.model.areaDropDownValue.areaName}' +
              ' shipmentPlace:' +
              '${widget.model.areaDropDownValue.shipmentPlace}' +
              ' spNmae: ' +
              '${widget.model.areaDropDownValue.spName}');

          // widget.model.nodeEditData.areaId = area.shipmentPlace;
          //widget.model.isBankChanged = true;
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

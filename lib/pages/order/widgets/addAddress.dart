import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/area.dart';
import 'package:mor_release/models/courier.dart';
import 'package:mor_release/pages/const.dart';
import 'package:mor_release/pages/order/widgets/shipmentArea.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/widgets/color_loader_2.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:http/http.dart' as http;

class AddRegion extends StatefulWidget {
  final String memberId;
  const AddRegion(this.memberId, {Key key}) : super(key: key);

  @override
  _AddRegionState createState() => _AddRegionState();
}

class _AddRegionState extends State<AddRegion> {
  String path = 'flamelink/environments/indoProduction/content/region/en-US/';
  FirebaseDatabase database = FirebaseDatabase.instance;

  List<DropdownMenuItem> regions = [];
  List<DropdownMenuItem> areas = [];
  String selectedRegion;
  var regionSplit;
  bool _isLoading = false;

  void loading(bool l) {
    setState(() {
      _isLoading = l;
    });
  }

  void getRegions() async {
    DataSnapshot snapshot = await database.reference().child(path).once();

    Map<dynamic, dynamic> _areas = snapshot.value;
    List list = _areas.values.toList();
    List<Region> fbRegion = list.map((f) => Region.json(f)).toList();

    if (snapshot.value != null) {
      for (var t in fbRegion) {
        String sValue = "${t.regionId}" + " " + "${t.name}";
        regions.add(
          DropdownMenuItem(
              child: Text(
                sValue,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[900]),
              ),
              value: sValue),
        );
      }
    }
  }

  Future<List<ShipmentArea>> getAreas(String areaId, String apiUrl) async {
    loading(true);

    List<ShipmentArea> shipmentAreas = [];
    areas.clear();
    final response =
        await http.get('$apiUrl/get_shipment_places_by_area_id/$areaId');
    if (response.statusCode == 200) {
      final _shipmentArea = json.decode(response.body) as List;
      shipmentAreas =
          _shipmentArea.map((s) => ShipmentArea.fromJson(s)).toList();
      shipmentAreas.forEach((a) => print(a.shipmentName));
      if (shipmentAreas.length != 0) {
        for (var t in shipmentAreas) {
          String aValue = "${t.shipmentArea}" + " " + "${t.shipmentName}";
          areas.add(
            DropdownMenuItem(
                child: Text(
                  aValue,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                value: aValue),
          );
        }
      }
    }
    loading(false);
    // print('AREAS LENGTH:${areas.length}');
    return shipmentAreas;
  }

  bool _hasData = false;

  void hasData(bool has) {
    setState(
      () {
        _hasData = has;
      },
    );
  }

  @override
  void initState() {
    getRegions();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return SingleChildScrollView(
          child: AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        content: Column(
          mainAxisSize: MainAxisSize.max,
          //  mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Tambahkan Alamat',
              softWrap: true,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SearchableDropdown(
              hint: Center(
                child: Text(
                  'Pilih Kota',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              icon: Icon(
                Icons.location_searching,
                size: 24,
              ),
              iconEnabledColor: Colors.pink[200],
              iconDisabledColor: Colors.grey,
              items: regions,
              value: selectedRegion,
              onChanged: (value) async {
                hasData(false);
                setState(() {
                  selectedRegion = value;
                  regionSplit = selectedRegion.split('\ ');
                  hasData(true);
                });
                await getAreas(regionSplit.first, model.settings.apiUrl);
                setState(() {});
              },
            ),
            regionSplit != null
                ? Container(
                    child: areas.length > 0
                        ? AddAddress(widget.memberId, areas)
                        : Container(
                            child: LinearProgressIndicator(
                              backgroundColor: greyColor,
                            ),
                          ),
                  )
                : Container()
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.red,
              size: 24,
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              showDialog(
                  context: context,
                  builder: (_) => ShipmentPlace(
                      model: model, isEdit: model.isBulk ? true : false));
            },
          )
        ],
      ));
    });
  }
}

class AddAddress extends StatefulWidget {
  final String memberId;
  final List<DropdownMenuItem> _areas;

  AddAddress(this.memberId, this._areas, {Key key}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormBuilderState> _addressFormKey =
      GlobalKey<FormBuilderState>();
  bool isValid = false;
  String selectedArea;
  var areaSplit;
  bool _async = false;
  String errorText = 'Entri yang diperlukan';
  void isAsync(bool l) {
    setState(() {
      _async = l;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final ShipmentArea _newAddressForm = ShipmentArea(
    shipmentDistrId: '',
    shipmentArea: '',
    shipmentName: '',
    shipmentAddress: '',
  );

  Area stateValue;

  @override
  Widget build(BuildContext context) {
    return !_async
        ? Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            SearchableDropdown(
              isExpanded: true,
              hint: Center(
                child: Text(
                  'Pilih Area Pengiriman',
                  softWrap: true,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              icon: Icon(
                Icons.location_on,
                size: 24,
              ),
              iconEnabledColor: Colors.pink[200],
              iconDisabledColor: Colors.grey,
              items: widget._areas,
              value: selectedArea,
              onChanged: (value) {
                setState(() {
                  selectedArea = value;
                  areaSplit = selectedArea.split('\ ');
                  _newAddressForm.shipmentArea = selectedArea.substring(7);
                  _newAddressForm.shipmentArea = areaSplit.first;
                  print('split:${_newAddressForm.shipmentArea}');
                });
              },
            ),
            areaSplit != null
                ? FormBuilder(
                    key: _addressFormKey,
                    //  autovalidate: true,
                    child: FormBuilderTextField(
                      enableInteractiveSelection: false,
                      expands: false,
                      autocorrect: true,
                      // autovalidate: true,
                      maxLengthEnforcement: MaxLengthEnforcement.none,
                      maxLines: 3,
                      name: "comment",
                      decoration: InputDecoration(
                        labelText: "Detail Alamat",
                        /*  border: OutlineInputBorder(
                        gapPadding: 20,
                        borderSide: BorderSide(color: Colors.red),
                      ),*/
                      ),
                      onChanged: (value) {
                        setState(() {
                          isValid = _addressFormKey.currentState.validate();
                          _newAddressForm.shipmentAddress = value;
                        });
                      },

                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(context),
                        FormBuilderValidators.minLength(context, 3,
                            allowEmpty: false, errorText: errorText),
                        FormBuilderValidators.maxLength(context, 500,
                            errorText: 'Batas masuk tercapai'),
                      ]),

                      //  valueTransformer: (text) => num.tryParse(text),
                      /* validators: [
                        FormBuilderValidators.required(errorText: errorText),
                        FormBuilderValidators.minLength(3,
                            errorText: errorText),
                        FormBuilderValidators.maxLength(500,
                            errorText: 'Batas masuk tercapai'),
                      ],*/
                    ))
                : Container(),
            isValid
                ? ScopedModelDescendant<MainModel>(builder:
                    (BuildContext context, Widget child, MainModel model) {
                    return ModalProgressHUD(
                      inAsyncCall: _async,
                      opacity: 0.65,
                      child: IconButton(
                        icon: Icon(
                          Icons.check_circle_outline,
                          color: Colors.green,
                          size: 42,
                        ),
                        onPressed: () async {
                          String msg = "";
                          String distrId;
                          widget.memberId == null
                              ? distrId = model.userInfo.distrId
                              : distrId = widget.memberId;

                          if (_validateAndSave(distrId)) {
                            print(_newAddressForm
                                .postAddressToJson(_newAddressForm));
                            await _saveAddress(model, distrId);
                          }
                        },
                      ),
                    );
                  })
                : Container(),
          ])
        : Container(
            child: ColorLoader2(),
          );
  }

  bool _validateAndSave(String memberId) {
    final addressData = _addressFormKey.currentState;
    isAsync(true);
    if (addressData.validate() &&
        _newAddressForm.shipmentArea != null &&
        _newAddressForm.shipmentName != null) {
      _newAddressForm.shipmentDistrId = memberId;
      _newAddressForm.shipmentArea = areaSplit.first;
      _newAddressForm.shipmentName = selectedArea.substring(7);
      _addressFormKey.currentState.save();
      isAsync(false);
      return true;
    }
    isAsync(false);
    return false;
  }

  Future _saveAddress(MainModel model, String memberId) async {
    isAsync(true);
    print('distrPoint:${model.distrPoint}');
    List<ShipmentArea> list =
        await model.getShipmentAreas(memberId, model.distrPoint);
    print('address length=>${list.length}');
    if (list.length > 5) {
      String delId = list.first.shipmentId.toString();
      http.delete(
          '${model.settings.apiUrl}/delete_distr_shipment_place_record/$delId');
    }
    String msg;

    http.Response response = await _newAddressForm.createPost(
        _newAddressForm, model.settings.apiUrl);
    if (response.statusCode == 201) {
      msg = 'sukses';
      isAsync(false);
      Navigator.of(context).pop();
      showDialog(
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
                          ' penambahan Alamat $msg ',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (msg == 'sukses') {
                          showDialog(
                              context: context,
                              builder: (_) => ShipmentPlace(
                                    model: model,
                                    memberId: memberId,
                                    isEdit: model.isBulk ? true : false,
                                  ));
                        }
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
    } else {
      msg = 'gagal';
      isAsync(false);
      showDialog(
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
                          ' penambahan Alamat $msg ',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                        if (msg == 'sukses') {
                          showDialog(
                              context: context,
                              builder: (_) => ShipmentPlace(
                                    model: model,
                                    isEdit: model.isBulk ? true : false,
                                  ));
                        }
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
                    )
                  ],
                ),
              ),
            );
          });
    }
  }
}

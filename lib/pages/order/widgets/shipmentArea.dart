import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/area.dart';
import 'package:mor_release/models/courier.dart';
import 'package:mor_release/pages/order/widgets/addAddress.dart';
import 'package:mor_release/pages/order/widgets/newMem_Courier.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/widgets/color_loader_2.dart';

class ShipmentPlace extends StatefulWidget {
  final MainModel model;
  final String memberId;
  final bool isEdit;
  final bool isNewMember;

  ShipmentPlace({
    @required this.model,
    this.memberId,
    this.isEdit = false,
    this.isNewMember = false,
  });

  @override
  _ShipmentAreaState createState() => _ShipmentAreaState();
}

class _ShipmentAreaState extends State<ShipmentPlace>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  bool _isloading = false;
  bool isSelected = false;
  bool _hasData = false;
  int distrpoint = 1;
  String type;
  List<Region> distrPoints = [];
  List<ShipmentArea> shipmentAreas = [];
  List<Courier> couriers = [];

  hasData(bool data) {
    if (mounted) {
      setState(() {
        _hasData = data;
      });
    }
  }

  isloading(bool loading) {
    if (mounted) {
      setState(() {
        _isloading = loading;
      });
    }
  }

  void _valueChanged(bool v) {
    if (mounted) {
      setState(() {
        isSelected = v;
      });
    }
  }

  void _setType(
    String value,
  ) {
    if (mounted) {
      setState(() {
        type = value;
        widget.model.distrPoint = distrpoint;
        widget.model.shipmentArea = value;
        widget.model.shipmentName = shipmentAreas
            .where((a) => a.shipmentArea == value)
            .first
            .shipmentName;
      });
    }
    print('type=>$type');
    print('distrPoint=>${widget.model.distrPoint}');
    print('shipmentArea=>${widget.model.shipmentArea}');
    print('shipmentName=>${widget.model.shipmentName}');
    print('address=>${widget.model.shipmentAddress}');
  }

  getDistrPoints() async {
    isloading(true);
    distrPoints = await widget.model.getPoints(widget.model.distrPoint);
    distrPoints.forEach((p) => print('getpoints+>${p.name}'));
    if (distrPoints.length > 0 && mounted) {
      setState(() {
        //   widget.model.distrPoint = distrPoints[0].id;
        isloading(false);
      });
    } else {
      if (mounted) {
        setState(() {
          isloading(false);
        });
      }
    }
    if (distrPoints.length == 1 && mounted) {
      setState(() {
        distrpoint = widget.model.distrPoint; //distrPoints[0].id;
      });
      await getAreas();
      if (shipmentAreas.length == 0) {
        Navigator.of(context).pop();
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AddRegion(widget.memberId));
      }
    }
  }

  _showNewMemberCourier() {
    showDialog(
        context: context,
        builder: (_) => NewMemberCourier(couriers, widget.model.shipmentArea,
            widget.model.userInfo.distrId, widget.model.userInfo.distrId));
  }

  getAreas() async {
    isloading(true);
    print(
        'Global distrPoint:${widget.model.distrPoint}: local distrPoint:$distrpoint');
    widget.memberId == null
        ? shipmentAreas = await widget.model
            .getShipmentAreas(widget.model.userInfo.distrId, distrpoint)
        : shipmentAreas =
            await widget.model.getShipmentAreas(widget.memberId, distrpoint);

    if (shipmentAreas.length > 0 && mounted) {
      setState(() {
        hasData(true);
        isloading(false);
      });
    } else {
      if (mounted) {
        setState(() {
          hasData(false);
          isloading(false);
        });
      }
    }
  }

  @override
  void initState() {
    isloading(true);
    //getCouriers();
    getDistrPoints();
    distrpoint = widget.model.distrPoint;
    isloading(false);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return shipmentArea(context);
  }

  Widget shipmentArea(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _isloading,
        opacity: 0.6,
        progressIndicator: ColorLoader2(),
        child: distrPoints.length > 0
            ? AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                title: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    leading: Text(
                      'Pilih Area Pengiriman',
                      style: TextStyle(fontSize: 14),
                    ),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        IconButton(
                          alignment: Alignment.center,
                          icon: Icon(
                            Icons.add_location,
                            color: Colors.pink[900],
                            size: 39,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => AddRegion(widget.memberId));
                          },
                        ),
                      ],
                    )),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FormBuilder(
                        key: _fbKey,
                        // autovalidate: true,
                        child: Column(
                          children: <Widget>[
                            FormBuilderDropdown(
                              isExpanded: true,
                              icon: Icon(
                                Icons.location_searching,
                                size: 30,
                              ),
                              name: "Point",
                              decoration: InputDecoration(
                                  labelText: "Titik Distribusi"),
                              initialValue: distrpoint,
                              hint: Text('Select Point'),
                              validator: FormBuilderValidators.compose(
                                  [FormBuilderValidators.required(context)]),
                              onChanged: (value) async {
                                print('dropdown value:$value');
                                if (mounted) {
                                  setState(() {
                                    distrpoint = value;
                                  });
                                }
                                await getAreas();
                                checkAvalAddress();
                              },
                              items: distrPoints
                                  .map((region) => DropdownMenuItem(
                                      value: region.id,
                                      child: Text(
                                        "${region.name}",
                                        textAlign: TextAlign.center,
                                      )))
                                  .toList(),
                            ),
                            shipmentAreas.length > 0
                                ? FormBuilderField(
                                    name: 'test',
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(context)
                                    ]),
                                    initialValue: shipmentAreas.last.shipmentId,
                                    enabled: _hasData ? true : false,
                                    builder: (FormFieldState<dynamic> field) {
                                      return DropdownButton(
                                        icon: Icon(
                                          Icons.location_on,
                                          size: 32,
                                          color: Colors.black,
                                        ),
                                        isExpanded: true,
                                        items: shipmentAreas.map((option) {
                                          return DropdownMenuItem(
                                              child: Text(
                                                "${option.shipmentAddress}/${option.shipmentName}",
                                                softWrap: true,
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              value: option.shipmentId);
                                        }).toList(),
                                        value: field.value,
                                        onChanged: (value) async {
                                          //!try to change value from shipment area but
                                          //! get shipmennt area to model.shipmenntarea;
                                          field.didChange(value);
                                          shipmentAreas.forEach(
                                              (i) => print(i.shipmentAddress));
                                          _valueChanged(true);
                                          print('dropDown value:$value');
                                          // int x = shipmentAreas.indexOf(value);
                                        },
                                      );
                                    })
                                : Container(),
                          ],
                        )),
                  ],
                ),
                actions: shipmentAreas.length > 0
                    ? <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 32,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            widget.model.shipmentArea = '';
                          },
                        ),
                        shipmentAreas.length > 0
                            ? IconButton(
                                icon: Icon(
                                  Icons.done,
                                  color: Colors.green,
                                  size: 32,
                                ),
                                onPressed: () async {
                                  _fbKey.currentState.save();
                                  print(_fbKey.currentState.value.values);
                                  _setType(shipmentAreas
                                      .where((s) =>
                                          s.shipmentId ==
                                          _fbKey.currentState.value.values.last)
                                      .first
                                      .shipmentArea);
                                  if (mounted) {
                                    setState(() {
                                      widget.model.shipmentAddress =
                                          shipmentAreas
                                              .where((id) =>
                                                  id.shipmentId ==
                                                  _fbKey.currentState.value
                                                      .values.last)
                                              .first
                                              .shipmentAddress;
                                      print(
                                          'shipment Address${widget.model.shipmentAddress}');
                                    });
                                  }
                                  print(
                                      '${widget.model.shipmentAddress}==>${widget.model.shipmentArea}=>${widget.model.shipmentName}');

                                  widget.model.isBulk && !widget.isEdit
                                      ? widget.model
                                          .orderToBulk(widget.model.bulkDistrId)
                                      : null;
                                  couriers = await widget.model.couriersList(
                                      widget.model.shipmentArea,
                                      widget.model.distrPoint);
                                  Navigator.of(context).pop();

                                  widget.isNewMember
                                      ? _showNewMemberCourier()
                                      : Container();
                                },
                              )
                            : Container(),
                      ]
                    : <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 32,
                          ),
                          onPressed: () {
                            widget.model.distrPoint = 0;

                            Navigator.of(context).pop();
                          },
                        ),
                        distrPoints.length > 0
                            ? IconButton(
                                icon: Icon(
                                  Icons.done,
                                  color: Colors.green,
                                  size: 32,
                                ),
                                onPressed: () async {
                                  _fbKey.currentState.save();
                                  if (mounted) {
                                    setState(() {
                                      distrpoint = _fbKey
                                          .currentState.value.values.first;
                                    });
                                  }
                                  await getAreas();
                                  checkAvalAddress();
                                },
                              )
                            : Container(),
                      ])
            : Container());
  }

  void checkAvalAddress() {
    if (shipmentAreas.length == 0) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AddRegion(widget.memberId));
    }
  }
}

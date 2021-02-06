import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/account/new_registration.dart';
import 'package:mor_release/models/courier.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class NewMemberCourier extends StatefulWidget {
  final List<Courier> couriers;
  final String areaId;
  final String distrId;
  final String userId;

  NewMemberCourier(this.couriers, this.areaId, this.distrId, this.userId);
  @override
  _NewMemberCourierState createState() => _NewMemberCourierState();
}

class _NewMemberCourierState extends State<NewMemberCourier> {
  List<Courier> shipments;
  String areaId;
  Courier _chosenValue;
  Courier stateValue;
  var courierFee;
  bool _loading = false;
  isloading(bool l) {
    setState(() {
      _loading = l;
    });
  }

  @override
  void initState() {
    getinit();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getinit() async {
    //  shipments = widget.couriers;
    areaId = widget.areaId;
  }

  final doubleFormat = new NumberFormat("####.##");
  final formatter = new NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ModalProgressHUD(
        inAsyncCall: _loading, //courierFee == null ? true : false,
        opacity: 0.6,
        progressIndicator: LinearProgressIndicator(),
        child: AlertDialog(
            title: Text(
              "New Member Shipping / Fees",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                child: FormField<Courier>(
                  initialValue: _chosenValue = null,
                  onSaved: (val) => _chosenValue = val,
                  validator: (val) =>
                      (val == null) ? 'Please choose a Courier' : null,
                  builder: (FormFieldState<Courier> state) {
                    return InputDecorator(
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(fontSize: 12),
                        isCollapsed: true,
                        isDense: true,
                        icon: Icon(Icons.local_shipping),
                        labelText: stateValue == null
                            ? 'Tipe Pengiriman / ${model.shipmentName}'
                            : '',
                        errorText: state.hasError ? state.errorText : null,
                      ),
                      isEmpty: state.value == null,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Courier>(
                          isExpanded: true,
                          // iconSize: 25.0,
                          // elevation: 5,
                          value: stateValue,
                          isDense: true,
                          onChanged: (Courier newValue) async {
                            if (newValue.courierId == '') {
                              newValue = null;
                            }
                            setState(() {
                              stateValue = newValue;
                              _loading = true;
                            });
                            state.didChange(newValue);
                            print(
                                "CourierId=>${newValue.id.toString()}..areaID=>$areaId..skitweight=>${model.settings.sKitWeight}");
                            courierFee = await model.courierServiceFee(
                                newValue.id.toString(),
                                areaId,
                                model.settings.sKitWeight);
                            setState(() {
                              model.newRegcourierFee = courierFee;
                            });
                            //  print('courierFee=>$courierFee');

                            isloading(false);
                            // print(newValue.id.toString());
                          },
                          items: widget.couriers.map((Courier courier) {
                            return DropdownMenuItem<Courier>(
                              value: courier,
                              child: Text(
                                "${courier.name} / ${model.shipmentName}",
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.pink[900],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              courierFee != null
                  ? Column(children: [
                      Container(
                          height: 27,
                          child: ListTile(
                            title: Text(
                              'Courier Fee',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              // textDirection: TextDirection.rtl,
                            ),
                            trailing: Text(
                              formatter
                                      .format(courierFee > 0 ? courierFee : 0) +
                                  ' Rp ',
                              style: TextStyle(fontSize: 12),
                            ),
                            leading: Icon(
                              GroovinMaterialIcons.truck,
                              size: 22,
                              color: Colors.black,
                            ),
                          )),
                      Container(
                          height: 27,
                          child: ListTile(
                            title: Text(
                              'Membership Fee',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                              formatter.format(
                                      double.tryParse(model.settings.catCode)) +
                                  ' Rp',
                              style: TextStyle(fontSize: 12),
                            ),
                            leading: Icon(
                              GroovinMaterialIcons.account_plus,
                              size: 22,
                              color: Colors.black,
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 24),
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                      Container(
                          height: 27,
                          child: ListTile(
                            title: Text(
                              'Total',
                              style: TextStyle(
                                  fontSize: 12.5, fontWeight: FontWeight.bold),
                              // textDirection: TextDirection.rtl,
                            ),
                            trailing: Text(
                              formatter.format(courierFee +
                                      double.tryParse(model.settings.catCode)) +
                                  ' Rp ',
                              style: TextStyle(
                                  fontSize: 12.2, fontWeight: FontWeight.bold),
                            ),
                            leading: Icon(
                              GroovinMaterialIcons.cash_multiple,
                              size: 24,
                              color: Colors.green,
                            ),
                          )),
                    ])
                  : Container()
            ]),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]),
      );
    });
  }
}

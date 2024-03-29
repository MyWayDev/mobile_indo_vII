import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_up_panel/sliding_up_panel_widget.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/pages/gift/gift_card.dart';
import 'package:mor_release/pages/gift/promo/promo_card.dart';
import 'package:mor_release/pages/items/itemDetails/details.dart';
import 'package:mor_release/pages/order/bulkOrder.dart';
import 'package:mor_release/pages/order/end_order.dart';
import 'package:mor_release/pages/order/widgets/bonus.deduct.dart';
import 'package:mor_release/pages/order/widgets/shipmentArea.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/widgets/stock_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/cupertino.dart';

class OrderPage extends StatefulWidget {
  final MainModel model;
  OrderPage(this.model);

  State<StatefulWidget> createState() {
    return _OrderPage();
  }
}

@override
class _OrderPage extends State<OrderPage> {
  final formatter = new NumberFormat("#,###");
  final formatWeight = new NumberFormat("#,###.##");

  void isBulk(bool b, MainModel model) {
    setState(() {
      model.isBulk = b;
    });
  }

  ScrollController scrollController;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.offset >=
              scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.expand();
      } else if (scrollController.offset <=
              scrollController.position.minScrollExtent &&
          !scrollController.position.outOfRange) {
        panelController.anchor();
      } else {}
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        elevation: 8,
        backgroundColor: Colors.deepPurple[50],
        context: context,
        builder: (BuildContext bc) {
          return ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Positioned(
                      top: 1,
                      left: MediaQuery.of(context).size.width / 6,
                      right: MediaQuery.of(context).size.width / 6,
                      child: IconButton(
                        icon: Icon(
                          Icons.add_location,
                          size: 32,
                          color: Colors.pink[900],
                        ),
                        onPressed: () {
                          //Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (_) => ShipmentPlace(
                                    model: widget.model,
                                    memberId: model.userInfo.distrId,
                                    isEdit: true,
                                  ));
                        },
                      )),
                  Positioned(
                    top: 40,
                    left: MediaQuery.of(context).size.width / 10,
                    right: MediaQuery.of(context).size.width / 10,
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Row(
                        children: <Widget>[
                          Container(
                            //width: MediaQuery.of(context).size.width * 0.8,
                            child: Flexible(
                                flex: 1,
                                child: Column(
                                  children: <Widget>[
                                    Flex(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        direction: Axis.horizontal,
                                        //  direction: Axis.horizontal,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 1,
                                              // width: 113,
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8),
                                                child: Text(
                                                  '${model.shipmentAddress}/${model.shipmentName}',
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )),
                                        ]),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 68),
                    child: ListView.builder(
                      itemCount: model.bulkOrder.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          enabled: true,
                          selected: true,
                          onTap: () {
                            if (model.itemorderlist.length > 0) {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Hapus pesanan di keranjang ?',
                                          style: TextStyle(
                                              color: Colors.pink[900])),
                                      actions: <Widget>[
                                        IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.check),
                                          onPressed: () {
                                            model.itemorderlist.clear();
                                            model.itemorderlist.addAll(
                                                model.bulkOrder[index].order);
                                            model.bulkOrder
                                                .remove(model.bulkOrder[index]);
                                            model.bulkOrder.length == 0
                                                ? model.shipmentAddress = ''
                                                : null;
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              model.itemorderlist
                                  .addAll(model.bulkOrder[index].order);
                              model.giftorderList
                                  .addAll(model.bulkOrder[index].gifts);
                              model.promoOrderList
                                  .addAll(model.bulkOrder[index].promos);
                              model.bulkOrder.remove(model.bulkOrder[index]);
                              model.bulkOrder.length == 0
                                  ? model.shipmentAddress = ''
                                  : null;
                              print(model.shipmentArea);
                              Navigator.of(context).pop();
                            }
                          },
                          leading: Column(
                            children: <Widget>[
                              Icon(Icons.vpn_key, size: 18),
                              Text(model.bulkOrder[index].distrId,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                            ],
                          ),
                          title: Column(
                            children: <Widget>[
                              Text(
                                "Rp ${formatter.format(model.bulkOrder[index].total)}",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                              Text(
                                "Bp ${formatter.format(model.bulkOrder[index].totalBp)}",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                              Text(
                                "kg ${formatWeight.format(model.bulkOrder[index].weight)}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11),
                              ),
                              Divider(height: 12, color: Colors.black)
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              model.bulkOrder.remove(model.bulkOrder[index]);
                              if (model.bulkOrder.length == 0) {
                                isBulk(false, model);
                                model.shipmentAddress = '';
                                //model.shipmentArea = '';
                              }

                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.delete_forever),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
          floatingActionButton: model.isBulk
              ? FloatingActionButton(
                  backgroundColor: Colors.purple[800],
                  onPressed: () {
                    _settingModalBottomSheet(context);
                  },
                  child: BadgeIconButton(
                    // badgeColor: Colors.red[800],
                    badgeTextColor: Colors.white,
                    itemCount: model.bulkOrder.length,
                    icon: Icon(
                      Icons.format_list_numbered,
                      size: 28,
                      color: Colors.white,
                    ),
                  ))
              : Container(),
          resizeToAvoidBottomInset: true,
          // resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              Column(children: <Widget>[
                model.bulkOrder.length != 0
                    ? Container(
                        height: 60,
                        child: Card(
                          color: Colors.grey[350],
                          elevation: 5,
                          child: ListTile(
                              leading: Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(left: 20),
                                    ),
                                    Text(
                                      ' Rp ${formatter.format(model.bulkOrderSum())}',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' Bp ${formatter.format(model.bulkOrderBp())}',
                                      style: TextStyle(
                                        color: Colors.pink[800],
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      ' Kg ${formatWeight.format(model.bulkOrderWeight())}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              title: Icon(
                                GroovinMaterialIcons.format_list_checks,
                                color: Colors.grey,
                                size: 34,
                              ), // required
                              //badgeColor: Colors.red, // default: Colors.red

                              trailing: Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: model.itemorderlist.length == 0
                                      ? RawMaterialButton(
                                          child: Icon(
                                            Icons.send,
                                            size: 24.0,
                                            color: Colors.white,
                                          ),
                                          shape: CircleBorder(),
                                          highlightColor: Colors.pink[900],
                                          elevation: 3,
                                          fillColor: Colors.green,
                                          onPressed: () {
                                            model.loading = false;

                                            Navigator.push(context,
                                                MaterialPageRoute(builder: (_) {
                                              return BulkOrder(
                                                  model,
                                                  model.shipmentArea,
                                                  model.distrPoint);
                                            }));
                                          },
                                          splashColor: Colors.pink[900],
                                        )
                                      : RawMaterialButton(
                                          child: Icon(
                                            Icons.block,
                                            size: 24.0,
                                            color: Colors.white,
                                          ),
                                          shape: CircleBorder(),
                                          highlightColor: Colors.pink[900],
                                          elevation: 3,
                                          fillColor: Colors.red,
                                          onPressed: () {
                                            model.loading = false;
                                          },
                                          splashColor: Colors.pink[900],
                                        ))),
                        ),
                      )
                    : Container(),
                model.itemorderlist.length != 0
                    ? Container(
                        height: 60,
                        // decoration: BoxDecoration(color: Colors.grey[350]),
                        child: Card(
                            color: Colors.purple[50],
                            elevation: 8,
                            child: ListTile(
                                leading: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                      ),
                                      Text(
                                        'Rp ${formatter.format(model.orderSum())}',
                                        style: TextStyle(
                                          color: Colors.green[700],
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ' Bp ${formatter.format(model.orderBp())}',
                                        style: TextStyle(
                                          color: Colors.pink[800],
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ' Kg ${formatWeight.format(model.orderWeight())}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    model.bulkOrder.length == 0 &&
                                            model.userInfo.isleader &&
                                            model.docType == 'CR'
                                        ? Transform.scale(
                                            scale: 1.5,
                                            child: Switch(
                                              inactiveTrackColor:
                                                  Colors.white70,
                                              activeTrackColor: Colors.grey,
                                              activeColor: Colors.black12,
                                              value: model.isBulk,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  model.isBulk = value;
                                                  model.shipmentAddress = '';
                                                  model.shipmentArea = '';
                                                });
                                              },
                                              activeThumbImage: AssetImage(
                                                  'assets/images/bulk.png'),
                                              inactiveThumbImage: AssetImage(
                                                  'assets/images/box.png'),
                                            ),
                                          )
                                        : Icon(
                                            GroovinMaterialIcons.cart_plus,
                                            color: Colors.grey,
                                            size: 32,
                                          ),
                                  ],
                                ),
                                trailing: !model.isBulk
                                    ? Padding(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: RawMaterialButton(
                                          child: Icon(
                                            Icons.send,
                                            size: 24.0,
                                            color: Colors.white,
                                          ),
                                          shape: CircleBorder(),
                                          highlightColor: Colors.pink[900],
                                          elevation: 3,
                                          fillColor: Colors.green,
                                          onPressed: () async {
                                            model.loading = false;
                                            model.bonusDeductValidation()
                                                ? model
                                                    .flush(context,
                                                        'Pembayaran bonus tidak boleh lebih dari total pesanan')
                                                    .show(context)
                                                : Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) {
                                                      return EndOrder(model);
                                                    }),
                                                  );
                                          },
                                          splashColor: Colors.pink[900],
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(bottom: 8),
                                        child: model.giftPacks.length == 0 &&
                                                model.promoPacks.length == 0
                                            ? RawMaterialButton(
                                                child: Icon(
                                                  Icons.add,
                                                  size: 24.0,
                                                  color: Colors.white,
                                                ),
                                                shape: CircleBorder(),
                                                highlightColor:
                                                    Colors.pink[900],
                                                elevation: 9,
                                                fillColor: Colors.purple[800],
                                                onPressed: () async {
                                                  //model.giftorderList.clear();

                                                  showDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          NodeDialoge(model));
                                                },
                                                splashColor: Colors.pink[900],
                                              )
                                            : RawMaterialButton(
                                                child: Icon(
                                                  Icons.block,
                                                  size: 24.0,
                                                  color: Colors.white,
                                                ),
                                                shape: CircleBorder(),
                                                highlightColor:
                                                    Colors.pink[900],
                                                elevation: 9,
                                                fillColor: Colors.red[800],
                                                onPressed: () async {
                                                  //model.giftorderList.clear();
                                                  /* showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      NodeDialoge(model));*/
                                                },
                                                splashColor: Colors.pink[900],
                                              )))))
                    : Container(),
                model.itemorderlist.isNotEmpty &&
                        model.desrvBonusList.isNotEmpty
                    ? BonusDeduct(model)
                    : Container(),
                model.isBulk ? BulkGiftsAndPromos(model) : Container(),
                _orderExp(context, model, formatter, formatWeight)
              ]),
            ],
          ));
    });
  }
}

Widget _orderExp(BuildContext context, MainModel model, NumberFormat formatter,
    NumberFormat formatWeight) {
  return Expanded(
      child: model.itemorderlist.length != 0
          ? ListView.builder(
              itemCount: model.itemorderlist.length,
              itemBuilder: (BuildContext context, int i) {
                return Dismissible(
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {
                        model.deleteItemOrder(i);
                        model.itemCount();
                      } else if (direction == DismissDirection.startToEnd) {
                        model.deleteItemOrder(i);
                        model.itemCount();
                      }
                    },
                    background: Container(
                      color: Colors.grey[50],
                    ),
                    key: Key(model.displayItemOrder[i].itemId),
                    child: Column(
                      children: <Widget>[
                        Card(
                          elevation: 8,
                          child: ListTile(
                            enabled: true,
                            selected: true,
                            //   trailing: _buildIconButton(context, i, model),
                            // contentPadding: EdgeInsets.only(top: 10.0),
                            leading: CircleAvatar(
                              minRadius: 36,
                              maxRadius: 36,
                              backgroundColor: Colors.purple[50],
                              backgroundImage: NetworkImage(
                                model.itemorderlist[i].img,
                              ),
                            ),
                            title: Row(children: <Widget>[
                              Container(
                                child: Flexible(
                                  flex: 1,
                                  child: Column(children: <Widget>[
                                    Flex(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        direction: Axis.horizontal,
                                        //  direction: Axis.horizontal,
                                        children: <Widget>[
                                          model
                                                      .itemorderlist[i]
                                                      .promoItemsDetails
                                                      .length >
                                                  0
                                              ? Container(
                                                  width: model
                                                                  .itemorderlist[
                                                                      i]
                                                                  .promoItemsDetails
                                                                  .length ==
                                                              2 ||
                                                          model
                                                                  .itemorderlist[
                                                                      i]
                                                                  .promoItemsDetails
                                                                  .length ==
                                                              3
                                                      ? 108
                                                      : model
                                                                  .itemorderlist[
                                                                      i]
                                                                  .promoItemsDetails
                                                                  .length >
                                                              3
                                                          ? 146
                                                          : 36,
                                                  height: 55,
                                                  child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: model
                                                          .itemorderlist[i]
                                                          .promoItemsDetails
                                                          .length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              model
                                                                  .itemorderlist[
                                                                      i]
                                                                  .promoItemsDetails[
                                                                      index]
                                                                  .itemId,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      10.5,
                                                                  color: Colors
                                                                          .orange[
                                                                      800],
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            GestureDetector(
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => Details(
                                                                            model.itemorderlist[i].promoItemsDetails[index],
                                                                            model.getCaouselItems(model.itemorderlist[i].promoItemsDetails[index])),
                                                                      ));
                                                                },
                                                                child:
                                                                    CircleAvatar(
                                                                  child: Text(
                                                                    'GRATIS',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            9,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .grey[800]),
                                                                  ),
                                                                  radius: 18,
                                                                  backgroundColor:
                                                                      Colors.grey[
                                                                          300],
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                    model
                                                                        .itemorderlist[
                                                                            i]
                                                                        .promoItemsDetails[
                                                                            index]
                                                                        .imageUrl,
                                                                  ),
                                                                ))
                                                          ],
                                                        );
                                                      }),
                                                )
                                              : Container(),
                                          Container(
                                            width: 38,
                                            child: Text(
                                              " " +
                                                  model.itemorderlist[i].itemId,
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFFF8C00),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              // width: 113,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 8, left: 3),
                                                child: Text(
                                                  model.itemorderlist[i].name,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13.0,
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )),
                                        ]),
                                    Center(
                                        child: Text(
                                      'Total Barang',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    )),
                                    Divider(
                                      height: 3.0,
                                      indent: 0,
                                      color: Colors.blueGrey,
                                    ),
                                  ]),
                                ),
                              ),
                            ]),
                            subtitle: Row(
                              children: <Widget>[
                                Container(
                                  child: Flexible(
                                    flex: 1,
                                    child: Column(
                                      children: <Widget>[
                                        Flex(
                                            direction: Axis.horizontal,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Text(
                                                'Rp ${formatter.format(model.itemorderlist[i].totalPrice)}',
                                                style: TextStyle(
                                                  fontSize: 13.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green[700],
                                                ),
                                              ),
                                              _buildIconButton(
                                                  context, i, model),
                                              Column(
                                                children: <Widget>[
                                                  Text(
                                                    'Bp ${model.itemorderlist[i].totalBp.toString()}',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.red[900],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Divider(
                                                    height: 2.0,
                                                    indent: 1,
                                                    color: Colors.black,
                                                  ),
                                                  Text(
                                                    'Kg ${formatWeight.format(model.itemorderlist[i].totalWeight)}',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ]),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ));
              },
            )
          : Center(
              child: Icon(
              Icons.remove_shopping_cart,
              size: 80.5,
              color: Colors.grey[300],
            )));
}
//double orderPlus(double orderSum, int courierFee, int bpLimit) {}

Widget _buildIconButton(BuildContext context, int i, MainModel model) {
  return BadgeIconButton(
    itemCount: model.itemorderlist[i].qty <= 0
        ? 0
        : model.itemorderlist[i].qty, // required
    icon: Icon(
      Icons.shopping_cart,
      color: Colors.grey[600],
      size: 28.0,
    ), // required
    //badgeColor: Colors.pink[900],
    badgeTextColor: Colors.white,
    onPressed: () {
      showDialog(
          context: context,
          builder: (_) => StockDialog(model.itemData, model.getItemIndex(i),
              model.itemorderlist[i].qty));
    },
  );
}

class BulkGiftsAndPromos extends StatefulWidget {
  final MainModel model;
  BulkGiftsAndPromos(this.model, {Key key}) : super(key: key);

  @override
  _BulkGiftsAndPromosState createState() => _BulkGiftsAndPromosState();
}

class _BulkGiftsAndPromosState extends State<BulkGiftsAndPromos> {
  void giftState(MainModel model) async {
    await model.checkGift(model.orderBp(), model.giftBp());
    model.getGiftPack();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.model.rungiftState();

    return Row(
      children: <Widget>[
        widget.model.giftPacks.length > 0
            ? Flexible(
                child: SizedBox(
                    height: 45.0,
                    child: Card(
                      color: Color(0xFFFFFFF1),
                      elevation: 5,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ModalProgressHUD(
                                color: Colors.transparent,
                                inAsyncCall: widget.model.isloading,
                                opacity: 0.1,
                                progressIndicator: LinearProgressIndicator(
                                  backgroundColor: Colors.grey[200],
                                ),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: widget.model.giftPacks.length,
                                  itemBuilder: (context, i) {
                                    return GiftCard(widget.model.giftPacks, i);
                                  },
                                )),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    )),
              )
            : Container(),
        widget.model.promoPacks.length > 0
            ? Flexible(
                child: SizedBox(
                  height: 45.0,
                  child: Card(
                    color: Color(0xFFFFFFF1),
                    elevation: 5,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ModalProgressHUD(
                              color: Colors.transparent,
                              inAsyncCall: widget.model.isloading,
                              opacity: 0.1,
                              progressIndicator: LinearProgressIndicator(
                                backgroundColor: Colors.grey[200],
                              ),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.model.promoPacks.length,
                                itemBuilder: (context, i) {
                                  return PromoCard(widget.model.promoPacks, i);
                                },
                              )),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                  ),
                ),
              )
            : Container(),
        widget.model.giftorderList.length > 0
            ? Flexible(
                child: SizedBox(
                    height: 45.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        ListView.builder(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 15),
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.model.giftorderList.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Stack(
                              children: <Widget>[
                                Positioned(
                                    child: Opacity(
                                  opacity: 0.9,
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: NetworkImage(
                                      widget.model.giftorderList[i].imageUrl,
                                    ),
                                    child: BadgeIconButton(
                                      itemCount: widget.model.gCount(i),
                                      icon: Icon(
                                        Icons.shopping_cart,
                                        color: Colors.pink[900],
                                        size: 0.0,
                                      ), // required
                                      //badgeColor: Colors.pink[900],
                                      badgeTextColor: Colors.white,
                                      onPressed: () {
                                        widget.model.deleteGiftOrder(i);
                                        setState(() {
                                          giftState(widget.model);
                                        });
                                      },
                                    ),
                                  ),
                                )),
                                /*Padding(
                                      padding: EdgeInsets.only(left: 40),
                                      child: Text(
                                        model.giftorderList[i].desc,
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 0.8,
                                      )),*/
                              ],
                            );
                          },
                        ),
                      ],
                    )),
              )
            : Container(),
        widget.model.promoOrderList.length > 0
            ? Flexible(
                child: SizedBox(
                    height: 45,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        ListView.builder(
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 15),
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.model.promoOrderList.length,
                          itemBuilder: (BuildContext context, int i) {
                            return Stack(
                              children: <Widget>[
                                Positioned(
                                    child: Opacity(
                                  opacity: 0.9,
                                  child: CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.grey[300],
                                    backgroundImage: NetworkImage(
                                      widget.model.promoOrderList[i].imageUrl,
                                    ),
                                    child: BadgeIconButton(
                                      itemCount: widget.model.promoCount(i),
                                      icon: Icon(
                                        Icons.shopping_cart,
                                        color: Colors.pink[900],
                                        size: 0.0,
                                      ), // required
                                      //badgeColor: Colors.pink[900],
                                      badgeTextColor: Colors.white,
                                      onPressed: () {
                                        widget.model.deletePromoOrder(i);
                                        setState(() {
                                          giftState(widget.model);
                                        });
                                      },
                                    ),
                                  ),
                                )),
                                /*Padding(
                                      padding: EdgeInsets.only(left: 40),
                                      child: Text(
                                        model.giftorderList[i].desc,
                                        textAlign: TextAlign.left,
                                        textScaleFactor: 0.8,
                                      )),*/
                              ],
                            );
                          },
                        )
                      ],
                    )),
              )
            : Container()
      ],
    );
  }
}

class NodeDialoge extends StatefulWidget {
  final MainModel model;
  NodeDialoge(this.model, {Key key}) : super(key: key);

  @override
  _NodeDialogeState createState() => _NodeDialogeState();
}

class _NodeDialogeState extends State<NodeDialoge> {
  User _nodeData;
  bool isTyping;
  bool veri = false;
  bool _isloading = false;

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

  void getTyping(MainModel model) {
    setState(() {
      model.isTypeing = isTyping;
    });
  }

  void resetVeri() {
    controller.clear();
    setState(() {
      veri = false;
      _isloading = false;
    });
  }

  final Map<String, dynamic> _orderFormData = {
    'id': null,
    'areaId': null,
    'name': null,
  };

  TextEditingController controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: _isloading,
        opacity: 0.6,
        progressIndicator: LinearProgressIndicator(),
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            width: 120,
            height: 60,
            child: ListTile(
              //  contentPadding: EdgeInsets.all(0),
              leading: Icon(Icons.vpn_key, size: 24.0, color: Colors.pink[500]),
              title: TextFormField(
                textAlign: TextAlign.center,
                controller: controller,
                enabled: !veri ? true : false,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Masukkan ID member',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value.isEmpty
                    ? 'Code is Empty !!'
                    : RegExp('[0-9]').hasMatch(value)
                        ? null
                        : 'invalid code !!',
                onSaved: (String value) {
                  _orderFormData['id'] = value.padLeft(8, '0');
                },
              ),
              trailing: IconButton(
                icon: !veri //&& controller.text.length > 0
                    ? Icon(
                        Icons.check,
                        size: 26.0,
                        color: Colors.blue,
                      )
                    : controller.text.length > 0
                        ? Icon(
                            Icons.close,
                            size: 24.0,
                            color: Colors.grey,
                          )
                        : Container(),
                color: Colors.pink[900],
                onPressed: () async {
                  isloading(true);
                  if (!veri) {
                    veri = await widget.model
                        .leaderVerification(controller.text.padLeft(8, '0'));
                    if (veri) {
                      _nodeData = await widget.model
                          .nodeJson(controller.text.padLeft(8, '0'));
                      print('_nodeData.distrId:${_nodeData.distrId}');
                      _nodeData.distrId == '00000000'
                          ? resetVeri()
                          : controller.text =
                              _nodeData.distrId + '    ' + _nodeData.name;
                      if (_nodeData.distrId == '00000000') {
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (_) => NodeDialoge(widget.model));
                      } else {
                        Navigator.of(context).pop();
                        setState(() {
                          widget.model.bulkDistrId = _nodeData.distrId;
                        });
                        widget.model.shipmentAddress == null ||
                                widget.model.shipmentAddress == ''
                            ? showDialog(
                                context: context,
                                builder: (_) => ShipmentPlace(
                                      model: widget.model,
                                      memberId: _nodeData.distrId,
                                    ))
                            : widget.model
                                .orderToBulk(widget.model.bulkDistrId);
                      }
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
          ),
        ));
  }
}

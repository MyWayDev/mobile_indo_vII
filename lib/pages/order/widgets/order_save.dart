import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mor_release/widgets/save_bulk_dialog.dart';
import 'package:mor_release/widgets/save_dialog.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class OrderSave extends StatelessWidget {
  final String courierId;
  final double courierFee;
  final double courierDiscount;
  final String distrId;
  final String note;
  final String userId;
  final String areaId;
  final formatter = new NumberFormat("#,###");

  OrderSave(this.courierId, this.courierFee, this.courierDiscount, this.distrId,
      this.note, this.areaId, this.userId);
  double orderTotal(MainModel model) {
    return model.orderSum() + model.settings.adminFee;
  }

  double bulkOrderCourierFee(MainModel model) {
    double finalCourierFee = courierFee - courierDiscount;
    return finalCourierFee;
  }

  double bulkOrderTotal(MainModel model) {
    double finalBulkOrderSum = model.bulkOrderSum() + model.settings.adminFee;
    return finalBulkOrderSum;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return saveButton(context, model);
    });
  }

  Widget saveButton(BuildContext context, MainModel model) {
    return !model.isBulk
        ? Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      splashColor: Theme.of(context).primaryColor,
                      color: Colors.tealAccent[400],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Transform.translate(
                            offset: Offset(1.0, 0.0),
                            child: Container(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: model.distrBonusList.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800]),
                                          //  textDirection: TextDirection.rtl,
                                        ),
                                        Text(
                                          'Pemotongan Bonus',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.deepOrange[400]),
                                          //  textDirection: TextDirection.rtl,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Total Keseluruhan',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              //  textDirection: TextDirection.rtl,
                                            ),
                                            Text(
                                              "  + 10% PPN",
                                              style: TextStyle(
                                                  color: Colors.pink[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Total Keseluruhan',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          //  textDirection: TextDirection.rtl,
                                        ),
                                        Text(
                                          "  + 10% PPN",
                                          style: TextStyle(
                                              color: Colors.pink[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          model.distrBonusList.isNotEmpty
                              ? Column(
                                  children: [
                                    Text(
                                      formatter.format((orderTotal(model)) +
                                              courierFee) +
                                          ' Rp',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '-' +
                                          formatter.format(
                                              model.distrBonusList[0].bonus) +
                                          ' Rp',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.deepOrangeAccent[400],
                                      ),
                                    ),
                                    Text(
                                      formatter.format((orderTotal(model) -
                                                  model.distrBonusList[0]
                                                          .bonus *
                                                      1.1) +
                                              courierFee) +
                                          ' Rp',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              : Text(
                                  formatter.format((orderTotal(model) * 1.1) +
                                          courierFee) +
                                      ' Rp',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                      onPressed: () {
                        model.isBalanceChecked = true;

                        // model.promoOrderList.forEach(
                        //   (f) => print('bp?:${model.orderBp() / f.bp} qty:${f.qty}'));
                        //model.isTypeing = false;
                        showDialog(
                            context: context,
                            builder: (_) => SaveDialog(
                                courierId,
                                (courierFee - courierDiscount),
                                distrId,
                                note,
                                areaId,
                                userId));
                      })),
            ],
          )
        : Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 1),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      splashColor: Theme.of(context).primaryColor,
                      color: Colors.tealAccent[400],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Transform.translate(
                            offset: Offset(1.0, 0.0),
                            child: Container(
                              padding: const EdgeInsets.only(right: 2.0),
                              child: model.distrBonusList.isNotEmpty
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[800]),
                                          //  textDirection: TextDirection.rtl,
                                        ),
                                        Text(
                                          'Pemotongan Bonus',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.deepOrange[300]),
                                          //  textDirection: TextDirection.rtl,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              'Total Keseluruhan',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                              //  textDirection: TextDirection.rtl,
                                            ),
                                            Text(
                                              "  + 10% PPN",
                                              style: TextStyle(
                                                  color: Colors.pink[800],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Total Keseluruhan',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          //  textDirection: TextDirection.rtl,
                                        ),
                                        Text(
                                          "  + 10% PPN",
                                          style: TextStyle(
                                              color: Colors.pink[800],
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          model.distrBonusList.isNotEmpty
                              ? Column(
                                  children: [
                                    Text(
                                      formatter.format((bulkOrderTotal(model)) +
                                              bulkOrderCourierFee(model)) +
                                          ' Rp',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '-' +
                                          formatter.format(
                                              model.distrBonusList[0].bonus) +
                                          ' Rp',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.deepOrangeAccent[400],
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      formatter.format((bulkOrderTotal(model) -
                                                  model.distrBonusList[0]
                                                          .bonus *
                                                      1.1) +
                                              bulkOrderCourierFee(model)) +
                                          ' Rp',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              : Text(
                                  formatter.format(
                                          (bulkOrderTotal(model) * 1.1) +
                                              bulkOrderCourierFee(model)) +
                                      ' Rp',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                        ],
                      ),
                      onPressed: () async {
                        model.isBalanceChecked = true;

                        // model.promoOrderList.forEach(
                        //   (f) => print('bp?:${model.orderBp() / f.bp} qty:${f.qty}'));
                        model.isTypeing = false;
                        /*   await model.saveBulkOrders(model.bulkOrder,
                            (courierFee - courierDiscount), note, courierId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BottomNav(model.userInfo.distrId),
                          ),
                        );*/

                        showDialog(
                            context: context,
                            builder: (_) => SaveBulkDialog(
                                courierId,
                                (courierFee - courierDiscount),
                                distrId,
                                note,
                                areaId,
                                userId));
                      })),
            ],
          );
  }
}

/*

 */

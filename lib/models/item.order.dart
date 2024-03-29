import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:mor_release/models/gift.order.dart';
import 'package:mor_release/models/user.dart';

import 'item.dart';

class ItemOrder {
  String itemId;
  double price;
  int bp;
  double bv;
  double weight;
  int qty;
  String name;
  String img;
  List<Item> promoItemsDetails;

  double get totalWeight {
    double _totalWeight = weight * qty;
    return _totalWeight;
  }

  double get totalPrice {
    double _totalPrice = qty * price;
    return _totalPrice;
  }

  int get totalBp {
    int _totalBp = qty * bp;
    return _totalBp;
  }

  ItemOrder(
      {this.itemId,
      this.price,
      this.qty,
      this.bp,
      this.bv,
      this.name,
      this.weight,
      this.img,
      this.promoItemsDetails});

  Map<String, dynamic> toJson() => {
        "ITEM_ID": itemId,
        "QTY": qty,
        "QTY_REQ": qty,
        "UNIT_PRICE": price,
        "NET_PRICE": totalPrice,
        "TOT_PRICE": totalPrice,
        "ITEM_BP": bp,
        "ITEM_BV": bv,
      };

  String postToJson(ItemOrder itemOrder) {
    final dyn = itemOrder.toJson();
    return json.encode(dyn);
  }

  factory ItemOrder.fromJson(Map<String, dynamic> json) {
    return ItemOrder(itemId: json['itemId'], qty: json['qty']);
  }

  //  this.bv, });
}

class OrderMsg {
  String soid;
  double amt;
  String docDate;
  String addTime;
  String error;

  DateTime get addDate {
    DateTime _addDate = DateTime.parse(docDate + " " + addTime);
    return _addDate;
  }

  OrderMsg({this.soid, this.amt, this.docDate, this.addTime, this.error});
  factory OrderMsg.fromJson(Map<String, dynamic> msg) {
    return OrderMsg(
      soid: msg['id'],
      amt: msg['amt'],
      docDate: msg['docDate'],
      addTime: msg['addTime'],
    );
  }
}

class OrderBulkMsg {
  List<dynamic> ids;
  String error;

  OrderBulkMsg({this.ids, this.error});
  factory OrderBulkMsg.fromJson(Map<String, dynamic> msg) {
    return OrderBulkMsg(
      ids: msg['ids'] ?? [],
      error: msg['error'] ?? '',
    );
  }
}

class SalesOrder {
  String distrId;
  String userId;
  String courierId;
  String areaId;
  double total;
  int totalBp;
  double weight;
  String note;
  String address;
  String amt;
  String so;
  String storeId;
  String branchId;
  String soType;
  String projId;
  String courierFee;
  String bonusDeduc;
  List<DistrBonus> distrBonues;
  List<ItemOrder> order;
  List<GiftOrder> gifts;
  List<PromoOrder> promos;

  SalesOrder(
      {this.distrId,
      this.userId,
      this.total,
      this.totalBp,
      this.order,
      this.weight,
      this.courierId,
      this.areaId,
      this.note,
      this.address,
      this.amt,
      this.so,
      this.storeId,
      this.branchId,
      this.soType,
      this.projId,
      this.courierFee,
      this.bonusDeduc,
      this.distrBonues,
      this.gifts,
      this.promos});

  Map<String, dynamic> toJson() => {
        "ap3": distrBonues,
        "a9master": {
          "STORE_ID": storeId, //!new
          "BRANCH_ID": branchId, //!new
          "CUS_VEN_ID": distrId,
          "USER_ID": userId,
        },
        "apmaster": {
          "STORE_ID": storeId, //!new
          "SO_INV_TYPE": soType, //!new
          "GROSS_TOTAL": total,
          "NET_TOTAL": total,
          "PRJ_ID": projId,
          "DS_SHIPMENT_COMP": courierId,
          "DS_SHIPMENT_PLACE": areaId,
          "LREMARKS": note,
          "AREMARKS": courierFee ?? '0',
          "SHIPMTHD_L": bonusDeduc,
          "DISC_NOTES": address,
        },
        "aadetail": order,
        "aqdetail": order,
      };

  String postOrderToJson(SalesOrder salesOrder) {
    final dyn = salesOrder.toJson();
    return json.encode(dyn);
  }

  Future<http.Response> createPost(SalesOrder salesOrder, String apiUrl) async {
    final response = await http.put('$apiUrl/invoice',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          //HttpHeaders.authorizationHeader: ''
        },
        body: postOrderToJson(salesOrder));
    return response;
  }
}

class BulkSalesOrder {
  List<SalesOrder> bulkSalesOrder;

  BulkSalesOrder({
    this.bulkSalesOrder,
  });

  Map<String, dynamic> toJson() => {"batch": bulkSalesOrder};

  String postBulkOrderToJson(BulkSalesOrder bulkOrder) {
    final dyn = bulkOrder.toJson();
    return json.encode(dyn);
  }

  Future<http.Response> createBulkPost(
      BulkSalesOrder batch, String apiUrl) async {
    final response = await http.put('$apiUrl/insert_batch_sales_orders',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          //HttpHeaders.authorizationHeader: ''
        },
        body: postBulkOrderToJson(batch));
    return response;
  }
}

import 'package:firebase_database/firebase_database.dart';

class Area {
  String areaId;
  String name;

  Area({this.areaId, this.name});

  Area.fromSnapshot(DataSnapshot snapshot)
      : areaId = snapshot.value['areaId'],
        name = snapshot.value['name'];
  factory Area.json(Map<dynamic, dynamic> json) {
    return Area(areaId: json['areaId'], name: json['name']);
  }
  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(areaId: json['AREA_ID'], name: json['LNAME']);
  }
  toJson() {
    return {
      "areaId": areaId,
      "name": name,
      "id": areaId,
    };
  }
}

class AreaPlace {
  String shipmentPlace;
  String spName;
  String areaId;
  String areaName;

  AreaPlace({this.shipmentPlace, this.spName, this.areaId, this.areaName});

  factory AreaPlace.json(Map<dynamic, dynamic> json) {
    return AreaPlace(
        shipmentPlace: json['DS_SHIPMENT_PLACE'],
        spName: json['SPNAME'],
        areaId: json['AREA_ID'],
        areaName: json['AREA_NAME']);
  }
}

class Region {
  String regionId;
  String name;
  bool distrPoint;
  List storeId;
  int id;
  Region({this.regionId, this.name, this.id, this.distrPoint, this.storeId});
  Region.fromSnapshot(DataSnapshot snapshot)
      : regionId = snapshot.value['regionId'],
        name = snapshot.value['name'],
        id = snapshot.value['id'];

  factory Region.json(Map<dynamic, dynamic> json) {
    return Region(
        id: json['id'],
        regionId: json['regionId'],
        name: json['name'],
        storeId: json['storeId'],
        distrPoint: json['distrPoint'] ?? false);
  }
}

class Store {
  String storeId;
  String name;
  String docType;
  int region;

  Store({this.storeId, this.name, this.docType, this.region});
  Store.fromSnapshot(DataSnapshot snapshot)
      : storeId = snapshot.value['storeId'] ?? '05',
        name = snapshot.value['name'] ?? 'JAKARTA',
        region = snapshot.value['region'],
        docType = snapshot.value['docType'] ?? 'CR';

  factory Store.json(Map<dynamic, dynamic> json) {
    return Store(
      storeId: json['storeId'] ?? '02',
      name: json['name'] ?? 'JAKARTA',
      docType: json['docType'] ?? 'CR',
      region: json['region'] ?? 1,
    );
  }
}

class Bank {
  String bankId;
  String bankName;

  Bank({this.bankId, this.bankName});

  factory Bank.json(Map<dynamic, dynamic> json) {
    return Bank(bankId: json['DS_BANK'], bankName: json['LNAME']);
  }
}

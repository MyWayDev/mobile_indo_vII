import 'package:firebase_database/firebase_database.dart';
import 'package:mor_release/models/user.dart';

class Gift {
  List items;
  String desc;
  int bp;
  String imageUrl;
  //double weight;
  bool accumilitive;
  bool newStart;

  Gift(
      {this.items,
      this.bp,
      this.imageUrl,
      this.desc,
      // this.weight,
      this.accumilitive,
      this.newStart});

  Gift.fromSnapshot(DataSnapshot snapshot)
      : items = snapshot.value['items'] ?? [],
        bp = snapshot.value['bp'] ?? 0,
        accumilitive = snapshot.value['accumilitive'] ?? false,
        newStart = snapshot.value['newStart'] ?? false,
        imageUrl = snapshot.value['imageUrl'] ?? ''
  // weight = snapshot.value['weight'] ?? 0.0
  ;

  factory Gift.fbList(Map<dynamic, dynamic> list) {
    return Gift(
        bp: list['bp'] ?? 0,
        desc: list['desc'] ?? '',
        items: list['items'] ?? [],
        accumilitive: list['accumilitive'] ?? false,
        newStart: list['newStart'] ?? false,
        // weight: list['weight'] ?? 0.0,
        imageUrl: list['imageUrl'] ?? '');
  }
}

class MemberPerBp {
  String distrId;
  double bpA;
  MemberPerBp({this.distrId, this.bpA});

  factory MemberPerBp.fromJson(Map<String, dynamic> json) {
    return MemberPerBp(
        distrId: json['DISTR_ID'] ?? '', bpA: json["BPA"] ?? 0.0);
  }
}

class Promo {
  int id;
  String desc;
  int bp;
  List items;
  List areas;
  String imageUrl;
  String fromDate;
  String toDate;
  bool oneOrder;

  Promo(
      {this.id,
      this.desc,
      this.bp,
      this.items,
      this.areas,
      this.imageUrl,
      this.fromDate,
      this.toDate,
      this.oneOrder});

  factory Promo.fbList(Map<dynamic, dynamic> fbList) {
    return Promo(
        id: fbList['id'],
        desc: fbList['desc'],
        bp: fbList['bp'],
        items: fbList['items'],
        areas: fbList['areas'],
        imageUrl: fbList['imageUrl'],
        fromDate: fbList['fromDate'],
        toDate: fbList['toDate'],
        oneOrder: fbList['oneOrder']);
  }
}

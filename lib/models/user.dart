import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String distrId;
  String name;
  String distrIdent;
  String email;
  String phone;
  String areaId;
  String photoUrl;
  String idPhotoUrl;
  String taxPhotoUrl;
  String bankPhotoUrl;
  String serviceCenter;
  bool isAllowed;
  bool isleader;
  bool tester;
  String token;
  String bankId;

  User(
      {this.distrId,
      this.email,
      this.distrIdent,
      this.phone,
      this.name,
      this.areaId,
      this.photoUrl,
      this.idPhotoUrl,
      this.taxPhotoUrl,
      this.bankPhotoUrl,
      this.serviceCenter,
      this.isAllowed,
      this.isleader,
      this.tester,
      this.bankId,
      this.token});

  toJson() {
    return {
      "IsAllowed": true,
      "distrId": distrId,
      "distrIdent": distrIdent ?? '',
      "email": email ?? '',
      "id": int.parse(distrId).toString(),
      "isleader": false,
      "areaId": areaId,
      "name": name ?? '',
      "tele": phone ?? '',
      "bankId": bankId ?? ''
    };
  }

  factory User.formJson(Map<String, dynamic> json) {
    return User(
        distrId: json['DISTR_ID'] ?? '',
        name: json['LNAME'] ?? '',
        distrIdent: json['DISTR_IDENT'] ?? '',
        email: json['E_MAIL'] ?? '',
        phone: json['TELEPHONE'] ?? '',
        areaId: json['AREA_ID'] ?? '',
        serviceCenter: json['SERVICE_CENTER'] ?? '',
        bankId: json['bankId'] ?? '');
  }
  // * firebase sample code for model..
  User.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        name = snapshot.value["name"] ?? '',
        distrId = snapshot.value["distrId"],
        email = snapshot.value["email"] ?? '',
        isAllowed = snapshot.value["IsAllowed"],
        isleader = snapshot.value["isleader"],
        areaId = snapshot.value["areaId"],
        token = snapshot.value["token"],
        tester = snapshot.value["tester"] ?? false,
        photoUrl = snapshot.value["photoUrl"] ?? '',
        bankPhotoUrl = snapshot.value["bankPhotoUrl"] ?? '',
        idPhotoUrl = snapshot.value["idPhotoUrl"] ?? '',
        taxPhotoUrl = snapshot.value["taxPhotoUrl"] ?? '';

  User.useSnapshot(DataSnapshot snapshot)
      : name = snapshot.value["name"] ?? '',
        distrId = snapshot.value["distrId"],
        email = snapshot.value["email"] ?? '',
        isAllowed = snapshot.value["IsAllowed"],
        isleader = snapshot.value["isleader"],
        areaId = snapshot.value["areaId"],
        token = snapshot.value["token"],
        tester = snapshot.value["tester"] ?? false,
        photoUrl = snapshot.value["photoUrl"] ?? '',
        idPhotoUrl = snapshot.value["idPhotoUrl"] ?? '',
        taxPhotoUrl = snapshot.value["taxPhotoUrl"] ?? '',
        bankPhotoUrl = snapshot.value["bankPhotoUrl"] ?? '';
}

class NewMember {
  String distrId;
  String sponsorId;
  String familyName;
  String name;
  String personalId;
  String birthDate;
  String email;
  String telephone;
  String address;
  String areaId;
  String bankAccoutName;
  String bankAccountNumber;
  String taxNumber;
  String serviceCenter;
  String areaName;
  String held;
  var rate;
  String bankId;
  String shipmentCompany;

  NewMember(
      {this.distrId,
      this.sponsorId,
      this.familyName,
      this.name,
      this.personalId,
      this.birthDate,
      this.email,
      this.telephone,
      this.address,
      this.areaId,
      this.areaName,
      this.bankAccoutName,
      this.bankAccountNumber,
      this.taxNumber,
      this.serviceCenter,
      this.held,
      this.rate,
      this.bankId,
      this.shipmentCompany});

  factory NewMember.formJson(Map<String, dynamic> json) {
    return NewMember(
        distrId: json['DISTR_ID'] ?? '',
        name: json['LNAME'] ?? '',
        personalId: json['DISTR_IDENT'] ?? '',
        email: json['E_MAIL'] ?? '',
        birthDate: json['BIRTH_DATE'] ?? '',
        address: json['ADDRESS'] ?? '',
        telephone: json['TELEPHONE'] ?? '',
        bankAccoutName: json['ACCOUNT_OWNER'] ?? '',
        bankAccountNumber: json['ACCOUNT_NUM'] ?? '',
        taxNumber: json['TAX_NUM'] ?? '',
        areaId: json['AREA_ID'] ?? '',
        areaName: json['AREA_NAME'] ?? '',
        serviceCenter: json['SERVICE_CENTER'] ?? '',
        bankId: json['DS_BANK'] ?? '',
        held: json['HOLD_CRE'] ?? '1');
  }

  Map<String, dynamic> toJson() => {
        "SERVICE_CENTER": serviceCenter,
        "SPONSOR_ID": sponsorId,
        "FAMILY_LNAME": familyName,
        "LNAME": name,
        "DISTR_IDENT": personalId,
        "BIRTH_DATE": birthDate,
        "E_MAIL": email,
        "TELEPHONE": telephone,
        "ADDRESS": address,
        "AREA_ID": areaId,
        "NOTES": bankAccoutName,
        "SM_ID": bankAccountNumber,
        "AP_AC_ID": taxNumber,
        "RATE": rate,
        "Ds_SHIPMENT_COMP": shipmentCompany,
        "DS_BANK": bankId,
      };

  Map<String, dynamic> editToJson() => {
        "DISTR_ID": distrId,
        "LNAME": name,
        "DISTR_IDENT": personalId,
        "TELEPHONE": telephone,
        "ADDRESS": address,
        "NOTES": bankAccoutName,
        "HOLD_CRE": held,
        "SM_ID": bankAccountNumber,
        "AP_AC_ID": taxNumber,
        "SERVICE_CENTER": serviceCenter,
        "DS_BANK": bankId, // NOT IN DOCUMENTATION BUT NEEDED
      };

  String postNewMemberToJson(NewMember newMember) {
    final dyn = newMember.toJson();
    return json.encode(dyn);
  }
  // refactor to new schema from api documentation;

  Future<http.Response> createPost(
      String apiUrl,
      NewMember newMember,
      String user,
      String shipmentPlace,
      String shipmentPlaceName,
      String docType,
      String storeId) async {
    final response = await http.put(
        '$apiUrl/memregister/$user/$shipmentPlace/$shipmentPlaceName/$docType/$storeId',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          //HttpHeaders.authorizationHeader: ''
        },
        body: postNewMemberToJson(newMember));

    return response;
  }

  Future<http.Response> newMemberCreatePost(
      String apiUrl,
      NewMember newMember,
      String user,
      String shipmentPlace,
      String shipmentPlaceName,
      String docType,
      String address,
      String storeId) async {
    final response = await http.put(
        '$apiUrl/memregister_updated/$user/$shipmentPlace/$shipmentPlaceName/$address/$docType/$storeId',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          //HttpHeaders.authorizationHeader: ''
        },
        body: postNewMemberToJson(newMember));

    return response;
  }

  String editMemberEncode(NewMember newMember) {
    final dyn = newMember.editToJson();

    return json.encode(dyn);
  }

  Future<http.Response> editPost(NewMember newMember, String apiUrl) async {
    print(editMemberEncode(newMember));

    final response = await http.post('$apiUrl/edit_distr/',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          //HttpHeaders.authorizationHeader: ''
        },
        body: editMemberEncode(newMember));

    return response;
  }
}

class Member {
  String distrId;
  String name;
  String joinDate; //?new member REPORT
  var count21; //? ratio REPORT
  var perBp;
  var grpBp;
  var totBp;
  var ratio;
  var grpCount;
  String leaderId;
  String leaderName; //? details REPORT
  String sponsorId;
  String sponsorName; //? details REPORT
  String areaName; //?new member REPORT
  String telephone; //?new member REPORT
  String area;
  String lastUpdate;
  String nextUpdate;

  Member({
    this.distrId,
    this.name,
    this.joinDate,
    this.count21,
    this.perBp,
    this.grpBp,
    this.totBp,
    this.ratio,
    this.leaderId,
    this.leaderName,
    this.sponsorId,
    this.sponsorName,
    this.areaName,
    this.telephone,
    this.grpCount,
    this.area,
    this.lastUpdate,
    this.nextUpdate,
  });

  factory Member.formJson(Map<String, dynamic> json) {
    return Member(
      distrId: json['DISTR_ID'],
      name: json['M_ANAME'],
      perBp: json['PER_BP'] ?? 0,
      grpBp: json['PGROUP_BP'] ?? 0,
      totBp: json['TOTAL_BP'] ?? 0,
      ratio: json['m_ratio'] ?? 0,
      leaderId: json['LEADER_ID_N'],
      sponsorId: json['SPONSOR_ID'],
      grpCount: json['COUNT'] ?? 0,
      area: json['AREA'],
      lastUpdate: json['LASTUPDATE'],
      nextUpdate: json['NEXTUPDATE'],
    );
  }
  factory Member.formJsonNew(Map<String, dynamic> json) {
    return Member(
      distrId: json['distr_id'],
      name: json['distr_name'],
      joinDate: json['JOIN_DATE'],
      perBp: json['per_bp'] ?? 0,
      areaName: json['area_name'],
      telephone: json['TELEPHONE'],
    );
  }
  factory Member.formJsonRatio(Map<String, dynamic> json) {
    return Member(
      distrId: json['distr_id'],
      name: json['distr_name'],
      ratio: json['M_RATIO'],
      count21: json['COUNT21'],
      perBp: json['per_bp'] ?? 0,
      grpBp: json['PGROUP_BP'] ?? 0,
      totBp: json['TOTAL_BP'] ?? 0,
      areaName: json['area_name'],
      telephone: json['TELEPHONE'],
    );
  }
  factory Member.formJsonDetails(Map<String, dynamic> json) {
    return Member(
      distrId: json['DISTR_ID'],
      name: json['NAME'],
      perBp: json['PER_BP'] ?? 0,
      grpBp: json['PGROUP_BP'] ?? 0,
      totBp: json['TOTAL_BP'] ?? 0,
      ratio: json['RATIO'] ?? 0,
      leaderId: json['LEADER_ID'],
      leaderName: json['LEADER_NAME'],
      sponsorId: json['SPONSER_ID'],
      sponsorName: json['SPONSER_NAME'],
      grpCount: json['COUNT'] ?? 0,
      areaName: json['AREA'],
    );
  }
}

class DistrBonus {
  String distrId;
  String name;
  String status;
  var bonus;

  DistrBonus({this.distrId, this.name, this.bonus, this.status});
  toJson() {
    return {"DISTR_ID": distrId, "NET_DESRV": bonus, "ANAME": name};
  }

  String distrBonusToJson(DistrBonus distrBonus) {
    final dyn = distrBonus.toJson();
    return json.encode(dyn);
  }

  factory DistrBonus.fromJson(Map<dynamic, dynamic> json) {
    return DistrBonus(
        distrId: json['distr_id'],
        bonus: json['NET_DESRV'] ?? 0,
        status: json['IS_TEMPLATE'] ?? '');
  }
}

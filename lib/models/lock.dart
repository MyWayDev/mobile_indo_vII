import 'package:firebase_database/firebase_database.dart';

class Lock {
  String id; // ! changed here to display new non string id fb requirement.
  bool lockApp;
  bool lockCart;
  String catCode;
  String version;
  int safetyStock;
  int maxOrder;
  int adminFee;
  String bannerUrl;
  int maxLimited;
  String pdfUrl;
  List limitedItem;
  String bankInfo;
  String flush;
  var sKitWeight;
  String apiUrl;

  Lock(
      {this.id,
      this.lockApp,
      this.catCode,
      this.version,
      this.adminFee,
      this.safetyStock,
      this.maxOrder,
      this.pdfUrl,
      this.maxLimited,
      this.bankInfo,
      this.flush,
      this.sKitWeight,
      this.apiUrl});

  Lock.fromSnapshot(DataSnapshot snapshot)
      : id = snapshot.value['id'],
        lockApp = snapshot.value['lockApp'] ?? false,
        lockCart = snapshot.value['lockCart'] ?? false,
        adminFee = snapshot.value['adminFee'] ?? 0,
        bannerUrl = snapshot.value['bannerUrl'],
        catCode = snapshot.value['catCode'] ?? '33000',
        version = snapshot.value['version'],
        safetyStock = snapshot.value['safetyStock'] ?? 0,
        maxOrder = snapshot.value['maxOrder'],
        maxLimited = snapshot.value['maxLimited'],
        pdfUrl = snapshot.value['pdfUrl'] ?? '',
        limitedItem = snapshot.value['limtedItem'] ?? [],
        flush = snapshot.value['flush'],
        sKitWeight = snapshot.value['sKitWeight' ?? 1.0],
        bankInfo = snapshot.value['bankInfo'] ?? '',
        apiUrl = snapshot.value['apiUrl' ?? 'http://34.101.79.170:5000/api'];
}

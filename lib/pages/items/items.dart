import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:mor_release/models/lock.dart';
import 'package:mor_release/pages/items/itemDetails/footer.dart';
import 'package:mor_release/pages/order/widgets/storeFloat.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../models/item.dart';
import '../items/item.card.dart';
import 'package:mor_release/scoped/connected.dart';

class ItemsPage extends StatefulWidget {
  final MainModel model;
  ItemsPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ItemsPage();
  }
}

@override
class _ItemsPage extends State<ItemsPage> with SingleTickerProviderStateMixin {
  final formatWeight = new NumberFormat("#,###.##");
  //String db = 'production';
  String path =
      "flamelink/environments/indoProduction/content/items/en-US"; //! VERY IMPORTANT change back to production before release
  List<Item> itemData = List();
  List<Item> searchResult = [];
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  var subAdd;
  var subChanged;
  TextEditingController controller = new TextEditingController();
  Lock lock;

  //bool defaultDB = true;

  @override
  void initState() {
    databaseReference = database.reference().child(path);
    Query query = databaseReference.orderByChild('catalogue').equalTo(true);
    widget.model.getStores();
    //!TODO ADD QUERY TO FILTER PRODUCTS NOT IN CATALOGE..
    subAdd = query.onChildAdded.listen(_onItemEntryAdded);
    subChanged = query.onChildChanged.listen(_onItemEntryChanged);

    super.initState();
  }

  @override
  void dispose() {
    subAdd?.cancel();
    subChanged?.cancel();
    super.dispose();
  }

  String type;
  bool isSelected = false;
  void _valueChanged(bool v) {
    setState(() {
      isSelected = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      model.itemData = itemData;
      model.searchResult = searchResult;

      /* itemData.forEach((i) {
        if (i.promoItems.isNotEmpty) {
          i.promoItems.forEach((i) => print(i.toString()));
        }
      });*/

      return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Padding(
            child: Column(
              children: <Widget>[
                model.orderSum() > 0
                    ? Wrap(
                        spacing: 24,
                        runSpacing: 10,
                        direction: Axis.horizontal,
                        children: <Widget>[
                          Chip(
                            elevation: 5,
                            shadowColor: Colors.black,
                            backgroundColor: Colors.grey[350],
                            avatar: CircleAvatar(
                              backgroundColor: Colors.green[700],
                              child: Text('Rp',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            label: Text(
                              formatter.format(model.orderSum()),
                              style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Chip(
                            elevation: 5,
                            shadowColor: Colors.black,
                            backgroundColor: Colors.grey[350],
                            avatar: CircleAvatar(
                              backgroundColor: Colors.pink[900],
                              child: Text('Bp',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            label: Text(
                              model.orderBp().toString(),
                              style: TextStyle(
                                  color: Colors.pink[900],
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Chip(
                            elevation: 5,
                            shadowColor: Colors.black,
                            backgroundColor: Colors.grey[350],
                            avatar: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: Text('kg',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                            label: Text(
                              formatWeight.format(model.orderWeight()),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                // MyBlinkingButton()
                StoreFloat(model)
              ],
            ),
            padding: EdgeInsets.only(right: 35),
          ),

          isExtended: true,
          elevation: 30,
          //onPressed:,
          icon: Icon(
            Icons.arrow_right,
            color: Colors.transparent,
          ),
          backgroundColor: Colors.transparent, onPressed: () {},
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        resizeToAvoidBottomInset: false,
        //resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Container(
              height: 58,
              color: Theme.of(context).primaryColorLight,
              child: Card(
                child: ListTile(
                  leading: Icon(
                    Icons.search,
                    size: 22.0,
                  ),
                  title: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "",
                      border: InputBorder.none,
                    ),
                    // style: TextStyle(fontSize: 18.0),
                    onChanged: onSearchTextChanged,
                  ),
                  trailing: IconButton(
                    alignment: AlignmentDirectional.centerEnd,
                    icon: Icon(Icons.cancel, size: 20.0),
                    onPressed: () {
                      controller.clear();
                      onSearchTextChanged('');
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: searchResult.length != 0 || controller.text.isNotEmpty
                  ? ListView.builder(
                      itemCount: searchResult.length,
                      itemBuilder: (context, i) {
                        return ItemCard(searchResult, i);
                      },
                    )
                  : ListView.builder(
                      itemCount: itemData.length,
                      itemBuilder: (context, index) {
                        return ItemCard(itemData, index);
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  onSearchTextChanged(String text) {
    searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    itemData.where((i) => !i.disabled).forEach((item) {
      if (item.name.toLowerCase().contains(text.toLowerCase()) ||
          item.itemId.contains(text)) searchResult.add(item);
    });
    setState(() {});
  }

  void _onItemEntryAdded(Event event) {
    //List<Item> items = List();
    itemData.add(Item.fromSnapshot(event.snapshot));
    // items.where((i) => !i.disabled).forEach((f) => itemData.add(f));
    //print("itemData length:${itemData.length}");
    setState(() {});
  }

  void _onItemEntryChanged(Event event) {
    var oldEntry = itemData.lastWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      itemData[itemData.indexOf(oldEntry)] = Item.fromSnapshot(event.snapshot);
    });
  }
}

/*

  Flushbar flushAction(BuildContext context) {
    Flushbar f = Flushbar(
      isDismissible: false,
      flushbarPosition: FlushbarPosition.BOTTOM,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.bounceIn,
      forwardAnimationCurve: Curves.fastOutSlowIn,

      mainButton: FlatButton(
        onPressed: () {
          _isMap = true;
          Navigator.of(context).pop();
        },
        child: Icon(
          GroovinMaterialIcons.close_circle_outline,
          color: Colors.red,
        ),
      ),
      margin: EdgeInsets.all(1),
      borderRadius: 8,
      title: 'Order From',
      messageText: Container(
        padding: EdgeInsets.all(8.0),
        child: Flexible(
          fit: FlexFit.tight,
          flex: 1,
          child: ModalProgressHUD(
              color: Colors.transparent,
              inAsyncCall: widget.model.isloading,
              opacity: 0.1,
              progressIndicator: LinearProgressIndicator(
                backgroundColor: Colors.grey[200],
              ),
              child: getRegions()),
        ),
      ),
      //  message: 'Silahkan Lakukan Pembayaran Melalui',
      icon: Icon(
        GroovinMaterialIcons.map_marker_radius,
        color: Colors.amberAccent,
        size: 28,
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.red[800],
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    );
    return f;
  }
*/

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mor_release/models/ticket.dart';
import "package:collection/collection.dart";
import 'package:grouped_list/grouped_list.dart';

class SupportReeport extends StatefulWidget {
  SupportReeport({Key key}) : super(key: key);

  @override
  _SupportReeportState createState() => _SupportReeportState();
}

class _SupportReeportState extends State<SupportReeport> {
  List<Ticket> ticketsData = List();
  List<TicketType> types = [];
  final String path =
      "flamelink/environments/indoProduction/content/support/en-US";
  FirebaseDatabase database = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  Query query;
  var subAdd;
  var subChanged;
  var subDel;
  @override
  void initState() {
    databaseReference = database.reference().child(path);
    query = databaseReference.child("/");

    subAdd = query.onChildAdded.listen(_onItemEntryAdded);
    subChanged = query.onChildChanged.listen(_onItemEntryChanged);
    subDel = query.onChildRemoved.listen(_onItemEntryDeleted);
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncInputDialog(context);
    });*/
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  getTicketTypes() async {
    DataSnapshot snapshot = await database
        .reference()
        .child(
            'flamelink/environments/indoProduction/content/ticketType/en-US/')
        .once();
    Map<dynamic, dynamic> typeList = snapshot.value;
    List list = typeList.values.toList();
    types = list.map((f) => TicketType.toJosn(f)).toList();
  }

  List<Ticket> getTicketCount(String _date) {
    print(_date);
    List<Ticket> results = [];
    List<Ticket> t = ticketsData
        .where((t) => t.openDate.substring(0, 10).toString() == _date)
        .where((o) => o.open == true)
        .toList();
    for (Ticket _t in t) {
      if (t.length != 0) {
        results.add(_t);
      }
    }
    results.forEach(
        (f) => print("tlist: ${f.openDate.substring(0, 10)} open:${f.open}"));
    return results;
  }

  void runType() {
    types.forEach((t) => runCount(t.ticketType));
  }

  void runCount(String type) {
    var ls = ticketCount(ticketsData);

    ls.forEach((d) => getTicketCount(d).where((t) => t.type == type));
  }

  List<String> ticketCount(List<Ticket> data) {
    var newMap =
        groupBy(data, (obj) => obj.openDate.substring(0, 10).toString());
    List<String> ls = newMap.keys.toList();

    return ls;
  }

  List _elements = [
    {'name': 'John', 'group': 'Team A'},
    {'name': 'Will', 'group': 'Team B'},
    {'name': 'Beth', 'group': 'Team A'},
    {'name': 'Miranda', 'group': 'Team B'},
    {'name': 'Mike', 'group': 'Team C'},
    {'name': 'Danny', 'group': 'Team C'},
  ];

  @override
  Widget build(BuildContext context) {
    return GroupedListView<dynamic, String>(
      groupBy: (element) => element['group'],
      elements: _elements,
      order: GroupedListOrder.DESC,
      groupSeparatorBuilder: (String value) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        )),
      ),
      itemBuilder: (context, element) {
        return Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Icon(Icons.account_circle),
              title: FlatButton(onPressed: () => runType(), child: Text('map')),
              trailing: Icon(Icons.arrow_forward),
            ),
          ),
        );
      },
    );
  }

//FlatButton(onPressed: () => runCount(), child: Text('map'))
  void _onItemEntryAdded(Event event) {
    ticketsData.add(Ticket.fromSnapshot(event.snapshot));

    setState(() {});
  }

  void _onItemEntryDeleted(Event event) {
    Ticket tick =
        ticketsData.firstWhere((f) => f.id == event.snapshot.value['id']);

    setState(() {
      ticketsData.remove(ticketsData[ticketsData.indexOf(tick)]);
    });
  }

  void _onItemEntryChanged(Event event) {
    var oldEntry = ticketsData.lastWhere((entry) {
      return entry.key == event.snapshot.key;
    });
    setState(() {
      ticketsData[ticketsData.indexOf(oldEntry)] =
          Ticket.fromSnapshot(event.snapshot);
    });
  }
}

class TicketReport {
  String type;
  String date;
  int count;
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/models/user.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:mor_release/widgets/color_loader_2.dart';
import 'package:scoped_model/scoped_model.dart';

class DistrBonusList extends StatefulWidget {
  DistrBonusList({Key key}) : super(key: key);

  @override
  _DistrBonusListState createState() => _DistrBonusListState();
}

class _DistrBonusListState extends State<DistrBonusList> {
  bool _isloading = false;
  final _formatBonus = new NumberFormat("#,###,###");

  void isloading(bool i) {
    setState(() {
      _isloading = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
        return model.distrBonusList.isNotEmpty
            ? ModalProgressHUD(
                color: Colors.black,
                inAsyncCall: _isloading,
                opacity: 0.6,
                progressIndicator: ColorLoader2(),
                child: Card(
                    color: Colors.green[200],
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Bayar dengan Dokumen Bonus',
                                style: TextStyle(
                                    color: Colors.purple[900],
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          _buildDistrBonus(model.distrBonusList, 0, model),
                        ])))
            : Container();
      }),
    );
  }

  Widget _buildDistrBonus(
      List<DistrBonus> _distrBonusList, int index, MainModel model) {
    return ListTile(
      leading: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 50.0, maxWidth: 23.0),
        child: IconButton(
            disabledColor: Colors.transparent,
            icon: Icon(
              Icons.delete_forever,
              color: Colors.pink[900],
              size: 22,
            ),
            onPressed: () {
              model.deleteDistrBonus(index, context);
            }),
      ),
      title: Container(
        width: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 45.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.vpn_key,
                    color: Colors.pink[500],
                    size: 17,
                  ),
                  SizedBox(width: 2),
                  Text(
                    int.parse(model.distrBonusList[index].distrId).toString(),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Center(
              child: Text(
                model.distrBonusList[index].name,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                _formatBonus.format(model.distrBonusList[index].bonus),
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

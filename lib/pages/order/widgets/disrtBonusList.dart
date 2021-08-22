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

  void isloading(MainModel model) {
    setState(() {
      model.distrBonusList.isNotEmpty ? _isloading = false : _isloading = true;
    });
  }

  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //widget.model.distrBonusList = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ModalProgressHUD(
          color: Colors.black,
          inAsyncCall: _isloading,
          opacity: 0.6,
          progressIndicator: ColorLoader2(),
          child: AlertDialog(
            actions: [
              IconButton(
                  highlightColor: Colors.amber,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_outlined,
                    size: 30,
                    color: Colors.red,
                  ))
            ],
            backgroundColor: Color(0xFF303030),
            content: Container(
              height: 290,
              width: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      'Pembayaran Menggunakan Bonus',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                  Flexible(
                      child: Scrollbar(
                    child: ListView.builder(
                      itemCount: model.distrBonusList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Dismissible(
                          onDismissed: (DismissDirection direction) {
                            if (direction == DismissDirection.endToStart) {
                              model.deleteDistrBonus(index, context);
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              model.deleteDistrBonus(index, context);
                            }
                          },
                          key:
                              Key(model.distrBonusList[index].bonus.toString()),
                          child: Padding(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, bottom: 6, top: 3),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                    maxHeight: 45.0,
                                    maxWidth: double.minPositive),
                                child: ElevatedButton(
                                  onPressed: () {
                                    model.deleteDistrBonus(index, context);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.green[300]),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    overlayColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.grey),
                                  ),
                                  child: _buildDistrBonus(
                                      model.distrBonusList, index, model),
                                ),
                              )),
                        );
                      },
                    ),
                  ))
                ],
              ),
            ),
          ));
    });
  }

  Widget _buildDistrBonus(
      List<DistrBonus> _distrBonusList, int index, MainModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
            child: Text(model.distrBonusList[index].period,
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 13))),
        Center(
            child: Text(
          _formatBonus.format(model.distrBonusList[index].bonus) + ' - ' + 'Rp',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
        ))
      ],
    );
  }
}

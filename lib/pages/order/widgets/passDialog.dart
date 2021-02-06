import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:mor_release/pages/profile/profile.dart';
import 'package:mor_release/scoped/connected.dart';
import 'package:scoped_model/scoped_model.dart';

class PassDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PassDialog();
  }
}

@override
class _PassDialog extends State<PassDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void isLoading(bool o) {
    setState(() {
      _loading = o;
    });
  }

  bool _loading = false;
  String pass = '';

  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return _passDialog(context, model);
    });
  }

  Widget _passDialog(BuildContext context, MainModel model) {
    return Dialog(
      child: new Row(
        children: <Widget>[
          new Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(left: 12),
                child: TextField(
                  obscureText: true,
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Password'),
                  onChanged: (value) {
                    pass = value;
                  },
                ),
              )),
          FlatButton(
            child: pass.isNotEmpty
                ? Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 26,
                  )
                : Icon(
                    Icons.no_encryption,
                    color: Colors.grey[400],
                  ),
            onPressed: () {
              if (pass == model.pass) {
                setState(() {
                  model.modify = true;
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

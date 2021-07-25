import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class ErrorMsgs extends StatelessWidget {
  final String _msg;
  const ErrorMsgs(this._msg, {Key key}) : super(key: key);

  Flushbar flushErrorMsg(BuildContext context) {
    Flushbar flush = Flushbar(
      isDismissible: false,
      duration: Duration(seconds: 4),
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      messageText:
          Text(_msg, style: TextStyle(fontSize: 14, color: Colors.red[50])),
      icon: Icon(
        Icons.error_outline_rounded,
        color: Colors.red,
        size: 38,
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.red[800],
          offset: Offset(0.0, 2.0),
          blurRadius: 3.0,
        )
      ],
    );
    return flush;
  }

  @override
  Widget build(BuildContext context) {
    return flushErrorMsg(context);
  }
}

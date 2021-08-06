import 'package:flutter/material.dart';

class RegistrationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)),
              splashColor: Theme.of(context).primaryColor,
              color: Colors.purple[100],
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Daftar",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Transform.translate(
                    offset: Offset(15.0, 0.0),
                    child: Container(
                      padding: const EdgeInsets.all(0.2),
                      child: FlatButton(
                          highlightColor: Colors.purple,
                          colorBrightness: Brightness.dark,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28.0)),
                          splashColor: Colors.white,
                          color: Colors.white,
                          child: Icon(
                            Icons.person_add,
                            size: 32.0,
                            color: Colors.purple,
                          ),
                          onPressed: () =>
                              //  Navigator.pushNamed(context, '/phoneAuth')),
                              Navigator.pushNamed(context, '/registration')),
                    ),
                  )
                ],
              ),
              onPressed: () => //Navigator.pushNamed(context, '/phoneAuth'),
                  Navigator.pushNamed(context, '/registration'),
            ),
          ),
        ],
      ),
    );
  }
}

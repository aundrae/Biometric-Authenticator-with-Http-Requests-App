import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import './requests.dart';
class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Route'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MakeRequest()),
            );
          },
        ),
      ),
    );
  }
}

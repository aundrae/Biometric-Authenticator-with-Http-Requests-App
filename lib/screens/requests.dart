import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class MakeRequest extends StatefulWidget {

  @override
  _MakeRequestPage createState() => _MakeRequestPage();
}

class _MakeRequestPage extends State<MakeRequest>{
  final _auth = LocalAuthentication();
  String _value;
  final format = DateFormat("yyyy-MM-dd");

  bool _isAuthenticating = false;
  String _authorized="";

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticateWithBiometrics(
          localizedReason: 'Please Authenticate to Proceed.',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    if(!authenticated){
      Navigator.pop(context);
    }
    setState(() {
      _authorized = message;
    });
  }
  @override
  void initState(){
    _authenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Leave of Absence"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new TextField(
              decoration: new InputDecoration(labelText: "Enter Your Name", border: OutlineInputBorder(), hasFloatingPlaceholder: true),
              autofocus: false,
            ),
            SizedBox(height: 24),
            new DateTimeField(
              decoration: new InputDecoration(labelText:"Enter Start Date", border: OutlineInputBorder(),hasFloatingPlaceholder: true),
              format: format,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
            ),
            SizedBox(height: 24),
            new DateTimeField(
              decoration: new InputDecoration(labelText:"Enter End Date", border: OutlineInputBorder(),hasFloatingPlaceholder: true),
              format: format,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              },
            ),
            SizedBox(height: 24),
            new DropdownButtonFormField<String>(
              decoration: new InputDecoration(labelText:"Select Reason for Leave", border: OutlineInputBorder(),hasFloatingPlaceholder: true),
              items: [
                DropdownMenuItem<String>(
                  child: Text('Vacation'),
                  value: 'one',
                ),
                DropdownMenuItem<String>(
                  child: Text('Sick Leave'),
                  value: 'two',
                ),
                DropdownMenuItem<String>(
                  child: Text('Maternity'),
                  value: 'three',
                ),
              ],
              onChanged: (String value) {
                setState(() {
                  _value = value;
                });
              },
              value: _value,
            ),
            SizedBox(height: 24),
            RaisedButton(
              onPressed: () {
                //Navigator.pop(context);
                _authenticate();
              },
              child: Text('Go back!'),
            ),
          ],
        )
      ),
    );
  }
}
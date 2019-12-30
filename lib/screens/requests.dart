import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class MakeRequest extends StatefulWidget {
  @override
  _MakeRequestPage createState() => _MakeRequestPage();
}

class _MakeRequestPage extends State<MakeRequest> {
  final _formValidator = GlobalKey<FormState>();
  final _auth = LocalAuthentication();
  String _value="";
  final format = DateFormat("yyyy-MM-dd");
  String _startDate = "",
      _endDate = "",
      _employeeID = "",
      _name = "",
      _reason = "No Reason";
  bool visibility=false;
  bool _isAuthenticating = false;
  String _authorized = "";

//This method is is used to further authenticate the user using biometrics if it's available on the device
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
    if (!authenticated) {
      Navigator.pop(context);
    }
    setState(() {
      _authorized = message;
    });
  }

  @override
  void initState() {
    _authenticate();
    super.initState();
  }

  _sendRequest() async{
    String url = 'https://diagonconsulting-task.000webhostapp.com/post.php?id=$_employeeID&name=$_name&type=$_value&reason=$_reason&start=$_startDate&end=$_endDate';
    Response response = await post(url);
    var data = (response.body);
    print(data);
    _alertDialog(data.toString());
  }
  Future<void> _alertDialog(message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Message'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request Leave of Absence"),
      ),
      body: Form(
        key: _formValidator,
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your Employee ID.';
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                      labelText: "Enter Your Employee ID",
                      border: OutlineInputBorder(),
                      hasFloatingPlaceholder: true),
                  autofocus: false,
                  onChanged: (val) {
                    setState(() {
                      _employeeID = val;
                    });
                  },
                ),
                SizedBox(height: 24),
                new TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter you name.';
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                      labelText: "Enter Your Name",
                      border: OutlineInputBorder(),
                      hasFloatingPlaceholder: true),
                  autofocus: false,
                  onChanged: (val) {
                    setState(() {
                      _name = val;
                    });
                  },
                ),
                SizedBox(height: 24),
                new DateTimeField(
                  validator: (value) {
                    if (_startDate.isEmpty) {
                      return 'Please enter start date';
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                      labelText: "Enter Start Date",
                      border: OutlineInputBorder(),
                      hasFloatingPlaceholder: true),
                  format: format,
                  onChanged: (val){
                    setState(() {
                      _startDate = format.format(val);
                    });
                  },
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
                  validator: (value) {
                    if (_endDate.isEmpty) {
                      return 'Please enter end date';
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                      labelText: "Enter End Date",
                      border: OutlineInputBorder(),
                      hasFloatingPlaceholder: true),
                  onChanged: (val){
                    setState(() {
                      _endDate = format.format(val);
                    });
                  },
                  format: format,
                  onShowPicker: (context, currentValue) {
                    return showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100),
                    );
                  },
                ),
                SizedBox(height: 24),
                new DropdownButtonFormField<String>(
                  validator: (value) {
                    if (_value.isEmpty) {
                      return 'Please enter reason';
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                      labelText: "Select Reason for Leave",
                      border: OutlineInputBorder(),
                      hasFloatingPlaceholder: true),
                  items: [
                    DropdownMenuItem<String>(
                      child: Text('Vacation'),
                      value: 'Vaction',
                    ),
                    DropdownMenuItem<String>(
                      child: Text('Sick Leave'),
                      value: 'Sick Leave',
                    ),
                    DropdownMenuItem<String>(
                      child: Text('Maternity'),
                      value: 'Maternity',
                    ),
                    DropdownMenuItem<String>(
                      child: Text('Other'),
                      value: 'Other',
                    ),
                  ],
                  onChanged: (String value) {
                    setState(() {
                      _value = value;
                    });
                    if(_value == "Other"){
                      visibility=true;
                    }
                    else{
                      visibility=false;
                    }
                  },

                  value: _value,
                ),
                SizedBox(height: 24),
                Visibility(
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: new InputDecoration(
                        labelText: "Enter Your Reason",
                        border: OutlineInputBorder(),
                        hasFloatingPlaceholder: true),
                    autofocus: false,
                    onChanged: (val) {
                      setState(() {
                        _reason = val;
                      });
                    },
                  ),
                  visible: visibility,
                ),
                SizedBox(height: 24),
                Center(
                  child: MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      if(_formValidator.currentState.validate()){
                        print(_employeeID.toString());
                        _sendRequest();
                      }
                      //Navigator.pop(context);
                    },
                    child: Text('Make Request'),
                  ),
                )
              ],
            )),
      ),
    );
  }
}

import 'package:brew_crew/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // textfield state
  String email = '';
  String pw = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign Up to Brew Crew'),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('Sign In'),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          vertical: 20.0,
          horizontal: 50.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Email text Box
              SizedBox(height: 20.0),
              TextFormField(
                validator: (value) => value.isEmpty ? 'Enter an Email' : null,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              // Password Text Box
              SizedBox(height: 20.0),
              TextFormField(
                validator: (value) =>
                    value.length < 6 ? 'Enter a Password 6+ char long' : null,
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    pw = value;
                  });
                },
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    dynamic result =
                        await _auth.registerWithEmailAndPassword(email, pw);
                    if (result == null) {
                      setState(() {
                        error = 'Please Supply Valid Email';
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

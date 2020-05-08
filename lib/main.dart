// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Ceqsab';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  List<dynamic> listToSave = [];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: myController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () async{
                if (_formKey.currentState.validate()) {
                  var savedList = await _read();
                  var myControllerText = myController.text;
                  savedList.add(myControllerText);
                  listToSave = savedList;
                  await _save();
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Saved!')));
                  myController.text = "";
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

    _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'savedValue';
    final value = jsonDecode(prefs.getString(key) ?? '');
    return value;
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'savedValue';
    final value = listToSave;
    prefs.setString(key, jsonEncode(value));
    print('saved $value');
  }
}
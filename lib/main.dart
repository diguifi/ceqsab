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
        body: Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          child: Text('Open menu'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlacesMenu()),
            );
          },
        ),
      ),
    );
  }
}

class PlacesMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add places'),
      ),
      body: PlaceRegister(),
    );
  }
}


class PlaceRegister extends StatefulWidget {
  @override
  PlaceRegisterState createState() {
    return PlaceRegisterState();
  }
}

class PlaceRegisterState extends State<PlaceRegister> {
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
                  List<dynamic> savedList = await _read();
                  String myControllerText = myController.text;
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
          new Expanded(
            child: listBuilder(),
          ),
        ],
      ),
    );
  }

  Widget listBuilder() {
    return new ListView.builder(
      itemCount: listToSave.length,
      itemBuilder: (BuildContext ctxt, int index) => buildBody(ctxt, index)
    );
  }

  Widget buildBody(BuildContext ctxt, int index) {
    return new ListTile(
        title: Text(listToSave[index]),
    );
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'savedList';
    final value = jsonDecode(prefs.getString(key) ?? '[]');
    return value;
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'savedList';
    final value = listToSave;
    prefs.setString(key, jsonEncode(value));
    print('saved $value');
    listBuilder();
    setState(() {});
  }

  @override
  void initState() {
    _read().then((value){
      listToSave = value;
      setState(() {});
    });
    super.initState();
  }
}
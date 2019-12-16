import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:solpac_teste/entity/Person.dart';
import 'package:solpac_teste/tools/constants/ProjectMessages.dart';
import 'package:solpac_teste/view/Profile.dart';

class Dashboard extends StatefulWidget {
  Person value;

  Dashboard({this.value});

  @override
  _DashboardState createState() => new _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String _codeOfBar = "Código:";

  @override
  Widget build(BuildContext context) {

     Future _scan() async {
      try {
        String codeBar = await BarcodeScanner.scan();
        setState(()  {
          _codeOfBar = "Código: $codeBar";
        });
      } on PlatformException catch(e){
          if(e.code == BarcodeScanner.CameraAccessDenied){
            setState(() {
              _codeOfBar = ProjectMessages.CAM_ACCESS_NOT_GRANT;
            });
          } else {
            setState(() {
              _codeOfBar = ProjectMessages.UNKNOWN_ERROR;
            });
          }
      } on FormatException {
        setState(() {
          _codeOfBar = "Código:";
        });
      } catch (e) {
        _codeOfBar = ProjectMessages.UNKNOWN_ERROR;
       }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.person,
              size: 35.0,
            ),
            onPressed: (){
              var route = new MaterialPageRoute(
                  builder: (BuildContext context) => new Profile(widget.value));
              Navigator.of(context).push(route);
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
                child: Text("Bem vindo, ${widget.value.name}!",
                    style:
                    TextStyle(fontSize: 25.0, color: Colors.black)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Container(
                height: 50.0,
                child: RaisedButton(
                  onPressed: (){
                    _scan();
                  },
                  child: Text("Código de barras",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),),
                  color: Colors.green,
                ),
              ),
            ),
            Text(_codeOfBar, textAlign: TextAlign.center, style: TextStyle(color: Colors.green))
          ],
        ),
      ),
    );
  }
}

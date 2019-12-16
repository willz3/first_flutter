import 'package:flutter/material.dart';
import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:solpac_teste/tools/CustomDialogTool.dart';
import 'package:solpac_teste/tools/TextBuilderTool.dart';
import 'package:solpac_teste/tools/constants/ProjectMessages.dart';
import 'package:solpac_teste/webservice/AuthController.dart';

var otherKey = GlobalKey<FormState>();


class RememberPassword extends StatefulWidget {
  final Auth0 auth;

  RememberPassword(this.auth);

  @override
  _RememberPasswordStateState createState() => _RememberPasswordStateState();
}

class _RememberPasswordStateState extends State<RememberPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[900],
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: otherKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20.0),
                        child: Text(
                          'Esqueceu a senha?',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      ),
                    ),
                    TextBuilderTool.buildTextFieldEmail(_emailController),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      height: 50.0,
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          if (otherKey.currentState.validate()) {
                            _rememberPasswordAuth(_emailController.text, widget.auth);
                            _showSucessMessage(context);
                            _emailController.text = '';
                          }
                        },
                        child: Text(
                          'Enviar',
                          style: TextStyle(color: Colors.white, fontSize: 20.0),
                        ),
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    FlatButton(
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

void _rememberPasswordAuth(final String email, final Auth0 auth) {
  AuthController.resetPassword(email, auth);
}

void _showSucessMessage(final BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomDialogTool.buildDialog(
            context,
            'E-mail',
            ProjectMessages.REMEMBER_PASSWORD_SUCCESS,
            TextAlign.justify);
      });
}

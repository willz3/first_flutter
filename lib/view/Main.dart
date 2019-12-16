import 'package:flutter/material.dart';
import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:solpac_teste/entity/Person.dart';
import 'package:solpac_teste/sqlite/DAO/PersonDAO.dart';
import 'package:solpac_teste/tools/CustomDialogTool.dart';
import 'package:solpac_teste/tools/TextBuilderTool.dart';
import 'package:solpac_teste/tools/Prefs.dart';
import 'package:solpac_teste/view/Dashboard.dart';
import 'package:solpac_teste/view/RememberPassword.dart';
import 'package:solpac_teste/view/SignUp.dart';
import 'package:solpac_teste/webservice/AuthController.dart';

void main() {
  runApp(new MaterialApp(title: '', home: Home()));
}

var theKey = GlobalKey<FormState>();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  Auth0 auth;
  bool _rememberOfMe = false;
  bool onLoading = false;

  @override
  void initState() {
    _initOtherState();
    super.initState();
  }

  _initOtherState() async {
    try {
      onLoading = true;
      bool remembered = await Prefs.hasPrefs('rememberMe') ? await Prefs.getBool('rememberMe') : false;

      auth = Auth0(
          baseUrl: 'url',
          clientId: 'token');
      if (remembered) {
        String personPrefs = await Prefs.getString('personPrefs');
        Person person = Person.getPersonFromJson(personPrefs);
        String tokenAuth =
            await AuthController.signIn(person.email, person.password, auth);
        onLoading = false;
        if (tokenAuth != null && tokenAuth.compareTo("") != 0) {
          var route = new MaterialPageRoute(
              builder: (BuildContext context) => new Dashboard(value: person));
          Navigator.of(context).push(route);
        } else {
          onLoading = false;
          print("There is something wrong with the login!");
        }
      } else{
        onLoading = false;
      }
    } catch (e) {
      print(e);
      onLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(16.0),
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: theKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Center(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              )),
                        ),
                        TextBuilderTool.buildTextFieldEmail(_loginController),
                        SizedBox(height: 16.0),
                        TextBuilderTool.buildTextFieldPassword(
                            'Senha', _passController),
                        SizedBox(height: 16.0),
                        Row(
                          children: <Widget>[
                            Transform.scale(
                              scale: 1.4,
                              child: Switch(
                                value: _rememberOfMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberOfMe = value;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text('Lembrar de mim',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                        FlatButton(
                          child: Text(
                            "Esqueci minha senha",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            var route = new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new RememberPassword(auth));
                            Navigator.of(context).push(route);
                          },
                        ),
                        Container(
                          height: 50.0,
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              if (theKey.currentState.validate()) {
                                _createSessionLogin();
                              }
                            },
                            child: Text(
                              'ENTRAR',
                              style: TextStyle(color: Colors.white, fontSize: 20.0),
                            ),
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(
                    "Cadastre-se",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) => new SignUp(this.auth));
                    Navigator.of(context).push(route);
                  },
                ),
              ]),
            ),
            onLoading ? Container(
              color: Colors.white,
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: CircularProgressIndicator(),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  _createSessionLogin() async {
    try {
      final String email = _loginController.text;
      final String password = _passController.text;

      final Person personForLogin = await PersonDAO.getPersonByEmail(email);

      String tokenAuth = await AuthController.signIn(email, password, auth);
      print(personForLogin);

      if (personForLogin != null) {
        if (tokenAuth != null && tokenAuth.compareTo("") != 0) {
          Prefs.clearPreferences();
          if (_rememberOfMe) {
            Prefs.saveLoginPreferences(personForLogin);
          }
          var route = new MaterialPageRoute(
              builder: (BuildContext context) =>
                  new Dashboard(value: personForLogin));
          Navigator.of(context).push(route);
        }
      } else {
        CustomDialogTool.buildDialog(context, 'Erro ao realizar login',
            'Seu e-mail ou senha estão incorretos!', TextAlign.justify);
      }
    } catch (e) {
      print(e);
    }
  }
}

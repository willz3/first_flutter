import 'package:flutter/material.dart';
import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:solpac_teste/entity/Person.dart';
import 'package:solpac_teste/sqlite/DAO/PersonDAO.dart';
import 'package:solpac_teste/tools/CustomDialogTool.dart';
import 'package:solpac_teste/tools/Prefs.dart';
import 'package:solpac_teste/tools/TextBuilderTool.dart';
import 'package:solpac_teste/tools/constants/ProjectMessages.dart';
import 'package:solpac_teste/webservice/AuthController.dart';

var formKey = GlobalKey<FormState>();

class SignUp extends StatefulWidget {

  final Auth0 auth;
  SignUp(this.auth);

  @override
  State<StatefulWidget> createState() => new _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool logged;
  dynamic currentAuth;

  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cnpController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

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
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "Cadastro",
                          style: TextStyle(color: Colors.black, fontSize: 20.0),
                        ),
                      ),
                    ),
                    TextBuilderTool.buildTextField("Nome", _nameController, TextInputType.text, true),
                    SizedBox(
                      height: 16,
                    ),
                    TextBuilderTool.buildTextField("CPF/CNPJ", _cnpController, TextInputType.number, true),
                    SizedBox(
                      height: 16,
                    ),
                    TextBuilderTool.buildTextFieldEmail(_emailController),
                    SizedBox(
                      height: 16,
                    ),
                    TextBuilderTool.buildTextFieldPassword("Senha", _passController),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50.0,
                      width: double.infinity,
                      child: RaisedButton(
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            _sendPersonToPersist();
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "Cadastrar",
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
                        "Já possui uma conta?",
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Auth0 get auth {
    return widget.auth;
  }

  Future<Person> _getPersonAndPersist() async {
    final Person person = Person();
    person.name = _nameController.text;
    person.document = _cnpController.text;
    person.email = _emailController.text;
    person.password = _passController.text;

    return person;
  }

  void _sendPersonToPersist() async {
    try {
      Person person = await _getPersonAndPersist();
      String token = await AuthController.signUp(person, auth);
      await PersonDAO.insertPerson(person);
      Prefs.setString('token', token);
      print(person.toString());
      debugPrint(person.toString());
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogTool.buildDialog(context, 'Cadastro',
                ProjectMessages.SIGNUP_SUCCESS, TextAlign.center);
          });
    }catch(e){
      print(e);
    }
  }
}

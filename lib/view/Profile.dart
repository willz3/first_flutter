import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solpac_teste/entity/Person.dart';
import 'package:solpac_teste/tools/TextBuilderTool.dart';

class Profile extends StatelessWidget {
  final Person _value;

  Profile(this._value);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _documentController = TextEditingController();
    final TextEditingController _emailController = TextEditingController();
    _nameController.text = _value.name;
    _documentController.text = _value.document;
    _emailController.text = _value.email;
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextBuilderTool.buildTextField(
                'Nome', _nameController, TextInputType.text, false),
            SizedBox(
              height: 16,
            ),
            TextBuilderTool.buildTextField(
                'CPF/CNPJ', _documentController, TextInputType.number, false),
            SizedBox(
              height: 16,
            ),
            TextBuilderTool.buildTextField(
                'E-mail', _emailController, TextInputType.text, false),
          ],
        ),
      ),
    );
  }
}

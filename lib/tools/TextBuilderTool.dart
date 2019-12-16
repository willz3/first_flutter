import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:solpac_teste/tools/constants/ProjectMessages.dart';

class TextBuilderTool {
  static Widget buildTextField(
      final String label,
      final TextEditingController controller,
      final TextInputType type,
      final bool able) {
    return Container(
      height: 50.0,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
        controller: controller,
        validator: (s) => _validatorNotEmpty(s),
        keyboardType: type,
        enabled: able,
      ),
    );
  }

  static Widget buildTextFieldEmail(final TextEditingController controller) {
    return Container(
      height: 50.0,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'E-mail',
          labelStyle: TextStyle(color: Colors.black),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
        controller: controller,
        validator: (s) => validatorEmail(s),
      ),
    );
  }

  static String validatorEmail(final String email) {
    if (!EmailValidator.validate(email)) {
      return ProjectMessages.SEND_VALID_EMAIL;
    }
  }

  static Widget buildTextFieldPassword(
      final String label, final TextEditingController controller) {
    return Container(
      height: 50.0,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black),
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
        controller: controller,
        obscureText: true,
        validator: (s) => _validatorPassword(s),
      ),
    );
  }

  static String _validatorNotEmpty(final String value) {
    if (value == null || value.isEmpty) {
      return "Por favor, preencha o campo!";
    }
  }

  static String _validatorPassword(final String value) {
    if (value == null || value.isEmpty) {
      return "Por favor, preencha o campo!";
    }
    if (value.length < 6) {
      return "A senha informada deve ter seis ou mais caracteres!";
    }
  }
}

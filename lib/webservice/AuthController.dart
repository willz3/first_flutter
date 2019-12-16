import 'package:flutter_auth0/flutter_auth0.dart';
import 'package:solpac_teste/entity/Person.dart';

class AuthController {

  static Future<String> signIn(final String email, final String password, final Auth0 auth) async {
    try {
      var response = await auth.auth.passwordRealm({
        'username': email,
        'password': password,
        'realm': 'Username-Password-Authentication'
      });
      return response['access_token'];
    } catch (e) {
      print(e);
    }
  }

  static void resetPassword(final String email, final Auth0 auth) async {
    try {
      var success = await auth.auth.resetPassword({
        'email': email,
        'connection': 'Username-Password-Authentication'
      });
      print('Password Restarted: $success');
    } catch (e) {
      print(e);
    }
  }

  static Future<String> signUp(final Person person, final Auth0 auth) async  {
    try {
      var response = await auth.auth.createUser({
        'email': person.email,
        'password': person.password,
        'connection': 'Username-Password-Authentication'
      });
      return response['access_token'];
    } catch (e) {
      print(e);
    }
  }

}
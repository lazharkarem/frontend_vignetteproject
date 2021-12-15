import 'dart:convert';
import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vignetteproject3/Models/Status.dart';
import 'package:vignetteproject3/Statics/Statics.dart';

class AuthentificationController {
  Future<int> authentificate(String email, String password) async {
    //bool isConnected = await checkConnection(baseURL);
    print(baseURL + "users/login");
    final uri = Uri.parse(baseURL + "users/login");
    http.Response response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          "email": email,
          "password": password,
        }));

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      String id = body['_id'] as String;
      String firstName = body['firstName'] as String;
      String lastName = body['lastName'] as String;
      String token = body['token'] as String;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('id', id);
      prefs.setString('firstName', firstName);
      prefs.setString('lastName', lastName);
      prefs.setString('token', token);
    }

    return response.statusCode;
  }

  Future<AuthStatus> authentificationStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    await Future.delayed(Duration(seconds: 3));

    if (token != null) {
      if (Jwt.isExpired(token)) {
        // if token expired redirect to login
        print("token Expired");
        EasyLoading.showError(
            "Vous avez été deconnecté(e) \n Veuillez vous reconnecter");
        return AuthStatus.tokenExpired;
      }
      return AuthStatus.connected;
    } else {
      //token null
      return AuthStatus.tokenNull;
    }
  }

  Future<void> logout() async {
    EasyLoading.show(status: 'loading...');
    await Future.delayed(Duration(seconds: 2));
    EasyLoading.dismiss();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('token');
    prefs.remove('firstName');
    prefs.remove('lastName');
    prefs.remove('id');
  }
}

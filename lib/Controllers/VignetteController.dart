import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vignetteproject3/Models/Vignette.dart';
import 'package:vignetteproject3/Statics/Statics.dart';

class VignetteController {
  Future<List<Vignette>> getVignettes() async {
    await Future.delayed(Duration(seconds: 1));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    if (Jwt.isExpired(token)) {
      print("token Expired");
      return null;
    }

    final uri = Uri.parse(baseURL + "vignettes/getVignettes");
    http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token
      },
    );

    if (response.statusCode == 200) {
      //dynamic body = jsonDecode(staticFactures);
      var body = json.decode(response.body);
      List<Vignette> vignettes = [];
      for (var v in body) {
        Vignette vignette = Vignette.fromJson(v);
        vignettes.add(vignette);
      }
      vignettes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return vignettes;
    } else {
      return null;
    }
  }

  Future<int> uploadImage(filename) async {
    var url = baseURL + "vignettes/AddVignette";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');

    if (Jwt.isExpired(token)) {
      print("token Expired");
      return null;
    }

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', filename));
    request.headers.addAll({
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ' + token
    });

    var res = await request.send();
    if (res.statusCode == 200) {
      EasyLoading.showSuccess("Vignette scannée avec succès");
    }
    return res.statusCode;
  }
}

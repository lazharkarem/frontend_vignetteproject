import 'package:flutter/material.dart';
import 'package:vignetteproject3/Statics/Statics.dart';

class Vignette {
  String imageVignette;
  String text;
  String colorText;
  String id;
  Color color;

  DateTime createdAt;

  String promotion;

  Vignette({this.imageVignette, this.text, this.colorText, this.id});

  Vignette.fromJson(Map<String, dynamic> json) {
    imageVignette = json['image_vignette'] as String;
    text = json['text'] as String;
    colorText = json['color'] as String;
    id = json['id'] as String;

    String dateString = json['createdAt'].toString();

    dateString != null
        ? this.createdAt = DateTime.parse(dateString)
        : this.createdAt = defaultDateTime;

    if (colorText == "orange") {
      color = Colors.orange;
    } else if (colorText == "blue") {
      color = Colors.blue;
    } else {
      color = Colors.blueGrey;
    }

    if (colorText == "orange") {
      promotion = "15%";
    } else if (colorText == "blue") {
      promotion = "30%";
    } else {
      promotion = "65%";
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_vignette'] = this.imageVignette;
    data['text'] = this.text;
    data['color'] = this.color;
    data['id'] = this.id;
    return data;
  }
}

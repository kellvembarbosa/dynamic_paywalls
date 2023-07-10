import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:hexcolor/hexcolor.dart';

/// type = "social_proof_one"
class SocialProofStarsWidget extends StatelessWidget {
  final Map<String, dynamic> newData;
  const SocialProofStarsWidget(this.newData, {super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = {
      "socialText": "Millions Of Users\'s Choices",
      "rating": 4.5,
      "starCount": 5,
      "labelColor": "#3c3c3c",
      "starColor": "#CCBF4E",
      "maxValueVisibility": true,
      "valueLabelVisibility": true,
      "starSize": 20.0,
      "maxValue": 5.0,
      "starSpacing": 2.0,
      "valueLabelRadius": 10.0,
      "paddingTop": 16.0,
      "paddingBottom": 16.0,
    }..addAll(newData);

    return <Widget>[
      RatingStars(
        value: data["rating"],
        onValueChanged: (v) {},
        starBuilder: (index, color) => Icon(
          Icons.star,
          color: color,
        ),
        starCount: data["starCount"],
        starSize: data["starSize"],
        valueLabelColor: HexColor(data["labelColor"]),
        valueLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 12.0),
        valueLabelRadius: data["valueLabelRadius"],
        maxValue: data["maxValue"],
        starSpacing: data["starSpacing"],
        maxValueVisibility: data["maxValueVisibility"],
        valueLabelVisibility: data["valueLabelVisibility"],
        animationDuration: const Duration(milliseconds: 500),
        valueLabelPadding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
        valueLabelMargin: const EdgeInsets.only(right: 8),
        starOffColor: const Color(0xffe7e8ea),
        starColor: HexColor(data["starColor"]),
      ),
      const SizedBox(height: 4),
      Text(data["socialText"]).textColor(HexColor(data["labelColor"])).fontSize(12.0).fontWeight(FontWeight.w600)
    ].toColumn().padding(top: data["paddingTop"], bottom: data["paddingBottom"]);
  }
}

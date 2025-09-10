// To parse this JSON data, do
//
//     final showTripRespones = showTripResponesFromJson(jsonString);

import 'dart:convert';

List<ShowTripRespones> showTripResponesFromJson(String str) =>
    List<ShowTripRespones>.from(
      json.decode(str).map((x) => ShowTripRespones.fromJson(x)),
    );

String showTripResponesToJson(List<ShowTripRespones> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShowTripRespones {
  int idx;
  String name;
  String country;
  String coverimage;
  String detail;
  int price;
  int duration;
  String destinationZone;

  ShowTripRespones({
    required this.idx,
    required this.name,
    required this.country,
    required this.coverimage,
    required this.detail,
    required this.price,
    required this.duration,
    required this.destinationZone,
  });

  factory ShowTripRespones.fromJson(Map<String, dynamic> json) =>
      ShowTripRespones(
        idx: json["idx"],
        name: json["name"],
        country: json["country"],
        coverimage: json["coverimage"],
        detail: json["detail"],
        price: json["price"],
        duration: json["duration"],
        destinationZone: json["destination_zone"],
      );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "name": name,
    "country": country,
    "coverimage": coverimage,
    "detail": detail,
    "price": price,
    "duration": duration,
    "destination_zone": destinationZone,
  };
}

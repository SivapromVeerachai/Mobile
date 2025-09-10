// To parse this JSON data, do
//
//     final cusIdxGetRes = cusIdxGetResFromJson(jsonString);

import 'dart:convert';

CusIdxGetRes cusIdxGetResFromJson(String str) =>
    CusIdxGetRes.fromJson(json.decode(str));

String cusIdxGetResToJson(CusIdxGetRes data) => json.encode(data.toJson());

class CusIdxGetRes {
  int idx;
  String fullname;
  String phone;
  String email;
  String image;

  CusIdxGetRes({
    required this.idx,
    required this.fullname,
    required this.phone,
    required this.email,
    required this.image,
  });

  factory CusIdxGetRes.fromJson(Map<String, dynamic> json) => CusIdxGetRes(
    idx: json["idx"],
    fullname: json["fullname"],
    phone: json["phone"],
    email: json["email"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "idx": idx,
    "fullname": fullname,
    "phone": phone,
    "email": email,
    "image": image,
  };
}

// To parse this JSON data, do
//     final stepUser = stepUserFromJson(jsonString);

import 'dart:convert';

StepsUserDetail stepUserDetailFromJson(String str) =>
    StepsUserDetail.fromJson(json.decode(str));

String stepUserDetailToJson(StepsUserDetail data) => json.encode(data.toJson());

class StepsUserDetail {
  int? id;
  int? stepUserId;
  double? latitude;
  double? longtitude;
  DateTime? createdAt;
  DateTime? updatedAt;

  StepsUserDetail({
    this.id,
    this.stepUserId,
    this.latitude,
    this.longtitude,
    this.createdAt,
    this.updatedAt,
  });

  factory StepsUserDetail.fromJson(Map<String, dynamic> json) =>
      StepsUserDetail(
        id: json["id"],
        stepUserId: json["step_user_id"],
        latitude: json["latitude"].toDouble(),
        longtitude: json["longtitude"].toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "step_user_id": stepUserId,
        "latitude": latitude,
        "longtitude": longtitude,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

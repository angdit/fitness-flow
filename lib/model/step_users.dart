// To parse this JSON data, do
//     final stepUser = stepUserFromJson(jsonString);

import 'dart:convert';

StepUser stepUserFromJson(String str) => StepUser.fromJson(json.decode(str));

String stepUserToJson(StepUser data) => json.encode(data.toJson());

class StepUser {
  int? id;
  int? userId;
  DateTime? tanggal;
  int? step;
  double? berat;
  double? totalDistance;
  String? type;
  DateTime? mulai;
  DateTime? selesai;
  DateTime? createdAt;
  DateTime? updatedAt;

  StepUser({
    this.id,
    this.userId,
    this.tanggal,
    this.step,
    this.berat,
    this.totalDistance,
    this.type,
    this.mulai,
    this.selesai,
    this.createdAt,
    this.updatedAt,
  });

  factory StepUser.fromJson(Map<String, dynamic> json) => StepUser(
        id: json["id"],
        userId: json["user_id"],
        tanggal: DateTime.parse(json["tanggal"]),
        step: json["step"],
        berat: json["berat"].toDouble(),
        totalDistance: json["total_distance"].toDouble(),
        type: json["type"],
        mulai: DateTime.parse(json["mulai"]),
        selesai: DateTime.parse(json["selesai"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "tanggal":
            "${tanggal?.year.toString().padLeft(4, '0')}-${tanggal?.month.toString().padLeft(2, '0')}-${tanggal?.day.toString().padLeft(2, '0')}",
        "step": step,
        "berat": berat,
        "total_distance": totalDistance,
        "type": type,
        "mulai": mulai?.toIso8601String(),
        "selesai": selesai?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };

  @override
  String toString() {
    return 'StepUser(id: $id, userId: $userId, tanggal: $tanggal, step: $step, berat: $berat, totalDistance: $totalDistance, type: $type, mulai: $mulai, selesai: $selesai, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

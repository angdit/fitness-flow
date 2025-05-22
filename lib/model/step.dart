class Step {
  int id;
  int userId;
  DateTime tanggal;
  String step;
  DateTime createdAt;
  DateTime updatedAt;

  Step({
    required this.id,
    required this.userId,
    required this.tanggal,
    required this.step,
    required this.createdAt,
    required this.updatedAt,
  });

  Step.fromMap(Map<String, dynamic> item)
      : id = item["id"] ?? '',
        userId = item["userId"] ?? '',
        step = item["step"] ?? '',
        tanggal = item["tanggal"] ?? '',
        createdAt = item["createdAt"] ?? '',
        updatedAt = item["updatedAt"] ?? '';

  //kode kustom
  // Step.fromMap(Map<String, dynamic> item)
  //     : id = item["id"] ?? 0,
  //       userId = item["user_id"] ?? 0,
  //       step = item["step"] ?? '0',
  //       tanggal =
  //           DateTime.parse(item["tanggal"] ?? DateTime.now().toIso8601String()),
  //       createdAt =
  //           DateTime.fromMillisecondsSinceEpoch(item["created_at"] ?? 0),
  //       updatedAt =
  //           DateTime.fromMillisecondsSinceEpoch(item["updated_at"] ?? 0);

  Map<String, Object> toMap() {
    return {
      'id': id,
      'userId': userId,
      'step': step,
      'tanggal': tanggal,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  //kode kustom
  // Map<String, Object?> toMap() {
  //   return {
  //     'id': id,
  //     'user_id': userId,
  //     'step': step,
  //     'tanggal': tanggal.toIso8601String(),
  //     'created_at': createdAt.millisecondsSinceEpoch,
  //     'updated_at': updatedAt.millisecondsSinceEpoch,
  //   };
  // }
}

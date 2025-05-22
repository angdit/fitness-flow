class KaloriUser {
    int id;
    int userId;
    DateTime tanggal;
    String berat;
    String kalori;
    DateTime createdAt;
    DateTime updatedAt;
    int mealId;
    double totalkalori;
    double kaloriharian;

    KaloriUser({
        required this.id,
        required this.userId,
        required this.tanggal,
        required this.berat,
        required this.kalori,
        required this.createdAt,
        required this.updatedAt,
        required this.mealId,
        required this.totalkalori,
        required this.kaloriharian,
    });

    KaloriUser.fromMap(Map<String, dynamic> item): 
    id=item["id"] ?? '', 
    userId=item["userId"] ?? '', 
    mealId=item["mealId"] ?? '', 
    tanggal=item["tanggal"] ?? '', 
    berat=item["berat"] ?? '', 
    kalori=item["kalori"] ?? '', 
    createdAt= item["createdAt"] ?? '',
    updatedAt= item["updatedAt"] ?? '',
    totalkalori= item["totalkalori"] ?? '',
    kaloriharian= item["kaloriharian"] ?? '';
  
  Map<String, Object> toMap(){
    return {
      'id':id,
      'userId':userId,
      'mealId':mealId,
      'tanggal':tanggal,
      'berat':berat,
      'kalori':kalori,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

}

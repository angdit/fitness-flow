class Meal {
    int id;
    String nama;
    String berat;
    String kalori;
    DateTime createdAt;
    DateTime updatedAt;
    String gambar;
    String deskripsi;
    String type;

    Meal({
        required this.id,
        required this.nama,
        required this.berat,
        required this.kalori,
        required this.createdAt,
        required this.updatedAt,
        required this.gambar,
        required this.deskripsi,
        required this.type,
    });

    Meal.fromMap(Map<String, dynamic> item): 
    id=item["id"] ?? '', 
    nama=item["nama"] ?? '', 
    berat=item["berat"] ?? '', 
    kalori=item["kalori"] ?? '', 
    createdAt= item["createdAt"] ?? '',
    updatedAt= item["updatedAt"] ?? '',
    gambar= item["gambar"] ?? '',
    type= item["type"] ?? '',
    deskripsi= item["deskripsi"] ?? '';
  
  Map<String, Object> toMap(){
    return {
      'id':id,
      'nama':nama,
      'berat':berat,
      'kalori':kalori,
      'gambar':gambar,
      'deskripsi':deskripsi,
      'type':type,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

}

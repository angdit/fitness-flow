class User {
  int id;
  String username;
  String email;
  String jeniskelamin;
  String password;
  double berat;
  double berat_old;
  double tinggi; // Mengubah tipe dari int menjadi double
  String umur;
  String typeBerat;
  String typeTinggi;
  String target_berat;
  dynamic foto;
  dynamic createdAt;
  dynamic updatedAt;
  String kaloriharian;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.jeniskelamin,
    required this.password,
    required this.berat,
    required this.berat_old,
    required this.tinggi, // Tipe data baru
    required this.umur,
    required this.typeBerat,
    required this.typeTinggi,
    required this.target_berat,
    required this.foto,
    required this.createdAt,
    required this.updatedAt,
    required this.kaloriharian,
  });

  User.fromMap(Map<String, dynamic> item)
      : id = item["id"],
        username = item["username"],
        jeniskelamin = item["jeniskelamin"] ?? '',
        email = item["email"] ?? '',
        password = item["password"] ?? '',
        berat = item["berat"] != null && item["berat"] != ''
            ? item["berat"].toDouble()
            : 0.0,
        berat_old = item["berat_old"] != null && item["berat_old"] != ''
            ? item["berat_old"].toDouble()
            : 0.0,
        tinggi = item["tinggi"] != null &&
                item["tinggi"] != '' // Menangani tipe double
            ? item["tinggi"].toDouble()
            : 0.0,
        umur = item["umur"] ?? '',
        typeBerat = item["typeBerat"] ?? '',
        typeTinggi = item["type_tinggi"] ?? '',
        target_berat = (item["target_berat"] ?? 0).toString(),
        foto = item["foto"] ?? '',
        createdAt = item["createdAt"],
        updatedAt = item["updatedAt"],
        kaloriharian = (item["kaloriharian"] ?? 0).toString();

  Map<String, Object> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'jeniskelamin': jeniskelamin,
      'password': password,
      'berat': berat,
      'tinggi': tinggi, // Disesuaikan untuk tipe double
      'umur': umur,
      'typeBerat': typeBerat,
      'target_berat': target_berat,
      'type_tinggi': typeTinggi,
      'foto': foto,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'kaloriharian': kaloriharian,
    };
  }
}

import 'dart:developer';
import 'package:fitness_flow/flutter_flow/flutter_flow_util.dart';
import 'package:fitness_flow/model/step_users.dart';
import 'package:fitness_flow/model/steps_user_detail.dart';
import 'package:fitness_flow/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fitness_flow/services/sqlite_service.dart';

class FitnessFlowDB {
  Future<void> createTable(Database database) async {
    await database.execute(
        """CREATE TABLE IF NOT EXISTS "berat_users" ("id" integer,"user_id" INTEGER,"tanggal" datetime,"berat" decimal(15,2),"pinggang" decimal(15,2),"tangan" decimal(15,2),"paha" decimal(15,2),"created_at" datetime NOT NULL,"updated_at" datetime, PRIMARY KEY ("id" AUTOINCREMENT));""");
    await database.execute(
        """CREATE TABLE IF NOT EXISTS "kalori_users" ("id" integer,"user_id" integer,"tanggal" datetime,"minat" varchar,"berat" decimal(15,2),"kalori" decimal(15,2), "fat" decimal(15,2),"protein" decimal(15,2),"karbo" decimal(15,2), "created_at" datetime NOT NULL,"updated_at" datetime, "meal_id" INTEGER, PRIMARY KEY ("id" AUTOINCREMENT));""");
    await database.execute(
        """CREATE TABLE IF NOT EXISTS "meals" ("id" integer,"nama" varchar,"berat" decimal(15,2),"kalori" decimal(15,2),"fat" decimal(15,2),"protein" decimal(15,2),"karbo" decimal(15,2), "created_at" datetime NOT NULL,"updated_at" datetime, "gambar" text, "deskripsi" TEXT, "type" varchar, PRIMARY KEY ("id" AUTOINCREMENT));""");
    await database.execute(
        """CREATE TABLE IF NOT EXISTS "minat_users" ("id" integer,"user_id" INTEGER,"minat" varchar,"created_at" datetime NOT NULL,"updated_at" datetime, PRIMARY KEY ("id" AUTOINCREMENT));""");
    await database.execute(
        """CREATE TABLE IF NOT EXISTS "step_users" ("id" integer,"user_id" INTEGER,"tanggal" datetime,"step" integer, "berat" decimal(15,2), "total_distance" decimal(15,2), "type" varchar, "mulai" datetime, "selesai" datetime, "created_at" datetime NOT NULL,"updated_at" datetime, PRIMARY KEY ("id" AUTOINCREMENT));""");
    await database.execute(
        """CREATE TABLE IF NOT EXISTS "users" ("id" integer,"username" varchar,"password" varchar,"berat" decimal(15,2),"berat_old" decimal(15,2),"tinggi" decimal(15,2),"umur" varchar,"type_berat" varchar,"type_tinggi" varchar,"target_berat" decimal(15,2),"foto" text,"created_at" datetime,"updated_at" datetime, "kaloriharian" decimal(15,2), "aktivitas" decimal(15,4), "jeniskelamin" varchar, PRIMARY KEY ("id" AUTOINCREMENT));""");
    await database.execute(
        """CREATE TABLE IF NOT EXISTS "workout_users" ("id" integer,"user_id" INTEGER,"tanggal" datetime, "total_kalori" decimal(15,2), "menit" decimal(15,2), "is_running" INTEGER,"status" varchar,"created_at" datetime NOT NULL,"updated_at" datetime,"workout_id" INTEGER, PRIMARY KEY ("id" AUTOINCREMENT));""");
    await database.execute(
        """CREATE TABLE IF NOT EXISTS "workouts" ("id" integer, "nama" varchar, "kalori" decimal(15,2), "type" varchar, "deskripsi" text,"gambar" text,"link" text,"created_at" datetime NOT NULL,"updated_at" datetime, PRIMARY KEY ("id" AUTOINCREMENT));""");
    await database.execute(
        """CREATE TABLE IF NOT EXISTS "step_user_details" ("id" integer, "step_user_id" INTEGER, "latitude" decimal(15,2), "longtitude" decimal(15,2), "created_at" datetime NOT NULL,"updated_at" datetime, PRIMARY KEY ("id" AUTOINCREMENT));""");
    await database.execute("""CREATE TABLE IF NOT EXISTS "user_notes" (
            "id" INTEGER PRIMARY KEY AUTOINCREMENT,
            "user_id" INTEGER,
            "meals_id" INTEGER,
            "catatan" TEXT,
            "created_at" DATETIME NOT NULL,
            "updated_at" DATETIME,
            FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE CASCADE,
            FOREIGN KEY ("meals_id") REFERENCES "meals" ("id") ON DELETE CASCADE
        );""");
  }

  // tambahan column baru untuk table steps_users, column mulai dan selesai
  // tambahan table baru untuk table step_user_details

  // kode get untuk steps
  Future<List<StepUser>> getAllStepUsers() async {
    // Mendapatkan instance database
    final db = await SqliteService().database;

    // Menjalankan query untuk mendapatkan semua data dari tabel `step_users`
    final List<Map<String, dynamic>> maps = await db.query('step_users');

    // Mengonversi hasil query menjadi daftar objek `StepUser`
    return maps.map((e) => StepUser.fromJson(e)).toList();
  }

  // kode get untuk detail steps
  Future<List<StepsUserDetail>> getAllStepUserDetails() async {
    // Mendapatkan instance database
    final db = await SqliteService().database;

    // Menjalankan query untuk mendapatkan semua data dari tabel `step_users`
    final List<Map<String, dynamic>> maps = await db.query('step_user_details');

    // Mengonversi hasil query menjadi daftar objek `StepUser`
    return maps.map((e) => StepsUserDetail.fromJson(e)).toList();
  }

  Future<int> insertStepUsers(StepUser stepUser) async {
    // Mendapatkan instance database
    final db = await SqliteService().database;

    // Menyisipkan data ke tabel `step_users`
    final query = await db.insert(
      'step_users', // Nama tabel
      stepUser.toJson(), // Konversi model StepUser ke Map<String, dynamic>
    );

    log("${stepUser}");
    return query; // Mengembalikan id dari baris yang ditambahkan
  }

  Future<int> insertStepUserDetails(StepsUserDetail stepUserDetail) async {
    // Mendapatkan instance database
    final db = await SqliteService().database;

    // Menyisipkan data ke tabel `step_user_details`
    final query = await db.insert(
      'step_user_details', // Nama tabel
      stepUserDetail
          .toJson(), // Konversi model StepUserDetail ke Map<String, dynamic>
    );

    return query; // Mengembalikan id dari baris yang ditambahkan
  }

  Future<int> createUser(String username, password) async {
    final database = await SqliteService().database;
    return await database.rawInsert(
        '''INSERT INTO users (username, password, created_at, updated_at) VALUES (?,?,?,?)''',
        [
          username,
          password,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch
        ]);
  }

  // kode baru
  // Future<int> createUserUsername(String username) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.setString("username", username);
  //   final database = await SqliteService().database;
  //   return await database.rawInsert(
  //       '''INSERT INTO users (username, created_at, updated_at) VALUES (?,?,?)''',
  //       [
  //         username,
  //         DateTime.now().millisecondsSinceEpoch,
  //         DateTime.now().millisecondsSinceEpoch
  //       ]);
  // }
  Future<int> createUserUsername(String username) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool saved = await preferences.setString("username", username);
    if (!saved) {
      throw Exception("Failed to save username to SharedPreferences");
    }
    final database = await SqliteService().database;
    return await database.rawInsert(
        '''INSERT INTO users (username, created_at, updated_at) VALUES (?,?,?)''',
        [
          username,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch
        ]);
  }

  Future<bool> checkIfRegistered() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.containsKey('username');
  }

  Future<int> createMeal(String nama, berat, kalori, fat, protein, karbo,
      gambar, deskripsi, type) async {
    final database = await SqliteService().database;
    return await database.rawInsert(
        '''INSERT INTO meals (nama, berat, kalori, fat, protein, karbo, gambar, deskripsi, type, created_at, updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,?)''',
        [
          nama,
          berat,
          kalori,
          fat,
          protein,
          karbo,
          gambar,
          deskripsi,
          type,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch
        ]);
  }

  Future<int> createMealPickImage(String nama, berat, kalori, fat, protein,
      karbo, gambar, deskripsi, type) async {
    final database = await SqliteService().database;

    // Pastikan format path gambar benar sebelum menyimpan
    final normalizedPath = Uri.file(gambar).path;

    return await database.rawInsert(
      '''
    INSERT INTO meals (nama, berat, kalori, fat, protein, karbo, gambar, deskripsi, type, created_at, updated_at) 
    VALUES (?,?,?,?,?,?,?,?,?,?,?)
    ''',
      [
        nama,
        berat,
        kalori,
        fat,
        protein,
        karbo,
        normalizedPath,
        deskripsi,
        type,
        DateTime.now().millisecondsSinceEpoch,
        DateTime.now().millisecondsSinceEpoch,
      ],
    );
  }

  Future<int> createUserNote(int userId, int mealsId, String? catatan) async {
    final database = await SqliteService().database;

    // Menyimpan data ke dalam tabel user_notes
    return await database.insert(
      'user_notes',
      {
        'user_id': userId,
        'meals_id': mealsId,
        'catatan': catatan,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> createLatihan(
      String nama, kalori, type, deskripsi, gambar, link) async {
    final database = await SqliteService().database;
    return await database.rawInsert(
        '''INSERT INTO workouts (nama, kalori, type, deskripsi, gambar, link, created_at, updated_at) VALUES (?,?,?,?,?,?,?,?)''',
        [
          nama,
          kalori,
          type,
          deskripsi,
          gambar,
          link,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch
        ]);
  }

  Future<int> createLatihanPickImage(
      String nama, kalori, type, deskripsi, gambar, link) async {
    final database = await SqliteService().database;

    final normalizedPath = Uri.file(gambar).path;

    return await database.rawInsert(
        '''INSERT INTO workouts (nama, kalori, type, deskripsi, gambar, link, created_at, updated_at) VALUES (?,?,?,?,?,?,?,?)''',
        [
          nama,
          kalori,
          type,
          deskripsi,
          normalizedPath,
          link,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch
        ]);
  }

  Future<int> createKaloriUser(
      user_id, berat, kalori, fat, protein, karbo, minat, meal_id) async {
    final database = await SqliteService().database;
    var test = await database.rawInsert(
        '''INSERT INTO kalori_users (user_id, berat, kalori, fat, protein, karbo, minat, meal_id, tanggal, created_at, updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,?)''',
        [
          user_id,
          berat,
          kalori,
          fat,
          protein,
          karbo,
          minat,
          meal_id,
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch
        ]);

    log("isi variabel test ${test}, ${berat},${kalori}, ${fat}, ${protein}, ${karbo}");
    return test;
  }

  // Future<int> createLatihanUser(user_id, workout_id, tanggal, menit) async {
  //   final database = await SqliteService().database;

  //   // Ambil kalori per workout dari tabel workouts
  //   final kaloriData = await database.rawQuery(
  //     '''SELECT kalori FROM workouts WHERE id = ?''',
  //     [workout_id],
  //   );

  //   // Pastikan data kalori ditemukan
  //   if (kaloriData.isEmpty) {
  //     throw Exception('Workout dengan ID $workout_id tidak ditemukan.');
  //   }

  //   // Ambil nilai kalori per workout dan hitung total kalori
  //   final kaloriPerMenit = kaloriData[0]['kalori'] as int;
  //   final totalKalori = kaloriPerMenit * menit;

  //   // Lakukan insert ke tabel workout_users dengan total kalori
  //   var test = await database.rawInsert(
  //     '''INSERT INTO workout_users (user_id, workout_id, tanggal, menit, total_kalori, status, created_at, updated_at) VALUES (?,?,?,?,?,?,?,?)''',
  //     [
  //       user_id,
  //       workout_id,
  //       tanggal,
  //       menit,
  //       totalKalori,
  //       'belum',
  //       DateTime.now().millisecondsSinceEpoch,
  //       DateTime.now().millisecondsSinceEpoch
  //     ],
  //   );

  //   return test;
  // }

  Future<int> createLatihanUser(user_id, workout_id, tanggal, menit,
      total_kalori, is_running, status) async {
    final database = await SqliteService().database;
    var test = await database.rawInsert(
        '''INSERT INTO workout_users (user_id, workout_id, tanggal, menit, total_kalori, is_running, status, created_at, updated_at) VALUES (?,?,?,?,?,?,?,?,?)''',
        [
          user_id,
          workout_id,
          tanggal,
          menit,
          total_kalori,
          is_running,
          status,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch,
        ]);
    log("ini adalah data dari test $test");
    return test;
  }

  // kode untuk memasukkan data secara manual
  // Future<int> createStep(
  //     int userId, String step, double berat, String type) async {
  //   final database = await SqliteService().database;
  //   final result = await database.rawInsert(
  //     '''INSERT INTO step_users
  //      (user_id, step, berat, type, tanggal, created_at, updated_at)
  //      VALUES (?, ?, ?, ?, ?, ?, ?)''',
  //     [
  //       userId,
  //       step,
  //       berat,
  //       type,
  //       DateFormat('yyyy-MM-dd').format(DateTime.now()), // Format tanggal
  //       DateTime.now().millisecondsSinceEpoch, // Timestamp created_at
  //       DateTime.now().millisecondsSinceEpoch, // Timestamp updated_at
  //     ],
  //   );
  //   return result;
  // }

  Future<int> createStep(user_id, step, berat, type) async {
    final database = await SqliteService().database;
    var test = await database.rawInsert(
        '''INSERT INTO step_users (user_id, step,  berat, type, tanggal, created_at, updated_at) VALUES (?,?,?,?,?,?,?)''',
        [
          user_id,
          step,
          berat,
          type,
          DateFormat('yyyy-MM-dd').format(DateTime.now()),
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch
        ]);
    return test;
  }

  Future<int> createBeratBadan(
      user_id, berat, tanggal, pinggang, tangan, paha) async {
    final database = await SqliteService().database;
    var test = await database.rawInsert(
        '''INSERT INTO berat_users (user_id, berat, tanggal, pinggang, tangan, paha, created_at, updated_at) VALUES (?,?,?,?,?,?,?,?)''',
        [
          user_id,
          berat,
          tanggal,
          pinggang,
          tangan,
          paha,
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch
        ]);
    return test;
  }

  Future<int> updateUser(int id, String field, String value) async {
    final database = await SqliteService().database;
    return await database.rawUpdate(
        '''UPDATE users SET $field = ?, updated_at = ? WHERE id = ?''',
        [value, DateTime.now().millisecondsSinceEpoch, id]);
  }

  Future<int> changeStatusLatihan(int id, String status, int is_running) async {
    final database = await SqliteService().database;
    return await database.rawUpdate(
        '''UPDATE workout_users SET status = ?, is_running = ?, updated_at = ? WHERE id = ?''',
        [status, is_running, DateTime.now().millisecondsSinceEpoch, id]);
  }

  fetchStepHarian(tanggal) async {
    final database = await SqliteService().database;
    final step = await database.rawQuery('''
      SELECT COALESCE(SUM(step), 0) AS total_steps 
      FROM step_users 
      WHERE DATE(tanggal) = '$tanggal';
    ''');
    return step;
  }

  fetchLatihanHarianGroup(tanggal) async {
    final database = await SqliteService().database;
    final step = await database.rawQuery('''
      SELECT 
        COUNT(CASE WHEN status = 'belum' THEN 1 END) AS belum_count,
        COUNT(CASE WHEN status = 'sudah' THEN 1 END) AS sudah_count
      FROM workout_users 
      WHERE DATE(tanggal) = '$tanggal';
    ''');
    print(step);
    return step;
  }

  fetchLatihanHarian(date) async {
    final database = await SqliteService().database;
    final latihan = await database.rawQuery(
      '''
      SELECT *, workout_users.id as workout_user_id
      FROM workout_users
      INNER JOIN workouts ON workouts.id = workout_users.workout_id
      WHERE user_id = 1
      AND tanggal = '$date'
      ''',
    );
    log(" dari fetch latihan harian : ${latihan}");
    return latihan;
  }

  fetchLatihanAll() async {
    final database = await SqliteService().database;
    final latihan = await database.rawQuery(
      '''
      SELECT *
      FROM workouts
      ''',
    );
    return latihan;
  }

  fetchKaloriHarian(date) async {
    final database = await SqliteService().database;
    final kalori_harian = await database.rawQuery(
      '''
      SELECT u.id AS user_id,
          u.username  ,
            u.tinggi,
            u.berat,
            u.umur,
            u.jeniskelamin,
            u.type_berat,
            u.target_berat,
            u.aktivitas,
            COALESCE(SUM(k.kalori), 0) AS total_kalori_consumed
      FROM users u
      LEFT JOIN kalori_users k ON u.id = k.user_id
      WHERE u.id = 1
      AND k.tanggal = '$date'
      ''',
    );
    log("kalori harian : $kalori_harian");

    return kalori_harian;
  }

  // kode sebelumnya
  // fetchKaloriHarianSteps(date) async {
  //   final database = await SqliteService().database;
  //   final kalori_harian_steps = await database.rawQuery('''
  //    SELECT COALESCE(SUM(step_users.step) * 0.04, 0) AS total_burned_steps
  //    FROM step_users
  //    WHERE user_id = 1 AND DATE(step_users.tanggal) = '$date'
  //    ''');

  //   log("kalori harian : $kalori_harian_steps");
  //   return kalori_harian_steps;
  // }

  fetchKaloriHarianSteps(date) async {
    final database = await SqliteService().database;
    final kalori_harian_steps = await database.rawQuery('''
    SELECT 
      step_users.step,
      step_users.type,
      users.berat
    FROM step_users
    INNER JOIN users ON step_users.user_id = users.id
    WHERE step_users.user_id = 1 
    AND DATE(step_users.tanggal) = '$date'
  ''');

    double totalBurnedSteps = 0.0;

    for (var item in kalori_harian_steps) {
      var berat = (item['berat'] ?? 0) as int;
      var step = (item['step'] ?? 0) as int;
      var type = item['type'] ?? 'walk';

      double kalori = 0.0;

      // Perhitungan berdasarkan tipe aktivitas
      if (type == 'walk') {
        kalori = 0.57 * berat * (step / 1312);
      } else if (type == 'run') {
        kalori = 1.03 * berat * (step / 1312);
      } else {
        kalori = 0.8 * berat * (step / 1312);
      }

      totalBurnedSteps += kalori;
    }
    String roundedResult = totalBurnedSteps.toStringAsFixed(2);

    log("Kalori harian (dibulatkan): $roundedResult");
    return {'total_burned_steps': roundedResult};
  }

  // kode lama
  // fetchKaloriHarianWorkouts(date) async {
  //   final database = await SqliteService().database;
  //   final kalori_harian_workouts = await database.rawQuery('''
  //    SELECT COALESCE(SUM(workouts.kalori), 0) AS total_burned_workouts
  //    FROM workout_users
  //    INNER JOIN workouts ON workouts.id = workout_users.workout_id
  //    WHERE user_id = 1 AND DATE(workout_users.tanggal) = '$date'
  //    ''');
  //   log("kalori harian : $kalori_harian_workouts");
  //   return kalori_harian_workouts;
  // }

  fetchKaloriHarianWorkouts(date) async {
    final database = await SqliteService().database;
    final kaloriHarianWorkouts = await database.rawQuery('''
    SELECT COALESCE(SUM(total_kalori), 0) AS total_burned_workouts
    FROM workout_users
    WHERE user_id = 1 AND DATE(tanggal) = ?
  ''', [date]);

    log("Kalori harian: $kaloriHarianWorkouts");
    return kaloriHarianWorkouts;
  }

  fetchKaloriHarianGroup(date) async {
    final database = await SqliteService().database;
    final kalori_harian = await database.rawQuery(
      '''
      SELECT u.id AS user_id,
            u.username,
            u.tinggi,
            u.berat,
            u.umur,
            u.jeniskelamin,
            u.type_berat,
            u.target_berat,
            u.aktivitas,
            COALESCE(SUM(CASE WHEN k.minat = 'Breakfast' THEN k.kalori ELSE 0 END), 0) AS breakfast,
            COALESCE(SUM(CASE WHEN k.minat = 'Lunch' THEN k.kalori ELSE 0 END), 0) AS lunch,
            COALESCE(SUM(CASE WHEN k.minat = 'Dinner' THEN k.kalori ELSE 0 END), 0) AS dinner,
            COALESCE(SUM(CASE WHEN k.minat = 'Snack' THEN k.kalori ELSE 0 END), 0) AS snack
      FROM users u
      LEFT JOIN kalori_users k 
      ON u.id = k.user_id
      AND DATE(k.tanggal) = DATE(?) 
      WHERE u.id = 1
      GROUP BY u.id
      ''',
      [date],
    );
    return kalori_harian;
  }

  // fetchKaloriHarianGroup(date) async {
  //   final database = await SqliteService().database;
  //   final kalori_harian = await database.rawQuery(
  //     '''
  //     SELECT u.id AS user_id,
  //           u.username,
  //           u.tinggi,
  //           u.berat,
  //           u.umur,
  //           u.jeniskelamin,
  //           u.type_berat,
  //           u.target_berat,
  //           u.aktivitas,
  //           COALESCE(SUM(CASE WHEN k.minat = 'Breakfast' THEN k.kalori ELSE 0 END), 0) AS breakfast,
  //           COALESCE(SUM(CASE WHEN k.minat = 'Lunch' THEN k.kalori ELSE 0 END), 0) AS lunch,
  //           COALESCE(SUM(CASE WHEN k.minat = 'Dinner' THEN k.kalori ELSE 0 END), 0) AS dinner,
  //           COALESCE(SUM(CASE WHEN k.minat = 'Snack' THEN k.kalori ELSE 0 END), 0) AS snack
  //     FROM users u
  //     LEFT JOIN kalori_users k ON u.id = k.user_id
  //     WHERE u.id = 1
  //     AND DATE(k.tanggal) = DATE(?)
  //     ''',
  //     [date],
  //   );
  //   return kalori_harian;
  // }

//   fetchKaloriHarianGroup(date) async {
//     final database = await SqliteService().database;
//     final kalori_harian = await database.rawQuery(
//       '''
//       SELECT
//           u.id AS user_id,
//           u.username,
//           COALESCE(u.tinggi, 0) AS tinggi,
//           COALESCE(u.berat, 0) AS berat,
//           COALESCE(u.umur, 0) AS umur,
//           COALESCE(u.jeniskelamin, 'L') AS jeniskelamin,
//           COALESCE(u.type_berat, 'kg') AS type_berat,
//           COALESCE(u.target_berat, 0) AS target_berat,
//           COALESCE(u.aktivitas, 0) AS aktivitas,
//           COALESCE(SUM(CASE WHEN k.minat = 'Breakfast' THEN k.kalori ELSE 0 END), 0) AS breakfast,
//           COALESCE(SUM(CASE WHEN k.minat = 'Lunch' THEN k.kalori ELSE 0 END), 0) AS lunch,
//           COALESCE(SUM(CASE WHEN k.minat = 'Dinner' THEN k.kalori ELSE 0 END), 0) AS dinner,
//           COALESCE(SUM(CASE WHEN k.minat = 'Snack' THEN k.kalori ELSE 0 END), 0) AS snack
//       FROM users u
//       LEFT JOIN kalori_users k
//           ON u.id = k.user_id
//           AND DATE(k.tanggal) = DATE(?)
//       WHERE u.id = 1
//       GROUP BY u.id
//       ''',
//       [date],
//     );
//     return kalori_harian;
// }

  fetchBeratBadan() async {
    final database = await SqliteService().database;
    final berat = await database.rawQuery(
      '''
      SELECT *
      FROM berat_users 
      WHERE user_id = 1
      ''',
    );
    log("isi variabel : ${berat}");
    return berat;
  }

  // kode sebelumnya
  login(username, password) async {
    final database = await SqliteService().database;
    final user = await database.rawQuery(
      '''SELECT * FROM users WHERE username = '$username' AND password = '$password' ''',
    );
    final login = await database.rawQuery(
      '''SELECT * FROM users''',
    );
    if (user.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  loginusername(username) async {
    final database = await SqliteService().database;
    final user = await database.rawQuery(
      '''SELECT * FROM users WHERE username = '$username' ''',
    );
    final login = await database.rawQuery(
      '''SELECT * FROM users''',
    );
    if (user.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  fetchUserById(int id) async {
    final database = await SqliteService().database;
    final user = await database.rawQuery(
      '''SELECT * FROM users WHERE id = $id''',
    );

    if (user.isNotEmpty) {
      return User.fromMap(user.first);
    } else {
      return null;
    }
  }

  fetchUserByIdV2(int id) async {
    final database = await SqliteService().database;
    final user = await database.rawQuery(
      '''SELECT * FROM users WHERE id = $id''',
    );

    return user;
  }

  fetchUserAll() async {
    final database = await SqliteService().database;
    final user = await database.rawQuery(
      '''SELECT * FROM users''',
    );
    return user;
  }

  // fetchMeals() async {
  //   final database = await SqliteService().database;
  //   final meal = await database.rawQuery(
  //     '''SELECT * FROM meals''',
  //   );
  //   return meal;
  // }

  fetchMeals() async {
    final database = await SqliteService().database;
    final meal = await database.rawQuery('''
    SELECT 
      meals.*, 
      CASE 
        WHEN COUNT(user_notes.id) > 0 THEN GROUP_CONCAT(user_notes.catatan, ' || ') 
        ELSE NULL 
      END AS notes
    FROM meals
    LEFT JOIN user_notes ON meals.id = user_notes.meals_id
    GROUP BY meals.id
    ''');
    return meal;
  }

  Future<List<Map<String, dynamic>>> fetchMealsNote() async {
    final database = await SqliteService().database;
    return await database.query('meals');
  }

  Future<List<Map<String, dynamic>>> fetchNotes() async {
    final database = await SqliteService().database;
    final notes = await database.rawQuery('''SELECT 
          user_notes.id AS note_id, 
          user_notes.user_id, 
          user_notes.meals_id, 
          user_notes.catatan, 
          user_notes.created_at AS note_created_at, 
          user_notes.updated_at AS note_updated_at,
          meals.id AS meal_id, 
          meals.nama AS meal_nama, 
          meals.berat AS meal_berat, 
          meals.kalori AS meal_kalori, 
          meals.fat AS meal_fat, 
          meals.protein AS meal_protein, 
          meals.karbo AS meal_karbo, 
          meals.gambar AS meal_gambar, 
          meals.deskripsi AS meal_deskripsi, 
          meals.type AS meal_type, 
          meals.created_at AS meal_created_at, 
          meals.updated_at AS meal_updated_at
      FROM user_notes
      LEFT JOIN meals ON user_notes.meals_id = meals.id
    ''');
    return notes;
  }

  fetchStep() async {
    final database = await SqliteService().database;
    final step = await database.rawQuery(
      '''SELECT * FROM step_users WHERE user_id = 1 ORDER BY id DESC''',
    );
    return step;
  }

  // fetchMealDaily(type, date) async {
  //   final database = await SqliteService().database;
  //   final kalori_harian = await database.rawQuery(
  //     '''
  //     SELECT kalori_users.* , meals.*, kalori_users.id AS kalori_user_id
  //     FROM kalori_users
  //     LEFT JOIN meals ON kalori_users.meal_id = meals.id
  //     WHERE minat = '$type'
  //     AND kalori_users.tanggal = '$date'
  //     ''',
  //   );
  //   return kalori_harian;
  // }
  fetchMealDaily(type, date) async {
    final database = await SqliteService().database;
    final kalori_harian = await database.rawQuery(
      '''
      SELECT 
        kalori_users.*,
        meals.nama AS meal_nama,
        meals.gambar AS meal_gambar,
        meals.berat AS meal_berat,
        meals.kalori AS meal_kalori,
        meals.fat AS meal_fat,
        meals.protein AS meal_protein,
        meals.karbo AS meal_karbo,
        kalori_users.id AS kalori_user_id
      FROM kalori_users
      LEFT JOIN meals ON kalori_users.meal_id = meals.id
      WHERE kalori_users.minat = '$type'
      AND kalori_users.tanggal = '$date'
      ''',
    );
    return kalori_harian;
  }

  Future<void> updateMealDaily(int id, double berat, double kalori, double fat,
      double protein, double karbo) async {
    final database = await SqliteService().database;

    await database.update(
      'kalori_users',
      {
        'berat': berat,
        'kalori': kalori,
        'fat': fat,
        'protein': protein,
        'karbo': karbo,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateMeal(
  int id,
  String nama,
  double berat,
  double kalori,
  double fat,
  double protein,
  double karbo,
  String gambar,
  String deskripsi,
  String type,
) async {
  final database = await SqliteService().database;

  await database.update(
    'meals',
    {
      'nama': nama,
      'berat': berat,
      'kalori': kalori,
      'fat': fat,
      'protein': protein,
      'karbo': karbo,
      'gambar': gambar,
      'deskripsi': deskripsi,
      'type': type,
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    },
    where: 'id = ?',
    whereArgs: [id],
  );
}


  fetchKaloriHarianJurnalTipe(type, date) async {
    final database = await SqliteService().database;
    final kalori_harian = await database.rawQuery(
      '''
      SELECT 
      kalori_users.kalori AS kalori_custom,  
      kalori_users.id AS kalori_user_id,   
      kalori_users.minat,                  
      kalori_users.tanggal,
      meals.nama AS meal_nama,             
      meals.gambar AS meal_gambar
      FROM kalori_users
      LEFT JOIN meals ON kalori_users.meal_id = meals.id
      WHERE minat = '$type' 
      AND kalori_users.minat = '$date'
      ''',
    );
    log("Fetching data with date: $date and type: $type");
    if (kalori_harian.isNotEmpty) {
      log("Data kalori harian ditemukan: ${kalori_harian.toString()}");
    } else {
      log("Tidak ada data kalori harian ditemukan untuk tanggal $date dan tipe $type");
    }
    return kalori_harian ?? [];
  }

  fetchMealById(int id) async {
    final database = await SqliteService().database;
    final meal = await database.rawQuery(
      '''SELECT * FROM meals WHERE id = $id''',
    );
    return meal;
  }

  fetchLatihanById(int id) async {
    final database = await SqliteService().database;
    final latihan = await database.rawQuery(
      '''SELECT * FROM workouts WHERE id = $id''',
    );
    log("${latihan}");
    return latihan;
  }

  fetchKaloriHarianJurnal(date) async {
    final database = await SqliteService().database;
    final kalori_harian = await database.rawQuery(
      '''
      SELECT *
      FROM kalori_users
      WHERE tanggal = '$date'
      ''',
    );
    return kalori_harian;
  }

  deleteMealJurnal(id) async {
    final database = await SqliteService().database;
    final kalori_harian = await database.rawDelete(
      '''
      DELETE FROM kalori_users
      WHERE id = ?
      ''',
      ['$id'],
    );
    return kalori_harian;
  }

    deleteMeal(id) async {
    final database = await SqliteService().database;
    final meal = await database.rawDelete(
      '''
      DELETE FROM meals
      WHERE id = ?
      ''',
      ['$id'],
    );
    return meal;
  }

    deleteWorks(id) async {
    final database = await SqliteService().database;
    final works = await database.rawDelete(
      '''
      DELETE FROM workouts
      WHERE id = ?
      ''',
      ['$id'],
    );
    return works;
  }

  deleteBeratBadan(id) async {
    final database = await SqliteService().database;
    final berat_users = await database.rawDelete(
      '''
      DELETE FROM berat_users
      WHERE id = ?
      ''',
      ['$id'],
    );
    return berat_users;
  }

  deleteNotes(id) async {
    final database = await SqliteService().database;
    final user_notes = await database.rawDelete(
      '''
      DELETE FROM user_notes
      WHERE id = ?
      ''',
      ['$id'],
    );
    return user_notes;
  }

  deleteLatihanHarian(id) async {
    final database = await SqliteService().database;
    final workout_users = await database.rawDelete(
      '''
      DELETE FROM workout_users
      WHERE id = ?
      ''',
      ['$id'],
    );
    return workout_users;
  }
}

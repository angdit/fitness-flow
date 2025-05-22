import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/widgets.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'events_page_model.dart';
export 'events_page_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsPageWidget extends StatefulWidget {
  const EventsPageWidget({super.key});

  @override
  State<EventsPageWidget> createState() => _EventsPageWidgetState();
}

class _EventsPageWidgetState extends State<EventsPageWidget>
    with TickerProviderStateMixin {
  // double _itemOpacity = 1.0;
  late EventsPageModel _model;
  Timer? _timer;
  List<bool> isRunning = [];
  List<bool> hasStarted = [];
  List<int?> remainingTime = [];
  List<bool> isButtonVisible = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();
  var hariini = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String dateFormat = DateFormat('MMMM , yyyy').format(DateTime.now());

  final animationsMap = {
    'containerOnPageLoadAnimation1': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 20.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(0.0, 20.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  Future<void> clearCorruptPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isRunning');
    await prefs.remove('hasStarted');
    await prefs.remove('remainingTime');
    await prefs.remove('isButtonVisible');
  }

  Future? futureUser;
  var futureUserSession;
  Future? futureLatihanHarian;
  final fitnessFlowDB = FitnessFlowDB();

  Future<void> saveLatihanState() async {
    final prefs = await SharedPreferences.getInstance();

    log("✅ State akan disimpan kembali karena masih ada data latihan.");
    prefs.setStringList(
        'isRunning', isRunning.map((e) => e.toString()).toList());
    prefs.setStringList(
        'hasStarted', hasStarted.map((e) => e.toString()).toList());
    prefs.setStringList(
        'remainingTime', remainingTime.map((e) => e.toString()).toList());
    prefs.setStringList(
        'isButtonVisible', isButtonVisible.map((e) => e.toString()).toList());

    log("✅ State Disimpan: isRunning: $isRunning, hasStarted: $hasStarted, remainingTime: $remainingTime, isButtonVisible: $isButtonVisible");
  }

  Future<void> loadLatihanState() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (prefs.containsKey('isRunning') && prefs.get('isRunning') is List) {
        isRunning = prefs
                .getStringList('isRunning')
                ?.map((e) => e == 'true')
                .toList() ??
            [];
      }
      if (prefs.containsKey('hasStarted') && prefs.get('hasStarted') is List) {
        hasStarted = prefs
                .getStringList('hasStarted')
                ?.map((e) => e == 'true')
                .toList() ??
            [];
      }
      if (prefs.containsKey('remainingTime') &&
          prefs.get('remainingTime') is List) {
        remainingTime = prefs
                .getStringList('remainingTime')
                ?.map((e) => int.tryParse(e) ?? 0)
                .toList() ??
            [];
      }
      if (prefs.containsKey('isButtonVisible') &&
          prefs.get('isButtonVisible') is List) {
        isButtonVisible = prefs
                .getStringList('isButtonVisible')
                ?.map((e) => e == 'true')
                .toList() ??
            [];
      }

      log("📥 State Dimuat: isRunning: $isRunning, hasStarted: $hasStarted, remainingTime: $remainingTime, isButtonVisible: $isButtonVisible");
    });
  }

  Future<void> deleteLatihan(
      int idToDelete, List<Map<String, dynamic>> itemList) async {
    await fitnessFlowDB.deleteLatihanHarian(idToDelete);

    final prefs = await SharedPreferences.getInstance();

    int removeIndex =
        itemList.indexWhere((item) => item['workout_user_id'] == idToDelete);

    log("📌 removeIndex ditemukan: $removeIndex");

    if (removeIndex != -1) {
      log("🔄 Sebelum dihapus: isRunning: ${prefs.getStringList('isRunning')}, hasStarted: ${prefs.getStringList('hasStarted')}, remainingTime: ${prefs.getStringList('remainingTime')}, isButtonVisible: ${prefs.getStringList('isButtonVisible')}");

      List<String>? runningList = prefs.getStringList('isRunning');
      List<String>? startedList = prefs.getStringList('hasStarted');
      List<String>? timeList = prefs.getStringList('remainingTime');
      List<String>? buttonVisibleList = prefs.getStringList('isButtonVisible');

      // Pastikan list tidak null dan removeIndex valid
      if (runningList != null &&
          startedList != null &&
          timeList != null &&
          buttonVisibleList != null &&
          removeIndex < runningList.length &&
          removeIndex < startedList.length &&
          removeIndex < timeList.length &&
          removeIndex < buttonVisibleList.length) {
        runningList.removeAt(removeIndex);
        startedList.removeAt(removeIndex);
        timeList.removeAt(removeIndex);
        buttonVisibleList.removeAt(removeIndex);

        await prefs.setStringList('isRunning', runningList);
        await prefs.setStringList('hasStarted', startedList);
        await prefs.setStringList('remainingTime', timeList);
        await prefs.setStringList('isButtonVisible', buttonVisibleList);
      } else {
        log("⚠️ List kosong atau removeIndex tidak valid: $removeIndex");
      }

      setState(() {
        itemList.removeWhere((item) => item['workout_user_id'] == idToDelete);
      });

      log("🗑 Data dengan ID $idToDelete dihapus dari UI dan SharedPreferences");

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: AppLocalizations.of(context)!.success + '!',
          message: AppLocalizations.of(context)!.exercise_successfully_deleted,
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        _loadStateAndFetchData();
      });
    } else {
      log("⚠️ Item dengan ID $idToDelete tidak ditemukan di itemList");
    }
  }

  @override
  void initState() {
    super.initState();

    // clearCorruptPreferences().then((_) {
    //   _loadStateAndFetchData();
    // });

    _model = createModel(context, () => EventsPageModel());

    _initializeAlarm();
    requestPermissions();
    _loadStateAndFetchData();
  }

  Future<void> _loadStateAndFetchData() async {
    await loadLatihanState();
    latihanHarian(hariini);
  }

  Future<void> requestPermissions() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  void _initializeAlarm() async {
    await Alarm.init();
  }

  // latihanHarian(date) {
  //   setState(() {
  //     futureLatihanHarian = fitnessFlowDB.fetchLatihanHarian(date);
  //   });

  //   futureLatihanHarian?.then((data) {
  //     if (data == null || data.isEmpty) {
  //       log("⚠️ Data latihan harian kosong atau null!");
  //       return;
  //     }

  //     setState(() {
  //       isRunning = List.generate(data.length, (index) {
  //         bool isNew = (data[index]['is_running'] ?? 0) == 0;

  //         return isNew
  //             ? false
  //             : (isRunning.length > index ? isRunning[index] : false);
  //       });

  //       hasStarted = List.generate(data.length, (index) {
  //         bool isNew = (data[index]['is_running'] ?? 0) == 0;

  //         return isNew
  //             ? false
  //             : (hasStarted.length > index ? hasStarted[index] : false);
  //       });

  //       remainingTime = List.generate(data.length, (index) {
  //         return remainingTime.length > index ? remainingTime[index] : 0;
  //       });

  //       isButtonVisible = List.generate(data.length, (index) {
  //         bool isRunningNow = (data[index]['is_running'] ?? 0) == 1;

  //         return isRunningNow
  //             ? true
  //             : (isButtonVisible.length > index
  //                 ? isButtonVisible[index]
  //                 : false);
  //       });
  //     });

  //     log("✅ Data latihan harian berhasil dimuat dengan panjang ${data.length}");
  //   }).catchError((error) {
  //     log("❌ Error saat mengambil data latihan harian: $error");
  //   });
  // }

  latihanHarian(date) {
    setState(() {
      futureLatihanHarian = fitnessFlowDB.fetchLatihanHarian(date);
    });

    futureLatihanHarian?.then((data) async {
      if (data == null || data.isEmpty) {
        log("⚠️ Data latihan harian kosong atau null!");
        return;
      }

      setState(() {
        isRunning = List.generate(data.length, (index) {
          bool isNew = (data[index]['is_running'] ?? 0) == 0;

          return isNew
              ? false
              : (isRunning.length > index ? isRunning[index] : false);
        });

        hasStarted = List.generate(data.length, (index) {
          bool isNew = (data[index]['is_running'] ?? 0) == 0;

          return isNew
              ? false
              : (hasStarted.length > index ? hasStarted[index] : false);
        });

        remainingTime = List.generate(data.length, (index) {
          return remainingTime.length > index ? remainingTime[index] : 0;
        });

        isButtonVisible = List.generate(data.length, (index) {
          bool isRunningNow = (data[index]['is_running'] ?? 0) == 1;

          return isRunningNow
              ? true
              : (isButtonVisible.length > index
                  ? isButtonVisible[index]
                  : false);
        });
      });

      // Update SharedPreferences jika is_running == 1
      final prefs = await SharedPreferences.getInstance();
      for (int i = 0; i < data.length; i++) {
        if (data[i]['is_running'] == 1) {
          isRunning[i] = false; // Set isRunning to false
          hasStarted[i] = true; // Set hasStarted to true
          remainingTime[i] = 0; // Set remainingTime to 0
          isButtonVisible[i] = true; // Set isButtonVisible to true
        }
      }

      // Simpan perubahan ke SharedPreferences
      await prefs.setStringList(
          'isRunning', isRunning.map((e) => e.toString()).toList());
      await prefs.setStringList(
          'hasStarted', hasStarted.map((e) => e.toString()).toList());
      await prefs.setStringList(
          'remainingTime', remainingTime.map((e) => e.toString()).toList());
      await prefs.setStringList(
          'isButtonVisible', isButtonVisible.map((e) => e.toString()).toList());

      log("✅ Data latihan harian berhasil dimuat dengan panjang ${data.length}");
      log("📥 State Dimuat: isRunning: $isRunning, hasStarted: $hasStarted, remainingTime: $remainingTime, isButtonVisible: $isButtonVisible");
    }).catchError((error) {
      log("❌ Error saat mengambil data latihan harian: $error");
    });
  }

  void _startTimer(
      int index, int initialMinutes, Map<String, dynamic> itemData) {
    if (isRunning.any((status) => status)) return;

    setState(() {
      hasStarted[index] = true; // Timer dimulai
      isRunning[index] = true;
      remainingTime[index] = initialMinutes * 60; // Konversi menit ke detik
    });

    saveLatihanState();

    // Timer berjalan setiap detik
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (!isRunning[index] || remainingTime[index]! <= 0) {
        timer.cancel(); // Timer berhenti jika di-pause atau waktu habis
        if (remainingTime[index]! <= 0) {
          setState(() {
            remainingTime[index] = 0;
            hasStarted[index] = true; // Timer selesai
            isRunning[index] = false;
          });

          saveLatihanState();

          if (mounted) {
            _showTimeUpDialog(context, index, itemData);
          }
        }
      } else {
        setState(() {
          remainingTime[index] =
              (remainingTime[index] ?? 0) - 1; // Kurangi 1 detik
        });
      }
    });
  }

  void _pauseTimer(int index) {
    if (isRunning[index]) {
      setState(() {
        isRunning[index] = false;
      });

      saveLatihanState();
    }
  }

  void _resumeTimer(int index, Map<String, dynamic> itemData) {
    if (remainingTime[index]! <= 0) return;

    setState(() {
      isRunning[index] = true;
    });

    saveLatihanState();

    // Timer berjalan kembali
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (!isRunning[index] || remainingTime[index]! <= 0) {
        timer.cancel(); // Timer berhenti jika di-pause atau waktu habis
        if (remainingTime[index]! <= 0) {
          setState(() {
            hasStarted[index] = false; // Timer selesai
            isRunning[index] = false;
          });

          saveLatihanState();

          if (mounted) {
            _showTimeUpDialog(context, index, itemData);
          }
        }
      } else {
        setState(() {
          remainingTime[index] =
              (remainingTime[index] ?? 0) - 1; // Kurangi 1 detik
        });
      }
    });
  }

  bool isNetworkImage(String imagePath) {
    final uri = Uri.tryParse(imagePath);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  Widget displayImage(String imagePath) {
    debugPrint(
        'Gambar path: $imagePath'); // Debug log untuk melihat path gambar

    if (isNetworkImage(imagePath)) {
      return Image.network(
        imagePath,
        width: 44.0,
        height: 44.0,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint(
              'Error loading network image: $error'); // Debug log untuk error URL
          return const Icon(Icons.broken_image, size: 44.0);
        },
      );
    } else if (File(imagePath).existsSync()) {
      return Image.file(
        File(imagePath),
        width: 44.0,
        height: 44.0,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint(
              'Error loading local file: $error'); // Debug log untuk error file
          return const Icon(Icons.broken_image, size: 44.0);
        },
      );
    } else {
      debugPrint(
          'Path tidak valid atau file tidak ditemukan'); // Debug log untuk path invalid
      return const Icon(Icons.image_not_supported, size: 44.0);
    }
  }

  void _showTimeUpDialog(
      BuildContext context, int index, Map<String, dynamic> itemData) {
    if (!mounted) return;

    _setAlarm();

    Future.delayed(Duration.zero, () {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.time_out),
            content: Text(AppLocalizations.of(context)!.exercise_time_is_over),
            actions: [
              TextButton(
                onPressed: () async {
                  if (mounted) {
                    Alarm.stop(1).then((_) {
                      print("🔇 Alarm dihentikan sebelum diputar ulang.");
                    });
                    Navigator.of(context).pop();
                    setState(() {
                      isRunning[index] = false;
                      isButtonVisible[index] = true;
                    });

                    await fitnessFlowDB.changeStatusLatihan(
                        itemData['workout_user_id'], 'sudah', 1);

                    setState(() {
                      isButtonVisible[index] = true;
                      itemData = {...itemData, 'is_running': 1};
                      itemData = {...itemData, 'status': 'sudah'};
                      log("DEBUG: itemData['status'] setelah update: ${itemData['status']}");
                    });

                    await saveLatihanState();

                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: AppLocalizations.of(context)!.success + '!',
                        message: AppLocalizations.of(context)!
                            .exercise_status_successfully_changed,
                        contentType: ContentType.success,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  }
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    });
  }

  void _setAlarm() {
    final alarmSettings = AlarmSettings(
      id: 1,
      dateTime:
          DateTime.now().add(Duration(seconds: 3)), // Bunyi setelah 3 detik
      assetAudioPath: "assets/audios/alarm.mp3",
      loopAudio: true,
      vibrate: true,
      volume: 1.0,
      fadeDuration: 3.0,
      notificationTitle: AppLocalizations.of(context)!.time_out,
      notificationBody: AppLocalizations.of(context)!.exercise_time_is_over,
    );

    print("⏰ Alarm akan diset...");
    Alarm.set(alarmSettings: alarmSettings).then((_) {
      print("✅ Alarm berhasil diset!");
    }).catchError((error) {
      print("❌ Gagal menyetel alarm: $error");
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String dateFormat = AppLocalizations.of(context)!.date_journal;

    DateTime now = DateTime.now();

    String formattedDatee =
        DateFormat('MMMM, yyyy', Localizations.localeOf(context).toString())
            .format(now);

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushNamed('FormAddWork');
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8.0,
          child: Icon(
            Icons.add_outlined,
            color: Colors.white,
            size: 24.0,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 48.0, 12.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlutterFlowIconButton(
                          borderColor: Colors.transparent,
                          borderRadius: 30.0,
                          borderWidth: 1.0,
                          buttonSize: 48.0,
                          icon: Icon(
                            Icons.keyboard_arrow_left,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 30.0,
                          ),
                          onPressed: () async {
                            context.pushNamed('HomePage');
                          },
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .exercise
                              .toLowerCase()
                              .split(' ')
                              .map((word) => word.isNotEmpty
                                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                                  : '')
                              .join(' '),
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Rubik',
                                    fontSize: 16.0,
                                    letterSpacing: 0.2,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          AppLocalizations.of(context)!
                              .exercise
                              .toLowerCase()
                              .split(' ')
                              .map((word) => word.isNotEmpty
                                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                                  : '')
                              .join(' '),
                          style: TextStyle(
                            color: Colors.transparent,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(30.0, 12.0, 24.0, 0.0),
                  child: Text(
                    "${formattedDatee}",
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Rubik',
                          color: dateFormat == hariini
                              ? FlutterFlowTheme.of(context).secondary
                              : FlutterFlowTheme.of(context).primaryText,
                        ),
                  )),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 7.0, 24.0, 0.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (index) {
                      DateTime date =
                          DateTime.now().subtract(Duration(days: 2 - index));
                      String formattedDate = DateFormat(dateFormat,
                              Localizations.localeOf(context).toString())
                          .format(date);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            latihanHarian(formattedDate);
                            hariini = formattedDate;
                          });
                        },
                        child: Container(
                          width: 64.0,
                          height: 96.0,
                          decoration: BoxDecoration(
                            color: formattedDate == hariini
                                ? FlutterFlowTheme.of(context).primary
                                : Color(0x007165E3),
                            borderRadius: BorderRadius.circular(48.0),
                          ),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 16.0, 0.0, 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat.E(Localizations.localeOf(context)
                                          .languageCode)
                                      .format(date)
                                      .toUpperCase(),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Rubik',
                                        color: formattedDate == hariini
                                            ? Colors.white
                                            : FlutterFlowTheme.of(context)
                                                .secondaryText,
                                        letterSpacing: 0.4,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                                Container(
                                  width: 36.0,
                                  height: 36.0,
                                  decoration: BoxDecoration(
                                    color: formattedDate == hariini
                                        ? FlutterFlowTheme.of(context)
                                            .secondaryBackground
                                        : Color(0x00F5F6FA),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    DateFormat.d().format(date),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Rubik',
                                          color: formattedDate == hariini
                                              ? FlutterFlowTheme.of(context)
                                                  .secondary
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FutureBuilder(
                        future: futureLatihanHarian,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (snapshot.data.length == 0) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context)!.no_data)
                                ],
                              );
                            } else {
                              return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var itemData = snapshot.data[index];
                                    var kalori = (double.parse(
                                                itemData['kalori'].toString()) *
                                            double.parse(
                                                itemData['menit'].toString()))
                                        .toStringAsFixed(1);
                                    // return AnimatedOpacity(
                                    //   opacity:
                                    //       _itemOpacity, // Kontrol opacity di sini
                                    //   duration: Duration(milliseconds: 1000),
                                    //   child:
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 10.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 144.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0.0),
                                                    bottomRight:
                                                        Radius.circular(0.0),
                                                    topLeft:
                                                        Radius.circular(24.0),
                                                    topRight:
                                                        Radius.circular(24.0),
                                                  ),
                                                ),
                                                child: Stack(children: <Widget>[
                                                  Positioned.fill(
                                                      child: displayImage(
                                                          itemData['gambar'])),
                                                  Positioned(
                                                    top: 8.0,
                                                    right: 8.0,
                                                    child: AnimatedOpacity(
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      opacity: isButtonVisible[
                                                                  index] ==
                                                              true
                                                          ? 1.0
                                                          : 0.0,
                                                      child: IgnorePointer(
                                                        ignoring:
                                                            !isButtonVisible[
                                                                index],
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12.0),
                                                          ),
                                                          child: IconButton(
                                                            iconSize: 24.0,
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .solidCheckCircle,
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primary,
                                                            ),
                                                            onPressed:
                                                                () async {},
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(24.0),
                                                    bottomRight:
                                                        Radius.circular(24.0),
                                                    topLeft:
                                                        Radius.circular(0.0),
                                                    topRight:
                                                        Radius.circular(0.0),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 24,
                                                      right: 12,
                                                      top: 12,
                                                      bottom: 24),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text(
                                                            AppLocalizations.of(
                                                                        context)!
                                                                    .getTranslation(
                                                                        itemData[
                                                                            'type']) +
                                                                " | ${itemData['total_kalori']} " +
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .calorie
                                                                    .toLowerCase()
                                                                    .split(' ')
                                                                    .map((word) =>
                                                                        word.isNotEmpty
                                                                            ? '${word[0].toUpperCase()}${word.substring(1)}'
                                                                            : '')
                                                                    .join(' ') +
                                                                " | ${itemData['menit']} " +
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .minutes
                                                                    .toLowerCase()
                                                                    .split(' ')
                                                                    .map((word) =>
                                                                        word.isNotEmpty
                                                                            ? '${word[0].toUpperCase()}${word.substring(1)}'
                                                                            : '')
                                                                    .join(' '),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                          ),
                                                          Spacer(),
                                                          FlutterFlowIconButton(
                                                            borderColor: Colors
                                                                .transparent,
                                                            borderRadius: 12.0,
                                                            borderWidth: 1.0,
                                                            buttonSize: 36.0,
                                                            fillColor: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryBackground,
                                                            icon: FaIcon(
                                                              FontAwesomeIcons
                                                                  .trashAlt,
                                                              color: Colors.red,
                                                              size: 14.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              int idToDelete =
                                                                  itemData[
                                                                      'workout_user_id'];
                                                              List<
                                                                      Map<String,
                                                                          dynamic>>
                                                                  itemList = [];
                                                              if (itemData
                                                                  is List) {
                                                                itemList = List<
                                                                        Map<String,
                                                                            dynamic>>.from(
                                                                    itemData);
                                                              } else {
                                                                itemList.add(Map<
                                                                        String,
                                                                        dynamic>.from(
                                                                    itemData));
                                                              }

                                                              log("isi dari item list : ${itemList}");

                                                              // setState(() {
                                                              //   _itemOpacity =
                                                              //       0.0; // Atur opacity menjadi 0
                                                              // });
                                                              // await Future.delayed(
                                                              //     Duration(
                                                              //         milliseconds:
                                                              //             500));

                                                              await deleteLatihan(
                                                                  idToDelete,
                                                                  itemList);

                                                              // log("🗑 Data latihan dengan ID $index telah dihapus dari database dan SharedPreferences.");
                                                              final snackBar =
                                                                  SnackBar(
                                                                elevation: 0,
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                content:
                                                                    AwesomeSnackbarContent(
                                                                  title: AppLocalizations.of(
                                                                              context)!
                                                                          .success +
                                                                      '!',
                                                                  message: AppLocalizations.of(
                                                                          context)!
                                                                      .exercise_successfully_deleted,
                                                                  contentType:
                                                                      ContentType
                                                                          .success,
                                                                ),
                                                              );

                                                              ScaffoldMessenger
                                                                  .of(context)
                                                                ..hideCurrentSnackBar()
                                                                ..showSnackBar(
                                                                    snackBar);
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    0.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .getTranslation(
                                                                  itemData[
                                                                      'nama']),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Rubik',
                                                                fontSize: 16.0,
                                                              ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    6.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .getTranslation(
                                                                  itemData[
                                                                      'deskripsi']),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Rubik',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 12.0,
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          await launchURL(
                                                              itemData['link']);
                                                        },
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .see_tutorial,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  decoration:
                                                                      TextDecoration
                                                                          .underline,
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .secondary,
                                                                  fontSize:
                                                                      12.0,
                                                                  letterSpacing:
                                                                      0.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                )),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    24.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            FFButtonWidget(
                                                              onPressed: (hasStarted[
                                                                          index] &&
                                                                      remainingTime[
                                                                              index] ==
                                                                          0)
                                                                  ? null
                                                                  : isRunning.any((status) =>
                                                                              status) &&
                                                                          !isRunning[
                                                                              index]
                                                                      ? null
                                                                      : (itemData['is_running'] == 1 &&
                                                                              itemData['status'] == 'Sudah')
                                                                          ? null
                                                                          : () {
                                                                              if (isRunning[index]) {
                                                                                _pauseTimer(index); // Pause the timer
                                                                              } else {
                                                                                final Map<String, dynamic> data = Map<String, dynamic>.from(itemData);
                                                                                if (remainingTime[index] == 0) {
                                                                                  // Jika timer selesai, mulai dari awal
                                                                                  _startTimer(index, itemData['menit'], data);
                                                                                } else {
                                                                                  // Jika timer dijeda, lanjutkan
                                                                                  _resumeTimer(index, data);
                                                                                }
                                                                                setState(() {
                                                                                  hasStarted[index] = true;
                                                                                });
                                                                              }
                                                                            },
                                                              text: (hasStarted[
                                                                          index] &&
                                                                      remainingTime[
                                                                              index] ==
                                                                          0)
                                                                  ? AppLocalizations
                                                                          .of(
                                                                              context)!
                                                                      .done
                                                                  : isRunning[
                                                                          index]
                                                                      ? AppLocalizations.of(
                                                                              context)!
                                                                          .pause
                                                                      : (remainingTime[index]! >
                                                                              0
                                                                          ? AppLocalizations.of(context)!
                                                                              .resume
                                                                          : AppLocalizations.of(context)!
                                                                              .start),
                                                              options:
                                                                  FFButtonOptions(
                                                                height: 42.0,
                                                                padding: EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        24.0,
                                                                        0.0,
                                                                        24.0,
                                                                        0.0),
                                                                iconPadding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                color: (hasStarted[index] &&
                                                                        remainingTime[index] ==
                                                                            0)
                                                                    ? Color(
                                                                        0xFFE0E0E0)
                                                                    : (isRunning.any((status) =>
                                                                                status) &&
                                                                            !isRunning[
                                                                                index])
                                                                        ? Color(
                                                                            0xFFE0E0E0)
                                                                        : (itemData['is_running'] == 1 &&
                                                                                itemData['status'] == 'Sudah')
                                                                            ? Color(0xFFE0E0E0)
                                                                            : FlutterFlowTheme.of(context).tertiary, // Warna tombol aktif
                                                                textStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .titleSmall
                                                                    .override(
                                                                      fontFamily:
                                                                          'Rubik',
                                                                      color: (hasStarted[index] &&
                                                                              remainingTime[index] ==
                                                                                  0)
                                                                          ? Color(
                                                                              0xFF9E9E9E) // Warna teks nonaktif
                                                                          : FlutterFlowTheme.of(context)
                                                                              .primary, // Warna teks aktif
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                elevation: 0.0,
                                                                borderSide:
                                                                    BorderSide(
                                                                  color: Colors
                                                                      .transparent,
                                                                  width: 0.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12.0),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (hasStarted[index])
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 12),
                                                          child: Center(
                                                            child: Text(
                                                              remainingTime[
                                                                          index]! >
                                                                      0
                                                                  ? '${(remainingTime[index]! ~/ 60).toString().padLeft(2, '0')}:${(remainingTime[index]! % 60).toString().padLeft(2, '0')}'
                                                                  : AppLocalizations.of(
                                                                          context)!
                                                                      .done,
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    fontSize:
                                                                        16.0,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'containerOnPageLoadAnimation1']!),
                                    );
                                  });
                            }
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension LocalizationHelper on AppLocalizations {
  String getTranslation(String key) {
    switch (key) {
      //nama
      case 'squat_jump':
        return this.squat_jump;
      case 'skipping_rope':
        return this.skipping_rope;
      case 'squat':
        return this.squat;
      case 'rowing':
        return this.rowing;
      case 'stair_climbing':
        return this.stair_climbing;

      //type
      case 'chest_type':
        return this.chest_type;
      case 'legs_type':
        return this.legs_type;
      case 'shoulders_type':
        return this.shoulders_type;
      case 'full_body_type':
        return this.full_body_type;
      case 'abs_type':
        return this.abs_type;

      //deskripsi
      case 'diamond_push_up_desc':
        return this.diamond_push_up_desc;
      case 'legs_desc':
        return this.legs_desc;
      case 'arm_circle_desc':
        return this.arm_circle_desc;
      case 'lateral_raises_desc':
        return this.lateral_raises_desc;
      case 'bench_press_desc':
        return this.bench_press_desc;
      case 'skipping_rope_desc':
        return this.skipping_rope_desc;
      case 'jumping_jacks_desc':
        return this.jumping_jacks_desc;
      case 'sit_up_desc':
        return this.sit_up_desc;
      case 'squat_desc':
        return this.squat_desc;
      case 'spinning_desc':
        return this.spinning_desc;
      case 'rowing_desc':
        return this.rowing_desc;
      case 'stair_climbing_desc':
        return this.stair_climbing_desc;
      case 'elliptical_desc':
        return this.elliptical_desc;
      case 'px_desc':
        return this.px_desc;
      case 'muay_thai_desc':
        return this.muay_thai_desc;
      default:
        return key;
    }
  }
}

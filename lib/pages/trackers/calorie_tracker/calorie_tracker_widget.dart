import 'dart:developer';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'calorie_tracker_model.dart';
export 'calorie_tracker_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalorieTrackerWidget extends StatefulWidget {
  const CalorieTrackerWidget({super.key});

  @override
  State<CalorieTrackerWidget> createState() => _CalorieTrackerWidgetState();
}

class _CalorieTrackerWidgetState extends State<CalorieTrackerWidget>
    with TickerProviderStateMixin {
  late CalorieTrackerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'columnOnPageLoadAnimation1': AnimationInfo(
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
    'columnOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 600.ms,
          begin: Offset(0.0, 20.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'columnOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: Offset(0.0, 20.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  Future? futureKaloriHarianSteps;
  Future? futureKaloriHarianWorkouts;

  var hariini = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String formattedDate =
      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());

  fetchKaloriHarianSteps(date) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        futureKaloriHarianSteps = fitnessFlowDB.fetchKaloriHarianSteps(date);
      });
    });
    log(" fetchKaloriHarianSteps : ${futureKaloriHarianSteps.toString()}");
  }

  fetchKaloriHarianWorkouts(date) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        futureKaloriHarianWorkouts =
            fitnessFlowDB.fetchKaloriHarianWorkouts(date);
      });
    });
    log("fetchKaloriHarianWorkouts : ${futureKaloriHarianWorkouts.toString()}");
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CalorieTrackerModel());
    fetchKaloriHarianGroup(hariini);
    fetchKaloriHarianSteps(hariini);
    fetchKaloriHarianWorkouts(hariini);
  }

  Future? futureUser;
  var futureUserSession;
  Future? futureKaloriHarianGroup;
  final fitnessFlowDB = FitnessFlowDB();

  void fetchUser() async {
    setState(() {
      futureUser = fitnessFlowDB.fetchUserById(1);
    });
  }

  void fetchKaloriHarianGroup(date) async {
    try {
      // Fetch data dari database
      Map<String, dynamic>? kaloriStepsData =
          await fitnessFlowDB.fetchKaloriHarianSteps(date);
      List<Map<String, dynamic>>? kaloriWorkoutsData =
          await fitnessFlowDB.fetchKaloriHarianWorkouts(date);
      List<Map<String, dynamic>>? kaloriHarianGroupData =
          await fitnessFlowDB.fetchKaloriHarianGroup(date);

      // Hitung kalori langkah dan workout
      double kaloriSteps = double.tryParse(
              kaloriStepsData?['total_burned_steps']?.toString() ?? '0') ??
          0.0;
      double kaloriWorkouts = kaloriWorkoutsData != null &&
              kaloriWorkoutsData.isNotEmpty
          ? kaloriWorkoutsData.first['total_burned_workouts']?.toDouble() ?? 0.0
          : 0.0;

      // Data default untuk ditampilkan jika grup kosong
      Map<String, dynamic> defaultData = {
        'tinggi': 0.0,
        'berat': 0.0,
        'umur': 0,
        'jeniskelamin': 'L',
        'type_berat': 'kg',
        'target_berat': 0.0,
        'aktivitas': 0.0,
        'breakfast': 0.0,
        'lunch': 0.0,
        'dinner': 0.0,
        'snack': 0.0,
        'adjusted_total_kalori': 0.0,
        'user_id': 1,
        'tanggal': date,
      };

      log("Kalori Harian Workouts Data Sebelum Kondisi : $kaloriWorkoutsData");
      log("Kalori Harian Steps Data Sebelum Kondisi : $kaloriStepsData");
      log("Kalori Harian group data sebelum kondisi :  ${kaloriHarianGroupData}");

      if (kaloriHarianGroupData != null && kaloriHarianGroupData.isNotEmpty) {
        // Ambil data asli
        var originalData = Map<String, dynamic>.from(kaloriHarianGroupData[0]);

        // Hitung total kalori meal
        double totalKalori = (originalData['breakfast']?.toDouble() ?? 0.0) +
            (originalData['lunch']?.toDouble() ?? 0.0) +
            (originalData['dinner']?.toDouble() ?? 0.0) +
            (originalData['snack']?.toDouble() ?? 0.0);

        // Kurangi total kalori dengan langkah dan workout
        double adjustedTotalKalori =
            totalKalori - (kaloriSteps + kaloriWorkouts);
        log("adjustedtotalkalori di dalam if sebelum tambahkan adjusted : ${originalData}");

        // Tambahkan total kalori yang disesuaikan ke data asli

        originalData['adjusted_total_kalori'] = adjustedTotalKalori;
        originalData['kalori_steps'] = kaloriSteps;
        originalData['kalori_workouts'] = kaloriWorkouts;

        log("adjustedtotalkalori di dalam if setelah tambahkan adjusted : ${originalData}");
        log("adjustedtotalkalori di dalam if : ${adjustedTotalKalori}");

        setState(() {
          futureKaloriHarianGroup = Future.value([originalData]);

          log("ini future kalori di set state : ${originalData}");
        });
      } else {
        double adjustedTotalKalori = -(kaloriSteps + kaloriWorkouts);
        defaultData['adjusted_total_kalori'] = adjustedTotalKalori;
        defaultData['kalori_steps'] = kaloriSteps;
        defaultData['kalori_workouts'] = kaloriWorkouts;

        log("DI ELSE ${kaloriSteps}");
        log("DI ELSE ${kaloriWorkouts}");
        log("Default Data (Else): $defaultData");

        setState(() {
          futureKaloriHarianGroup = Future.value([defaultData]);
        });
      }
    } catch (e) {
      log("Error saat fetch kalori harian group: $e");
      setState(() {
        futureKaloriHarianGroup = Future.value([
          {
            'breakfast': 0.0,
            'lunch': 0.0,
            'dinner': 0.0,
            'snack': 0.0,
            'adjusted_total_kalori': 0.0,
            'user_id': 1,
            'tanggal': date,
          }
        ]);
      });
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  hitungKaloriHarian(user) {
    var berat =
        user['type_berat'] == 'kg' ? user['berat'] : user['berat'] * 0.45359237;
    var bmr;
    if (user['jeniskelamin'] == 'L') {
      bmr = 66 +
          (13.7 * berat) +
          (5 * user['tinggi']) -
          (6.8 * int.parse(user['umur']));
    } else {
      bmr = 655 +
          (9.6 * berat) +
          (1.8 * user['tinggi']) -
          (4.7 * int.parse(user['umur']));
    }
    var kalori = bmr * user['aktivitas'];
    if (user['target_berat'] < berat) {
      kalori -= 500; // Adjust based on how aggressive the weight loss should be
      if (kalori < 1200) {
        // Ensure calories don't go below a healthy level
        kalori = 1200; // Minimum calorie intake for safe weight loss
      }
    } else if (user['target_berat'] > berat) {
      kalori += 500;
    }
    return kalori.round();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureKaloriHarianGroup,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var totalkalori = 0.0;
            var targetkalori = 0;
            var breakfast = 0.0;
            var lunch = 0.0;
            var dinner = 0.0;
            var snack = 0.0;
            var totalkaloriharian = '0';
            var adjustedTotalKalori = 0.0;
            var adjustedtotalkaloriharian = '0';
            var kaloriterbakarstepsdouble = 0.0;
            var kaloriterbakarworkoutsdouble = 0.0;

            // log("snapshot data sebelum pengkondisian : ${snapshot.data[0]}");

            if (snapshot.data[0]['user_id'] != null) {
              // log("snapshot data setelah pengkondisian : ${snapshot.data[0]}");

              log("snapshot data : ${snapshot.data[0]['kalori_steps']}");

              // kaloriterbakarstepsdouble =
              //     snapshot.data[0]['kalori_steps'] ?? 0.0;
              // kaloriterbakarworkoutsdouble =
              //     snapshot.data[0]['kalori_workouts'] ?? 0.0;

              kaloriterbakarstepsdouble =
                  snapshot.data[0]['kalori_steps']?.toDouble() ?? 0.0;
              kaloriterbakarworkoutsdouble =
                  snapshot.data[0]['kalori_workouts']?.toDouble() ?? 0.0;

              log("Kalori terbakar dari langkah ${kaloriterbakarstepsdouble}");

              totalkalori = (snapshot.data[0]['breakfast']?.toDouble() ?? 0.0) +
                  (snapshot.data[0]['lunch']?.toDouble() ?? 0.0) +
                  (snapshot.data[0]['dinner']?.toDouble() ?? 0.0) +
                  (snapshot.data[0]['snack']?.toDouble() ?? 0.0);

              targetkalori = hitungKaloriHarian(snapshot.data[0]);

              log("target kalori : $targetkalori");

              // Hitung persentase masing-masing meal terhadap total
              // breakfast = snapshot.data[0]['breakfast'] / totalkalori;
              // lunch = snapshot.data[0]['lunch'] / totalkalori;
              // dinner = snapshot.data[0]['dinner'] / totalkalori;
              breakfast = (snapshot.data[0]['breakfast']?.toDouble() ?? 0.0) /
                  totalkalori;
              lunch =
                  (snapshot.data[0]['lunch']?.toDouble() ?? 0.0) / totalkalori;
              dinner =
                  (snapshot.data[0]['dinner']?.toDouble() ?? 0.0) / totalkalori;
              snack =
                  (snapshot.data[0]['snack']?.toDouble() ?? 0.0) / totalkalori;

              log("total kalori : $totalkalori");

              // Hitung total kalori harian dalam persen
              totalkaloriharian =
                  ((totalkalori / targetkalori) * 100).round().toString();

              log("Total Kalori: $totalkaloriharian");
              log("Breakfast: ${snapshot.data[0]['breakfast']}");
              log("Lunch: ${snapshot.data[0]['lunch']}");
              log("Dinner: ${snapshot.data[0]['dinner']}");

              // Ambil nilai adjusted_total_kalori jika ada
              if (snapshot.data[0].containsKey('adjusted_total_kalori')) {
                adjustedTotalKalori = snapshot.data[0]['adjusted_total_kalori'];
                adjustedtotalkaloriharian =
                    ((adjustedTotalKalori / targetkalori) * 100)
                        .toStringAsFixed(1)
                        .toString();
                log("adjusttotalkaloriharian di dalam if : ${adjustedtotalkaloriharian}");
              } else {
                // Jika tidak ada, gunakan totalkalori sebagai default
                adjustedTotalKalori = totalkalori;
                adjustedtotalkaloriharian = totalkaloriharian;
                log(" adjusted kalori di dalam else: $adjustedTotalKalori");
                log(" harian adjusted di dalam else: $adjustedtotalkaloriharian");
              }
            }

            adjustedTotalKalori = snapshot.data[0]['adjusted_total_kalori'];

            log("kalori terbakar dari langkah : ${kaloriterbakarstepsdouble}");

            return GestureDetector(
              onTap: () => _model.unfocusNode.canRequestFocus
                  ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                  : FocusScope.of(context).unfocus(),
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: Colors.white,
                floatingActionButton: Transform.translate(
                  offset: Offset(0, -12),
                  child: FloatingActionButton(
                    onPressed: () {
                      context.pushNamed('FormAddMeal');
                    },
                    backgroundColor: FlutterFlowTheme.of(context).primary,
                    elevation: 8.0,
                    child: Icon(
                      Icons.add_outlined,
                      color: Colors.white,
                      size: 24.0,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 48.0, 24.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlutterFlowIconButton(
                              borderColor: Colors.transparent,
                              borderRadius: 30.0,
                              borderWidth: 1.0,
                              buttonSize: 60.0,
                              icon: Icon(
                                Icons.keyboard_arrow_left,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 30.0,
                              ),
                              onPressed: () async {
                                context.pushNamed('HomePage');
                              },
                            ),
                            FFButtonWidget(
                              onPressed: () async {
                                context.pushNamed('FoodJournal');
                              },
                              text: AppLocalizations.of(context)!
                                  .journal
                                  .toLowerCase()
                                  .split(' ')
                                  .map((word) => word.isNotEmpty
                                      ? '${word[0].toUpperCase()}${word.substring(1)}'
                                      : '')
                                  .join(' '),
                              options: FFButtonOptions(
                                width: 84.0,
                                height: 40.0,
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                iconPadding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                color: Color(0xFFE4DFFF),
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Rubik',
                                      color: Color(0xFF7165E3),
                                      fontSize: 2.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                elevation: 0.0,
                                borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 0.0, 24.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.daily_intake,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Rubik',
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 14.0,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  60.0, 12.0, 60.0, 0.0),
                              child: RichText(
                                textScaler: MediaQuery.of(context).textScaler,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!
                                              .you_have_consumed +
                                          ' ',
                                      style: TextStyle(),
                                    ),
                                    TextSpan(
                                      text:
                                          "${adjustedTotalKalori.toStringAsFixed(1)} cal ",
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                      ),
                                    ),
                                    TextSpan(
                                      text: AppLocalizations.of(context)!
                                              .position_tracker_text +
                                          " ${formatDateWithLocalization(context, DateTime.now())}",
                                      style: TextStyle(),
                                    )
                                  ],
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Rubik',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 10.0, 0.0, 0.0),
                              child: Stack(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                children: [
                                  CircularPercentIndicator(
                                    percent:
                                        (breakfast >= 0.0 && breakfast <= 1.0)
                                            ? breakfast
                                            : 0.0,
                                    radius: 120.0,
                                    lineWidth: 10.0,
                                    animation: true,
                                    animateFromLastPercent: true,
                                    progressColor: Color(0xFF1D87FD),
                                    backgroundColor: Color(0xFFE9E9E9),
                                    startAngle: 0.0,
                                  ),
                                  CircularPercentIndicator(
                                    percent: (lunch >= 0.0 && lunch <= 1.0)
                                        ? lunch
                                        : 0.0,
                                    radius: 100.0,
                                    lineWidth: 10.0,
                                    animation: true,
                                    animateFromLastPercent: true,
                                    progressColor:
                                        FlutterFlowTheme.of(context).primary,
                                    backgroundColor: Color(0xFFE9E9E9),
                                    startAngle: 0.0,
                                  ),
                                  CircularPercentIndicator(
                                    percent: (dinner >= 0.0 && dinner <= 1.0)
                                        ? dinner
                                        : 0.0,
                                    radius: 80.0,
                                    lineWidth: 10.0,
                                    animation: true,
                                    animateFromLastPercent: true,
                                    progressColor: Color(0xFF7EE4F0),
                                    backgroundColor: Color(0xFFE9E9E9),
                                    startAngle: 0.0,
                                  ),
                                  CircularPercentIndicator(
                                    percent: (snack >= 0.0 && snack <= 1.0)
                                        ? snack
                                        : 0.0,
                                    radius: 60.0,
                                    lineWidth: 10.0,
                                    animation: true,
                                    animateFromLastPercent: true,
                                    progressColor: Color(0xFFFFA500),
                                    backgroundColor: Color(0xFFE9E9E9),
                                    startAngle: 0.0,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 0.0, 0.0, 0.0),
                                        child: Text(
                                          '${adjustedtotalkaloriharian}%',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Rubik',
                                                fontSize: 24.0,
                                              ),
                                        ),
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .of_daily_goals,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Rubik',
                                              color: Color(0xFF828282),
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (double.tryParse(adjustedtotalkaloriharian) != null &&
                          double.tryParse(adjustedtotalkaloriharian)! > 100.0)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            AppLocalizations.of(context)!
                                .calories_have_exceeded_the_daily_target,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Rubik',
                                  color: Colors.red,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  36.0, 0.0, 36.0, 0.0),
                              child: ListView(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed('FormAddMeal');
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 22.0,
                                              height: 22.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF0066FF),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .breakfast,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Rubik',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                            Text(
                                              "${snapshot.data[0]['breakfast']} cal",
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Rubik',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 24.0,
                                        thickness: 1.0,
                                        color: Color(0xFFE9E9E9),
                                      ),
                                    ],
                                  ).animateOnPageLoad(animationsMap[
                                      'columnOnPageLoadAnimation1']!),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed(
                                            'FormAddMeal',
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 22.0,
                                              height: 22.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF8B80F8),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .lunch,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Rubik',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                            Text(
                                              "${snapshot.data[0]['lunch']} cal",
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Rubik',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 24.0,
                                        thickness: 1.0,
                                        color: Color(0xFFE9E9E9),
                                      ),
                                    ],
                                  ).animateOnPageLoad(animationsMap[
                                      'columnOnPageLoadAnimation2']!),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed(
                                            'FormAddMeal',
                                          );
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 22.0,
                                              height: 22.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFF7EE4F0),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .dinner,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Rubik',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                            Text(
                                              "${snapshot.data[0]['dinner']} cal",
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Rubik',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 24.0,
                                        thickness: 1.0,
                                        color: Color(0xFFE9E9E9),
                                      ),
                                    ],
                                  ).animateOnPageLoad(animationsMap[
                                      'columnOnPageLoadAnimation3']!),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          context.pushNamed('FormAddMeal');
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 22.0,
                                              height: 22.0,
                                              decoration: BoxDecoration(
                                                color: Color(0xFFFFA500),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .snack,
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Rubik',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                            Text(
                                              "${snapshot.data[0]['snack']} cal",
                                              style:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Rubik',
                                                        fontWeight:
                                                            FontWeight.normal,
                                                      ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ).animateOnPageLoad(animationsMap[
                                      'columnOnPageLoadAnimation3']!),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .calories_burned_from_steps,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                        Text(
                                          "${kaloriterbakarstepsdouble.toStringAsFixed(1)} cal",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'columnOnPageLoadAnimation3']!),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 0.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .calories_burned_from_workouts,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                        Text(
                                          "${kaloriterbakarworkoutsdouble.toStringAsFixed(1)} cal",
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Rubik',
                                                fontWeight: FontWeight.normal,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ).animateOnPageLoad(animationsMap[
                                      'columnOnPageLoadAnimation3']!),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}

String formatDateWithLocalization(BuildContext context, DateTime date) {
  final localizations = AppLocalizations.of(context)!;

  // Mapping hari
  Map<String, String> days = {
    'Monday': localizations.monday,
    'Tuesday': localizations.tuesday,
    'Wednesday': localizations.wednesday,
    'Thursday': localizations.thursday,
    'Friday': localizations.friday,
    'Saturday': localizations.saturday,
    'Sunday': localizations.sunday,
  };

  // Mapping bulan
  Map<String, String> months = {
    'January': localizations.january,
    'February': localizations.february,
    'March': localizations.march,
    'April': localizations.april,
    'May': localizations.may,
    'June': localizations.june,
    'July': localizations.july,
    'August': localizations.august,
    'September': localizations.september,
    'October': localizations.october,
    'November': localizations.november,
    'December': localizations.december,
  };

  // Format awal
  String day = DateFormat('EEEE').format(date); // Hari
  String month = DateFormat('MMMM').format(date); // Bulan

  // Ganti dengan hasil terjemahan
  String localizedDay = days[day] ?? day;
  String localizedMonth = months[month] ?? month;

  // Format ulang
  return "$localizedDay, ${DateFormat('dd').format(date)} $localizedMonth ${DateFormat('yyyy').format(date)}";
}

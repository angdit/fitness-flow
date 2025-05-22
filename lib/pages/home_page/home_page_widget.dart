import 'dart:convert';
import 'dart:developer';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/widgets.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'containerOnPageLoadAnimation1': AnimationInfo(
      reverse: true,
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        ScaleEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 2000.ms,
          begin: Offset(1.0, 1.0),
          end: Offset(1.2, 1.2),
        ),
      ],
    ),
    'imageOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        RotateEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 900.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 600.ms,
          begin: Offset(0.0, 80.0),
          end: Offset(0.0, 0.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 200.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
    'containerOnPageLoadAnimation3': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: Offset(0.0, 80.0),
          end: Offset(0.0, 0.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 400.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
    'containerOnPageLoadAnimation4': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 600.ms,
          begin: Offset(0.0, 80.0),
          end: Offset(0.0, 0.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 300.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
    'containerOnPageLoadAnimation5': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 500.ms,
          duration: 600.ms,
          begin: Offset(0.0, 80.0),
          end: Offset(0.0, 0.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 500.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
    'containerOnPageLoadAnimation6': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 900.ms,
          duration: 600.ms,
          begin: Offset(0.0, 80.0),
          end: Offset(0.0, 0.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 900.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  Future? futureUser;
  var futureUserSession;
  Future? futureKaloriHarian;
  Future? futureBeratBadan;
  Future? futureStepHarian;
  Future? futureLatihanHarian;
  Future? futureKaloriStep;
  Future? futureKaloriWorkouts;
  final fitnessFlowDB = FitnessFlowDB();
  // final Datetime datetime;
  var hariini = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var beratuser = 0.0;

  void fetchUser() async {
    setState(() {
      futureUser = fitnessFlowDB.fetchUserById(1);
    });
  }

  //fetch harian yang sudah dimodifikasi
  void fetchKaloriHarian(date) async {
    try {
      // Fetch data dari database
      Map<String, dynamic>? kaloriStepsData =
          await fitnessFlowDB.fetchKaloriHarianSteps(date);
      List<Map<String, dynamic>>? kaloriWorkoutsData =
          await fitnessFlowDB.fetchKaloriHarianWorkouts(date);
      List<Map<String, dynamic>>? kaloriHarianData =
          await fitnessFlowDB.fetchKaloriHarian(date);

      // Hitung kalori langkah dan workout
      double kaloriSteps = double.tryParse(
              kaloriStepsData?['total_burned_steps']?.toString() ?? '0') ??
          0.0;
      double kaloriWorkouts = kaloriWorkoutsData != null &&
              kaloriWorkoutsData.isNotEmpty
          ? kaloriWorkoutsData.first['total_burned_workouts']?.toDouble() ?? 0.0
          : 0.0;

      Map<String, dynamic> defaultData = {
        'total_kalori_consumed': 0.0,
        'user_id': null,
        'tanggal': date,
      };

      // Buat salinan data untuk dimodifikasi
      if (kaloriHarianData != null && kaloriHarianData.isNotEmpty) {
        List<Map<String, dynamic>> modifiableKaloriHarianData =
            kaloriHarianData.map((e) => Map<String, dynamic>.from(e)).toList();

        modifiableKaloriHarianData[0]['total_kalori_consumed'] -=
            (kaloriSteps + kaloriWorkouts);

        log("${modifiableKaloriHarianData}");

        // Simpan data ke state
        setState(() {
          futureKaloriHarian = Future.value(modifiableKaloriHarianData);
        });
      } else {
        // Inisialisasi dengan data default jika tidak ada data
        setState(() {
          futureKaloriHarian = Future.value([
            {
              'total_kalori_consumed': -(kaloriSteps + kaloriWorkouts),
              'user_id': null,
              'tanggal': date,
            }
          ]);
        });
      }
    } catch (e) {
      log("Error saat fetch kalori harian: $e");
      setState(() {
        futureKaloriHarian = Future.value([]);
      });
    }
  }

  void fetchStepHarian() async {
    setState(() {
      futureStepHarian = fitnessFlowDB
          .fetchStepHarian(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    });
  }

  void fetchBeratBadan() async {
    setState(() {
      futureBeratBadan = fitnessFlowDB.fetchBeratBadan();
    });
  }

  void fetchLatihanHarian(date) async {
    setState(() {
      futureLatihanHarian = fitnessFlowDB.fetchLatihanHarianGroup(date);
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    fetchUser();
    fetchKaloriHarian(hariini);
    fetchBeratBadan();
    fetchStepHarian();
    fetchLatihanHarian(hariini);
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  hitungKaloriHarian(user) {
    log("Berat User Saat ini : ${user['berat']}");
    var berat =
        user['type_berat'] == 'kg' ? user['berat'] : user['berat'] * 0.45359237;

    log("var berat ${berat}");
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
    String dateFormat = AppLocalizations.of(context)!.date_format_home;

    DateTime now = DateTime.now();

    String formattedDate =
        DateFormat(dateFormat, Localizations.localeOf(context).toString())
            .format(now);

    context.watch<FFAppState>();
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(20.0, 24.0, 20.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FutureBuilder(
                            future: futureUser,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                futureUserSession = snapshot.data;
                                if (snapshot.data != null) {
                                  beratuser = snapshot.data.berat_old;
                                }
                                return Stack(
                                  alignment: AlignmentDirectional(-1.0, 1.0),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed('ProfilePage');
                                        },
                                        child: Container(
                                          width: 48.0,
                                          height: 48.0,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .secondaryBackground,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: snapshot.data.foto != ''
                                                  ? Image.memory(
                                                          const Base64Decoder()
                                                              .convert(snapshot
                                                                      .data
                                                                      .foto ??
                                                                  ""))
                                                      .image
                                                  : Image.network(
                                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                                                      .image,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 10.0,
                                      height: 10.0,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF7EE4F0),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ).animateOnPageLoad(animationsMap[
                                        'containerOnPageLoadAnimation1']!),
                                  ],
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FutureBuilder(
                            future: futureUser,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else {
                                return Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/images/Sun.svg',
                                          width: 16.0,
                                          height: 16.0,
                                          fit: BoxFit.cover,
                                        ).animateOnPageLoad(animationsMap[
                                            'imageOnPageLoadAnimation']!),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  6.0, 0.0, 0.0, 0.0),
                                          child: Text(
                                            formattedDate,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Rubik',
                                                  color: Color(0xFF8B80F8),
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 6.0, 0.0, 0.0),
                                      child: RichText(
                                        textScaler:
                                            MediaQuery.of(context).textScaler,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: AppLocalizations.of(
                                                      context)!
                                                  .hi
                                                  .toLowerCase()
                                                  .split(' ')
                                                  .map((word) => word.isNotEmpty
                                                      ? '${word[0].toUpperCase()}${word.substring(1)}'
                                                      : '')
                                                  .join(' '),
                                              style: TextStyle(),
                                            ),
                                            TextSpan(
                                              text:
                                                  ', ${snapshot.data?.username.toLowerCase().split(' ').map((word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '').join(' ') ?? ""}',
                                              style: TextStyle(),
                                            ),
                                          ],
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Rubik',
                                                fontSize: 24.0,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 16.0, 0.0, 0.0),
                          child: GridView(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 0.75,
                            ),
                            primary: false,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: [
                              FutureBuilder(
                                  future: futureKaloriHarian,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      var jumlahkalori = 0.0;
                                      var tanggalupdate = '';
                                      var kaloriuser = 0.0;
                                      var daily_calorie_intake = 0;
                                      var kaloriuserpersentase = 0.0;
                                      Object kaloriusertext = 0;

                                      if (snapshot.data != null &&
                                          snapshot.data.isNotEmpty) {
                                        if (snapshot.data[0]['user_id'] !=
                                            null) {
                                          jumlahkalori = (snapshot.data[0]
                                                  ['total_kalori_consumed'])
                                              .toDouble();
                                          tanggalupdate = '';
                                          kaloriuser = snapshot.data[0]
                                                  ['total_kalori_consumed']
                                              .toDouble();
                                          daily_calorie_intake =
                                              hitungKaloriHarian(
                                                  snapshot.data[0]);

                                          if (daily_calorie_intake <= 0) {
                                            // Jika daily_calorie_intake tidak valid
                                            return Center(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .calories_have_exceeded,
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            );
                                          }

                                          kaloriuserpersentase =
                                              kaloriuser / daily_calorie_intake;

                                          if (kaloriuserpersentase.isNaN ||
                                              kaloriuserpersentase.isInfinite ||
                                              kaloriuserpersentase < 0) {
                                            kaloriuserpersentase = 0.0;
                                          }
                                          kaloriusertext =
                                              daily_calorie_intake != 0
                                                  ? (kaloriuserpersentase * 100)
                                                      .toStringAsFixed(1)
                                                      .toString()
                                                  : 0;
                                        }
                                        jumlahkalori = (snapshot.data[0]
                                                ['total_kalori_consumed'])
                                            .toDouble();
                                      }

                                      //   kaloriuserpersentase =
                                      //       kaloriuser / daily_calorie_intake;
                                      //   kaloriusertext =
                                      //       daily_calorie_intake != 0
                                      //           ? (kaloriuserpersentase * 100)
                                      //               .toStringAsFixed(1)
                                      //               .toString()
                                      //           : 0;
                                      // }
                                      // jumlahkalori = (snapshot.data[0]
                                      //         ['total_kalori_consumed'])
                                      //     .toDouble();

                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            'CalorieTracker',
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey:
                                                  TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType.scale,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                duration:
                                                    Duration(milliseconds: 200),
                                              ),
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 156.0,
                                          height: 216.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF8B80F8),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .calorie,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Rubik',
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 1.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                // daily_calorie_intake > 0 &&
                                                kaloriuserpersentase <= 1.0
                                                    ? CircularPercentIndicator(
                                                        percent:
                                                            kaloriuserpersentase
                                                                .clamp(
                                                                    0.0, 1.0),
                                                        radius: 48.0,
                                                        lineWidth: 18.0,
                                                        animation: true,
                                                        animateFromLastPercent:
                                                            true,
                                                        progressColor:
                                                            Color(0xFF7EE4F0),
                                                        backgroundColor:
                                                            Color(0x32000000),
                                                        center: Text(
                                                          '$kaloriusertext%',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Rubik',
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                        ),
                                                      )
                                                    : Column(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons
                                                                .assignment_late_outlined,
                                                            size: 36,
                                                            color: Colors.red,
                                                          ),
                                                          RichText(
                                                            textAlign: TextAlign
                                                                .center,
                                                            text: TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                    text: kaloriuserpersentase > 1.0
                                                                        ? AppLocalizations.of(context)!
                                                                            .calories_have_exceeded_the_daily_target
                                                                        : AppLocalizations.of(context)!
                                                                            .daily_calorie_targets_are_invalid,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          '${jumlahkalori.toStringAsFixed(0).substring(0, jumlahkalori.toStringAsFixed(0).length > 4 ? 4 : jumlahkalori.toStringAsFixed(0).length)}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Rubik',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 24.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      2.0,
                                                                      0.0,
                                                                      0.0,
                                                                      2.0),
                                                          child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .cal,
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      AppLocalizations.of(
                                                                  context)!
                                                              .from +
                                                          ' ${daily_calorie_intake} ' +
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .cal,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Rubik',
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'containerOnPageLoadAnimation2']!);
                                    }
                                  }),
                              FutureBuilder(
                                  future: futureBeratBadan,
                                  builder: (context, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      var xarray = [1.0];
                                      var yarray = [beratuser.toDouble()];
                                      if (snap.data.length != 0) {
                                        for (var key = 1;
                                            key <= snap.data.length;
                                            key++) {
                                          var datafor = snap.data[key - 1];
                                          xarray.add((key + 1).toDouble());
                                          yarray
                                              .add(datafor['berat'].toDouble());
                                        }
                                      }
                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            'WeightTracker',
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey:
                                                  TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType.scale,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                duration:
                                                    Duration(milliseconds: 200),
                                              ),
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 156.0,
                                          height: 216.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFFAF8EFF),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .body_weight,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Rubik',
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 1.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 72.0,
                                                  child: FlutterFlowLineChart(
                                                    data: [
                                                      FFLineChartData(
                                                        xData: xarray,
                                                        yData: yarray,
                                                        settings:
                                                            LineChartBarData(
                                                          color:
                                                              Color(0xFF7165E3),
                                                          barWidth: 2.0,
                                                          isCurved: true,
                                                          dotData: FlDotData(
                                                              show: false),
                                                        ),
                                                      )
                                                    ],
                                                    chartStylingInfo:
                                                        ChartStylingInfo(
                                                      backgroundColor:
                                                          Color(0x00FFFFFF),
                                                      showBorder: false,
                                                    ),
                                                    axisBounds: AxisBounds(),
                                                    xAxisLabelInfo:
                                                        AxisLabelInfo(),
                                                    yAxisLabelInfo:
                                                        AxisLabelInfo(),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          '${futureUserSession.berat}',
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Rubik',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 24.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      2.0,
                                                                      0.0,
                                                                      0.0,
                                                                      2.0),
                                                          child: Text(
                                                            'kg',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      'target ${futureUserSession.target_berat}kg',
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Rubik',
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'containerOnPageLoadAnimation3']!);
                                    }
                                  }),
                              FutureBuilder(
                                  future: futureLatihanHarian,
                                  builder: (context, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      var total = snap.data[0]['belum_count'] +
                                          snap.data[0]['sudah_count'];
                                      print(total);
                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            'EventsPage',
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey:
                                                  TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType.scale,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                duration:
                                                    Duration(milliseconds: 200),
                                              ),
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 156.0,
                                          height: 216.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF1E87FD),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .exercise,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Rubik',
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 1.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                Image.asset(
                                                  'assets/images/report.png',
                                                  width: 84.0,
                                                  height: 84.0,
                                                  fit: BoxFit.contain,
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          total == 0
                                                              ? AppLocalizations
                                                                      .of(context)!
                                                                  .not_yet
                                                              : "${snap.data[0]['sudah_count'].toString()}",
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Rubik',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 24.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      2.0,
                                                                      0.0,
                                                                      0.0,
                                                                      2.0),
                                                          child: Text(
                                                            total == 0
                                                                ? ''
                                                                : AppLocalizations.of(
                                                                            context)!
                                                                        .from +
                                                                    ' ${total}',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      14.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      total == 0
                                                          ? AppLocalizations.of(
                                                                  context)!
                                                              .choose_exercise
                                                          : AppLocalizations.of(
                                                                  context)!
                                                              .already_settled,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Rubik',
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'containerOnPageLoadAnimation4']!);
                                    }
                                  }),
                              FutureBuilder(
                                  future: futureStepHarian,
                                  builder: (context, snap) {
                                    if (snap.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          context.pushNamed(
                                            'StepsTrackerGps',
                                            extra: <String, dynamic>{
                                              kTransitionInfoKey:
                                                  TransitionInfo(
                                                hasTransition: true,
                                                transitionType:
                                                    PageTransitionType.scale,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                duration:
                                                    Duration(milliseconds: 200),
                                              ),
                                            },
                                          );
                                        },
                                        child: Container(
                                          width: 156.0,
                                          height: 216.0,
                                          decoration: BoxDecoration(
                                            color: Color(0xFF4C5A81),
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Column(
                                              // mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  // mainAxisSize:
                                                  //     MainAxisSize.max,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .step,
                                                      style: FlutterFlowTheme
                                                              .of(context)
                                                          .bodyMedium
                                                          .override(
                                                            fontFamily: 'Rubik',
                                                            color: Colors.white,
                                                            fontSize: 12.0,
                                                            letterSpacing: 1.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                                Stack(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  children: [
                                                    CircularPercentIndicator(
                                                      percent: 1.0,
                                                      radius: 45.0,
                                                      lineWidth: 12.0,
                                                      animation: true,
                                                      animateFromLastPercent:
                                                          true,
                                                      progressColor:
                                                          Color(0xFF7165E3),
                                                      backgroundColor:
                                                          Color(0x32000000),
                                                    ),
                                                    Icon(
                                                      Icons
                                                          .directions_run_rounded,
                                                      color: Colors.white,
                                                      size: 36.0,
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "${snap.data[0]['total_steps']} ",
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Rubik',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 24.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                        ),
                                                        Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .steps
                                                              .toLowerCase()
                                                              .split(' ')
                                                              .map((word) => word
                                                                      .isNotEmpty
                                                                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                                                                  : '')
                                                              .join(' '),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Rubik',
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    MediaQuery(
                                                      data: MediaQuery.of(
                                                              context)
                                                          .copyWith(
                                                              textScaleFactor:
                                                                  1.0),
                                                      child: Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .step_target,
                                                        overflow:
                                                            TextOverflow.clip,
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Rubik',
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).animateOnPageLoad(animationsMap[
                                          'containerOnPageLoadAnimation5']!);
                                    }
                                  })
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(24.0),
                  //   child: Container(
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       color: Color(0xFFF5F6FA),
                  //       borderRadius: BorderRadius.circular(24.0),
                  //     ),
                  //     child: Padding(
                  //       padding: EdgeInsets.all(24.0),
                  //       child: Column(
                  //         mainAxisSize: MainAxisSize.max,
                  //         children: [
                  //           Row(
                  //             mainAxisSize: MainAxisSize.max,
                  //             children: [
                  //               Stack(
                  //                 alignment: AlignmentDirectional(0.0, 0.0),
                  //                 children: [
                  //                   CircularPercentIndicator(
                  //                     percent: 0.85,
                  //                     radius: 30.0,
                  //                     lineWidth: 4.0,
                  //                     animation: true,
                  //                     animateFromLastPercent: true,
                  //                     progressColor: Color(0xFF7165E3),
                  //                     backgroundColor: Color(0xFFE9E9E9),
                  //                   ),
                  //                   SvgPicture.asset(
                  //                     'assets/images/spoon.svg',
                  //                     width: 24.0,
                  //                     height: 24.0,
                  //                     fit: BoxFit.contain,
                  //                   ),
                  //                 ],
                  //               ),
                  //               Expanded(
                  //                 child: Padding(
                  //                   padding: EdgeInsetsDirectional.fromSTEB(
                  //                       12.0, 0.0, 0.0, 0.0),
                  //                   child: Column(
                  //                     mainAxisSize: MainAxisSize.max,
                  //                     crossAxisAlignment:
                  //                         CrossAxisAlignment.start,
                  //                     children: [
                  //                       RichText(
                  //                         textScaler:
                  //                             MediaQuery.of(context).textScaler,
                  //                         text: TextSpan(
                  //                           children: [
                  //                             TextSpan(
                  //                               text: '2158',
                  //                               style: TextStyle(),
                  //                             ),
                  //                             TextSpan(
                  //                               text: ' of ',
                  //                               style: TextStyle(),
                  //                             ),
                  //                             TextSpan(
                  //                               text: '2850',
                  //                               style: TextStyle(),
                  //                             ),
                  //                             TextSpan(
                  //                               text: ' Cal',
                  //                               style: TextStyle(),
                  //                             )
                  //                           ],
                  //                           style: FlutterFlowTheme.of(context)
                  //                               .bodyMedium
                  //                               .override(
                  //                                 fontFamily: 'Rubik',
                  //                                 fontSize: 16.0,
                  //                               ),
                  //                         ),
                  //                       ),
                  //                       Padding(
                  //                         padding:
                  //                             EdgeInsetsDirectional.fromSTEB(
                  //                                 0.0, 6.0, 0.0, 0.0),
                  //                         child: Text(
                  //                           'Add more calories to your diet',
                  //                           style: FlutterFlowTheme.of(context)
                  //                               .bodyMedium
                  //                               .override(
                  //                                 fontFamily: 'Rubik',
                  //                                 color: Color(0xFF828282),
                  //                                 fontWeight: FontWeight.normal,
                  //                               ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //               ),
                  //               FlutterFlowIconButton(
                  //                 borderColor: Colors.transparent,
                  //                 borderRadius: 24.0,
                  //                 borderWidth: 1.0,
                  //                 buttonSize: 36.0,
                  //                 fillColor: Color(0xFFE4DFFF),
                  //                 icon: Icon(
                  //                   Icons.add_rounded,
                  //                   color: Color(0xFF7165E3),
                  //                   size: 16.0,
                  //                 ),
                  //                 onPressed: () async {
                  //                   context.pushNamed('FoodJournal');
                  //                 },
                  //               ),
                  //             ],
                  //           ),
                  //           Divider(
                  //             height: 48.0,
                  //             thickness: 1.0,
                  //             color: Color(0xFFE9E9E9),
                  //           ),
                  //           Column(
                  //             mainAxisSize: MainAxisSize.max,
                  //             children: [
                  //               Row(
                  //                 mainAxisSize: MainAxisSize.min,
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Expanded(
                  //                     child: Padding(
                  //                       padding: EdgeInsetsDirectional.fromSTEB(
                  //                           0.0, 0.0, 12.0, 0.0),
                  //                       child: Column(
                  //                         mainAxisSize: MainAxisSize.min,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           Text(
                  //                             'Proteins: 56%',
                  //                             style:
                  //                                 FlutterFlowTheme.of(context)
                  //                                     .bodyMedium
                  //                                     .override(
                  //                                       fontFamily: 'Rubik',
                  //                                       fontSize: 12.0,
                  //                                       fontWeight:
                  //                                           FontWeight.normal,
                  //                                     ),
                  //                           ),
                  //                           Padding(
                  //                             padding: EdgeInsetsDirectional
                  //                                 .fromSTEB(0.0, 6.0, 0.0, 0.0),
                  //                             child: LinearPercentIndicator(
                  //                               percent: 0.4,
                  //                               width: 132.0,
                  //                               lineHeight: 6.0,
                  //                               animation: true,
                  //                               animateFromLastPercent: true,
                  //                               progressColor:
                  //                                   Color(0xFFFF8C00),
                  //                               backgroundColor:
                  //                                   Color(0xFFE9E9E9),
                  //                               barRadius:
                  //                                   Radius.circular(12.0),
                  //                               padding: EdgeInsets.zero,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   Expanded(
                  //                     child: Padding(
                  //                       padding: EdgeInsetsDirectional.fromSTEB(
                  //                           12.0, 0.0, 0.0, 0.0),
                  //                       child: Column(
                  //                         mainAxisSize: MainAxisSize.max,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.start,
                  //                         children: [
                  //                           Text(
                  //                             'Proteins: 142%',
                  //                             style:
                  //                                 FlutterFlowTheme.of(context)
                  //                                     .bodyMedium
                  //                                     .override(
                  //                                       fontFamily: 'Rubik',
                  //                                       fontSize: 12.0,
                  //                                       fontWeight:
                  //                                           FontWeight.normal,
                  //                                     ),
                  //                           ),
                  //                           Padding(
                  //                             padding: EdgeInsetsDirectional
                  //                                 .fromSTEB(0.0, 6.0, 0.0, 0.0),
                  //                             child: LinearPercentIndicator(
                  //                               percent: 1.0,
                  //                               width: 132.0,
                  //                               lineHeight: 6.0,
                  //                               animation: true,
                  //                               animateFromLastPercent: true,
                  //                               progressColor:
                  //                                   Color(0xFFDD2E44),
                  //                               backgroundColor:
                  //                                   Color(0xFFE9E9E9),
                  //                               barRadius:
                  //                                   Radius.circular(12.0),
                  //                               padding: EdgeInsets.zero,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //               Padding(
                  //                 padding: EdgeInsetsDirectional.fromSTEB(
                  //                     0.0, 24.0, 0.0, 0.0),
                  //                 child: Row(
                  //                   mainAxisSize: MainAxisSize.max,
                  //                   children: [
                  //                     Expanded(
                  //                       child: Padding(
                  //                         padding:
                  //                             EdgeInsetsDirectional.fromSTEB(
                  //                                 0.0, 0.0, 12.0, 0.0),
                  //                         child: Column(
                  //                           mainAxisSize: MainAxisSize.max,
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.start,
                  //                           children: [
                  //                             Text(
                  //                               'Proteins: 90%',
                  //                               style:
                  //                                   FlutterFlowTheme.of(context)
                  //                                       .bodyMedium
                  //                                       .override(
                  //                                         fontFamily: 'Rubik',
                  //                                         fontSize: 12.0,
                  //                                         fontWeight:
                  //                                             FontWeight.normal,
                  //                                       ),
                  //                             ),
                  //                             Padding(
                  //                               padding: EdgeInsetsDirectional
                  //                                   .fromSTEB(
                  //                                       0.0, 6.0, 0.0, 0.0),
                  //                               child: LinearPercentIndicator(
                  //                                 percent: 0.9,
                  //                                 width: 132.0,
                  //                                 lineHeight: 6.0,
                  //                                 animation: true,
                  //                                 animateFromLastPercent: true,
                  //                                 progressColor:
                  //                                     Color(0xFF7ABD4C),
                  //                                 backgroundColor:
                  //                                     Color(0xFFE9E9E9),
                  //                                 barRadius:
                  //                                     Radius.circular(12.0),
                  //                                 padding: EdgeInsets.zero,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     Expanded(
                  //                       child: Padding(
                  //                         padding:
                  //                             EdgeInsetsDirectional.fromSTEB(
                  //                                 12.0, 0.0, 0.0, 0.0),
                  //                         child: Column(
                  //                           mainAxisSize: MainAxisSize.max,
                  //                           crossAxisAlignment:
                  //                               CrossAxisAlignment.start,
                  //                           children: [
                  //                             Text(
                  //                               'Proteins: 86%',
                  //                               style:
                  //                                   FlutterFlowTheme.of(context)
                  //                                       .bodyMedium
                  //                                       .override(
                  //                                         fontFamily: 'Rubik',
                  //                                         fontSize: 12.0,
                  //                                         fontWeight:
                  //                                             FontWeight.normal,
                  //                                       ),
                  //                             ),
                  //                             Padding(
                  //                               padding: EdgeInsetsDirectional
                  //                                   .fromSTEB(
                  //                                       0.0, 6.0, 0.0, 0.0),
                  //                               child: LinearPercentIndicator(
                  //                                 percent: 0.8,
                  //                                 width: 132.0,
                  //                                 lineHeight: 6.0,
                  //                                 animation: true,
                  //                                 animateFromLastPercent: true,
                  //                                 progressColor:
                  //                                     Color(0xFFFFC850),
                  //                                 backgroundColor:
                  //                                     Color(0xFFE9E9E9),
                  //                                 barRadius:
                  //                                     Radius.circular(12.0),
                  //                                 padding: EdgeInsets.zero,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ).animateOnPageLoad(
                  //       animationsMap['containerOnPageLoadAnimation6']!),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

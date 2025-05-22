import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/pages/trackers/steps_tracker/steps_tracker_gps_widget.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'steps_tracker_model.dart';
export 'steps_tracker_model.dart';
import 'package:pedometer/pedometer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepsTrackerWidget extends StatefulWidget {
  const StepsTrackerWidget({super.key});

  @override
  State<StepsTrackerWidget> createState() => _StepsTrackerWidgetState();
}

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class _StepsTrackerWidgetState extends State<StepsTrackerWidget> {
  late StepsTrackerModel _model;

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '', _steps = 'Mulai';
  var step_temp = 40;
  bool startcount = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var typeStep = 'walk';

  String formattedDate =
      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());

  // modifikasi data manual
  // final fitnessFlowDB = FitnessFlowDB();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StepsTrackerModel());
    initPlatformState();
    fetchStepHarian();
    //Data untuk manual insert
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   addManualStep();
    // });
  }

  final fitnessFlowDB = FitnessFlowDB();

  Future? futureStepHarian;
  void fetchStepHarian() async {
    setState(() {
      futureStepHarian = fitnessFlowDB
          .fetchStepHarian(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    });
  }

  void onStepCount(StepCount event) {
    setState(() {
      if (startcount) {
        step_temp++;
        _steps = step_temp.toString();
      }
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = '';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Cek Permision';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  //function untuk add data secara manual
  // Future<void> addManualStep() async {
  //   int userId = 1; // Ganti dengan ID pengguna sesuai kebutuhan
  //   String step = step_temp.toString(); // Jumlah langkah dari step_temp
  //   double berat = 65.0; // Berat badan (contoh nilai default)
  //   String type = typeStep; // Tipe aktivitas

  //   try {
  //     final result = await fitnessFlowDB.createStep(userId, step, berat, type);
  //     if (result > 0) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Data berhasil dimasukkan! ID: $result')),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Gagal memasukkan data')),
  //       );
  //     }
  //   } catch (e) {
  //     print("Error saat memasukkan data: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Terjadi kesalahan: $e')),
  //     );
  //   }
  // }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 48.0, 24.0, 0.0),
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
                      onPressed: () {
                        context.pushNamed('listStep');
                      },
                      text: 'History',
                      options: FFButtonOptions(
                        width: 84.0,
                        height: 40.0,
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0xFFE4DFFF),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
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
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 48.0, 24.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'LANGKAH HARIAN',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Rubik',
                            color: FlutterFlowTheme.of(context).primary,
                            fontSize: 14.0,
                            letterSpacing: 1.0,
                          ),
                    ),
                    FutureBuilder(
                        future: futureStepHarian,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  48.0, 8.0, 48.0, 0.0),
                              child: Text(
                                "Anda telah mencapai ${snapshot.data[0]['total_steps']} / 10.000 langkah pada ${formattedDate}",
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Rubik',
                                      fontSize: 24.0,
                                    ),
                              ),
                            );
                          }
                        }),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 48.0, 0.0, 0.0),
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        children: [
                          CircularPercentIndicator(
                            percent: 0.8,
                            radius: 90.0,
                            lineWidth: 12.0,
                            animation: true,
                            animateFromLastPercent: true,
                            progressColor: _status == 'walking'
                                ? Color.fromRGBO(23, 204, 192, 1)
                                : FlutterFlowTheme.of(context).primary,
                            backgroundColor: Color(0x00F1F4F8),
                            startAngle: 216.0,
                          ),
                          CircularPercentIndicator(
                            percent: 0.7,
                            radius: 72.0,
                            lineWidth: 2.0,
                            animation: true,
                            animateFromLastPercent: true,
                            progressColor: _status == 'walking'
                                ? Color.fromRGBO(23, 204, 192, 1)
                                : Color(0xFFE9E9E9),
                            backgroundColor: Colors.transparent,
                            startAngle: 232.0,
                          ),
                          GestureDetector(
                            onTap: () async {
                              var user = await fitnessFlowDB.fetchUserByIdV2(1);
                              setState(() {
                                if (startcount) {
                                  startcount = false;
                                  if (_steps != 0 &&
                                      _steps != '0' &&
                                      _steps != 'Cek Permision' &&
                                      _steps != '') {
                                    fitnessFlowDB.createStep(
                                        1, _steps, user[0]['berat'], typeStep);
                                    final snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: AppLocalizations.of(context)!
                                                .success +
                                            '!',
                                        message: AppLocalizations.of(context)!
                                            .daily_steps_added_successfully,

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.success,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  }
                                  _steps = 'Mulai';
                                } else {
                                  startcount = true;
                                  _steps = '0';
                                }
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image.asset(
                                  _status == 'walking'
                                      ? (typeStep == 'walk'
                                          ? 'assets/images/walking-2.png'
                                          : (typeStep == 'run'
                                              ? 'assets/images/run-2.png'
                                              : 'assets/images/hiking-2.png'))
                                      : 'assets/images/standing-up-man-.png',
                                  width: 36.0,
                                  height: 36.0,
                                  fit: BoxFit.contain,
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 0.0),
                                  child: Text(
                                    _steps,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Rubik',
                                          fontSize: 20.0,
                                        ),
                                  ),
                                ),
                                Text(
                                  startcount ? 'selesai' : 'langkah',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Rubik',
                                        color: Color(0xFF828282),
                                        fontSize: 12.0,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 36.0, 24.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          typeStep = 'walk';
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            children: [
                              CircularPercentIndicator(
                                percent: 0.5,
                                radius: 30.0,
                                lineWidth: 8.0,
                                animation: true,
                                animateFromLastPercent: true,
                                progressColor: typeStep != 'walk'
                                    ? Color(0x00F1F4F8)
                                    : Color(0xFF7165E3),
                                backgroundColor: typeStep != 'walk'
                                    ? Color(0x00F1F4F8)
                                    : Color(0xFF7165E3),
                              ),
                              Image.asset(
                                typeStep != 'walk'
                                    ? 'assets/images/walking-2.png'
                                    : 'assets/images/walking.png',
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          typeStep = 'hiking';
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                24.0, 0.0, 24.0, 0.0),
                            child: Stack(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              children: [
                                CircularPercentIndicator(
                                  percent: 0.5,
                                  radius: 30.0,
                                  lineWidth: 8.0,
                                  animation: true,
                                  animateFromLastPercent: true,
                                  progressColor: typeStep != 'hiking'
                                      ? Color(0x00F1F4F8)
                                      : Color(0xFF7165E3),
                                  backgroundColor: typeStep != 'hiking'
                                      ? Color(0x00F1F4F8)
                                      : Color(0xFF7165E3),
                                ),
                                Image.asset(
                                  typeStep != 'hiking'
                                      ? 'assets/images/hiking-2.png'
                                      : 'assets/images/hiking.png',
                                  width: 24.0,
                                  height: 24.0,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          typeStep = 'run';
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            children: [
                              CircularPercentIndicator(
                                percent: 0.5,
                                radius: 30.0,
                                lineWidth: 8.0,
                                animation: true,
                                animateFromLastPercent: true,
                                progressColor: typeStep != 'run'
                                    ? Color(0x00F1F4F8)
                                    : Color(0xFF7165E3),
                                backgroundColor: typeStep != 'run'
                                    ? Color(0x00F1F4F8)
                                    : Color(0xFF7165E3),
                              ),
                              Image.asset(
                                typeStep != 'run'
                                    ? 'assets/images/run-2.png'
                                    : 'assets/images/run.png',
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StepsTrackerGpsWidget(),
                      ),
                    );
                  },
                  child: Text(
                    "Gunakan Maps untuk Tracking Langkah Anda",
                    style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: 'Rubik',
                        color: FlutterFlowTheme.of(context).primary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:fitness_flow/services/fitness_flow_db.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'enable_fingerprint_model.dart';
export 'enable_fingerprint_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnableFingerprintWidget extends StatefulWidget {
  const EnableFingerprintWidget({super.key});

  @override
  State<EnableFingerprintWidget> createState() =>
      _EnableFingerprintWidgetState();
}

class _EnableFingerprintWidgetState extends State<EnableFingerprintWidget>
    with TickerProviderStateMixin {
  late EnableFingerprintModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = {
    'imageOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      effects: [
        MoveEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: Offset(40.0, 0.0),
          end: Offset(0.0, 0.0),
        ),
        FadeEffect(
          curve: Curves.easeInOut,
          delay: 0.ms,
          duration: 600.ms,
          begin: 0.0,
          end: 1.0,
        ),
      ],
    ),
  };

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EnableFingerprintModel());
    fetchUser();
  }

  var checkbox1 = false;
  var checkbox2 = false;
  var checkbox3 = false;
  var checkbox4 = false;

  String? errorMessage;

  dynamic futureUser = null;
  final fitnessFlowDB = FitnessFlowDB();
  var kgCheckbox = true;
  var lbsCheckbox = false;

  void fetchUser() {
    setState(() {
      futureUser = fitnessFlowDB.fetchUserById(1);
      fitnessFlowDB.fetchUserAll();
    });
  }

  int createOrUpdateUser(aktivitas) {
    if (aktivitas != null) {
      fitnessFlowDB.updateUser(1, 'aktivitas', aktivitas.toString());
    }
    fetchUser();
    return 0;
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 30.0,
                      borderWidth: 1.0,
                      buttonSize: 48.0,
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        context.pop();
                      },
                    ),
                    LinearPercentIndicator(
                      percent: 1,
                      width: 120.0,
                      lineHeight: 8.0,
                      animation: true,
                      animateFromLastPercent: true,
                      progressColor: Color(0xFF7165E3),
                      backgroundColor: Color(0xFFE9E9E9),
                      barRadius: Radius.circular(12.0),
                      padding: EdgeInsets.zero,
                    ),
                    FFButtonWidget(
                      onPressed: () {
                        print('Button pressed ...');
                      },
                      text: '',
                      options: FFButtonOptions(
                        height: 40.0,
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        iconPadding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                        color: Color(0x007165E3),
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Rubik',
                                  color: Color(0xFF7165E3),
                                  fontSize: 14.0,
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
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 48.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    RichText(
                      textScaler: MediaQuery.of(context).textScaler,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.step,
                            style: GoogleFonts.getFont(
                              'Rubik',
                              color: FlutterFlowTheme.of(context).primary,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: '6',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            text: '/',
                            style: TextStyle(),
                          ),
                          TextSpan(
                            text: '6',
                            style: TextStyle(),
                          )
                        ],
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Rubik',
                              color: FlutterFlowTheme.of(context).primary,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(96.0, 12.0, 96.0, 0.0),
                      child: Text(
                        AppLocalizations.of(context)!.daily_physical_activities,
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Rubik',
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(84.0, 12.0, 84.0, 0.0),
                      child: Text(
                        AppLocalizations.of(context)!
                            .how_often_do_activity_per_day,
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Rubik',
                              fontSize: 14.0,
                              letterSpacing: 0.2,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text(
                            AppLocalizations.of(context)!
                                .first_option_daily_activity,
                          ),
                          value: checkbox1,
                          onChanged: (bool? value) {
                            setState(() {
                              checkbox1 = value!;
                              if (value) {
                                checkbox2 = checkbox3 = checkbox4 = false;
                                errorMessage = null; // Reset error
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(AppLocalizations.of(context)!
                              .second_option_daily_activity),
                          value: checkbox2,
                          onChanged: (bool? value) {
                            setState(() {
                              checkbox2 = value!;
                              if (value) {
                                checkbox1 = checkbox3 = checkbox4 = false;
                                errorMessage = null; // Reset error
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(
                            AppLocalizations.of(context)!
                                .third_option_daily_activity,
                          ),
                          value: checkbox3,
                          onChanged: (bool? value) {
                            setState(() {
                              checkbox3 = value!;
                              if (value) {
                                checkbox2 = checkbox1 = checkbox4 = false;
                                errorMessage = null; // Reset error
                              }
                            });
                          },
                        ),
                        CheckboxListTile(
                          title: Text(AppLocalizations.of(context)!
                              .fourth_option_daily_activity),
                          value: checkbox4,
                          onChanged: (bool? value) {
                            setState(() {
                              checkbox4 = value!;
                              if (value) {
                                checkbox2 = checkbox3 = checkbox1 = false;
                                errorMessage = null; // Reset error
                              }
                            });
                          },
                        ),
                        if (errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              errorMessage!,
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    )),
              ),
              FutureBuilder(
                  future: futureUser,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var snapshotdata;
                      if (snapshot.data != null) {
                        snapshotdata = snapshot.data;
                      }

                      return Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            72.0, 0.0, 72.0, 60.0),
                        child: FFButtonWidget(
                          onPressed: () async {
                            if (!checkbox1 &&
                                !checkbox2 &&
                                !checkbox3 &&
                                !checkbox4) {
                              setState(() {
                                errorMessage = AppLocalizations.of(context)!
                                    .error_message_for_daily_activity_option;
                              });
                              return;
                            }

                            double aktivitas;
                            if (checkbox1) {
                              aktivitas = 1.3;
                            } else if (checkbox2) {
                              aktivitas = snapshotdata.jeniskelamin == "L"
                                  ? 1.65
                                  : 1.55;
                            } else if (checkbox3) {
                              aktivitas =
                                  snapshotdata.jeniskelamin == "L" ? 1.76 : 1.7;
                            } else {
                              aktivitas =
                                  snapshotdata.jeniskelamin == "L" ? 2.1 : 2;
                            }

                            createOrUpdateUser(aktivitas);
                            context.pushNamed(
                              'GetStarted',
                              extra: <String, dynamic>{
                                kTransitionInfoKey: TransitionInfo(
                                  hasTransition: true,
                                  transitionType: PageTransitionType.fade,
                                ),
                              },
                            );
                          },
                          text: AppLocalizations.of(context)!.next,
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 54.0,
                            padding: EdgeInsets.all(0.0),
                            iconPadding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 0.0, 0.0),
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
                                  fontFamily: 'Rubik',
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

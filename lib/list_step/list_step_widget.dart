import 'dart:developer';

import 'package:fitness_flow/services/fitness_flow_db.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'list_step_model.dart';
export 'list_step_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListStepWidget extends StatefulWidget {
  const ListStepWidget({super.key});

  @override
  State<ListStepWidget> createState() => _ListStepWidgetState();
}

class _ListStepWidgetState extends State<ListStepWidget> {
  late ListStepModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ListStepModel());

    // On page load action.
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   context.pushNamed(
    //     'FoodNutrients',
    //     queryParameters: {
    //       'id': serializeParam(
    //         0,
    //         ParamType.int,
    //       ),
    //     }.withoutNulls,
    //   );
    // });
    fetchStep();
  }

  Future? futureStep;
  // List<dynamic> futureMeal = [];
  final fitnessFlowDB = FitnessFlowDB();
  void fetchStep() async {
    setState(() {
      futureStep = fitnessFlowDB.fetchStep();
    });
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
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed('StepsTrackerGps');
            },
          ),
          title: Text(
            AppLocalizations.of(context)!.step_history,
            style: FlutterFlowTheme.of(context).titleLarge,
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: FutureBuilder(
                          future: futureStep,
                          builder: (context, snapshot) {
                            debugPrint(" data future step : ${snapshot.data}");
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              if (snapshot.data == null ||
                                  snapshot.data.length == 0 ||
                                  snapshot.data[0]['total_distance'] == 0 ||
                                  snapshot.data[0]['step'] == 0) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.no_data,
                                    )
                                  ],
                                );
                              } else {
                                return ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var itemData = snapshot.data[index];
                                    log("isi data : ${itemData}");
                                    var kalori;
                                    if (itemData['type'] == 'walk') {
                                      kalori = 0.57 *
                                          itemData['berat'] *
                                          (itemData['step'] / 1312);
                                    } else if (itemData['type'] == 'run') {
                                      kalori = 1.03 *
                                          itemData['berat'] *
                                          (itemData['step'] / 1312);
                                    } else {
                                      kalori = 0.8 *
                                          itemData['berat'] *
                                          (itemData['step'] / 1312);
                                    }

                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          16.0, 0.0, 16.0, 8.0),
                                      child: Container(
                                        width: 100.0,
                                        // height: 70.0,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          border: Border.all(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 1.0,
                                          ),
                                        ),
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {},
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          5.0, 0.0, 0.0, 0.0),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${itemData['step']} Langkah | ${itemData['type']}",
                                                        style: FlutterFlowTheme
                                                                .of(context)
                                                            .bodyMedium
                                                            .override(
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                            ),
                                                      ),
                                                      RichText(
                                                        textScaler:
                                                            MediaQuery.of(
                                                                    context)
                                                                .textScaler,
                                                        text: TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: itemData[
                                                                  'tanggal'],
                                                              style: FlutterFlowTheme
                                                                      .of(context)
                                                                  .bodyMedium
                                                                  .override(
                                                                    fontFamily:
                                                                        'Rubik',
                                                                    color: FlutterFlowTheme.of(
                                                                            context)
                                                                        .primary,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                                  '| ${kalori.toStringAsFixed(2)} cal',
                                                              style:
                                                                  TextStyle(),
                                                            )
                                                          ],
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium,
                                                        ),
                                                      ),
                                                      if (itemData.containsKey(
                                                          'total_distance'))
                                                        RichText(
                                                          textScaler:
                                                              MediaQuery.of(
                                                                      context)
                                                                  .textScaler,
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    "Jarak: ${_formatDistance(itemData['total_distance']).toString()}",
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                              ),
                                                              // TextSpan(
                                                              //   text:
                                                              //       "Jarak: ${itemData['total_distance'].toStringAsFixed(2)} meter",
                                                              //   style: FlutterFlowTheme.of(
                                                              //           context)
                                                              //       .bodyMedium
                                                              //       .override(
                                                              //         fontFamily:
                                                              //             'Poppins',
                                                              //         fontSize:
                                                              //             16.0,
                                                              //         fontWeight:
                                                              //             FontWeight
                                                              //                 .normal,
                                                              //       ),
                                                              // ),
                                                              TextSpan(
                                                                text:
                                                                    "\nMulai: ${DateFormat('HH:mm:ss').format(DateTime.parse(itemData['mulai']))}",
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    " | Selesai: ${DateFormat('HH:mm:ss').format(DateTime.parse(itemData['selesai']))}",
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                              ),
                                                              TextSpan(
                                                                text:
                                                                    "\nTotal Waktu: ${_formatDuration(DateTime.parse(itemData['selesai']).difference(DateTime.parse(itemData['mulai'])))}",
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          16.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            }
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatDuration(Duration duration) {
  if (duration.inSeconds < 60) {
    return "${duration.inSeconds} detik";
  } else if (duration.inMinutes < 60) {
    return "${duration.inMinutes} menit ${duration.inSeconds.remainder(60)} detik";
  } else {
    return "${duration.inHours} jam ${duration.inMinutes.remainder(60)} menit ${duration.inSeconds.remainder(60)} detik";
  }
}

String _formatDistance(double distance) {
  if (distance >= 1000) {
    // Jika jarak >= 1000 meter, ubah ke kilometer
    return "${(distance / 1000).toStringAsFixed(2)} km";
  } else {
    // Jika jarak < 1000 meter, tetap dalam meter
    return "${distance.toStringAsFixed(2)} meter";
  }
}

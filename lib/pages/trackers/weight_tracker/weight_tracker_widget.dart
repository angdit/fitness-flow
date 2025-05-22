import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/pages/trackers/weight_tracker/weight_tracker_detail.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'weight_tracker_model.dart';
export 'weight_tracker_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeightTrackerWidget extends StatefulWidget {
  const WeightTrackerWidget({super.key});

  @override
  State<WeightTrackerWidget> createState() => _WeightTrackerWidgetState();
}

class _WeightTrackerWidgetState extends State<WeightTrackerWidget>
    with TickerProviderStateMixin {
  late WeightTrackerModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

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
          begin: Offset(0.0, 5.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation2': AnimationInfo(
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
          begin: Offset(0.0, 10.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
    'containerOnPageLoadAnimation3': AnimationInfo(
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
          begin: Offset(0.0, 10.0),
          end: Offset(0.0, 0.0),
        ),
      ],
    ),
  };

  Future? futureUser;
  var futureUserSession;
  Future? futureBeratBadan;
  final fitnessFlowDB = FitnessFlowDB();
  var hariini = DateFormat('yyyy-MM-dd').format(DateTime.now());

  var beratuser = 0.0;

  void fetchUser() async {
    setState(() {
      futureUser = fitnessFlowDB.fetchUserById(1);
    });
  }

  void fetchBeratBadan() async {
    setState(() {
      futureBeratBadan = fitnessFlowDB.fetchBeratBadan();
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WeightTrackerModel());
    fetchUser();
    fetchBeratBadan();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  deleteBeratBadan(id) async {
    var user = await fitnessFlowDB.fetchUserByIdV2(1);
    setState(() {
      fitnessFlowDB.deleteBeratBadan(id);
      fitnessFlowDB.updateUser(1, 'berat', user[0]['berat_old'].toString());
      fetchBeratBadan();
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primary,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.pushNamed('Subscription');
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8.0,
          child: Icon(
            Icons.add_outlined,
            color: Colors.white,
            size: 24.0,
          ),
        ),
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
                    buttonSize: 48.0,
                    icon: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () async {
                      context.pushNamed('HomePage');
                    },
                  ),
                  Text(
                    AppLocalizations.of(context)!
                        .body_weight
                        .toLowerCase()
                        .split(' ')
                        .map((word) => word.isNotEmpty
                            ? '${word[0].toUpperCase()}${word.substring(1)}'
                            : '')
                        .join(' '),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Rubik',
                          color: Colors.white,
                          fontSize: 16.0,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 48.0,
                    icon: Icon(
                      Icons.more_vert_outlined,
                      color: Colors.white,
                      size: 24.0,
                    ),
                    onPressed: () {
                      print('IconButton pressed ...');
                    },
                  ),
                ],
              ),
            ),
            FutureBuilder(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data != null) {
                      beratuser = snapshot.data.berat_old;
                    }
                    var persentase = snapshot.data.berat /
                        int.parse(snapshot.data.target_berat);
                    return Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(48.0, 48.0, 48.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.now,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Rubik',
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      letterSpacing: 0.6,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${snapshot.data.berat}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Rubik',
                                          color: Colors.white,
                                          fontSize: 36.0,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        2.0, 0.0, 0.0, 6.0),
                                    child: Text(
                                      'kg',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Rubik',
                                            color: Colors.white,
                                            letterSpacing: 0.2,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Stack(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            children: [
                              CircularPercentIndicator(
                                percent: persentase.clamp(0.0, 1.0),
                                radius: 30.0,
                                lineWidth: 4.0,
                                animation: true,
                                animateFromLastPercent: true,
                                progressColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                backgroundColor: Color(0x4D000000),
                              ),
                              SvgPicture.asset(
                                'assets/images/weight-scale.svg',
                                width: 24.0,
                                height: 24.0,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TARGET',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Rubik',
                                      color: Colors.white,
                                      fontSize: 12.0,
                                      letterSpacing: 0.6,
                                      fontWeight: FontWeight.normal,
                                    ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${snapshot.data.target_berat}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Rubik',
                                          color: Colors.white,
                                          fontSize: 36.0,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        2.0, 0.0, 0.0, 6.0),
                                    child: Text(
                                      'kg',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Rubik',
                                            color: Colors.white,
                                            letterSpacing: 0.2,
                                            fontWeight: FontWeight.normal,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                }),
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 48.0, 0.0, 0.0),
                child: Container(
                  width: double.infinity,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(0.0),
                      topLeft: Radius.circular(36.0),
                      topRight: Radius.circular(36.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: FutureBuilder(
                        future: futureBeratBadan,
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            var xArray = <double>[];
                            var yWeight = <double>[];
                            var yWaist = <double>[];
                            var yArm = <double>[];
                            var yThigh = <double>[];

                            if (snap.data != null && snap.data.length > 0) {
                              for (var i = 0; i < snap.data.length; i++) {
                                var data = snap.data[i];
                                xArray.add((i + 1).toDouble());
                                yWeight.add(data['berat']?.toDouble() ?? 0.0);
                                yWaist.add(data['pinggang']?.toDouble() ?? 0.0);
                                yArm.add(data['tangan']?.toDouble() ?? 0.0);
                                yThigh.add(data['paha']?.toDouble() ?? 0.0);
                              }
                            } else {
                              xArray = [1.0];
                              yWeight = [0.0];
                              yWaist = [0.0];
                              yArm = [0.0];
                              yThigh = [0.0];
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 24.0, 24.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .my_progress,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Rubik',
                                              fontSize: 16.0,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 24.0, 0.0, 0.0),
                                          child: Container(
                                            width: 350.0,
                                            height: 150.0,
                                            child: LineChart(
                                              LineChartData(
                                                titlesData: FlTitlesData(
                                                  leftTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      reservedSize: 22,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        int intValue =
                                                            value.toInt();
                                                        String displayValue =
                                                            '';

                                                        // Menampilkan kelipatan 20 dari 60 hingga 0
                                                        if (intValue >= 0 &&
                                                            intValue <= 60 &&
                                                            intValue % 20 ==
                                                                0) {
                                                          displayValue = intValue
                                                              .toString(); // Menampilkan nilai
                                                        }

                                                        return Text(
                                                          displayValue,
                                                          style: const TextStyle(
                                                              fontSize:
                                                                  12), // Gaya untuk angka
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  rightTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                        showTitles: false),
                                                  ),
                                                  topTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                        showTitles: false),
                                                  ),
                                                  bottomTitles: AxisTitles(
                                                    sideTitles: SideTitles(
                                                      showTitles: true,
                                                      reservedSize: 22,
                                                      getTitlesWidget:
                                                          (value, meta) {
                                                        // Periksa jika value adalah bilangan bulat
                                                        if (value % 1 == 0) {
                                                          int index =
                                                              value.toInt() - 1;
                                                          if (index >= 0 &&
                                                              index <
                                                                  snap.data
                                                                      .length) {
                                                            var itemData = snap
                                                                .data[index];

                                                            try {
                                                              var formattedDate =
                                                                  DateFormat(
                                                                          'dd MMM')
                                                                      .format(
                                                                DateTime.parse(
                                                                    itemData[
                                                                        'tanggal']),
                                                              );
                                                              return Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            10),
                                                                child: Text(
                                                                  formattedDate,
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        12.0,
                                                                    fontFamily:
                                                                        'Rubik',
                                                                  ),
                                                                ),
                                                              );
                                                            } catch (e) {
                                                              // Jika terjadi kesalahan saat parsing tanggal
                                                              print(
                                                                  'Error parsing date: ${itemData['tanggal']}');
                                                              return const Text(
                                                                  'Invalid Date');
                                                            }
                                                          }
                                                        }
                                                        // Jika bukan bilangan bulat atau nilai tidak valid, tampilkan kosong
                                                        return const SizedBox
                                                            .shrink();
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                gridData: FlGridData(
                                                    show:
                                                        true), // Tampilkan garis grid
                                                borderData: FlBorderData(
                                                  show:
                                                      false, // Hilangkan border chart
                                                ),
                                                lineBarsData: [
                                                  LineChartBarData(
                                                    spots: List.generate(
                                                      yWeight.length,
                                                      (index) => FlSpot(
                                                          xArray[index]
                                                              .toDouble(),
                                                          yWeight[index]),
                                                    ),
                                                    isCurved: false,
                                                    color: Color(0xFF7165E3),
                                                    dotData:
                                                        FlDotData(show: true),
                                                    belowBarData: BarAreaData(
                                                        show: false),
                                                  ),
                                                  LineChartBarData(
                                                    spots: List.generate(
                                                      yWaist.length,
                                                      (index) => FlSpot(
                                                          xArray[index]
                                                              .toDouble(),
                                                          yWaist[index]),
                                                    ),
                                                    isCurved: false,
                                                    color: Colors.green,
                                                    dotData:
                                                        FlDotData(show: true),
                                                    belowBarData: BarAreaData(
                                                        show: false),
                                                  ),
                                                  LineChartBarData(
                                                    spots: List.generate(
                                                      yArm.length,
                                                      (index) => FlSpot(
                                                          xArray[index]
                                                              .toDouble(),
                                                          yArm[index]),
                                                    ),
                                                    isCurved: false,
                                                    color: Colors.orange,
                                                    dotData:
                                                        FlDotData(show: true),
                                                    belowBarData: BarAreaData(
                                                        show: false),
                                                  ),
                                                  LineChartBarData(
                                                    spots: List.generate(
                                                      yThigh.length,
                                                      (index) => FlSpot(
                                                          xArray[index]
                                                              .toDouble(),
                                                          yThigh[index]),
                                                    ),
                                                    isCurved: false,
                                                    color: Colors.red,
                                                    dotData:
                                                        FlDotData(show: true),
                                                    belowBarData: BarAreaData(
                                                        show: false),
                                                  ),
                                                ],
                                                // alignment: LineChartAlignment
                                                //     .spaceAround,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20, left: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      LegendItem(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        text: AppLocalizations.of(context)!
                                            .weight
                                            .toLowerCase()
                                            .split(' ')
                                            .map((word) => word.isNotEmpty
                                                ? '${word[0].toUpperCase()}${word.substring(1)}'
                                                : '')
                                            .join(' '),
                                      ),
                                      LegendItem(
                                          color: Colors.green,
                                          text: AppLocalizations.of(context)!
                                              .waist_weight_tracker
                                              .toLowerCase()
                                              .split(' ')
                                              .map((word) => word.isNotEmpty
                                                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                                                  : '')
                                              .join(' ')),
                                      LegendItem(
                                          color: Colors.orange,
                                          text: AppLocalizations.of(context)!
                                              .hand_weight_tracker
                                              .toLowerCase()
                                              .split(' ')
                                              .map((word) => word.isNotEmpty
                                                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                                                  : '')
                                              .join(' ')),
                                      LegendItem(
                                          color: Colors.red,
                                          text: AppLocalizations.of(context)!
                                              .thigh_weight_tracker
                                              .toLowerCase()
                                              .split(' ')
                                              .map((word) => word.isNotEmpty
                                                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                                                  : '')
                                              .join(' ')),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 36.0, 24.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.timeline,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Rubik',
                                              fontSize: 16.0,
                                            ),
                                      ),
                                      Icon(
                                        Icons.keyboard_control_outlined,
                                        color: Color(0xFFE9E9E9),
                                        size: 24.0,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 12.0, 0.0, 48.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            24.0, 0.0, 24.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [],
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  FutureBuilder(
                                                      future: futureBeratBadan,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        } else {
                                                          if (snapshot.data
                                                                  .length ==
                                                              0) {
                                                            return Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(AppLocalizations.of(
                                                                        context)!
                                                                    .no_data)
                                                              ],
                                                            );
                                                          } else {
                                                            return ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  snapshot.data
                                                                      .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                var itemData =
                                                                    snapshot.data[
                                                                        index];
                                                                return Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          16.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      Container(
                                                                    width:
                                                                        286.6,
                                                                    height:
                                                                        100.0,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .secondaryBackground,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              24.0),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          24.0,
                                                                          12.0,
                                                                          24.0,
                                                                          12.0),
                                                                      child:
                                                                          Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        // mainAxisAlignment:
                                                                        //     MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                                                children: [
                                                                                  Text(
                                                                                    "${itemData['berat']}",
                                                                                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                          fontFamily: 'Rubik',
                                                                                          color: FlutterFlowTheme.of(context).secondary,
                                                                                          fontSize: 24.0,
                                                                                        ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 0.0, 2.0),
                                                                                    child: Text(
                                                                                      'kg',
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Rubik',
                                                                                            color: FlutterFlowTheme.of(context).secondary,
                                                                                            fontSize: 12.0,
                                                                                            letterSpacing: 0.2,
                                                                                            fontWeight: FontWeight.normal,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Text(
                                                                                DateFormat(
                                                                                  'dd MMMM yyyy',
                                                                                  Localizations.localeOf(context).toString(), // Ambil locale dari aplikasi
                                                                                ).format(
                                                                                  DateTime.parse(itemData['tanggal']),
                                                                                ),
                                                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                      fontFamily: 'Rubik',
                                                                                      color: Color(0xFF7165E3),
                                                                                      fontSize: 12.0,
                                                                                      fontWeight: FontWeight.normal,
                                                                                    ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Spacer(),
                                                                          FlutterFlowIconButton(
                                                                            borderColor:
                                                                                Colors.transparent,
                                                                            borderRadius:
                                                                                12.0,
                                                                            borderWidth:
                                                                                1.0,
                                                                            buttonSize:
                                                                                36.0,
                                                                            fillColor:
                                                                                Colors.transparent,
                                                                            icon:
                                                                                FaIcon(
                                                                              FontAwesomeIcons.eye,
                                                                              color: Color(0xFF7165E3),
                                                                              size: 16.0,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.push(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => DetailBeratBadanPage(itemData: itemData),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ),
                                                                          FlutterFlowIconButton(
                                                                            borderColor:
                                                                                Colors.transparent,
                                                                            borderRadius:
                                                                                12.0,
                                                                            borderWidth:
                                                                                1.0,
                                                                            buttonSize:
                                                                                36.0,
                                                                            fillColor:
                                                                                Colors.transparent,
                                                                            icon:
                                                                                FaIcon(
                                                                              FontAwesomeIcons.trashAlt,
                                                                              color: Colors.red,
                                                                              size: 16.0,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              deleteBeratBadan(itemData['id']);
                                                                              final snackBar = SnackBar(
                                                                                /// need to set following properties for best effect of awesome_snackbar_content
                                                                                elevation: 0,
                                                                                behavior: SnackBarBehavior.floating,
                                                                                backgroundColor: Colors.transparent,
                                                                                content: AwesomeSnackbarContent(
                                                                                  title: AppLocalizations.of(context)!.success + '!',
                                                                                  message: AppLocalizations.of(context)!.weight_added_successfully,

                                                                                  /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                                                  contentType: ContentType.success,
                                                                                ),
                                                                              );

                                                                              ScaffoldMessenger.of(context)
                                                                                ..hideCurrentSnackBar()
                                                                                ..showSnackBar(snackBar);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ).animateOnPageLoad(
                                                                          animationsMap[
                                                                              'containerOnPageLoadAnimation3']!),
                                                                );
                                                              },
                                                            );
                                                          }
                                                        }
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const LegendItem({required this.color, required this.text, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          color: color,
        ),
        SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}

import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_widgets.dart';
import 'package:fitness_flow/model/step_users.dart';
import 'package:fitness_flow/model/steps_user_detail.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
export 'steps_tracker_model.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StepsTrackerGpsWidget extends StatefulWidget {
  const StepsTrackerGpsWidget({super.key});

  @override
  State<StepsTrackerGpsWidget> createState() => _StepsTrackerGpsWidgetState();
}

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class _StepsTrackerGpsWidgetState extends State<StepsTrackerGpsWidget> {
  Position? _currentPosition;
  List<Map<String, dynamic>> activityLog = [];
  List<MapLatLng> polylinePoints = [];
  MapLatLng? _currentMarkerPosition;
  int totalSteps = 0;
  bool isTracking = false; // Untuk menentukan apakah tracking aktif
  double totalCalories = 0.0;
  double totalDistance = 0.0;
  double userWeight = 0.0;
  double stepLength = 0.0;
  String _status = '', _steps = 'Mulai';
  bool usingMap = true; // Set this based on how you are counting steps
  Timer? _locationTimer;
  bool startcount = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var typeStep = 'walk';
  var step_temp = 0;
  String formattedDate =
      DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now());
  final MapZoomPanBehavior _zoomPanBehavior = MapZoomPanBehavior(
    enableDoubleTapZooming: true,
    enablePinching: true,
    enablePanning: true,
  );

  @override
  void initState() {
    super.initState();
    fetchStepHarian();
    fetchUserDetails();
    _getCurrentLocation();
    log("ini adalah data di init state pertama, Total Jarak: $totalDistance, Langkah: $totalSteps, step Length: $stepLength");
  }

  Future<void> fetchUserDetails() async {
    try {
      // Ambil berat badan pengguna
      final userWeightData = await fitnessFlowDB.fetchUserByIdV2(1);
      if (userWeightData.isNotEmpty) {
        setState(() {
          userWeight =
              userWeightData[0]['berat'].toDouble(); // Simpan berat badan
        });
        log("Berat pengguna: $userWeight");
      }

      // Ambil jenis kelamin pengguna
      final userData = await fitnessFlowDB.fetchUserAll();
      log("${userData}");
      if (userData.isNotEmpty) {
        String gender = userData[0]['jeniskelamin'].trim().toUpperCase();
        double newStepLength =
            (gender == 'L') ? 0.78 : 0.66; // Kalkulasi panjang langkah

        setState(() {
          stepLength =
              newStepLength; // Set panjang langkah setelah logika selesai
        });

        log("Jenis kelamin: $gender, Panjang langkah: $stepLength meter");
      }
    } catch (e) {
      debugPrint("Error saat mengambil detail pengguna: $e");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _currentPosition = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Layanan lokasi dimatikan, mohon aktifkan.'),
          ),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _currentPosition = null;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentPosition = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Izin lokasi ditolak secara permanen.'),
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _currentMarkerPosition =
            MapLatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      debugPrint('Error fetching current location: $e');
      setState(() {
        _currentPosition = null;
      });
    }
  }

  final fitnessFlowDB = FitnessFlowDB();

  Future? futureStep;

  Future? futureStepHarian;
  void fetchStepHarian() async {
    setState(() {
      futureStepHarian = fitnessFlowDB
          .fetchStepHarian(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    });
    log('${futureStepHarian}');
  }

  void fetchStep() async {
    setState(() {
      futureStep = fitnessFlowDB.getAllStepUsers();
    });
    log(' ini adalah data ${futureStep}');
  }

  double calculateCalories(String type, double totalDistance) {
    int steps = (totalDistance / stepLength).round();
    log('Jarak: $totalDistance meter, Langkah: $steps');

    double calories;
    if (type == 'walk') {
      calories = 0.57 * userWeight * (steps / 1312);
    } else if (type == 'run') {
      calories = 1.03 * userWeight * (steps / 1312);
    } else {
      calories = 0.8 * userWeight * (steps / 1312);
    }
    log('Kalori terbakar: $calories');
    return calories;
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  Future<void> toggleTracking({bool useSimulation = false}) async {
    log("Step length di toggle tracking: $stepLength");
    if (startcount) {
      await _stopTracking();
    } else {
      await _startTracking(useSimulation: useSimulation);
    }
  }

  Future<void> _stopTracking() async {
    _locationTimer?.cancel();

    // validasi nanti
    // if (totalSteps == 0) {
    //   await _saveTrackingData();
    // }
    await _saveTrackingData();

    // Reset data setelah tracking dihentikan
    setState(() {
      _steps = 'mulai';
      startcount = false;
      totalSteps = 0;
      totalDistance = 0.0;
      activityLog.clear();
    });
  }

  Future<void> _startTracking({bool useSimulation = false}) async {
    setState(() {
      startcount = true;
      _steps = '0';
      totalSteps = 0;
      totalDistance = 0.0;
      polylinePoints.clear();
      activityLog.clear();
    });

    Position? previousPosition;

    _locationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        Position? currentPosition;
        if (useSimulation) {
          // Simulasi lokasi
          currentPosition = _getSimulatedPosition();
        } else {
          // Lokasi nyata
          currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high,
          );
        }

        if (previousPosition != null && currentPosition != null) {
          log("Previous Position: ${previousPosition?.latitude}, ${previousPosition?.longitude}");
          log("Current Position: ${currentPosition.latitude}, ${currentPosition.longitude}");

          double distance = Geolocator.distanceBetween(
            previousPosition!.latitude,
            previousPosition!.longitude,
            currentPosition.latitude,
            currentPosition.longitude,
          );

          setState(() {
            totalDistance += distance;
            totalSteps = (totalDistance / stepLength).round();
            _steps = totalSteps.toString();
            _currentPosition = currentPosition;
            _currentMarkerPosition =
                MapLatLng(currentPosition!.latitude, currentPosition.longitude);
            polylinePoints.add(_currentMarkerPosition!);
            activityLog.add({
              'latitude': currentPosition.latitude,
              'longitude': currentPosition.longitude,
              'timestamp': DateTime.now().toIso8601String(),
            });

            totalCalories = calculateCalories(typeStep, totalDistance);

            log("UPDATE MARKER: $_currentMarkerPosition");
          });

          log("current marker position : ${_currentMarkerPosition}");
          log("current position : ${_currentMarkerPosition}");
          log("Jarak: $distance meter, Total Jarak: $totalDistance, Langkah: $totalSteps");
        }

        previousPosition = currentPosition;
      } catch (e) {
        debugPrint('Error fetching location: $e');
        timer.cancel();
      }
    });
  }

  Future<void> _saveTrackingData() async {
    try {
      // Buat objek StepUser
      StepUser stepUser = StepUser(
        userId: 1, // Ganti dengan userId yang sesuai
        tanggal: DateTime.now(),
        step: totalSteps,
        berat: userWeight, // Ganti dengan berat yang sesuai
        totalDistance: totalDistance,
        type: typeStep,
        mulai: activityLog.isNotEmpty
            ? DateTime.parse(activityLog.first['timestamp'])
            : DateTime.now(),
        selesai: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      log("Ini adalah data yang disave ke database : $stepUser");

      // Simpan data langkah ke database
      int stepUserId = await fitnessFlowDB.insertStepUsers(stepUser);

      // Simpan detail lokasi ke database
      for (var log in activityLog) {
        StepsUserDetail stepUserDetail = StepsUserDetail(
          stepUserId: stepUserId,
          latitude: log['latitude'],
          longtitude: log['longitude'],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        await fitnessFlowDB.insertStepUserDetails(stepUserDetail);
      }

      // Tampilkan notifikasi
      _showSuccessSnackBar(totalSteps, totalCalories);
    } catch (e) {
      debugPrint('Error saat menyimpan data: $e');
    }
  }

  void _showSuccessSnackBar(int steps, double calories) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: AppLocalizations.of(context)!.tracking_saved_successfully,
        message: AppLocalizations.of(context)!.total_steps +
            "${steps} " +
            AppLocalizations.of(context)!.steps +
            "\n" +
            AppLocalizations.of(context)!.calories_burned +
            "${calories.toStringAsFixed(2)} cal",
        contentType: ContentType.success,
        titleFontSize: 16,
      ),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(scaffoldKey.currentContext!)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Position? _getSimulatedPosition() {
    List<MapLatLng> mockLocations = [
      MapLatLng(-6.200000, 106.816666),
      MapLatLng(-6.200026, 106.816126),
      MapLatLng(-6.202000, 106.818000),
      MapLatLng(-6.203000, 106.819000),
      MapLatLng(-6.204000, 106.820000),
      MapLatLng(-6.205000, 106.821000),
      MapLatLng(-6.206000, 106.822000),
      MapLatLng(-6.207000, 106.823000),
      MapLatLng(-6.208000, 106.824000),
      MapLatLng(-6.209000, 106.825000),
    ];

    int index = activityLog.length % mockLocations.length;
    return Position(
      latitude: mockLocations[index].latitude,
      longitude: mockLocations[index].longitude,
      timestamp: DateTime.now(),
      accuracy: 5.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 5.0,
      headingAccuracy: 5.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();
    final appLocalizations = AppLocalizations.of(context);
    return GestureDetector(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 36.0, 24.0, 0.0),
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
                    Text(
                      AppLocalizations.of(context)!.daily_step,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Rubik',
                            color: FlutterFlowTheme.of(context).primary,
                            fontSize: 14.0,
                            letterSpacing: 1.0,
                          ),
                    ),
                    FFButtonWidget(
                      onPressed: () {
                        context.pushNamed('listStep');
                      },
                      text: AppLocalizations.of(context)!.history,
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
              Text(
                appLocalizations!.you_reach_daily_steps,
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Rubik',
                      fontSize: 20.0,
                    ),
              ),
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: futureStepHarian,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasData) {
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    .0, 0.0, 0.0, 0.0),
                                child: Text(
                                  "${snapshot.data[0]['total_steps']}",
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Rubik',
                                        fontSize: 20.0,
                                      ),
                                ),
                              );
                            } else {
                              return Center(
                                child: Text(
                                  appLocalizations.data_not_available,
                                ),
                              );
                            }
                          },
                        ),
                        Text(
                          appLocalizations.ten_thousand_steps,
                          textAlign: TextAlign.center,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Rubik',
                                    fontSize: 20.0,
                                  ),
                        ),
                      ])),
              Text(
                "${formatDateWithLocalization(context, DateTime.now())}",
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Rubik',
                      fontSize: 20.0,
                    ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FutureBuilder(
                      future: _getCurrentLocation(),
                      builder:
                          (BuildContext context, AsyncSnapshot<void> snapshot) {
                        if (_currentPosition == null &&
                            snapshot.connectionState ==
                                ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (_currentPosition == null) {
                          return Center(
                            child: Text(
                              'Lokasi ditolak atau tidak tersedia.',
                              style: TextStyle(fontSize: 16),
                            ),
                          );
                        } else {
                          return Container(
                            height: 350,
                            child: SfMaps(
                              layers: [
                                MapTileLayer(
                                  zoomPanBehavior: _zoomPanBehavior,
                                  initialFocalLatLng: _currentMarkerPosition ??
                                      MapLatLng(
                                        _currentPosition!.latitude,
                                        _currentPosition!.longitude,
                                      ),
                                  initialZoomLevel: 15,
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  initialMarkersCount: 1,
                                  markerBuilder:
                                      (BuildContext context, int index) {
                                    return MapMarker(
                                      latitude: _currentPosition!.latitude,
                                      longitude: _currentPosition!.longitude,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    );
                                  },
                                  sublayers: [
                                    if (activityLog.isNotEmpty &&
                                        activityLog.length > 1)
                                      MapPolylineLayer(
                                        polylines: {
                                          MapPolyline(
                                            points: activityLog.map((log) {
                                              return MapLatLng(log['latitude'],
                                                  log['longitude']);
                                            }).toList(),
                                            color: Colors.blue,
                                            width: 10,
                                          ),
                                        },
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
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
                      // kode untuk simulasi
                      onTap: () async {
                        var user = await fitnessFlowDB.fetchUserByIdV2(1);
                        toggleTracking(useSimulation: false);
                        if (!startcount && totalSteps > 0) {
                          log("isi type : ${typeStep}");
                          fitnessFlowDB.createStep(1, totalSteps.toString(),
                              user[0]['berat'], typeStep);
                        }
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
                              startcount
                                  ? _steps
                                  : AppLocalizations.of(context)!.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Rubik',
                                    fontSize: 20.0,
                                  ),
                            ),
                          ),
                          Text(
                            startcount
                                ? AppLocalizations.of(context)!.finish
                                : AppLocalizations.of(context)!
                                    .step
                                    .toLowerCase()
                                    .split(' ')
                                    .map((word) => word.isNotEmpty
                                        ? '${word[0].toUpperCase()}${word.substring(1)}'
                                        : '')
                                    .join(' '),
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final user = await fitnessFlowDB.fetchUserAll();
                        final gender =
                            user[0]['jeniskelamin'].trim().toUpperCase();

                        setState(() {
                          typeStep = 'walk';
                          stepLength = (gender == 'L') ? 0.78 : 0.66;
                        });

                        log("Type step diset ke: $typeStep");
                        log("Jenis kelamin: $gender, stepLength: $stepLength");
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
                    SizedBox(
                      width: 24.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final user = await fitnessFlowDB.fetchUserAll();
                        final gender =
                            user[0]['jeniskelamin'].trim().toUpperCase();

                        setState(() {
                          typeStep = 'run';
                          stepLength = (gender == 'L') ? 0.83 : 0.71;
                        });

                        log("Type step diset ke: $typeStep");
                        log("Jenis kelamin: $gender, stepLength: $stepLength");
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
                    SizedBox(
                      width: 24.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final user = await fitnessFlowDB.fetchUserAll();
                        final gender =
                            user[0]['jeniskelamin'].trim().toUpperCase();

                        setState(() {
                          typeStep = 'hiking';
                          stepLength = (gender == 'L') ? 0.78 : 0.66;
                        });

                        log("Type step diset ke: $typeStep");
                        log("Jenis kelamin: $gender, stepLength: $stepLength");
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

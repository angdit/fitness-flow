import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/services.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'food_nutrients_model.dart';
export 'food_nutrients_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodNutrientsWidget extends StatefulWidget {
  const FoodNutrientsWidget({
    super.key,
    required this.id,
  });

  final int? id;

  @override
  State<FoodNutrientsWidget> createState() => _FoodNutrientsWidgetState();
}

class _FoodNutrientsWidgetState extends State<FoodNutrientsWidget> {
  late FoodNutrientsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FoodNutrientsModel());
    _model.textController ??= TextEditingController(text: '100');
    fetchMeals(widget.id);
  }

  Future? futureMeal;
  var breakfastCheckbox = false;
  var lunchCheckbox = false;
  var dinnerCheckbox = false;
  var snackCheckbox = false;
  var kalori, fat, protein, karbo;
  var kalori100, fat100, protein100, karbo100;
  String? errorText;
  String? errorMessage;
  final fitnessFlowDB = FitnessFlowDB();
  void fetchMeals(id) async {
    setState(() {
      futureMeal = fitnessFlowDB.fetchMealById(id);
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: FutureBuilder(
            future: futureMeal,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var itemData = snapshot.data[0];

                // Ambil nilai input text dan validasi
                String inputText = _model.textController.text.trim();
                double inputValue = double.tryParse(inputText) ??
                    0; // Jika tidak valid, default ke 0

                // Pastikan semua nilai itemData tidak null atau kosong
                double kaloriItem =
                    double.tryParse(itemData['kalori']?.toString() ?? "0") ?? 0;
                double fatItem =
                    double.tryParse(itemData['fat']?.toString() ?? "0") ?? 0;
                double proteinItem =
                    double.tryParse(itemData['protein']?.toString() ?? "0") ??
                        0;
                double karboItem =
                    double.tryParse(itemData['karbo']?.toString() ?? "0") ?? 0;

                // Kalkulasi hanya jika inputValue lebih dari 0
                kalori = (kaloriItem * inputValue) / 100;
                fat = (fatItem * inputValue) / 100;
                protein = (proteinItem * inputValue) / 100;
                karbo = (karboItem * inputValue) / 100;

                // Data asli
                kalori100 = kaloriItem;
                fat100 = fatItem;
                protein100 = proteinItem;
                karbo100 = karboItem;

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 300.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Stack(
                              children: [
                                // Gambar menggunakan function displayImage
                                Positioned.fill(
                                  child: displayImage(
                                    itemData[
                                        'gambar'], // Fungsi displayImage mengatur cara gambar ditampilkan
                                  ),
                                ),
                                // Elemen tambahan di atas gambar
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          24.0, 36.0, 24.0, 0.0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          FlutterFlowIconButton(
                                            borderColor: Colors.transparent,
                                            borderRadius: 12.0,
                                            borderWidth: 1.0,
                                            buttonSize: 48.0,
                                            fillColor: Color(0x00FFFFFF),
                                            icon: Icon(
                                              Icons.keyboard_arrow_left,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              size: 24.0,
                                            ),
                                            onPressed: () async {
                                              context.pushNamed(
                                                'FormAddMeal',
                                                extra: <String, dynamic>{
                                                  kTransitionInfoKey:
                                                      TransitionInfo(
                                                    hasTransition: true,
                                                    transitionType:
                                                        PageTransitionType
                                                            .scale,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    duration: Duration(
                                                        milliseconds: 200),
                                                  ),
                                                },
                                              );
                                              // Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.0, -0.45),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 240.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(0.0),
                                    bottomRight: Radius.circular(0.0),
                                    topLeft: Radius.circular(36.0),
                                    topRight: Radius.circular(36.0),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 24.0, 24.0, 0.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  // itemData['type'],
                                                  AppLocalizations.of(context)!
                                                      .getTranslation(
                                                          itemData['type']),
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Rubik',
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.4,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 12.0, 0.0, 0.0),
                                                  child: Text(
                                                    // itemData['nama'],
                                                    AppLocalizations.of(
                                                            context)!
                                                        .getTranslation(
                                                            itemData['nama']),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Rubik',
                                                          fontSize: 20.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 8.0, 24.0, 0.0),
                                                  child: Text(
                                                    // itemData['deskripsi'],
                                                    AppLocalizations.of(
                                                            context)!
                                                        .getTranslation(
                                                            itemData[
                                                                'deskripsi']),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Rubik',
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 8.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  AppLocalizations.of(context)!
                                                      .nutrition,
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        fontFamily: 'Rubik',
                                                        fontSize: 20.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      12.0, 12.0, 12.0, 0.0),
                                              child: ListView(
                                                padding: EdgeInsets.zero,
                                                primary: false,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .fat,
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
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .carbs,
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
                                                          Text(
                                                            'Protein',
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
                                                          Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .calorie
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
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                          ),
                                                          // Text(
                                                          //   "${itemData['berat']}g",
                                                          //   style: FlutterFlowTheme.of(
                                                          //           context)
                                                          //       .bodyMedium
                                                          //       .override(
                                                          //         fontFamily: 'Rubik',
                                                          //         fontWeight:
                                                          //             FontWeight.normal,
                                                          //       ),
                                                          // ),
                                                        ],
                                                      ),
                                                      Divider(
                                                        height: 24.0,
                                                        thickness: 1.0,
                                                        color:
                                                            Color(0xFFE9E9E9),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            fat.toStringAsFixed(
                                                                2),
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
                                                          Text(
                                                            karbo
                                                                .toStringAsFixed(
                                                                    2),
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
                                                          Text(
                                                            protein
                                                                .toStringAsFixed(
                                                                    2),
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
                                                          Text(
                                                            kalori
                                                                .toStringAsFixed(
                                                                    2),
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
                                                        ],
                                                      ),
                                                      Divider(
                                                        height: 24.0,
                                                        thickness: 1.0,
                                                        color:
                                                            Color(0xFFE9E9E9),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 5.0, 0.0, 0.0),
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r'[0-9]+[,.]{0,1}[0-9]*')),
                                                  TextInputFormatter
                                                      .withFunction(
                                                    (oldValue, newValue) =>
                                                        newValue.copyWith(
                                                      text: newValue.text
                                                          .replaceAll(',', '.'),
                                                    ),
                                                  ),
                                                ],
                                                controller:
                                                    _model.textController,
                                                keyboardType: TextInputType
                                                    .numberWithOptions(
                                                        decimal: true),
                                                decoration: InputDecoration(
                                                  errorText: (double.tryParse(_model
                                                                  .textController
                                                                  .text) ??
                                                              0) <=
                                                          0
                                                      ? AppLocalizations.of(
                                                              context)!
                                                          .data_must_be_greater_than_zero
                                                      : null,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      100),
                                                          borderSide:
                                                              const BorderSide(
                                                                  width: 2,
                                                                  color: Color
                                                                      .fromRGBO(
                                                                          80,
                                                                          70,
                                                                          227,
                                                                          1))),
                                                  label: Text(
                                                    "Gram",
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                  floatingLabelStyle:
                                                      GoogleFonts.poppins(
                                                          color: Color.fromRGBO(
                                                              80, 70, 227, 1)),
                                                  // prefixIcon: const Icon(FontAwesomeIcons.rupiahSign, size: 18,),
                                                  prefixIconColor:
                                                      const Color.fromRGBO(
                                                          80, 70, 227, 1),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    final double? multiplier =
                                                        double.tryParse(value);

                                                    if (multiplier == null ||
                                                        multiplier <= 0) {
                                                      // Jika nilai tidak valid, reset nilai
                                                      kalori = 0;
                                                      fat = 0;
                                                      protein = 0;
                                                      karbo = 0;
                                                    } else {
                                                      // Lakukan kalkulasi jika nilai valid
                                                      final double
                                                          currentKalori =
                                                          double.tryParse(kalori
                                                                      ?.toString() ??
                                                                  '0') ??
                                                              0;
                                                      final double currentFat =
                                                          double.tryParse(
                                                                  fat?.toString() ??
                                                                      '0') ??
                                                              0;
                                                      final double
                                                          currentProtein =
                                                          double.tryParse(protein
                                                                      ?.toString() ??
                                                                  '0') ??
                                                              0;
                                                      final double
                                                          currentKarbo =
                                                          double.tryParse(karbo
                                                                      ?.toString() ??
                                                                  '0') ??
                                                              0;

                                                      kalori = (currentKalori *
                                                              multiplier) /
                                                          100;
                                                      fat = (currentFat *
                                                              multiplier) /
                                                          100;
                                                      protein =
                                                          (currentProtein *
                                                                  multiplier) /
                                                              100;
                                                      karbo = (currentKarbo *
                                                              multiplier) /
                                                          100;
                                                    }
                                                  });
                                                },
                                              ),
                                              CheckboxListTile(
                                                title: Text(AppLocalizations.of(
                                                        context)!
                                                    .breakfast),
                                                value: breakfastCheckbox,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    breakfastCheckbox =
                                                        value ?? false;
                                                    errorMessage =
                                                        null; // Reset error
                                                  });
                                                },
                                              ),
                                              CheckboxListTile(
                                                title: Text(AppLocalizations.of(
                                                        context)!
                                                    .lunch),
                                                value: lunchCheckbox,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    lunchCheckbox =
                                                        value ?? false;
                                                    errorMessage =
                                                        null; // Reset error
                                                  });
                                                },
                                              ),
                                              CheckboxListTile(
                                                title: Text(AppLocalizations.of(
                                                        context)!
                                                    .dinner),
                                                value: dinnerCheckbox,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    dinnerCheckbox =
                                                        value ?? false;
                                                    errorMessage =
                                                        null; // Reset error
                                                  });
                                                },
                                              ),
                                              CheckboxListTile(
                                                title: Text(AppLocalizations.of(
                                                        context)!
                                                    .snack),
                                                value: snackCheckbox,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    snackCheckbox =
                                                        value ?? false;
                                                    errorMessage =
                                                        null; // Reset error
                                                  });
                                                },
                                              ),
                                              if (errorMessage != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    errorMessage!,
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            24.0, 16.0, 24.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    setState(() {
                                      // Validasi input
                                      String inputText =
                                          _model.textController.text.trim();
                                      double inputValue =
                                          double.tryParse(inputText) ?? 0;

                                      if (inputValue <= 0) {
                                        errorText =
                                            AppLocalizations.of(context)!
                                                .data_must_be_greater_than_zero;
                                        return; // Berhenti jika validasi gagal
                                      } else {
                                        errorText =
                                            null; // Reset error jika validasi berhasil
                                      }
                                    });
                                    if (!breakfastCheckbox &&
                                        !lunchCheckbox &&
                                        !dinnerCheckbox &&
                                        !snackCheckbox) {
                                      setState(() {
                                        errorMessage = AppLocalizations.of(
                                                context)!
                                            .validation_choose_one_eat_activity;
                                      });
                                      return;
                                    }

                                    if (errorText == null) {
                                      var minat = 'Breakfast';
                                      if (breakfastCheckbox) {
                                        minat = 'Breakfast';
                                        fitnessFlowDB.createKaloriUser(
                                          1,
                                          _model.textController.text,
                                          kalori,
                                          fat,
                                          protein,
                                          karbo,
                                          minat,
                                          itemData['id'],
                                        );
                                      }
                                      if (lunchCheckbox) {
                                        minat = 'Lunch';
                                        fitnessFlowDB.createKaloriUser(
                                          1,
                                          _model.textController.text,
                                          kalori,
                                          fat,
                                          protein,
                                          karbo,
                                          minat,
                                          itemData['id'],
                                        );
                                      }
                                      if (dinnerCheckbox) {
                                        minat = 'Dinner';
                                        fitnessFlowDB.createKaloriUser(
                                          1,
                                          _model.textController.text,
                                          kalori,
                                          fat,
                                          protein,
                                          karbo,
                                          minat,
                                          itemData['id'],
                                        );
                                      }

                                      if (snackCheckbox) {
                                        minat = 'Snack';
                                        fitnessFlowDB.createKaloriUser(
                                          1,
                                          _model.textController.text,
                                          kalori,
                                          fat,
                                          protein,
                                          karbo,
                                          minat,
                                          itemData['id'],
                                        );
                                      }

                                      final snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: AppLocalizations.of(context)!
                                                  .success +
                                              '!',
                                          message: AppLocalizations.of(context)!
                                              .daily_calories_added_successfully,
                                          contentType: ContentType.success,
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                      context.pushNamed('FoodJournal');
                                    }
                                  },
                                  text: AppLocalizations.of(context)!
                                      .add_to_journal,
                                  options: FFButtonOptions(
                                    width: double.infinity,
                                    height: 54.0,
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 0.0, 0.0, 0.0),
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
                                    elevation: 2.0,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
      ),
    );
  }
}

extension LocalizationHelper on AppLocalizations {
  String getTranslation(String key) {
    switch (key) {
      // Nama
      case 'boiled_corn':
        return this.boiled_corn;
      case 'boiled_potato':
        return this.boiled_potato;
      case 'white_rice':
        return this.white_rice;
      case 'grilled_chicken':
        return this.grilled_chicken;
      case 'fried_chicken':
        return this.fried_chicken;
      case 'roast_beef':
        return this.roast_beef;
      case 'boiled_shrimp':
        return this.boiled_shrimp;
      case 'grilled_shrimp':
        return this.grilled_shrimp;
      case 'baked_salmon':
        return this.baked_salmon;
      case 'fried_squid':
        return this.fried_squid;
      case 'boiled_squid':
        return this.boiled_squid;
      case 'chicken_sausage':
        return this.chicken_sausage;
      case 'brown_rice':
        return this.brown_rice;
      case 'avocado':
        return this.avocado;
      case 'mango':
        return this.mango;
      case 'banana':
        return this.banana;
      case 'strawberry':
        return this.strawberry;

      // Deskripsi
      case 'boiled_corn_desc':
        return this.boiled_corn_desc;
      case 'boiled_potato_desc':
        return this.boiled_potato_desc;
      case 'white_rice_desc':
        return this.white_rice_desc;
      case 'grilled_chicken_desc':
        return this.grilled_chicken_desc;
      case 'fried_chicken_desc':
        return this.fried_chicken_desc;
      case 'roast_beef_desc':
        return this.roast_beef_desc;
      case 'boiled_shrimp_desc':
        return this.boiled_shrimp_desc;
      case 'grilled_shrimp_desc':
        return this.grilled_shrimp_desc;
      case 'baked_salmon_desc':
        return this.baked_salmon_desc;
      case 'fried_squid_desc':
        return this.fried_squid_desc;
      case 'boiled_squid_desc':
        return this.boiled_squid_desc;
      case 'chicken_sausage_desc':
        return this.chicken_sausage_desc;
      case 'brown_rice_desc':
        return this.brown_rice_desc;
      case 'avocado_desc':
        return this.avocado_desc;
      case 'mango_desc':
        return this.mango_desc;
      case 'banana_desc':
        return this.banana_desc;
      case 'strawberry_desc':
        return this.strawberry_desc;

      // Tipe
      case 'staple_type_b':
        return this.staple_type_b;
      case 'staple_type_a':
        return this.staple_type_a;
      case 'protein_type_b':
        return this.protein_type_b;
      case 'protein_type_a':
        return this.protein_type_a;
      case 'protein_type_c':
        return this.protein_type_c;
      case 'staple_food':
        return this.staple_food;
      case 'fruit':
        return this.fruit;
      case 'vegetable':
        return this.vegetable;

      // Default jika key tidak ditemukan
      default:
        return key; // Mengembalikan key untuk debug jika tidak ditemukan
    }
  }
}

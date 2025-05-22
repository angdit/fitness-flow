import 'dart:io';
import 'dart:developer';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/services.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'work_detail_model.dart';
export 'work_detail_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WorkDetailWidget extends StatefulWidget {
  const WorkDetailWidget({
    super.key,
    required this.id,
  });

  final int? id;

  @override
  State<WorkDetailWidget> createState() => _WorkDetailWidgetState();
}

class _WorkDetailWidgetState extends State<WorkDetailWidget> {
  late WorkDetailModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isInputValid = true;
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WorkDetailModel());
    fetchLatihan(widget.id);
    _model.textController3 ??= TextEditingController();
    _model.textFieldFocusNode3 ??= FocusNode();
    _model.textController2 ??= TextEditingController();
    _model.textFieldFocusNode2 ??= FocusNode();
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  bool _validateInput() {
    if (_model.textController.text.isEmpty ||
        _model.textController2.text.isEmpty ||
        selectedValue == null) {
      setState(() {
        _isInputValid = false;
      });
      return false;
    }
    setState(() {
      _isInputValid = true;
    });
    return true;
  }

  _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2050))
        .then((value) {
      setState(() {
        _model.textController2.text = DateFormat('yyyy-MM-dd').format(value!);
      });
    });
  }

  Future? futureLatihan;
  var breakfastCheckbox = true;
  var lunchCheckbox = false;
  var dinnerCheckbox = false;
  final fitnessFlowDB = FitnessFlowDB();
  void fetchLatihan(id) async {
    setState(() {
      futureLatihan = fitnessFlowDB.fetchLatihanById(id);
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
            future: futureLatihan,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                var itemData = snapshot.data[0];
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
                            child: Stack(children: [
                              Positioned.fill(
                                  child: displayImage(itemData['gambar'])),
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
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            size: 24.0,
                                          ),
                                          onPressed: () async {
                                            context.pushNamed(
                                              'FormAddWork',
                                              extra: <String, dynamic>{
                                                kTransitionInfoKey:
                                                    TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType:
                                                      PageTransitionType.scale,
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  duration: Duration(
                                                      milliseconds: 200),
                                                ),
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
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
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 24.0, 0.0, 0.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextFormField(
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                controller:
                                                    _model.textController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
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
                                                    AppLocalizations.of(
                                                            context)!
                                                        .minutes_wo,
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
                                              ),
                                              if (!_isInputValid &&
                                                  _model.textController.text
                                                      .isEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0, left: 10),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .validation_error_enter_name,
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(
                                                height: 12.0,
                                              ),
                                              TextFormField(
                                                controller:
                                                    _model.textController2,
                                                onTap: () {
                                                  _showDatePicker();
                                                },
                                                readOnly: true,
                                                decoration: InputDecoration(
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
                                                    AppLocalizations.of(
                                                            context)!
                                                        .date,
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                  floatingLabelStyle:
                                                      GoogleFonts.poppins(
                                                          color: Color.fromRGBO(
                                                              80, 70, 227, 1)),
                                                  // prefixIcon: const Icon(Icon.calendar, size: 18,),
                                                  prefixIconColor:
                                                      const Color.fromRGBO(
                                                          80, 70, 227, 1),
                                                ),
                                              ),
                                              if (!_isInputValid &&
                                                  _model.textController2.text
                                                      .isEmpty)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0, left: 10),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .validation_error_enter_name,
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12.0,
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(
                                                height: 12.0,
                                              ),
                                              DropdownButtonFormField<String>(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                    borderSide:
                                                        const BorderSide(
                                                      width: 2,
                                                      color: Color.fromRGBO(
                                                          80, 70, 227, 1),
                                                    ),
                                                  ),
                                                  label: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .exercise_status,
                                                    style:
                                                        GoogleFonts.poppins(),
                                                  ),
                                                  floatingLabelStyle:
                                                      GoogleFonts.poppins(
                                                    color: const Color.fromRGBO(
                                                        80, 70, 227, 1),
                                                  ),
                                                  prefixIconColor:
                                                      const Color.fromRGBO(
                                                          80, 70, 227, 1),
                                                ),
                                                value: selectedValue,
                                                items: [
                                                  DropdownMenuItem(
                                                    value: '0',
                                                    child: Text(AppLocalizations
                                                            .of(context)!
                                                        .exercise_is_not_yet_complete),
                                                  ),
                                                  DropdownMenuItem(
                                                    value: '1',
                                                    child: Text(AppLocalizations
                                                            .of(context)!
                                                        .exercise_is_complete),
                                                  ),
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedValue = value;
                                                  });
                                                },
                                              ),
                                              if (!_isInputValid &&
                                                  selectedValue == null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0, left: 10),
                                                  child: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .validation_error_enter_name,
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12.0,
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
                                    log("isi data menit : ${_model.textController}");
                                    log("isi data tanggal : ${_model.textController2}");
                                    log("isi data status latihan : ${selectedValue}");

                                    if (!_validateInput()) {
                                      return;
                                    }
                                    if (_model.textController2.text == '') {
                                      final snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: AppLocalizations.of(context)!
                                                  .failed +
                                              '!',
                                          message: AppLocalizations.of(context)!
                                              .please_select_a_date,
                                          contentType: ContentType.warning,
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                    } else {
                                      int exerciseStatusint =
                                          selectedValue == '1' ? 1 : 0;

                                      String exerciseStatusText =
                                          selectedValue == '1'
                                              ? 'sudah'
                                              : 'belum';

                                      final double inputNumber =
                                          double.tryParse(
                                                  _model.textController.text) ??
                                              1;

                                      final double total_kalori =
                                          itemData['kalori'] * inputNumber;

                                      log("ISI DATA INPUT NUMBER : $inputNumber");
                                      log("ISI DATA TOTAL KALORI : $total_kalori");
                                      log("ISI DATA STATUS LATIHAN : $exerciseStatusint");
                                      log("ISI DATA STATUS LATIHAN STRING : $exerciseStatusText");

                                      fitnessFlowDB.createLatihanUser(
                                          1,
                                          itemData['id'],
                                          _model.textController2.text,
                                          _model.textController.text,
                                          total_kalori,
                                          exerciseStatusint,
                                          exerciseStatusText);

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
                                              .daily_exercise_successfully_added,

                                          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                          contentType: ContentType.success,
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                      context.pushNamed('EventsPage');
                                    }
                                  },
                                  text: AppLocalizations.of(context)!
                                      .add_exercise,
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

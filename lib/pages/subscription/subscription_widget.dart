import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'subscription_model.dart';
export 'subscription_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubscriptionWidget extends StatefulWidget {
  const SubscriptionWidget({super.key});

  @override
  State<SubscriptionWidget> createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends State<SubscriptionWidget> {
  late SubscriptionModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future? futureUser;
  String? byte64String;
  final fitnessFlowDB = FitnessFlowDB();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SubscriptionModel());
    _model.textController ??= TextEditingController();
    _model.textController2 ??= TextEditingController();
    _model.textControllerPinggang ??= TextEditingController();
    _model.textControllerPaha ??= TextEditingController();
    _model.textControllerTangan ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _model.textFieldFocusNode2 ??= FocusNode();
    fetchUser();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  void fetchUser() async {
    setState(() {
      futureUser = fitnessFlowDB.fetchUserByIdV2(1);
    });
  }

  Future<String> pickImage() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 45);

    var imageBytes = await image!.readAsBytes();

    String base64Image = base64Encode(imageBytes);
    return base64Image;
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

  createBeratBadan() async {
    var user = await fitnessFlowDB.fetchUserByIdV2(1);
    fitnessFlowDB.updateUser(1, 'berat_old', user[0]['berat'].toString());
    fitnessFlowDB.createBeratBadan(
        1,
        _model.textController.text,
        _model.textController2.text,
        _model.textControllerPinggang.text,
        _model.textControllerTangan.text,
        _model.textControllerPaha.text);
    fitnessFlowDB.updateUser(1, 'berat', _model.textController.text);
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
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon:
                Icon(Icons.arrow_back_rounded, color: Colors.black, size: 30.0),
            onPressed: () {
              // Navigasi kembali ke halaman sebelumnya
              Navigator.of(context).pop();
            },
          ),
          title: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.add,
                        style:      FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Rubik',
                                    fontSize: 18.0,
                                  ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: Text(
                          AppLocalizations.of(context)!
                              .body_weight_weight_tracker,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Rubik',
                                    fontSize: 18.0,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 10.0, 24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Form(
                          child: Column(
                        children: [
                          TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) => newValue.copyWith(
                                  text: newValue.text.replaceAll(',', '.'),
                                ),
                              ),
                            ],
                            controller: _model.textController,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(80, 70, 227, 1))),
                              label: Text(
                                AppLocalizations.of(context)!
                                    .current_body_weight
                                    .toLowerCase()
                                    .split(' ')
                                    .map((word) => word.isNotEmpty
                                        ? '${word[0].toUpperCase()}${word.substring(1)}'
                                        : '')
                                    .join(' '),
                                style: GoogleFonts.poppins(),
                              ),
                              floatingLabelStyle: GoogleFonts.poppins(
                                  color: Color.fromRGBO(80, 70, 227, 1)),
                              // prefixIcon: const Icon(FontAwesomeIcons.rupiahSign, size: 18,),
                              prefixIconColor:
                                  const Color.fromRGBO(80, 70, 227, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) => newValue.copyWith(
                                  text: newValue.text.replaceAll(',', '.'),
                                ),
                              ),
                            ],
                            controller: _model.textControllerPinggang,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(80, 70, 227, 1))),
                              label: Text(
                                AppLocalizations.of(context)!.waist_line,
                                style: GoogleFonts.poppins(),
                              ),
                              floatingLabelStyle: GoogleFonts.poppins(
                                  color: Color.fromRGBO(80, 70, 227, 1)),
                              prefixIconColor:
                                  const Color.fromRGBO(80, 70, 227, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) => newValue.copyWith(
                                  text: newValue.text.replaceAll(',', '.'),
                                ),
                              ),
                            ],
                            controller: _model.textControllerTangan,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(80, 70, 227, 1))),
                              label: Text(
                                AppLocalizations.of(context)!
                                    .hand_circumference,
                                style: GoogleFonts.poppins(),
                              ),
                              floatingLabelStyle: GoogleFonts.poppins(
                                  color: Color.fromRGBO(80, 70, 227, 1)),
                              prefixIconColor:
                                  const Color.fromRGBO(80, 70, 227, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) => newValue.copyWith(
                                  text: newValue.text.replaceAll(',', '.'),
                                ),
                              ),
                            ],
                            controller: _model.textControllerPaha,
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(80, 70, 227, 1))),
                              label: Text(
                                AppLocalizations.of(context)!
                                    .thigh_circumference,
                                style: GoogleFonts.poppins(),
                              ),
                              floatingLabelStyle: GoogleFonts.poppins(
                                  color: Color.fromRGBO(80, 70, 227, 1)),
                              // prefixIcon: const Icon(FontAwesomeIcons.rupiahSign, size: 18,),
                              prefixIconColor:
                                  const Color.fromRGBO(80, 70, 227, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _model.textController2,
                            onTap: () {
                              _showDatePicker();
                            },
                            readOnly: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 2,
                                      color: Color.fromRGBO(80, 70, 227, 1))),
                              label: Text(
                                AppLocalizations.of(context)!.date,
                                style: GoogleFonts.poppins(),
                              ),
                              floatingLabelStyle: GoogleFonts.poppins(
                                  color: Color.fromRGBO(80, 70, 227, 1)),
                              // prefixIcon: const Icon(Icon.calendar, size: 18,),
                              prefixIconColor:
                                  const Color.fromRGBO(80, 70, 227, 1),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_model.textController.text != '' &&
                                      _model.textController2.text != '' &&
                                      _model.textControllerPinggang.text !=
                                          '' &&
                                      _model.textControllerTangan.text != '' &&
                                      _model.textControllerPaha.text != '') {
                                    await createBeratBadan();

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
                                            .weight_added_successfully,

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.success,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    context.pushNamed('WeightTracker');
                                  } else {
                                    final snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: AppLocalizations.of(context)!
                                                .attention +
                                            '!',
                                        message: AppLocalizations.of(context)!
                                            .validation_check_your_form,

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.warning,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color(0xFF7165E3),
                                    ),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            const EdgeInsets.all(20))),
                                child: Text(
                                  AppLocalizations.of(context)!.save,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:ffi';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_model.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_theme.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_util.dart';
import 'package:fitness_flow/pages/food_journal/user_note_add_model.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

class UserNoteAddWidget extends StatefulWidget {
  const UserNoteAddWidget({super.key});

  @override
  State<UserNoteAddWidget> createState() => _UserNoteAddWidgetState();
}

class _UserNoteAddWidgetState extends State<UserNoteAddWidget> {
  late UserNoteAddModel _model;
  // final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int? selectedValuee;
  Future? futureUser;
  Future? futureMeal;
  final fitnessFlowDB = FitnessFlowDB();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {}); // Update UI when focus changes
    });
    _model = createModel(context, () => UserNoteAddModel());
    _model.textControllerIdMakanan ??= TextEditingController();
    _model.textControllerCatatan ??= TextEditingController();
    fetchUser();
    fetchMealsNote();
  }

  void fetchUser() async {
    setState(() {
      futureUser = fitnessFlowDB.fetchUserByIdV2(1);
    });
  }

  void fetchMealsNote() async {
    setState(() {
      futureMeal = fitnessFlowDB.fetchMealsNote();
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<int> createUserNote() async {
    await fitnessFlowDB.createUserNote(
        1, selectedValuee!, _model.textControllerCatatan?.text);
    return 1;
  }

  // fetchUser();

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
            backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_rounded,
                  color: Colors.black, size: 30.0),
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
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.add,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Rubik',
                                    // color: FlutterFlowTheme.of(context).secondaryText,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 5.0, 0.0, 0.0),
                          child: Text(
                            AppLocalizations.of(context)!.allergy_note,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
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
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder<List<Map<String, dynamic>>>(
                              future: fitnessFlowDB
                                  .fetchMealsNote(), // Panggil future langsung di sini
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator(); // Tampilkan loading saat menunggu
                                } else if (snapshot.hasError) {
                                  return Text(
                                      'Terjadi kesalahan: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Text(
                                      'Tidak ada data makanan tersedia');
                                }

                                final meals = snapshot.data!;
                                final localizations =
                                    AppLocalizations.of(context)!;

                                return DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(0),
                                      borderSide: const BorderSide(
                                        width: 2,
                                        color: Color.fromRGBO(80, 70, 227, 1),
                                      ),
                                    ),
                                    label: Text(
                                      AppLocalizations.of(context)!
                                          .choose_your_meal,
                                      style: GoogleFonts.poppins(),
                                    ),
                                    floatingLabelStyle: GoogleFonts.poppins(
                                      color:
                                          const Color.fromRGBO(80, 70, 227, 1),
                                    ),
                                    prefixIconColor:
                                        const Color.fromRGBO(80, 70, 227, 1),
                                  ),
                                  value: selectedValuee,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValuee = value;
                                    });
                                  },
                                  items:
                                      meals.map<DropdownMenuItem<int>>((meal) {
                                    return DropdownMenuItem<int>(
                                      value:
                                          meal['id'] as int, // Konversi ke int
                                      child: Text(localizations.getTranslation(meal[
                                          'nama'])), // Terjemahkan nama makanan
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _model.textControllerCatatan,
                              keyboardType: TextInputType.text,
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
                                  AppLocalizations.of(context)!.allergy_note,
                                  style: GoogleFonts.poppins(),
                                ),
                                floatingLabelStyle: GoogleFonts.poppins(
                                    color: Color.fromRGBO(80, 70, 227, 1)),
                                // prefixIcon: const Icon(FontAwesomeIcons.rupiahSign, size: 18,),
                                prefixIconColor:
                                    const Color.fromRGBO(80, 70, 227, 1),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    if (_model.textControllerCatatan?.text !=
                                            '' &&
                                        selectedValuee != '') {
                                      await createUserNote();

                                      final snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        content: AwesomeSnackbarContent(
                                          title: AppLocalizations.of(context)!
                                                  .success +
                                              '!',
                                          message: AppLocalizations.of(context)!
                                              .note_successfully_added,
                                          // "Catatan Berhasil ditambahkan",

                                          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                          contentType: ContentType.success,
                                        ),
                                      );

                                      ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(snackBar);
                                      context.pushNamed('UserNoteListWidget');
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
        ));
  }
}

extension LocalizationHelper on AppLocalizations {
  String getTranslation(String key) {
    switch (key) {
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
      default:
        return key;
    }
  }
}

import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/form_add_meal/new_food_form_model.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewFoodFormWidget extends StatefulWidget {
  const NewFoodFormWidget({super.key});

  @override
  State<NewFoodFormWidget> createState() => _NewFoodFormWidget();
}

class _NewFoodFormWidget extends State<NewFoodFormWidget> {
  late NewFoodFormModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future? futureUser;
  String? byte64String;
  final fitnessFlowDB = FitnessFlowDB();
  File? image;
  String? selectedValue;
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewFoodFormModel());
    _model.textControllerNamaMakanan ??= TextEditingController();
    _model.textControllerKaloriMakanan ??= TextEditingController();
    _model.textControllerGramMakanan ??= TextEditingController();
    _model.textControllerLemakMakanan ??= TextEditingController();
    _model.textControllerProteinMakanan ??= TextEditingController();
    _model.textControllerKarboMakanan ??= TextEditingController();
    _model.textControllerGambarMakanan ??= TextEditingController();
    _model.textControllerDeskripsiMakanan ??= TextEditingController();
    _model.textControllerGolonganMakanan ??= TextEditingController();
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

  Future<String?> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        // Normalisasi path gambar
        // return Uri.file(pickedFile.path).path;
        return pickedFile.path;
      }
      return null;
    } catch (e) {
      debugPrint("Error memilih gambar: $e");
      return null;
    }
  }

// Fungsi validasi Base64
  bool isValidBase64(String base64String) {
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return base64Pattern.hasMatch(base64String);
  }

  Future<int> createMealPickImage() async {
    try {
      await fitnessFlowDB.createMealPickImage(
          _model.textControllerNamaMakanan.text,
          _model.textControllerGramMakanan.text,
          _model.textControllerKaloriMakanan.text,
          _model.textControllerLemakMakanan.text,
          _model.textControllerProteinMakanan.text,
          _model.textControllerKarboMakanan.text,
          _model.textControllerGambarMakanan.text, // Path gambar
          _model.textControllerDeskripsiMakanan.text,
          selectedValue);
      return 1;
    } catch (e) {
      debugPrint("Gagal menyimpan data: $e");
      return 0;
    }
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
          backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
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
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Rubik',
                              // color: FlutterFlowTheme.of(context).secondaryText,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                        child: Text(
                          AppLocalizations.of(context)!.meal,
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
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(
                            //       RegExp("[a-zA-Z]"))
                            // ],
                            controller: _model.textControllerNamaMakanan,
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
                                AppLocalizations.of(context)!.meal_name,
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
                            controller: _model.textControllerGramMakanan,
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
                                AppLocalizations.of(context)!.meal_gram,
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
                            controller: _model.textControllerKaloriMakanan,
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
                                AppLocalizations.of(context)!.meal_calorie,
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
                            controller: _model.textControllerLemakMakanan,
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
                                AppLocalizations.of(context)!.meal_fat,
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
                            controller: _model.textControllerProteinMakanan,
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
                                AppLocalizations.of(context)!.meal_protein,
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
                            controller: _model.textControllerKarboMakanan,
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
                                AppLocalizations.of(context)!.meal_carbs,
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
                            height: 10,
                          ),
                          TextFormField(
                            controller: _model.textControllerDeskripsiMakanan,
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
                                AppLocalizations.of(context)!.meal_description,
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
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
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
                                AppLocalizations.of(context)!.choose_meal_group,
                                style: GoogleFonts.poppins(),
                              ),
                              floatingLabelStyle: GoogleFonts.poppins(
                                color: const Color.fromRGBO(80, 70, 227, 1),
                              ),
                              prefixIconColor:
                                  const Color.fromRGBO(80, 70, 227, 1),
                            ),
                            value: selectedValue,
                            items: [
                              DropdownMenuItem(
                                value: 'staple_food',
                                child: Text(
                                    AppLocalizations.of(context)!.staple_food),
                              ),
                              DropdownMenuItem(
                                value: 'fruit',
                                child:
                                    Text(AppLocalizations.of(context)!.fruit),
                              ),
                              DropdownMenuItem(
                                value: 'vegetable',
                                child: Text(
                                    AppLocalizations.of(context)!.vegetable),
                              ),
                              DropdownMenuItem(
                                value: 'protein_type_a',
                                child: Text(AppLocalizations.of(context)!
                                    .protein_type_a),
                              ),
                              DropdownMenuItem(
                                value: 'protein_type_b',
                                child: Text(AppLocalizations.of(context)!
                                    .protein_type_b),
                              ),
                              DropdownMenuItem(
                                value: 'protein_type_c',
                                child: Text(AppLocalizations.of(context)!
                                    .protein_type_c),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              child: Container(
                            child: Row(
                              children: [
                                // Tombol untuk memilih gambar
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    try {
                                      // Memilih gambar dari galeri
                                      final pickedFile = await ImagePicker()
                                          .pickImage(
                                              source: ImageSource.gallery);

                                      if (pickedFile != null) {
                                        setState(() {
                                          // Menyimpan path gambar di text controller
                                          _model.textControllerGambarMakanan
                                              .text = pickedFile.path;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(AppLocalizations.of(
                                                          context)!
                                                      .image_successfully_selected +
                                                  "!")),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  AppLocalizations.of(context)!
                                                      .image_not_selected)),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Terjadi kesalahan: $e")),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromRGBO(139, 128, 248, 1),
                                    padding: EdgeInsets.all(20),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // <-- Radius
                                    ),
                                  ),
                                  label: Text(
                                    AppLocalizations.of(context)!.add_photo,
                                    style: GoogleFonts.poppins(),
                                  ),
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // TextField untuk menampilkan hasil gambar (base64)
                                Expanded(
                                  child: TextFormField(
                                    controller:
                                        _model.textControllerGambarMakanan,
                                    readOnly:
                                        true, // Agar tidak bisa diedit langsung
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        borderSide: const BorderSide(
                                          width: 2,
                                          color: Color.fromRGBO(80, 70, 227, 1),
                                        ),
                                      ),
                                      labelText: AppLocalizations.of(context)!
                                          .file_name,
                                      labelStyle: GoogleFonts.poppins(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_model.textControllerNamaMakanan.text !=
                                          '' &&
                                      _model.textControllerGramMakanan.text !=
                                          '' &&
                                      _model.textControllerKaloriMakanan.text !=
                                          '' &&
                                      _model.textControllerLemakMakanan.text !=
                                          '' &&
                                      _model.textControllerProteinMakanan
                                              .text !=
                                          '' &&
                                      _model.textControllerKarboMakanan.text !=
                                          '' &&
                                      _model.textControllerDeskripsiMakanan
                                              .text !=
                                          '' &&
                                      selectedValue != '' &&
                                      // _model.textControllerGambarMakanan.text !=
                                      //     '')
                                      File(_model
                                              .textControllerGambarMakanan.text)
                                          .existsSync()) {
                                    await createMealPickImage();

                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: AppLocalizations.of(context)!
                                                .success +
                                            '!',
                                        message: AppLocalizations.of(context)!
                                            .meal_added_successfully,

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.success,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    context.pushNamed('FormAddMeal');
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
                                    backgroundColor:         MaterialStateProperty.all<Color>(
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
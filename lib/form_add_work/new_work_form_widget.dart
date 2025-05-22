import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/form_add_work/new_work_form_model.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewWorkFormWidget extends StatefulWidget {
  const NewWorkFormWidget({super.key});

  @override
  State<NewWorkFormWidget> createState() => _NewWorkFormWidget();
}

class _NewWorkFormWidget extends State<NewWorkFormWidget> {
  late NewWorkFormModel _model;
  String? selectedValue;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future? futureUser;
  String? byte64String;
  final fitnessFlowDB = FitnessFlowDB();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NewWorkFormModel());
    _model.textControllerNamaLatihan ??= TextEditingController();
    _model.textControllerKaloriLatihan ??= TextEditingController();
    _model.textControllerTipeLatihan ??= TextEditingController();
    _model.textControllerDeskripsiLatihan ??= TextEditingController();
    _model.textControllerGambarLatihan ??= TextEditingController();
    _model.textControllerLinkLatihan ??= TextEditingController();
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

  /// Fungsi validasi Base64
  bool isValidBase64(String base64String) {
    final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return base64Pattern.hasMatch(base64String);
  }

  Future<int> createLatihanPickImage() async {
    try {
      fitnessFlowDB.createLatihanPickImage(
          _model.textControllerNamaLatihan.text,
          _model.textControllerKaloriLatihan.text,
          selectedValue,
          _model.textControllerDeskripsiLatihan.text,
          _model.textControllerGambarLatihan.text,
          _model.textControllerLinkLatihan.text);
      return 1;
    } catch (e) {
      debugPrint("Gagal Menyimpan Gambar");
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
                          AppLocalizations.of(context)!
                              .exercise
                              .toLowerCase()
                              .split(' ')
                              .map((word) => word.isNotEmpty
                                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                                  : '')
                              .join(' '),
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
                            controller: _model.textControllerNamaLatihan,
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
                                AppLocalizations.of(context)!.exercise_name,
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
                            controller: _model.textControllerKaloriLatihan,
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
                                    .exercise_calories_per_minute,
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
                          // TextFormField(
                          //   controller: _model.textControllerTipeLatihan,
                          //   keyboardType: TextInputType.text,
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(100),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //         borderRadius: BorderRadius.circular(100),
                          //         borderSide: const BorderSide(
                          //             width: 2,
                          //             color: Color.fromRGBO(80, 70, 227, 1))),
                          //     label: Text(
                          //       AppLocalizations.of(context)!.exercise_type,
                          //       style: GoogleFonts.poppins(),
                          //     ),
                          //     floatingLabelStyle: GoogleFonts.poppins(
                          //         color: Color.fromRGBO(80, 70, 227, 1)),
                          //     prefixIconColor:
                          //         const Color.fromRGBO(80, 70, 227, 1),
                          //   ),
                          // ),
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
                                'Pilih Tipe Latihan',
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
                                value: 'Dada',
                                child: Text('Dada'),
                              ),
                              DropdownMenuItem(
                                value: 'Kaki',
                                child: Text('Kaki'),
                              ),
                              DropdownMenuItem(
                                value: 'Bahu',
                                child: Text('Bahu'),
                              ),
                              DropdownMenuItem(
                                value: 'Perut',
                                child: Text('Perut'),
                              ),
                              DropdownMenuItem(
                                value: 'Seluruh Tubuh',
                                child: Text('Seluruh Tubuh'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _model.textControllerDeskripsiLatihan,
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
                                AppLocalizations.of(context)!
                                    .exercise_description,
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
                            controller: _model.textControllerLinkLatihan,
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
                                AppLocalizations.of(context)!.exercise_link,
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
                                          _model.textControllerGambarLatihan
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
                                    backgroundColor: const Color(0xFF8B80F8),
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
                                        _model.textControllerGambarLatihan,
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
                                  if (_model.textControllerNamaLatihan.text !=
                                          '' &&
                                      _model.textControllerKaloriLatihan.text !=
                                          '' &&
                                      selectedValue != '' &&
                                      _model.textControllerDeskripsiLatihan
                                              .text !=
                                          '' &&
                                      File(_model.textControllerGambarLatihan
                                                  .text)
                                              .existsSync() !=
                                          '' &&
                                      _model.textControllerLinkLatihan.text !=
                                          '') {
                                    await createLatihanPickImage();

                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: AppLocalizations.of(context)!
                                                .success +
                                            '!',
                                        message: AppLocalizations.of(context)!
                                            .exercise_added_successfully,
                                        contentType: ContentType.success,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    context.pushNamed('FormAddWork');
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

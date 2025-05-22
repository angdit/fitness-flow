import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_theme.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_util.dart';
import 'package:fitness_flow/pages/food_journal/food_journal_edit_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FoodJournalEdit extends StatefulWidget {
  const FoodJournalEdit({
    super.key,
    required this.id,
    required this.minat,
    required this.berat,
    required this.kalori,
    required this.fat,
    required this.protein,
    required this.karbo,
  });

  final int id;
  // final String nama;
  final String minat;
  final double berat;
  final double kalori;
  final double fat;
  final double protein;
  final double karbo;

  @override
  State<FoodJournalEdit> createState() => _FoodJournalEditState();
}

class _FoodJournalEditState extends State<FoodJournalEdit> {
  late FoodJournalEditModel _model;
  // late TextEditingController _namaController;
  late TextEditingController _beratController;
  late TextEditingController _kaloriController;
  late TextEditingController _fatController;
  late TextEditingController _proteinController;
  late TextEditingController _karboController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = FoodJournalEditModel();
    // _namaController = TextEditingController(text: widget.nama.toString());
    _beratController = TextEditingController(text: widget.berat.toString());
    _kaloriController = TextEditingController(text: widget.kalori.toString());
    _fatController = TextEditingController(text: widget.fat.toString());
    _proteinController = TextEditingController(text: widget.protein.toString());
    _karboController = TextEditingController(text: widget.karbo.toString());
  }

  final fitnessFlowDB = FitnessFlowDB();

  @override
  void dispose() {
    // _namaController.dispose();
    _beratController.dispose();
    _kaloriController.dispose();
    _fatController.dispose();
    _proteinController.dispose();
    _karboController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    log("${_beratController.text}");
    log("${_kaloriController.text}");
    log("${_fatController.text}");
    log("${_proteinController.text}");
    log("${_karboController.text}");
    await fitnessFlowDB.updateMealDaily(
      widget.id,
      double.parse(_beratController.text),
      double.parse(_kaloriController.text),
      double.parse(_fatController.text),
      double.parse(_proteinController.text),
      double.parse(_karboController.text),
    );
    // Navigator.pop(context, "updated");
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
              Navigator.of(context).pop();
            },
          ),
          title: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                    child: Text(
                      "Edit Food Journal",
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Rubik',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                    )),
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
                          // TextFormField(
                          //   controller: _namaController,
                          //   readOnly: true,
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
                          //       "Nama",
                          //       style: GoogleFonts.poppins(),
                          //     ),
                          //     floatingLabelStyle: GoogleFonts.poppins(
                          //         color: Color.fromRGBO(80, 70, 227, 1)),
                          //     // prefixIcon: const Icon(FontAwesomeIcons.rupiahSign, size: 18,),
                          //     prefixIconColor:
                          //         const Color.fromRGBO(80, 70, 227, 1),
                          //   ),
                          // ),
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
                            controller: _beratController,
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
                            controller: _kaloriController,
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
                            controller: _fatController,
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
                            controller: _proteinController,
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
                            controller: _karboController,
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
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // TextFormField(
                          //   controller: _model.textControllerDeskripsiMakanan,
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
                          //       AppLocalizations.of(context)!.meal_description,
                          //       style: GoogleFonts.poppins(),
                          //     ),
                          //     floatingLabelStyle: GoogleFonts.poppins(
                          //         color: Color.fromRGBO(80, 70, 227, 1)),
                          //     // prefixIcon: const Icon(FontAwesomeIcons.rupiahSign, size: 18,),
                          //     prefixIconColor:
                          //         const Color.fromRGBO(80, 70, 227, 1),
                          //   ),
                          // ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // DropdownButtonFormField<String>(
                          //   decoration: InputDecoration(
                          //     border: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(100),
                          //     ),
                          //     focusedBorder: OutlineInputBorder(
                          //       borderRadius: BorderRadius.circular(0),
                          //       borderSide: const BorderSide(
                          //         width: 2,
                          //         color: Color.fromRGBO(80, 70, 227, 1),
                          //       ),
                          //     ),
                          //     label: Text(
                          //       'Pilih Golongan Makanan',
                          //       style: GoogleFonts.poppins(),
                          //     ),
                          //     floatingLabelStyle: GoogleFonts.poppins(
                          //       color: const Color.fromRGBO(80, 70, 227, 1),
                          //     ),
                          //     prefixIconColor:
                          //         const Color.fromRGBO(80, 70, 227, 1),
                          //   ),
                          //   value: selectedValue,
                          //   items: [
                          //     DropdownMenuItem(
                          //       value: 'Makanan Pokok',
                          //       child: Text('Makanan Pokok'),
                          //     ),
                          //     DropdownMenuItem(
                          //       value: 'Buah',
                          //       child: Text('Buah'),
                          //     ),
                          //     DropdownMenuItem(
                          //       value: 'Sayur',
                          //       child: Text('Sayur'),
                          //     ),
                          //     DropdownMenuItem(
                          //       value: 'Protein Golongan A',
                          //       child: Text('Protein Golongan A'),
                          //     ),
                          //     DropdownMenuItem(
                          //       value: 'Protein Golongan B',
                          //       child: Text('Protein Golongan B'),
                          //     ),
                          //     DropdownMenuItem(
                          //       value: 'Protein Golongan C',
                          //       child: Text('Protein Golongan C'),
                          //     ),
                          //   ],
                          //   onChanged: (value) {
                          //     setState(() {
                          //       selectedValue = value;
                          //     });
                          //   },
                          // ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // Container(
                          //     child: Container(
                          //   child: Row(
                          //     children: [
                          // Tombol untuk memilih gambar
                          //       ElevatedButton.icon(
                          //         onPressed: () async {
                          //           try {
                          //             // Memilih gambar dari galeri
                          //             final pickedFile = await ImagePicker()
                          //                 .pickImage(
                          //                     source: ImageSource.gallery);

                          //             if (pickedFile != null) {
                          //               setState(() {
                          //                 // Menyimpan path gambar di text controller
                          //                 _model.textControllerGambarMakanan
                          //                     .text = pickedFile.path;
                          //               });
                          //               ScaffoldMessenger.of(context)
                          //                   .showSnackBar(
                          //                 SnackBar(
                          //                     content: Text(AppLocalizations.of(
                          //                                 context)!
                          //                             .image_successfully_selected +
                          //                         "!")),
                          //               );
                          //             } else {
                          //               ScaffoldMessenger.of(context)
                          //                   .showSnackBar(
                          //                 SnackBar(
                          //                     content: Text(
                          //                         AppLocalizations.of(context)!
                          //                             .image_not_selected)),
                          //               );
                          //             }
                          //           } catch (e) {
                          //             ScaffoldMessenger.of(context)
                          //                 .showSnackBar(
                          //               SnackBar(
                          //                   content:
                          //                       Text("Terjadi kesalahan: $e")),
                          //             );
                          //           }
                          //         },
                          //         style: ElevatedButton.styleFrom(
                          //           backgroundColor:
                          //               Color.fromRGBO(139, 128, 248, 1),
                          //           padding: EdgeInsets.all(20),
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: BorderRadius.circular(
                          //                 20), // <-- Radius
                          //           ),
                          //         ),
                          //         label: Text(
                          //           AppLocalizations.of(context)!.add_photo,
                          //           style: GoogleFonts.poppins(),
                          //         ),
                          //         icon: Icon(
                          //           Icons.add,
                          //           color: Colors.white,
                          //           size: 20.0,
                          //         ),
                          //       ),
                          //       const SizedBox(width: 10),
                          //       // TextField untuk menampilkan hasil gambar (base64)
                          //       Expanded(
                          //         child: TextFormField(
                          //           controller:
                          //               _model.textControllerGambarMakanan,
                          //           readOnly:
                          //               true, // Agar tidak bisa diedit langsung
                          //           decoration: InputDecoration(
                          //             border: OutlineInputBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(100),
                          //             ),
                          //             focusedBorder: OutlineInputBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(100),
                          //               borderSide: const BorderSide(
                          //                 width: 2,
                          //                 color: Color.fromRGBO(80, 70, 227, 1),
                          //               ),
                          //             ),
                          //             labelText: AppLocalizations.of(context)!
                          //                 .file_name,
                          //             labelStyle: GoogleFonts.poppins(),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // )),
                          const SizedBox(
                            height: 20  ,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  if (_beratController.text != '' &&
                                      _fatController.text != '' &&
                                      _kaloriController.text != '' &&
                                      _proteinController.text != '' &&
                                      _karboController.text != '') {
                                    _saveChanges();

                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: AppLocalizations.of(context)!
                                                .success +
                                            '!',
                                        message: AppLocalizations.of(context)!
                                            .update_content,

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.success,
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                    context.pushNamed('FoodJournal');
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
                                    backgroundColor:       MaterialStateProperty.all<Color>(
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

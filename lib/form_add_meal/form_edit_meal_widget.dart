import 'dart:developer';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_theme.dart';
import 'package:fitness_flow/flutter_flow/flutter_flow_util.dart';
import 'package:fitness_flow/form_add_meal/form_edit_meal_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class FormEditMealWidget extends StatefulWidget {
  const FormEditMealWidget(
      {super.key,
      required this.id,
      required this.nama,
      required this.berat,
      required this.kalori,
      required this.fat,
      required this.protein,
      required this.karbo,
      required this.gambar,
      required this.deskripsi,
      required this.type});

  final int id;
  // final String nama;
  final String nama;
  final double berat;
  final double kalori;
  final double fat;
  final double protein;
  final double karbo;
  final String gambar;
  final String deskripsi;
  final String type;

  @override
  State<FormEditMealWidget> createState() => _FormEditMealWidgetState();
}

class _FormEditMealWidgetState extends State<FormEditMealWidget> {
  late FormEditMealModel _model;
  late TextEditingController _namaController;
  late TextEditingController _beratController;
  late TextEditingController _kaloriController;
  late TextEditingController _fatController;
  late TextEditingController _proteinController;
  late TextEditingController _karboController;
  late TextEditingController _gambarController;
  late TextEditingController _deskripsiController;
  late TextEditingController _typeController;
  String? selectedValue;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = FormEditMealModel();
    _namaController = TextEditingController(text: widget.nama.toString());
    _beratController = TextEditingController(text: widget.berat.toString());
    _kaloriController = TextEditingController(text: widget.kalori.toString());
    _fatController = TextEditingController(text: widget.fat.toString());
    _proteinController = TextEditingController(text: widget.protein.toString());
    _karboController = TextEditingController(text: widget.karbo.toString());
    _gambarController = TextEditingController(text: widget.gambar.toString());
    _deskripsiController =
        TextEditingController(text: widget.deskripsi.toString());
    _typeController = TextEditingController(text: widget.type.toString());

    selectedValue = widget.type;
  }

  final fitnessFlowDB = FitnessFlowDB();

  @override
  void dispose() {
    _namaController.dispose();
    _beratController.dispose();
    _kaloriController.dispose();
    _fatController.dispose();
    _proteinController.dispose();
    _karboController.dispose();
    _gambarController.dispose();
    _deskripsiController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    // Logging nilai input dari TextField
    log("📝 ID: ${widget.id}");
    log("📝 Nama: ${_namaController}");
    log("📝 Berat: ${_beratController.text}");
    log("📝 Kalori: ${_kaloriController.text}");
    log("📝 Lemak (Fat): ${_fatController.text}");
    log("📝 Protein: ${_proteinController.text}");
    log("📝 Karbohidrat: ${_karboController.text}");
    log("🖼️ Gambar: ${widget.gambar}");
    log("📄 Deskripsi: ${widget.deskripsi}");
    log("🏷️ Tipe: $selectedValue");

    // Jalankan update
    await fitnessFlowDB.updateMeal(
      widget.id,
      _namaController.text,
      double.parse(_beratController.text),
      double.parse(_kaloriController.text),
      double.parse(_fatController.text),
      double.parse(_proteinController.text),
      double.parse(_karboController.text),
      _gambarController.text,
      _deskripsiController.text,
      selectedValue ?? '',
    );

    log("✅ Data berhasil diperbarui!");
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
                      "Edit Meal",
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
                          TextFormField(
                            controller: _namaController,
                            readOnly: true,
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
                                "Nama",
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
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: _deskripsiController,
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
                                'Pilih Golongan Makanan',
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
                              'staple_food',
                              'staple_type_a',
                              'staple_type_b',
                              'fruit',
                              'vegetable',
                              'protein_type_a',
                              'protein_type_b',
                              'protein_type_c',
                            ].map((key) {
                              final label = AppLocalizations.of(context)!
                                  .getTranslationEdit(key);
                              return DropdownMenuItem<String>(
                                value: key,
                                child: Text(label),
                              );
                            }).toList(),
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
                                          _gambarController.text =
                                              pickedFile.path;
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
                                    controller: _gambarController,
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
                                  if (_namaController.text != '' &&
                                      _beratController.text != '' &&
                                      _fatController.text != '' &&
                                      _kaloriController.text != '' &&
                                      _proteinController.text != '' &&
                                      _karboController.text != '' &&
                                      _gambarController.text != '' &&
                                      selectedValue != null &&
                                      selectedValue != '') {
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
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromRGBO(240, 0, 185, 1)),
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

extension LocalizationHelper on AppLocalizations {
  String getTranslationEdit(String key) {
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

      default:
        return key; // Mengembalikan key untuk debug jika tidak ditemukan
    }
  }
}

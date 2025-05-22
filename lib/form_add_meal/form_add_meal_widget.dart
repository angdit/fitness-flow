import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/form_add_meal/form_edit_meal_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fitness_flow/form_add_meal/new_food_form_widget.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'form_add_meal_model.dart';
export 'form_add_meal_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FormAddMealWidget extends StatefulWidget {
  const FormAddMealWidget({super.key});

  @override
  State<FormAddMealWidget> createState() => _FormAddMealWidgetState();
}

class _FormAddMealWidgetState extends State<FormAddMealWidget> {
  late FormAddMealModel _model;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String searchQuery = '';
  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FormAddMealModel());
    _focusNode.addListener(() {
      setState(() {}); // Update UI when focus changes
    });

    fetchMeals();
  }

  Future? futureMeal;
  // List<dynamic> futureMeal = [];
  final fitnessFlowDB = FitnessFlowDB();

  void fetchMeals() async {
    setState(() {
      futureMeal = fitnessFlowDB.fetchMeals();
    });
  }

  //function baru untuk edit dan delete
  deleteMeal(id) async {
    // var user = await fitnessFlowDB.fetchUserByIdV2(1);
    setState(() {
      fitnessFlowDB.deleteMeal(id);
      // fitnessFlowDB.updateUser(1, 'berat', user[0]['berat_old'].toString());
      fetchMeals();
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

  Future<bool> showWarningDialog(BuildContext context, int mealId) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.allergy_warning.toUpperCase(),
                style: FlutterFlowTheme.of(context).titleLarge,
              ),
              content: Text(
                AppLocalizations.of(context)!.allergy_warning_desc,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    AppLocalizations.of(context)!.no.toUpperCase(),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigator.pop(context); // Tutup dialog dulu
                    context.pushNamed(
                      'FoodNutrients',
                      queryParameters: {
                        'id': serializeParam(mealId, ParamType.int),
                      }.withoutNulls,
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.yes.toUpperCase(),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Poppins',
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.delete_meal.toUpperCase(),
              style: FlutterFlowTheme.of(context).titleLarge,
            ),
            content: Text(
              AppLocalizations.of(context)!.are_you_sure_delete_meal,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  AppLocalizations.of(context)!.no.toUpperCase(),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  AppLocalizations.of(context)!.yes.toUpperCase(),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.blue),
                ),
              ),
            ],
          );
        },
      ) ??
      false;
}

  @override
  void dispose() {
    _model.dispose();
    _searchController.dispose();
    _focusNode.dispose();
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewFoodFormWidget(),
              ),
            );
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8.0,
          child: Icon(
            Icons.add_outlined,
            color: Colors.white,
            size: 24.0,
          ),
        ),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_rounded,
              color: FlutterFlowTheme.of(context).primaryText,
              size: 30.0,
            ),
            onPressed: () async {
              final uri = Uri.parse(GoRouter.of(context).location);
              final previousPage = uri.queryParameters['previousPage'];

              if (previousPage == 'FoodJournal') {
                context.pushReplacementNamed(
                    'FoodJournal'); // Ganti halaman, bukan menumpuk navigasi
              } else {
                context.pushReplacementNamed(
                    'CalorieTracker'); // Default jika previousPage tidak ada
              }
            },
          ),
          title: Text(
            AppLocalizations.of(context)!.add_meal,
            style: FlutterFlowTheme.of(context).titleLarge,
          ),
          actions: [],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 16.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                16.0, 12.0, 0.0, 0.0),
                            child: Text(
                              AppLocalizations.of(context)!.choose_your_meal,
                              style: FlutterFlowTheme.of(context).labelMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 0.0),
                    child: SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF5F6FA),
                          hintText:
                              AppLocalizations.of(context)!.search + '...',
                          hintStyle: FlutterFlowTheme.of(context).labelSmall,
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: _focusNode.hasFocus
                                    ? Color(0xFF7165E3)
                                    : Colors.grey,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                updateSearchQuery('');
                              }),
                          prefixIcon: IconButton(
                            icon: Icon(
                              Icons.search,
                              color: _focusNode.hasFocus
                                  ? Color(0xFF7165E3)
                                  : Colors.grey,
                            ),
                            onPressed: () {},
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: _focusNode.hasFocus
                                  ? Color(0xFF7EE4F0)
                                  : Colors.transparent,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color(0xFF7EE4F0),
                            ),
                          ),
                        ),
                        onChanged: updateSearchQuery,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: FutureBuilder(
                          future: futureMeal,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (snapshot.hasData) {
                              var allData = snapshot
                                  .data; // Data tetap orisinil (QueryResultSet)

                              // var filteredData =
                              //     (allData as Iterable).where((item) {
                              //   return item['nama']
                              //       .toString()
                              //       .toLowerCase()
                              //       .contains(searchQuery.toLowerCase());
                              // }).toList();
                              // log("isi all data : ${allData}");

                              var filteredData =
                                  (allData as Iterable).where((item) {
                                String translatedName =
                                    AppLocalizations.of(context)!
                                        .getTranslation(item['nama']);

                                return translatedName
                                    .toLowerCase()
                                    .contains(searchQuery.toLowerCase());
                              }).toList();

                              if (filteredData.isEmpty) {
                                return Center(
                                  child: Text(AppLocalizations.of(context)!
                                      .no_results_found),
                                );
                              }
                              return ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                // itemCount: snapshot.data.length,
                                itemCount: filteredData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // var itemData = snapshot.data[index];
                                  var itemData = filteredData[index];
                                  // debugPrint(
                                  //     'Data gambar untuk index $index: ${itemData['gambar']}');
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        16.0, 0.0, 16.0, 8.0),
                                    child: Container(
                                      width: 100.0,
                                      height: 70.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () async {
                                          int mealId = itemData['id'];

                                          if (itemData['notes'] != null &&
                                              itemData['notes'].isNotEmpty) {
                                            await showWarningDialog(
                                                context, mealId);
                                          } else {
                                            context.pushNamed(
                                              'FoodNutrients',
                                              queryParameters: {
                                                'id': serializeParam(
                                                    mealId, ParamType.int),
                                              }.withoutNulls,
                                            );
                                          }
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(8.0, 0.0, 0.0, 0.0),
                                              child: Card(
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                elevation: 0.0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(2.0),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.0),
                                                    child: displayImage(
                                                        itemData['gambar']),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        5.0, 0.0, 0.0, 0.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .getTranslation(
                                                              itemData['nama']),
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                              ),
                                                    ),
                                                    RichText(
                                                      textScaler:
                                                          MediaQuery.of(context)
                                                              .textScaler,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: itemData[
                                                                    'kalori']
                                                                .toString(),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  fontFamily:
                                                                      'Rubik',
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primary,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          TextSpan(
                                                            text: ' ' +
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .calorie
                                                                    .toLowerCase()
                                                                    .split(' ')
                                                                    .map((word) =>
                                                                        word.isNotEmpty
                                                                            ? '${word[0].toUpperCase()}${word.substring(1)}'
                                                                            : '')
                                                                    .join(' '),
                                                            style: TextStyle(),
                                                          )
                                                        ],
                                                        style:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Spacer(),
                                            // FlutterFlowIconButton(
                                            //   borderColor: Colors.transparent,
                                            //   borderRadius: 12.0,
                                            //   borderWidth: 1.0,
                                            //   buttonSize: 36.0,
                                            //   fillColor: Colors.transparent,
                                            //   icon: FaIcon(
                                            //     FontAwesomeIcons.edit,
                                            //     color: Color(0xFFFFC107),
                                            //     size: 16.0,
                                            //   ),
                                            //   onPressed: () {
                                            //     Navigator.push(
                                            //       context,
                                            //       MaterialPageRoute(
                                            //         builder: (context) => FormEditMealWidget(
                                            //             id: itemData["id"],
                                            //             nama: itemData["nama"],
                                            //             berat: (itemData["berat"]
                                            //                     as num)
                                            //                 .toDouble(),
                                            //             kalori:
                                            //                 (itemData["kalori"]
                                            //                         as num)
                                            //                     .toDouble(),
                                            //             fat:
                                            //                 (itemData["fat"]
                                            //                         as num)
                                            //                     .toDouble(),
                                            //             protein:
                                            //                 (itemData["protein"]
                                            //                         as num)
                                            //                     .toDouble(),
                                            //             karbo:
                                            //                 (itemData["karbo"]
                                            //                         as num)
                                            //                     .toDouble(),
                                            //             gambar:
                                            //                 itemData["gambar"],
                                            //             deskripsi: itemData[
                                            //                 "deskripsi"],
                                            //             type: itemData["type"]),
                                            //       ),
                                            //     );
                                            //   },
                                            // ),
                                            FlutterFlowIconButton(
                                              borderColor: Colors.transparent,
                                              borderRadius: 12.0,
                                              borderWidth: 1.0,
                                              buttonSize: 36.0,
                                              fillColor: Colors.transparent,
                                              icon: FaIcon(
                                                FontAwesomeIcons.trashAlt,
                                                color: Colors.red,
                                                size: 16.0,
                                              ),
                                              onPressed: () async {
                                                final confirmDelete = await showDeleteConfirmationDialog(context);
                                                if (!confirmDelete) return;

                                                deleteMeal(itemData['id']);
                                                final snackBar = SnackBar(
                                                  elevation: 0,
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  content:
                                                      AwesomeSnackbarContent(
                                                    title: AppLocalizations.of(
                                                                context)!
                                                            .success +
                                                        '!',
                                                    message: AppLocalizations
                                                            .of(context)!
                                                        .meal_successfully_deleted,

                                                    /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                                    contentType:
                                                        ContentType.success,
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
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child: Text('Error fetching data'),
                              );
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

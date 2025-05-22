import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fitness_flow/form_add_work/new_work_form_widget.dart';
import 'package:fitness_flow/services/fitness_flow_db.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'form_add_work_model.dart';
export 'form_add_work_model.dart';

class FormAddWorkWidget extends StatefulWidget {
  const FormAddWorkWidget({super.key});

  @override
  State<FormAddWorkWidget> createState() => _FormAddWorkWidgetState();
}

class _FormAddWorkWidgetState extends State<FormAddWorkWidget> {
  late FormAddWorkModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String searchQuery = '';
  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FormAddWorkModel());
    _focusNode.addListener(() {
      setState(() {}); // Update UI when focus changes
    });
    // On page load action.
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   context.pushNamed(
    //     'FoodNutrients',
    //     queryParameters: {
    //       'id': serializeParam(
    //         0,
    //         ParamType.int,
    //       ),
    //     }.withoutNulls,
    //   );
    // });
    fetchWorks();
  }

  Future? futureWork;
  // List<dynamic> futureWork = [];
  final fitnessFlowDB = FitnessFlowDB();
  void fetchWorks() async {
    setState(() {
      futureWork = fitnessFlowDB.fetchLatihanAll();
    });
  }

    //function baru untuk edit dan delete
  deleteWorks(id) async {
    // var user = await fitnessFlowDB.fetchUserByIdV2(1);
    setState(() {
      fitnessFlowDB.deleteWorks(id);
      fetchWorks();
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

   Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.delete_exercise.toUpperCase(),
              style: FlutterFlowTheme.of(context).titleLarge,
            ),
            content: Text(
              AppLocalizations.of(context)!.are_you_sure_delete_exercise,
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
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewWorkFormWidget(),
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
              context.pushNamed('EventsPage');
            },
          ),
          title: Text(
            AppLocalizations.of(context)!.add_exercise,
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
                              AppLocalizations.of(context)!
                                  .choose_your_exercise,
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
                          future: futureWork,
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

                              // Salin data sementara untuk filtering
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
                                          context.pushNamed(
                                            'Workdetail',
                                            queryParameters: {
                                              'id': serializeParam(
                                                itemData['id'],
                                                ParamType.int,
                                              ),
                                            }.withoutNulls,
                                          );
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
                                                          itemData['gambar'])),
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
                                                      // itemData['nama'],
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
                                                            text: AppLocalizations
                                                                    .of(
                                                                        context)!
                                                                .getTranslation(
                                                                    itemData[
                                                                        'type'])
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
                                            ),Spacer(),
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
                                                deleteWorks(itemData['id']);
                                                final snackBar = SnackBar(
                                                  /// need to set following properties for best effect of awesome_snackbar_content
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
                                                        .workout_successfully_deleted,

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
